unit UPreview;

interface

uses
  Classes, Graphics, ExtCtrls, Controls, UFileinfo, SysUtils, ShellAPI, Windows, Forms,
  jpeg, UJPGStreamFix,
  SQLiteTable3,
  UHelper;

type

  TPreview = class(TImage)
    fileinfo: TFileinfo;
    parent: TObject;
    mainForm: TObject;
    procedure click(Sender:TObject);
    procedure DblClick(Sender:TObject);
  private
    selected : Boolean;
    thumbsdb : TSQLiteDatabase;
    procedure markSelected();
    procedure markUnselected();
    procedure loadThumb();
  public
    filepath: String;  // ein "accessible Path" sofern es einen gibt
    index: Integer;
    function getFilepath():string;
    procedure select;
    procedure unselect;
    procedure toggle;
    constructor create(mForm:TForm; aOwner:TComponent; aFileinfo: TFileinfo; aIndex: Integer);
  end;


implementation

{$OPTIMIZATION OFF}

uses
  Unit2, UFileLocation;

function TPreview.getFilepath():string;
begin
  result:=filepath;
end;

constructor TPreview.create(mForm:TForm; aOwner:TComponent; aFileinfo: TFileinfo; aIndex: Integer);
begin
  inherited create(aOwner);
  index:=aIndex; // der Index des zugehörigen Fileinfo-Objects in curFileinfos
  fileinfo:=aFileinfo;
  parent:=TObject(aOwner);
  mainForm:=TObject(mForm);
  thumbsdb:=TFrmMain(mainForm).thumbsdb;
  filepath:=fileinfo.getAccessibleLocation(TFrmMain(mainForm).selectedCDROMDrive,TFrmMain(mainForm).selectedUSBDrive);
  selected:=false;
  loadThumb();
end;

procedure TPreview.loadThumb();
var
  success: Boolean;
  tbl: TSQLiteTable;
  data: TMemoryStream;
  jp: TJpegImage;
begin
  // Versuchen den Thumbnail aus der DB zu laden:
  tbl:=thumbsdb.GetTable(AnsiString(UTF8ToString('SELECT data FROM thumbs WHERE fileinfo_id='+inttostr(fileinfo.id)+' LIMIT 1')));
  if tbl.RowCount>0 then begin
//    if not importingThumbs then begin
      data:=tbl.FieldAsBlob(tbl.FieldIndex['data']);
      data.Seek(0,0);
      jp:=TJPEGImage.create;
      jp.LoadFromStream(data);
      picture.bitmap.assign(jp);
      jp.free;
      data.free;
//    end;
  end
  else begin
    success := TFrmMain(mainForm).LoadImage(TImage(self),fileinfo,0);
    if not success then begin // Bild ist nicht-erreichbar oder nicht darstellbar.
      jp:=TJPEGImage.create;
      jp.LoadFromFile(ExtractFilepath(application.ExeName)+'public\images\no_disk.jpg');
      //Picture.LoadFromFile(ExtractFilepath(application.ExeName)+'public\images\no_disk.jpg');
      Picture.Bitmap.Assign(jp);
      jp.Free;
    end;
  end;
end;

procedure TPreview.DblClick(Sender:TObject);
var
  fname: string;
  Handle: Integer;
  usbLetter, cdromLetter, allFileLocs: String;
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
    allFileLocs:=allFileLocs+fileinfo.getFileLocationNames;
    alert(allFileLocs);
  end;
end;

procedure TPreview.click(Sender:TObject);
begin
  toggle();
end;

procedure TPreview.toggle();
begin
  if selected then
    markUnselected
  else
    markSelected;
end;

procedure TPreview.markSelected();
var
  i,px: Integer;
begin
  selected:=true;
  px:=4;
  with Canvas do begin
    Brush.Color:=clYellow;
    Brush.Style:=bsSolid;
    for i := 0 to px-1 do
    FrameRect(Rect(0+i,0+i,Picture.Width-i, Picture.Height-i));
  end;
end;
procedure TPreview.markUnselected();
begin
  selected:=false;
  loadThumb;
end;

procedure TPreview.select();
begin
  markSelected;
end;
procedure TPreview.unselect();
begin
  markUnselected;
end;



end.
