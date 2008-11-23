unit UPreview;

interface

uses
  Classes, Graphics, ExtCtrls, Controls, UFileinfo, SysUtils, ShellAPI, Windows, UHelper, Forms;

type

  TPreview = class(TImage)
    fileinfo: TFileinfo;
    parent: TObject;
    mainForm: TObject;
    procedure DblClick(Sender:TObject);
  private
  public
    filepath: String;  // ein "accessible Path" sofern es einen gibt
    function getFilepath():string;
    constructor create(mForm:TForm; aOwner:TComponent; aFileinfo: TFileinfo);
  end;


implementation

uses
  Unit2, UFileLocation;

function TPreview.getFilepath():string;
begin
  result:=filepath;
end;

constructor TPreview.create(mForm:TForm; aOwner:TComponent; aFileinfo: TFileinfo);
begin
  fileinfo:=aFileinfo;
  parent:=TObject(aOwner);
  mainForm:=TObject(mForm);
  filepath:=fileinfo.getAccessibleLocation(TFrmMain(mainForm).selectedCDROMDrive,TFrmMain(mainForm).selectedUSBDrive);
  inherited create(aOwner);
end;

procedure TPreview.DblClick(Sender:TObject);
var
  fname: string;
  Handle: Integer;
  usbLetter, cdromLetter, allFileLocs: String;
  i: integer;
begin
  Handle:=0;
  cdromLetter:=TFrmMain(mainForm).getCdromDriveLetter;
  usbLetter:=TFrmMain(mainForm).getUSBDriveLetter;
  fname:=fileinfo.getAccessibleLocation(cdromLetter, usbLetter);
  if FileExists(fname) then
    ShellExecute(Handle, 'open', PChar(fname), nil, nil, SW_SHOW)
  else begin
    allFileLocs:='Diese Datei ist von diesem Computer aus nicht zugreifbar.'+#13#10#13#10;
    allFileLocs:=allFileLocs+'Aber sie wurde an folgenden Stellen gefunden: '+#13#10#13#10;
    for i:=0 to fileinfo.file_locations.count-1 do
      allFileLocs:=allFileLocs+TFileLocation(fileinfo.file_locations[i]).location_and_full_path+#13#10;
    alert(allFileLocs);
  end;
end;


end.
