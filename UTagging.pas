unit UTagging;

interface

uses
  Contnrs,Hashes,SQLiteTable3,sysutils,
  UTag,
  UHelper; //UFileLocation, Dialogs, Forms;

type

  TTagging = class(TObject)
  public
    id, tag_id, taggable_id: Integer;
    taggable_type: String;
    tag: TTag;
    taggable: TObject;

    function getTag(reload:Boolean=false):TTag;
    function tgg_destroy():Boolean;


    constructor create(db: TSQLiteDatabase; fields: THash);
    class function db_find(db: TSQLiteDatabase; id: Integer): TTagging;
    class function db_find_by_tag_id(db: TSQLiteDatabase; tag_id: Integer): TObjectList;
    class function db_create(db: TSQLiteDatabase; taggable_type: String; taggable_id: Integer; tag_id: Integer): TTagging;
    class function db_find_or_create(db: TSQLiteDatabase; taggable_type: String; taggable_id: Integer; tag_id: Integer): TTagging;
    class procedure db_delete_by_taggable_type_and_taggable_id_and_tag_id(db: TSQLiteDatabase; taggable_type: String; taggable_id,tag_id: Integer);

  private
    sldb: TSQLiteDatabase;
  end;

implementation


function TTagging.getTag(reload:Boolean=false):TTag;
var
  tbl: TSQLiteTable;
begin
  if (tag=nil) or reload then begin
    if tag<>nil then tag.free;
    tbl := sldb.GetTable(AnsiString(UTF8Encode('SELECT * FROM tags WHERE id='+inttostr(self.tag_id))));
    tag:=TTag.create(sldb,tbl.GetRow);
  end;
  result:=tag;
end;

function TTagging.tgg_destroy():Boolean;
var
  tggs: TObjectList;
begin
  try
    sldb.ExecSQL(AnsiString(UTF8Encode('DELETE FROM taggings WHERE id='+inttostr(self.id))));
    tggs:=db_find_by_tag_id(sldb,self.tag_id);
    if tggs.count=0 then TTag.db_delete(sldb,tag_id);
    result:=true;
  finally
    result:=false;
  end;
end;

// =============================================================================
//                             Klassen-Methoden
// =============================================================================

constructor TTagging.create(db: TSQLiteDatabase; fields: THash);
begin
  sldb:=db;
  id:=strtoint(fields.GetString('ID'));
  tag_id:=strtoint(fields.GetString('TAG_ID'));
  taggable_type:=UTF8ToString(AnsiString(fields.GetString('TAGGABLE_TYPE')));
  taggable_id:=strtoint(fields.GetString('TAGGABLE_ID'));
end;

class function TTagging.db_find(db: TSQLiteDatabase; id: Integer): TTagging;
var
  tbl: TSQLiteTable;
begin
  tbl:=db.GetTable(AnsiString(UTF8Encode('SELECT * FROM taggings WHERE id='+inttostr(id))));
  if tbl.Count>0 then begin
    result:=TTagging.create(db,tbl.getRow);
  end
  else begin
    alert('Tagging '+inttostr(id)+' nicht gefunden!');
    result:=nil;
  end;
end;

class function TTagging.db_create(db: TSQLiteDatabase; taggable_type: String; taggable_id: Integer; tag_id: Integer): TTagging;
var
  id: Int64;
  dtime: String;
begin
  DateTimeToString(dtime, 'yyyy-mm-dd hh:nn:ss', Now());
  db.ExecSQL(AnsiString(UTF8Encode('INSERT INTO taggings (taggable_type,taggable_id,tag_id,created_at)'+
                                   ' VALUES ("'+taggable_type+'",'+inttostr(taggable_id)+', '+inttostr(tag_id)+',"'+dtime+'")')));
  id:=db.GetLastInsertRowID;
  result:=TTagging.db_find(db,id);
end;

class function TTagging.db_find_or_create(db: TSQLiteDatabase; taggable_type: String; taggable_id: Integer; tag_id: Integer): TTagging;
var
  tbl: TSQLiteTable;
begin
  tbl:=db.GetTable(AnsiString(UTF8Encode('SELECT * FROM taggings WHERE taggable_type="'+taggable_type+
                                          '" AND taggable_id='+inttostr(taggable_id)+
                                          '  AND tag_id='+inttostr(tag_id))));
  if tbl.Count>0 then begin
    result:=TTagging.create(db,tbl.getRow);
  end
  else begin
    result:=TTagging.db_create(db,taggable_type,taggable_id,tag_id);
  end;
end;

class function TTagging.db_find_by_tag_id(db: TSQLiteDatabase; tag_id: Integer): TObjectList;
var
  tbl: TSQLiteTable;
begin
  tbl:=db.GetTable(AnsiString(UTF8Encode('SELECT * FROM taggings WHERE tag_id='+inttostr(tag_id))));
  result:=TObjectList.create;
  while not tbl.EOF do begin
    result.Add(TTagging.create(db,tbl.getRow));
    tbl.next;
  end;
end;

class procedure TTagging.db_delete_by_taggable_type_and_taggable_id_and_tag_id(db: TSQLiteDatabase; taggable_type: String; taggable_id,tag_id: Integer);
var
  tggs: TObjectList;
begin
 try
   db.ExecSQL(AnsiString(UTF8Encode('DELETE FROM taggings WHERE taggable_type="'+taggable_type+'" AND taggable_id='+inttostr(taggable_id)+' AND tag_id='+inttostr(tag_id))));
   tggs:=db_find_by_tag_id(db,tag_id);
   if tggs.count=0 then TTag.db_delete(db,tag_id);
 finally
   tggs.Free;
 end;
end;


//class function TTagging.db_create_by_object(db: TSQLiteDatabase; taggable_id: Integer; taggable: TObject): TTagging;
//begin
//end;



end.

