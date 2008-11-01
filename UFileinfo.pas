unit UFileinfo;

interface

uses Hashes,sysutils,Contnrs;

type
  TFileinfo = class(TObject)

  public
    id: Integer;
    sha2: String;
    filesize: Integer;
    file_locations: TObjectList;
    constructor create(fields: THash);
    function getAttr(name:String):String;
  end;

implementation

constructor TFileinfo.create(fields: THash);
begin
  self.id:=strtoint(fields.GetString('ID'));
  self.sha2:=UTF8Decode(fields.GetString('SHA2'));
  self.filesize:=strtoint(fields.GetString('FILESIZE'));
  self.file_locations:=TObjectList.create;
end;

function TFileinfo.getAttr(name:String):String;
begin
  if name='id' then result:=inttostr(self.id)
  else if name='sha2' then result:=self.sha2
  else if name='filesize' then result:=inttostr(self.filesize);
end;

end.
