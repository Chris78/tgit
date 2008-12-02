unit UFrmEditTags;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SqliteTable3, StdCtrls, ExtCtrls, Contnrs,
  UFileinfo, UPreview, UTag,
  UHelper;

type
  TfrmEditTags = class(TForm)
    imgPreview: TImage;
    btnSaveTags: TButton;
    pnlCurTags: TPanel;
    edtEditTags: TEdit;
    btnAddTag: TButton;
    procedure FormShow(Sender: TObject);
    procedure edtEditTagsKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddTagClick(Sender: TObject);
    procedure btnSaveTagsClick(Sender: TObject);
  private
    { Private declarations }
    mainForm : TObject;
    sldb: TSQLiteDatabase;
    fileinfo: TFileinfo;
    procedure renderTags(tags:TObjectList);
    procedure renderTag(t:String);
    procedure arrangeTags;
    procedure toggleTag(Sender:TObject);
  public
    { Public declarations }
    constructor create(Sender:TComponent);
  end;

var
  frmEditTags: TfrmEditTags;

implementation

uses
  Unit2;

{$OPTIMIZATION OFF}
{$R *.dfm}


procedure TfrmEditTags.btnAddTagClick(Sender: TObject);
begin
  renderTag(edtEditTags.text);
  edtEditTags.text:='';
  arrangeTags;
end;

procedure TfrmEditTags.btnSaveTagsClick(Sender: TObject);
var
  i,dummy: Integer;
  lbl: TLabel;
  previewRemoved,newTagsAdded: Boolean;
  m: TFrmMain;
begin
  m:=TFrmMain(mainForm);
  previewRemoved:=false;
  for i:=0 to pnlCurTags.ComponentCount-1 do begin
    lbl:=TLabel(pnlCurTags.Components[i]);
    if lbl.Tag=1 then begin // Tag ist blau, also war er schon da oder kam neu hinzu
      fileinfo.addTagName(lbl.caption);
      newTagsAdded:=true;
    end
    else begin              // Tag ist rot, soll also gel�scht werden
      fileinfo.removeTagName(lbl.caption);
      // Preview entfernen, falls sie nun nicht mehr den gew�hlten Tags entspricht:
      if not previewRemoved and TFrmMain(mainForm).selectedTags.Find(lbl.caption,dummy) then begin
        m.curFileinfos.remove(fileinfo);
        m.updatePreviews;
        previewRemoved:=true;
      end;
    end;
  end;
  if newTagsAdded then m.reloadTagCloud;
  close;
end;

constructor TFrmEditTags.create(Sender:TComponent);
var
  m: TFrmMain;
begin
  inherited create(Sender);
  mainForm:=Sender;
  m:=TFrmMain(mainForm);
  sldb:=m.sldb;
end;

procedure TfrmEditTags.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  pnlCurTags.DestroyComponents;
  edtEditTags.Text:='';
end;

procedure TfrmEditTags.FormShow(Sender: TObject);
var
  m: TFrmMain;
begin
  m:=TFrmMain(mainForm);
  fileinfo:=TPreview(m.clickedPreview).fileinfo;
  renderTags(fileinfo.getTags);
  doLoadImage(TFileinfo(TPreview(m.clickedPreview).fileinfo).getAccessibleLocation(m.selectedCDROMDrive,m.selectedUSBDrive), imgPreview);
end;

procedure TFrmEditTags.renderTags(tags:TObjectList);
var
  i:integer;
begin
  for i:=0 to tags.Count-1 do begin
    renderTag(TTag(tags.Items[i]).name);
  end;
  arrangeTags;
end;

procedure TFrmEditTags.renderTag(t:String);
var
  lbl: TLabel;
begin
  lbl:=TLabel.Create(pnlCurTags);
  with lbl do begin
    Parent:=pnlCurTags;
    Caption:=t;
    with font do begin
      color:=clBlue;
      Size:=16;
      Style:=[fsUnderline];
      Name:='Helvetica';
    end;
    tag:=1; // nicht als "Tagging-Tag" zu verstehen, sondern nur als "selected=0 bzw. 1"
    onClick:=toggleTag;
  end;
end;
procedure TFrmEditTags.arrangeTags;
var
  i: integer;
  lbl: TLabel;
begin
  for i := 0 to pnlCurTags.ComponentCount - 1 do begin
    lbl:=TLabel(pnlCurTags.Components[i]);
    lbl.Left:=10;
    lbl.top:=26*i+10;
  end;
end;

procedure TfrmEditTags.edtEditTagsKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=Char(VK_RETURN) then begin
    if edtEditTags.text='' then
      btnSaveTagsClick(Sender)
    else begin
      renderTag(edtEditTags.text);
      arrangeTags;
      edtEditTags.Text:='';
    end;
  end;
end;

procedure TFrmEditTags.toggleTag(Sender: TObject);
var
  l: TLabel;
begin
  l:=TLabel(Sender);
  l.Tag := (l.Tag+1) mod 2;
  if l.Tag=1 then
    l.Font.Color:=clBlue
  else
    l.Font.Color:=clRed;
end;



end.
