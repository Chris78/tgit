unit ULocation;

interface

uses Hashes,sysutils,SQLiteTable3,UHelper;

type

  TObjectArray = Array of TObject;

  TLocation = class(TObject)

  public
    id, location_id: integer;
    loc_type, name, description, located : String;
    sldb: TSQLiteDatabase;
    constructor create(db: TSQLiteDatabase; fields: THash);
    class function db_find(db:TSQLiteDatabase; id: Integer):TLocation;
    class function all(db:TSQLiteDatabase) : TObjectArray;
  private

  end;

implementation


constructor TLocation.create(db: TSQLiteDatabase; fields: THash);
var
  sid,lid: String;
begin
  sid:=fields.GetString('ID');
  if sid='' then begin
    alert('FEHLER: ID ist leer');
    self.Free;
  end
  else begin
    sldb:=db;
    id:=strtoint(sid);
    loc_type:=UTF8ToString(AnsiString(fields.GetString('TYPE')));
    name:=UTF8ToString(AnsiString(fields.GetString('NAME')));
    description:=UTF8ToString(AnsiString(fields.GetString('DESCRIPTION')));
    located:=UTF8ToString(AnsiString(fields.GetString('LOCATED')));
    lid:=fields.GetString('LOCATION_ID');
    if lid<>'' then location_id:=strtoint(lid);
  end;
end;


class function TLocation.db_find(db:TSQLiteDatabase; id: Integer):TLocation;
var
  tbl: TSQLiteTable;
begin
  tbl:=db.GetTable(AnsiString(UTF8Encode('SELECT * FROM locations WHERE id='+inttostr(id))));
  if tbl.Count>0 then begin
    result:=TLocation.create(db,tbl.getRow);
  end
  else begin
    alert('Location '+inttostr(id)+' nicht gefunden!');
    result:=nil;
  end;
end;

class function TLocation.all(db:TSQLiteDatabase) : TObjectArray;
var
  tbl : TSQLiteTable;
  l: TLocation;
  lid: string;
begin
  tbl:=db.GetTable(AnsiString(UTF8Encode('SELECT * FROM locations ORDER BY name ASC')));
  while(not tbl.EOF) do begin
    lid:=tbl.getRow().getString('ID');
    l:=TLocation.db_find(db,strtoint(lid));
    setlength(result, length(result)+1);
    result[length(result)-1]:=l;
    tbl.Next;
  end;
end;

end.
 