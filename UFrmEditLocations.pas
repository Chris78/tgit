unit UFrmEditLocations;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls, SqliteTable3, Math, StdCtrls, Contnrs, Buttons,
  Hashes,
  ULocationType, ULocation,
  UHelper;

type
  TfrmEditLocations = class(TForm)
    TabControl1: TTabControl;
    SGLocations: TStringGrid;
    Label1: TLabel;
    edtName: TEdit;
    MemoDescription: TMemo;
    lblName: TLabel;
    lblDescription: TLabel;
    cmbLocationTypes: TComboBox;
    lblType: TLabel;
    lblParentLocation: TLabel;
    cmbParentLocation: TComboBox;
    lblLocated: TLabel;
    edtLocated: TEdit;
    btnSave: TSpeedButton;
    btnCreate: TSpeedButton;
    btnDelete: TSpeedButton;
    btnEmptyFields: TSpeedButton;
    procedure TabControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cmbLocationTypesChange(Sender: TObject);
    procedure SGLocationsClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure btnEmptyFieldsClick(Sender: TObject);
  private
    { Private-Deklarationen }
    mainForm : TObject;
    sldb: TSQLiteDatabase;
    locationTypes,parentLocations: TObjectList;
    curLocation: TLocation;
    procedure loadLocationTypes();
    procedure loadParentLocations();
    procedure loadLocations(location_type: String);
    procedure loadLocation(location_id: Integer);
    procedure clearLocations();
  public
    { Public-Deklarationen }
    constructor create(Sender: TComponent);
  end;

var
  frmEditLocations: TfrmEditLocations;

implementation

{$R *.dfm}
{$OPTIMIZATION OFF}

uses
  Unit2;

constructor TFrmEditLocations.create(Sender:TComponent);
var
  m: TFrmMain;
begin
  inherited create(Sender);
  mainForm:=Sender;
  m:=TFrmMain(mainForm);
  sldb:=m.sldb;
end;

procedure TfrmEditLocations.FormCreate(Sender: TObject);
begin
  with SGLocations do begin
    Cells[0,0]:='ID';
    Cells[1,0]:='Name';
    Cells[2,0]:='Beschreibung';
    ColWidths[0]:=40;
    ColWidths[1]:=120;
    ColWidths[2]:=240;
  end;
  MemoDescription.Lines.Clear;
  loadLocationTypes();
  loadParentLocations();
  TabControl1Change(frmEditLocations);
end;

procedure TfrmEditLocations.FormDestroy(Sender: TObject);
begin
  if locationTypes<>nil then locationTypes.Free;
  if curLocation<>nil then curLocation.free;
  if parentLocations<>nil then parentLocations.Free;
end;

procedure TfrmEditLocations.FormResize(Sender: TObject);
begin
  SGLocations.ColWidths[2]:=SGLocations.width-SGLocations.ColWidths[0]-SGLocations.ColWidths[1]-6;
end;

procedure TfrmEditLocations.btnSaveClick(Sender: TObject);
var
  i,j: Integer;
begin
  with curLocation do begin
    j:=cmbLocationTypes.itemIndex;
    if not j>=0 then begin
      alert('Sie müssen einen Location-Typ angeben!');
      exit;
    end;
    loc_type:=TLocationType(cmbLocationTypes.items.objects[j]).name;
    name:=edtName.Text;
    description:=MemoDescription.Text;
    i:=cmbParentLocation.ItemIndex;
    if i>0 then
      location_id:=TLocation(cmbParentLocation.Items.objects[i]).id
    else
      location_id:=-1;
    located:=edtLocated.Text;
  end;
  curLocation.db_update();
  btnSave.Enabled:=false;
  TabControl1Change(btnSave); // neu Laden des aktuellen Tabs triggern
end;

procedure TfrmEditLocations.btnDeleteClick(Sender: TObject);
begin
  alert('Ich glaub'' kaum, dass Sie das wirklich wollen...');
end;

procedure TfrmEditLocations.btnEmptyFieldsClick(Sender: TObject);
begin
  if curLocation<>nil then begin
    curLocation.Free;
    curLocation:=nil;
  end;
  btnSave.Enabled:=false;
  btnDelete.Enabled:=false;

  cmbLocationTypes.ItemIndex:=-1;
  edtName.text:='';
  memoDescription.lines.Clear;
  cmbParentLocation.ItemIndex:=-1;
  edtLocated.Text:='';
end;

procedure TfrmEditLocations.btnCreateClick(Sender: TObject);
var
  h: THash;
  l: TLocation;
begin
  h:=THash.create();
  try
    if not cmbLocationTypes.ItemIndex>=0 then begin
      alert('Sie müssen einen Location-Typ auswählen!');
      exit;
    end;
    h.SetString('TYPE',TLocationType(cmbLocationTypes.Items.objects[cmbLocationTypes.itemindex]).name);
    h.SetString('NAME',edtName.Text);
    h.SetString('DESCRIPTION',memoDescription.text);
    if (not cmbParentLocation.enabled) or (cmbParentLocation.ItemIndex<=0) then
      h.SetString('LOCATION_ID','-1')
    else
      h.SetString('LOCATION_ID',inttostr(TLocation(cmbParentLocation.Items.Objects[cmbParentLocation.ItemIndex]).id));
    h.SetString('LOCATED',edtLocated.text);
    l:=TLocation.db_create(sldb,h);
  finally
    h.free;
    if curLocation<>nil then curLocation.Free;
    curLocation:=l;
    TabControl1Change(btnDelete); // neu Laden des aktuellen Tabs triggern
  end;
