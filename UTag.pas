unit UTag;

interface

uses
  Classes, Hashes,sysutils,Contnrs, SQLiteTable3, StringItWell,
  UHelper; // , UFileLocation, Dialogs, Forms;

type

  TTag = class(TObject)
  public
    id: Integer;
    name: String;
    taggings: TObjectList;
    taggables: TObjectList;
    sldb: TSQLiteDatabase;

    constructor create(db: TSQLiteDatabase; fields: THash);
    class function db_find(db: TSQLiteDatabase; id:Integer): TTag;
    class function db_find_or_create(db: TSQLiteDatabase; name:String): TTag;
    class function db_create(db: TSQLiteDatabase; name:string):TTag;
    class procedure db_delete(db:TSQLiteDatabase;id:Integer);
    class procedure db_delete_by_name(db:TSQLiteDatabase;tagName:String);
    class function getRelatedFileinfoIds(db:TSQLiteDatabase; tags: TStringList; match_all:Boolean): String;
  end;

implementation

uses UTagging;


constructor TTag.create(db: TSQLiteDatabase; fields: THash);
var s: String;
begin
  sldb:=db;
  s:=fields.GetString('ID');
  if s='' then begin
    alert('FEHLER: ID ist leer! (in TTag.create)');
  end
  else begin
    id:=strtoint(s);
    name:=UTF8ToString(AnsiString(fields.GetString('NAME')));
  end;
end;

class function TTag.db_find_or_create(db: TSQLiteDatabase;name:String): TTag;
var
  tbl: TSQLiteTable;
begin
  tbl:=db.GetTable(AnsiString(UTF8Encode('SELECT * FROM tags WHERE name="'+name+'"')));
  if tbl.Count>0 then begin
    result:=TTag.create(db,tbl.getRow);
  end
  else begin
    result:=TTag.db_create(db,name);
  end;
end;

class function TTag.db_create(db: TSQLiteDatabase; name:string):TTag;
var
  id: Int64;
begin
  db.ExecSQL(AnsiString(UTF8Encode('INSERT INTO tags (name) VALUES ("'+name+'")')));
  id:=db.GetLastInsertRowID;
  result:=TTag.db_find(db,id);
end;

class function TTag.db_find(db: TSQLiteDatabase;id:Integer): TTag;
var
  tbl: TSQLiteTable;
begin
  tbl:=db.GetTable(AnsiString(UTF8Encode('SELECT * FROM tags WHERE id='+inttostr(id))));
  if tbl.Count>0 then begin
    result:=TTag.create(db,tbl.getRow);
  end
  else begin
    alert('Tag '+inttostr(id)+' nicht gefunden!');
    result:=nil;
  end;
end;

class procedure TTag.db_delete(db:TSQLiteDatabase;id:Integer);
begin
  db.ExecSQL(AnsiString(UTF8Encode('DELETE FROM tags WHERE id='+inttostr(id))));
end;

class procedure TTag.db_delete_by_name(db:TSQLiteDatabase;tagName:String);
begin
  db.ExecSQL(AnsiString(UTF8Encode('DELETE FROM tags WHERE name="'+tagName+'"')));
end;

class function TTag.getRelatedFileinfoIds(db:TSQLiteDatabase; tags: TStringList; match_all:Boolean): String;
var
  query: string;
  tbl: TSQLiteTable;
begin
  query:='SELECT group_concat(temp.TGGIDS) AS TAGGABLE_IDS FROM '+
         '  (SELECT g.taggable_id AS TGGIDS '+
         '    FROM tags t '+
         '    LEFT JOIN taggings g ON g.tag_id=t.id '+
         '    WHERE g.taggable_type="Fileinfo" AND t.name IN ("'+AssembleItWell(tags,'","')+'") '+
         '    GROUP BY g.taggable_type,g.taggable_id';
  if match_all then begin
    query := query+'   HAVING count(distinct t.id)='+inttostr(tags.count);
  end;
  query:=query+' ) AS temp ';
  tbl := db.GetTable(AnsiString(UTF8Encode(query)));
  result:=tbl.FieldAsString(tbl.FieldIndex['TAGGABLE_IDS']);
  tbl.Free;
end;


end.

