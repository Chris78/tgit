unit UFileLocation;

interface

uses Hashes,sysutils, ULocation;

type

  TFileLocation = class(TObject)

  public
    id,location_id: Integer;
    path,filename: String;

    alternateDriveLetter: String; // Es kann sein, dass eine CD in Laufwerk d: lag als sie indiziert wurde, aber nun in Laufwerk e: liegt!
    alternateHTTPHost,alternateHTTPPath: String;
    location: TLocation;
    function full_path():String;
    function accessible(): Boolean;
    constructor create(fields: THash);
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
