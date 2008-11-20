unit UTagging;

interface

uses UTag,Hashes,SQLiteTable3,sysutils,UHelper; //Contnrs, UFileLocation, Dialogs, Forms;

type

  TTagging = class(TObject)
  public
    id, taggable_id: Integer;
    taggable_type: String;
    tag: TTag;
    taggable: TObject;

    constructor create(db: TSQLiteDatabase; fields: THash);
    class function db_find(db: TSQLiteDatabase; id: Integer): TTagging;
    class function db_create(db: TSQLiteDatabase; taggable_type: String; taggable_id: Integer; tag_id: Integer): TTagging;
//    class function db_create_by_object(db: TSQLiteDatabase; taggable_id: Integer; taggable: TObject): TTagging;
    class function db_find_or_create(db: TSQLiteDatabase; taggable_type: String; taggable_id: Integer; tag_id: Integer): TTagging;

  end;

implementation


// =============================================================================
//                             Klassen-Methoden
// =============================================================================

constructor TTagging.create(db: TSQLiteDatabase; fields: THash);
begin
end;

class function TTagging.db_find(db: TSQLiteDatabase; id: Integer): TTagging;
var
  tbl: TSQLiteTable;
begin
  tbl:=db.GetTable('SELECT * FROM taggings WHERE id="'+inttostr(id)+'"');
  if tbl.Count>0 then begin
    result:=TTagging.create(db,tbl.getRow);
  end
  else begin
    alert('Tagging '+inttostr(id)+' nicht gefunden!');
  end;
end;

class function TTagging.db_create(db: TSQLiteDatabase; taggable_type: String; taggable_id: Integer; tag_id: Integer): TTagging;
var
  id: Int64;
begin
  db.ExecSQL('INSERT INTO taggings (taggable_type,taggable_id,tag_id)'+
                          ' VALUES ("'+taggable_type+'","'+inttostr(taggable_id)+'", "'+inttostr(tag_id)+'")');
  id:=db.GetLastInsertRowID;
  result:=TTagging.db_find(db,id);
end;

class function TTagging.db_find_or_create(db: TSQLiteDatabase; taggable_type: String; taggable_id: Integer; tag_id: Integer): TTagging;
var
  tgg: TTagging;
  id: Integer;
  tbl: TSQLiteTable;
begin
  tbl:=db.GetTable('SELECT * FROM taggings WHERE taggable_type="'+taggable_type+
                                          '" AND taggable_id="'+inttostr(taggable_id)+
                                          '" AND tag_id="'+inttostr(tag_id)+'"');
  if tbl.Count>0 then begin
    result:=TTagging.create(db,tbl.getRow);
  end
  else begin
    result:=TTagging.db_create(db,taggable_type,taggable_id,tag_id);
  end;
end;

//class function TTagging.db_create_by_object(db: TSQLiteDatabase; taggable_id: Integer; taggable: TObject): TTagging;
//begin
//end;



end.

