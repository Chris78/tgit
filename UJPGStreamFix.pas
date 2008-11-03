unit UJPGStreamFix;

interface

uses classes, jpeg;

function LoadJPGFromStream(FS: TStream; var JPG: TJPEGImage): boolean;

implementation


function LoadJPGFromStream(FS: TStream; var JPG: TJPEGImage): boolean;
var MS: TMemoryStream;
    s: Cardinal;
    offset: cardinal;
begin
  FS.Read(S, sizeof(s));
  offset := FS.Position;
  JPG.LoadFromStream(FS);
  FS.Position := offset + s;
end;

function SaveJPGToStream(FS: TStream; JPG: TJPEGImage): boolean;
var MS: TMemoryStream;
    s: Cardinal;
begin
  MS := TMemoryStream.Create;

  JPG.SaveToStream(MS);
  s := MS.Size;

  FS.WriteBuffer(S, sizeof(s));
  JPG.SaveToStream(FS);

  MS.free;
end;


end.
 