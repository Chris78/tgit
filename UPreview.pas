unit UPreview;

interface

uses
  Classes, Graphics, ExtCtrls, Controls, UFileinfo, SysUtils, ShellAPI, Windows, UHelper, Forms;

type

  TPreview = class(TImage)
    fileinfo: TFileinfo;
    parent: TObject;
    mainForm: TObject;
    procedure OnDblClick(Sender:TObject);
  private
  public
    filepath: String;  // ein "accessible Path" sofern es einen gibt
    function getFilepath():string;
    constructor create(mForm:TForm; aOwner:TComponent; aFileinfo: TFileinfo);
  end;


implementation

uses
  Unit2;

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

procedure TPreview.OnDblClick(Sender:TObject);
var
  fname: string;
  Handle: Integer;
  usbLetter, cdromLetter: String;
begin
  Handle:=0;
  cdromLetter:=TFrmMain(mainForm).getCdromDriveLetter;
  usbLetter:=TFrmMain(mainForm).getUSBDriveLetter;
  fname:=fileinfo.getAccessibleLocation(cdromLetter, usbLetter);
  if FileExists(fname) then
    ShellExecute(Handle, 'open', PChar(fname), nil, nil, SW_SHOW)
  else
    alert('Diese Datei ist von diesem Computer aus nicht zugreifbar.');
end;


end.
