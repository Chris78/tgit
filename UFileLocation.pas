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
    fileinfo : TObject; // "file_location belongs_to :fileinfo"
    function full_path():String;
    function accessible(): Boolean;
    constructor create(fields: THash; finfo: TObject);
  end;

implementation

uses UFileinfo;

constructor TFileLocation.create(fields: THash; finfo: TObject);
begin
  self.id:=strtoint(fields.GetString('ID'));
  self.path:=UTF8Decode(fields.GetString('PATH'));
  self.filename:=UTF8Decode(fields.GetString('FILENAME'));
  self.location_id:=strtoint(fields.GetString('LOCATION_ID'));
  if fileinfo<>nil then self.fileinfo:=finfo;
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
