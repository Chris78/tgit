unit UFileLocation;

interface

uses Hashes,sysutils; //,UFileinfo;

type

  TFileLocation = class(TObject)

  public
    id,location_id: Integer;
    path,filename: String;
//    fileinfo: TFileinfo;
    function full_path():String;
    function accessible(): Boolean;
    constructor create(fields: THash);
//    class function find_by_id(id:string):TFileLocation;
  end;

implementation

constructor TFileLocation.create(fields: THash);
begin
  self.id:=strtoint(fields.GetString('ID'));
  self.path:=UTF8Decode(fields.GetString('PATH'));
  self.filename:=UTF8Decode(fields.GetString('FILENAME'));
  self.location_id:=strtoint(fields.GetString('LOCATION_ID'));
//  self.fileinfo:=TFileinfo.create();
end;

function TFileLocation.full_path():String;
begin
  result:=self.path+'\'+self.filename;
  while pos('/',result)<>0 do
  begin
    result[pos('/',result)]:='\';
  end;
end;

function TFileLocation.accessible():Boolean;
begin
  result:=FileExists(self.full_path);
end;


end.
