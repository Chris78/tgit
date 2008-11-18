unit ULocation;

interface

uses Hashes,sysutils,SQLiteTable3;

type

  TObjectArray = Array of TObject;

  TLocation = class(TObject)

  public
    loc_id, location_id: integer;
    loc_type, name, description, located : String;
    class function all(db:TSQLiteDatabase) : TObjectArray;

  private

  end;

implementation


class function TLocation.all(db:TSQLiteDatabase) : TObjectArray;
var
  tbl : TSQLiteTable;
  l: TLocation;
begin
  tbl:=db.GetTable('select * from locations order by name asc');
  while(not tbl.EOF) do
  begin
    l:=TLocation.create();
    l.loc_id:=tbl.FieldAsInteger(tbl.FieldIndex['ID']);
    l.name:=tbl.FieldAsString(tbl.FieldIndex['NAME']);
    l.description:=tbl.FieldAsString(tbl.FieldIndex['DESCRIPTION']);
    setlength(result, length(result)+1);
    result[length(result)-1]:=l;
    tbl.Next;
  end;
end;

end.
 