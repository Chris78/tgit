unit ULocation;

interface

uses
  Hashes,sysutils,SQLiteTable3,Contnrs,
  UHelper;

type

  TObjectArray = Array of TObject;

  TLocation = class(TObject)

  public
    id, location_id: integer;
    loc_type, name, description, located : String;
    sldb: TSQLiteDatabase;
    function getParentLocation: TLocation;
    function db_update(): Boolean;
    constructor create(db: TSQLiteDatabase; fields: THash);
    class function db_create(db:TSQLiteDatabase; h: THash): TLocation;
    class function db_find(db:TSQLiteDatabase; id: Integer):TLocation;
    class function all(db:TSQLiteDatabase) : TObjectArray;
    class function db_find_parent_locations(db:TSQLiteDatabase): TObjectList;
  private
    parentLocation: TLocation;

  end;

implementation

{$OPTIMIZATION OFF}


function TLocation.getParentLocation;
begin
  if location_id>0 then begin
    if parentLocation=nil then parentLocation:=TLocation.db_find(sldb, location_id);
    result:=parentLocation;
  end
  else
    result:=nil;
end;

function TLocation.db_update(): Boolean;
var
  s: String;
begin
  if self.location_id>0 then
    s:=', location_id='+inttostr(self.location_id)
  else
    s:=', location_id=NULL';
  try
    sldb.ExecSQL(AnsiString(UTF8Encode('UPDATE locations SET '+
                 ' type="'+self.loc_type+'",'+
                 ' name="'+self.name+'",'+
                 ' description="'+self.description+'",'+
                 ' located="'+self.located+'"'+
                 s+
                 ' WHERE id='+inttostr(self.id))));
    result:=true;
  except
    result:=false;
  end;
end;


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
    if lid<>'' then
      location_id:=strtoint(lid)
    else
      location_id:=-1;
  end;
end;

class function TLocation.db_create(db:TSQLiteDatabase; h: THash): TLocation;
var
  s,query: String;
  id: Int64;
begin
  s:=h.GetString('LOCATION_ID');
  if not (strtoint(s)>0) then s:='NULL';
  query:='INSERT INTO locations '+
               '(type,name,description,located,location_id) VALUES '+
               '("'+h.GetString('TYPE')+'","'+
                    h.GetString('NAME')+'","'+
                    h.GetString('DESCRIPTION')+'","'+
                    h.GetString('LOCATED')+'",'+
                    s+')';
  db.ExecSQL(AnsiString(UTF8Encode(query)));
  id:=db.GetLastInsertRowID;
  result:=TLocation.db_find(db,id);
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


class function TLocation.db_find_parent_locations(db:TSQLiteDatabase): TObjectList;
var tbl: TSQLiteTable;
begin
  result:=TObjectList.Create;
  tbl:=db.GetTable(AnsiString(UTF8Encode('SELECT * FROM locations WHERE type in ("Computer","HddCase")')));
  while not tbl.eof do begin
    result.Add(TLocation.create(db,tbl.getRow));
    tbl.Next;
  end;
end;


end.

