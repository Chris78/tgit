unit UTag;

interface

uses Classes, Hashes,sysutils,Contnrs, SQLiteTable3, UHelper; // , UFileLocation, Dialogs, Forms;

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
    name:=fields.GetString('NAME');
  end;
end;

class function TTag.db_find_or_create(db: TSQLiteDatabase;name:String): TTag;
var
  tbl: TSQLiteTable;
begin
  tbl:=db.GetTable('SELECT * FROM tags WHERE name="'+name+'"');
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
  db.ExecSQL('INSERT INTO tags (name) VALUES ("'+name+'")');
  id:=db.GetLastInsertRowID;
  result:=TTag.db_find(db,id);
end;

class function TTag.db_find(db: TSQLiteDatabase;id:Integer): TTag;
var
  tbl: TSQLiteTable;
begin
  tbl:=db.GetTable('SELECT * FROM tags WHERE id="'+inttostr(id)+'"');
  if tbl.Count>0 then begin
    result:=TTag.create(db,tbl.getRow);
  end
  else begin
    alert('Tag '+inttostr(id)+' nicht gefunden!');
  end;
end;

end.