end;

procedure TFrmEditLocations.clearLocations();
var
  i,j: Integer;
begin
  for i:=1 to SGLocations.RowCount-1 do
    for j:=0 to SGLocations.ColCount - 1 do
      SGLocations.Cells[j,i]:='';
  SGLocations.rowCount:=2;
end;

procedure TfrmEditLocations.cmbLocationTypesChange(Sender: TObject);
var
  i: Integer;
  curType: TLocationType;
begin
  if curLocation<>nil then btnSave.Enabled:=true;
  i:=cmbLocationTypes.itemIndex;
  if i>=0 then begin
    curType:=TLocationType(cmbLocationTypes.Items.objects[i]);
    cmbParentLocation.Enabled:= not ((curType.name='Computer') or (curType.name='HddCase'));
  end;
end;

procedure TFrmEditLocations.TabControl1Change(Sender: TObject);
var
  t: String;
begin
  clearLocations();
  t:=TabControl1.Tabs[TabControl1.TabIndex];
  if t='Computer' then
    loadLocations('Computer')

  else if t='Festplatten' then
    loadLocations('Harddisk')

  else if t='HDD-Gehäuse' then
    loadLocations('HddCase')

  else if t='CD/DVD' then begin
    loadLocations('CdRom');
    loadLocations('Dvd')
  end

  else if t='USB/SD/MMC' then begin
    loadLocations('UsbStick');
    loadLocations('SdMmc');
  end

  else if t='WWW' then
    loadLocations('Web');

  if SGLocations.Cells[0,1]<>'' then
    loadLocation(strtoint(SGLocations.Cells[0,1]))
  else
    btnEmptyFieldsClick(TabControl1);
end;

procedure TFrmEditLocations.loadLocation(location_id: Integer);
begin
  if curLocation<>nil then curLocation.Free;
  curLocation:=TLocation.db_find(sldb,location_id);
  btnSave.enabled:=true;
  btnDelete.enabled:=true;
  cmbLocationTypes.ItemIndex:=cmbLocationTypes.Items.IndexOf(TLocationType.toTitle(curLocation.loc_type));
  edtName.Text:=curLocation.name;
  MemoDescription.Text:=curLocation.description;
  if curLocation.getParentLocation<>nil then
    cmbParentLocation.ItemIndex:=cmbParentLocation.items.IndexOf(curLocation.getParentLocation.name)
  else
    cmbParentLocation.ItemIndex:=-1;
  edtLocated.text:=curLocation.located;
end;


procedure TFrmEditLocations.loadLocations(location_type: String);
var
  tbl: TSQLiteTable;
  i: Integer;
begin
  tbl:=sldb.GetTable(AnsiString(UTF8Encode('SELECT * FROM locations WHERE type="'+location_type+'"')));
  i:=SGLocations.RowCount-1;
  while not tbl.EOF do begin
    SGLocations.RowCount:=max(SGLocations.RowCount,i+1);
    SGLocations.Cells[0,i]:=tbl.FieldAsString(tbl.FieldIndex['ID']);
    SGLocations.Cells[1,i]:=UTF8ToString(tbl.FieldAsString(tbl.FieldIndex['NAME']));
    SGLocations.Cells[2,i]:=UTF8ToString(tbl.FieldAsString(tbl.FieldIndex['DESCRIPTION']));
    inc(i);
    tbl.Next;
  end;
  tbl.Free;
end;

procedure TfrmEditLocations.SGLocationsClick(Sender: TObject);
begin
  if (SGLocations.Row>0) and (SGLocations.Cells[SGLocations.Col,SGLocations.Row]<>'') then loadLocation(strtoint(SGLocations.Cells[0,SGLocations.Row]));
end;

procedure TFrmEditLocations.loadLocationTypes();
var
  i: Integer;
  lt: TLocationType;
begin
  cmbLocationTypes.Items.Clear;
  if locationTypes=nil then locationTypes:=TLocationType.types;
  for i := 0 to locationTypes.Count - 1 do begin
    lt:=TLocationType(locationTypes[i]);
    cmbLocationTypes.Items.addObject(lt.title,lt);
  end;
end;

procedure TFrmEditLocations.loadParentLocations();
var
  i: Integer;
  l: TLocation;
begin
  cmbParentLocation.Items.clear;
  cmbParentLocation.Items.add('');
  if parentLocations=nil then parentLocations:=TLocation.db_find_parent_locations(sldb);
  for i := 0 to parentLocations.Count - 1 do begin
    l:=TLocation(parentLocations[i]);
    cmbParentLocation.Items.addObject(l.name,l);
  end;
end;


end.
