unit Unit2;
 {$OPTIMIZATION OFF}
interface

uses
  IdGlobalProtocols,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SQLiteTable3, ComCtrls, Grids, StringItWell,
  DCPcrypt2, DCPsha256, Math, TabNotBk, ExtCtrls, Menus, Hashes, Contnrs,
  ExtDlgs, FreeBitmap, DBTables,
  UFrmAddFiles, UFrmEditTags,
  UFileinfo, UFileLocation, ULocation, UTag, UTagging,
  UTagMenuItem,
  UHelper,
  //GraphicEx,
  jpeg, UJPGStreamFix, 
  ShellAPI, UPreview, MPlayer, ShellCtrls, IdGlobal,
  AVCodec;

const
  rowPadding=2;
  colPadding=10;
  marginLeft=5;
  marginTop=15;

type

  TByteArray = Array of Byte;
  TCharArray = Array of Char;
  TIntegerArray = Array of Integer;
  TFileinfos = Array of TFileinfo;
  TLocations = Array of TLocation;
  TFileLocations = Array of TFileLocation;
  TFunctionPtr = function : String of Object;
  TSQLParams = record
    select : string;
    from   : string;
    joins  : string;
    conditions : string;
    group_by   : string;
    having : string;
    order : string;
    limit  : integer;
    offset : integer;
  end;
  TFrmMain = class(TForm)
    TagCloud: TGroupBox;
    chkMatchAll: TCheckBox;
    Label1: TLabel;
    DCP_sha256: TDCP_sha256;
    TrackBar1: TTrackBar;
    lblLimitTags: TLabel;
    Timer1: TTimer;
    edtQuery: TEdit;
    MainMenu1: TMainMenu;
    Datei1: TMenuItem;
    Optionen1: TMenuItem;
    Hilfe1: TMenuItem;
    Datenbankwhlen1: TMenuItem;
    Locations1: TMenuItem;
    hinzufgen1: TMenuItem;
    bearbeiten1: TMenuItem;
    hinzufgen2: TMenuItem;
    agSuche1: TMenuItem;
    Filtersuche1: TMenuItem;
    nachSchlagwort1: TMenuItem;
    nachLocation1: TMenuItem;
    nachFilter1: TMenuItem;
    Zufallsmodus1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    Button3: TButton;
    Image1: TImage;
    Ansicht1: TMenuItem;
    VorschaubilderproSpalte1: TMenuItem;
    N11: TMenuItem;
    N21: TMenuItem;
    N31: TMenuItem;
    N41: TMenuItem;
    N51: TMenuItem;
    N61: TMenuItem;
    N71: TMenuItem;
    N81: TMenuItem;
    N91: TMenuItem;
    N101: TMenuItem;
    TabControl1: TTabControl;
    PanelTab1: TPanel;
    StringGrid2: TStringGrid;
    PanelTab2: TPanel;
    ButtonBack: TButton;
    ButtonNext: TButton;
    PanelPreviews: TPanel;
    PopupPreview: TPopupMenu;
    Schlagwortendern1: TMenuItem;
    Dateiffnen1: TMenuItem;
    EnthaltendenOrdnerffnen1: TMenuItem;
    Bilddrehen1: TMenuItem;
    N90rechts1: TMenuItem;
    N90links1: TMenuItem;
    N1801: TMenuItem;
    DateiausderDatenbankentfernen1: TMenuItem;
    Button4: TButton;
    btnCreateAllThumbs: TButton;
    ProgressThumbCreate: TProgressBar;
    humbDBwhlen1: TMenuItem;
    edtTagFilter: TEdit;
    lblFilterTags: TLabel;
    ChkShowAccessablesOnly: TCheckBox;
    Button6: TButton;
    CDROMwhlen1: TMenuItem;
    Button7: TButton;
    LaufwerksbuchstabefrUSBGerte1: TMenuItem;
    Label4: TLabel;
    Schlagwortentfernen1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Datenbankwhlen1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure StringGrid2SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure N11Click(Sender: TObject);
    procedure N101Click(Sender: TObject);
    procedure N91Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure N41Click(Sender: TObject);
    procedure N51Click(Sender: TObject);
    procedure N61Click(Sender: TObject);
    procedure N71Click(Sender: TObject);
    procedure N81Click(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure ButtonNextClick(Sender: TObject);
    procedure Dateiffnen1Click(Sender: TObject);
    procedure EnthaltendenOrdnerffnen1Click(Sender: TObject);
    procedure N90rechts1Click(Sender: TObject);
    procedure N90links1Click(Sender: TObject);
    procedure N1801Click(Sender: TObject);
    procedure btnCreateAllThumbsClick(Sender: TObject);
    procedure humbDBwhlen1Click(Sender: TObject);
    procedure edtTagFilterChange(Sender: TObject);
    procedure edtTagFilterKeyPress(Sender: TObject; var Key: Char);
    function getDriveLetters(): TCharArray;
    function getDriveTypeOf(drv:char):string;
    function getDrivesOfType(typ:Cardinal) : TCharArray;
    function getCdromDriveLetter():String;
    function getUSBDriveLetter():String;
    procedure selectCDROM(Sender: TObject);
    procedure selectUSB(Sender: TObject);

    procedure makeDriveLetterMenus;
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure hinzufgen2Click(Sender: TObject);
    procedure Schlagwortendern1Click(Sender: TObject);
    procedure PopupPreviewPopup(Sender: TObject);
    procedure doRemoveTag(Sender:TObject);
    procedure DateiausderDatenbankentfernen1Click(Sender: TObject);
  private
    { Private declarations }
    importingThumbs,busyReloading: Boolean;
    slDBPath, thumbDBPath: String;
    sltb: TSQLiteTable;
    ItemsForSelectedTags: TObjectList;
    lastLabel: TLabel;
    maxTagCount: Integer;
    curFileinfos: TObjectList;
    clickedPreview: TImage;
    clickedTagName: String;
    clickedTagWasActive: Boolean;
    picsPerCol: Integer;
    pageNo: Integer;
    procedure openDB(promptUser:Boolean);
    procedure openThumbDB;
    procedure loadSettingsFromIniFile();
    procedure highlight(Sender: TObject);
    procedure unhighlight(Sender: TObject);

    procedure showFileinfos(fis: TObjectList);

    // TagCloud
    procedure clearTagcloud;
    function  GetTagCloud(limit:Integer; filter:String = ''): TSQLIteTable;
    procedure showTagcloud(tags:TSQLiteTable);
    procedure renderTag(tag_item,tag_count:String;i:Integer);
    procedure ReloadTagCloud(limit:Integer = -1; filter: String = '');
    procedure arrangeTagCloud;
    procedure selectTag(tag:String);
    procedure unselectTag(tag:String);
    procedure FilterTagCloud;
    procedure tagClick(Sender: TObject);

    // Previews:
    procedure clearPreviews;
    function  GetItemsFor(tags: TStringList; match_all:Boolean): TObjectList;
    function  renderPreview(fi:TFileinfo;index:Integer):Boolean;
    procedure updatePreviews;
    procedure arrangePreviews();
    procedure previewClick(Sender: TObject; MousePos: TPoint; var Handled: Boolean);

    function  StringToArrayOfBytes(s:String): TByteArray;
    function  getCommaListOf(attr:String;t:TObjectList;quot:String): String;
    function  quoteConcatStrList(s:TStringlist): string;
    function LoadImage(var img: TImage; fi : TFileinfo; angle:Integer):Boolean;
//    function doLoadImage(fpath: String; img: TImage; angle: Integer = 0; fi:TFileinfo = nil): Boolean;
//    procedure saveThumb(fi:TFileinfo; img:TImage);
  public
    { Public declarations }
    sldb, thumbsdb: TSQLiteDatabase;
    selectedTags: TStringlist;
    locations : TLocations;
    getCDROM : TFunctionPtr;
    selectedCDROMDrive: String;
    selectedUSBDrive: String;
    procedure updateDocuments(limit: Integer = -1; offset:Integer = -1);
    function GetSha2(filename:String): String;
    function GetFilesize(path_file:string): Integer;
    function Sha2(s:String): String;
  end;

var
  FrmMain: TFrmMain;
  getCDROM : function(): String;
implementation

{$R *.dfm}

uses FreeImage;



procedure TFrmMain.FormCreate(Sender: TObject);
begin
  av_register_all;
  importingThumbs:=false;
  busyReloading:=false;
  // Settings setzen (Defaults)
  slDBPath := ExtractFilepath(application.exename)+ 'db\tgit.db';
  thumbDBPath := ExtractFilepath(application.exename)+ 'db\tgit_thumbs.db';
  picsPerCol:=3;
  // Settings ggf. überladen mit Einstellungen aus INI-File:
  loadSettingsFromIniFile();
  pageNo:=1;
  selectedTags:=TStringlist.create;
  selectedTags.Sorted:=true;
  curFileinfos:=TObjectList.create;
  openDB(false); // try to open DB, but don't prompt user to choose a db-file
  openThumbDB;
  makeDriveLetterMenus();
  self.OnResize(self);
end;

procedure TFrmMain.openDB(promptUser:Boolean);
var
  limit,i: Integer;
begin
  FrmMain.Caption:='Tgit GUI';
  if not FileExists(slDBPath) and promptUser then
    begin
      if OpenDialog1.execute then
        slDBPath := OpenDialog1.Filename
      else
        alert('Bitte wählen Sie im Menü "Optionen" eine Datenbank aus!');
    end;
  if FileExists(slDBPath) then begin
    sldb := TSQLiteDatabase.Create(slDBPath);
    FrmMain.Caption:='Tgit GUI - '+slDBPath;
    //sltb := sldb.GetTable('select count(*) as anz from tags');
    //limit := floor(sltb.FieldAsInteger(sltb.FieldIndex['anz'])*(TrackBar1.Position/Trackbar1.max));
    reloadTagCloud;
    lastLabel:=nil;
    locations:=TLocations(TLocation.all(sldb));
  end;
end;
procedure TFrmMain.openThumbDB;
begin
  try
    thumbsdb := TSQLiteDatabase.Create(thumbDBPath);
  except
    alert('Die Thumbnail-Datenbank konnte nicht geöffnet werden.');
  end;
end;

// Holt die Dokumente zu den angegebenen tags.
function TFrmMain.GetItemsFor(tags:TStringList; match_all: Boolean):TObjectList;
var
  idx: Integer;
  query,flid: String;
  tbl: TSQLiteTable;
  h,r: THash;
  f,fi: TFileinfo;
  fl: TFileLocation;
begin
  //result:=TObjectList.create;
  curFileinfos.Clear;
  query:='SELECT temp.*,file_locations.id AS FILE_LOCATION_ID FROM '+
         '  (SELECT fileinfos.* FROM tags '+
         '   LEFT JOIN taggings ON taggings.tag_id=tags.id '+
         '   LEFT JOIN fileinfos on fileinfos.id=taggings.taggable_id AND taggings.taggable_type="Fileinfo" '+
         '   WHERE tags.name in ("'+UTF8Encode(AssembleItWell(tags,'","'))+'") '+
         '   GROUP BY fileinfos.id ';
  if match_all then begin
    query := query+' HAVING count(distinct tags.id)='+inttostr(tags.count);
  end;
  query:=query+') AS temp'+
               ' LEFT JOIN file_locations ON temp.id=file_locations.fileinfo_id ';

  edtQuery.text:=query;
  tbl := slDb.GetTable(query);
  h:=THash.create;

  while not tbl.eof do begin
    r:=tbl.GetRow;
    f:=TFileinfo.create(sldb,r,true);
    r.free;
    if h.GetString(inttostr(f.id))<>'1' then begin
        h.SetString(inttostr(f.id),'1');
        curFileinfos.add(f);
    end;
    tbl.Next;
  end;
  h.free;
  result:=curFileinfos;
end;

procedure TFrmMain.showFileinfos(fis: TObjectList);
var
  i,j,k:Integer;
  fi:TFileinfo;
  fl: TFileLocation;
begin
  for i:=0 to StringGrid2.Rowcount-1 do begin
    StringGrid2.Rows[i].clear;
  end;
  i:=0;
  if fis.Count > 0 then begin
    while i<fis.count do begin
      fi:=TFileinfo(fis[i]);
      StringGrid2.rowcount:=i+1;
      StringGrid2.cells[0,i]:=inttostr(fi.id);
      StringGrid2.cells[1,i]:=fi.sha2;
      StringGrid2.cells[2,i]:=inttostr(fi.filesize);
      j:=4;
      for k:=0 to fi.file_locations.Count-1 do begin
          fl:=TFileLocation(fi.file_locations[k]);
          if fl.accessible then
            StringGrid2.cells[3,i]:=fl.full_path
          else begin
            StringGrid2.cells[j,i]:=fl.full_path;
            inc(j);
          end;
      end;
      inc(i);
    end;
  end;
  updatePreviews;
end;

// Fragt nichts in der DB ab oder so, sondern ist nur für die Pagination zuständig.
// Wird also von den Buttons BACK/NEXT aufgerufen, sowie dann, wenn im Menü eine
// andere Anzahl von Bildern pro Spalte eingestellt wird.
procedure TFrmMain.updatePreviews;
var
  i,perPage,c,k: Integer;
  fi: TFileinfo;
  fl:TFileLocation;
  accessiblePath: string;
begin
  clearPreviews;
  accessiblePath:='';
  perPage:=picsPerCol*picsPerCol;
  i:=(pageNo-1)*perPage;  // Startindex
  c:=0;
  while (i<curFileinfos.Count) and (c<perPage) do begin
    fi:=TFileinfo(curFileinfos[i]);
    if renderPreview(fi,i) then begin
      arrangePreviews();
      application.processMessages;
      inc(c);
    end;
    inc(i);
  end;
end;

function TFrmMain.renderPreview(fi:TFileinfo; index:Integer): Boolean;
var
  img: TImage;
  accessiblePath: String;
  success: Boolean;
  tbl: TSQLiteTable;
  data: TMemoryStream;
  jp: TJpegImage;
begin
  accessiblePath:=fi.getAccessibleLocation(selectedCDROMDrive,selectedUSBDrive);
  if (accessiblePath='') and ChkShowAccessablesOnly.Checked then
    result:=false  // Falls das Bild nicht erreichbar ist und nicht-erreichbare nicht ausgegeben werden sollen
  else begin
    result:=true;
    img:=TPreview.create(FrmMain,PanelPreviews,fi,index);
    with img do begin
      hide;
      stretch:=true;
      Proportional:=true;
      center:=true;
      //IncrementalDisplay:=true;  // ???
      width:=(PanelPreviews.Width div picsPerCol)-colPadding;
      height:=(PanelPreviews.height div picsPerCol)-rowPadding;
      Parent:=PanelPreviews;
      Hint:=accessiblePath;
      ShowHint:=true;
      img.onDblClick:=TPreview(img).dblClick;
      OnContextPopup:=previewClick;
      PopupMenu:=PopupPreview;
    end;

    // Versuchen den Thumbnail aus der DB zu laden:
    tbl:=thumbsdb.GetTable('SELECT data FROM thumbs WHERE fileinfo_id="'+inttostr(fi.id)+'" LIMIT 1');
    if tbl.RowCount>0 then begin
      if not importingThumbs then begin
        data:=TMemoryStream.create;
        data:=tbl.FieldAsBlob(tbl.FieldIndex['data']);
        data.Seek(0,0);
        jp:=TJPEGImage.create;
        jp.LoadFromStream(data);
        img.picture.assign(jp);
//alert('nach assign: '+TPreview(img).fileinfo.sha2);
        jp.free;
        data.free;
      end;
    end
    else begin
      success := LoadImage(img,fi,0);
//alert('nach LoadImage: '+TPreview(img).fileinfo.sha2);
      if not success then begin // Bild ist nicht-erreichbar oder nicht darstellbar.
        img.Picture.LoadFromFile(ExtractFilepath(application.ExeName)+'public\images\no_disk.jpg');
//alert('nach .Picture.LoadFromFile: '+TPreview(img).fileinfo.sha2);
      end;
    end;
  end;
end;

procedure TFrmMain.arrangePreviews();
const
  rowPadding=2;
  colPadding=10;
  marginLeft=5;
  marginTop=15;
var
  i: Integer;
  l,t,h: Integer; // left, top und height
  cur,last: TImage;
begin
  last:=nil;
  h:=0;
  for i:=0 to PanelPreviews.controlcount-1 do begin
    cur:=TPreview(PanelPreviews.controls[i]);
    // Positionierung:
    if last=nil then begin
      cur.left:=colPadding;
      cur.Top:=rowPadding;
    end
    else begin
      h:=max(h,last.Height);
      l:=last.Left+last.width+colPadding;
      t:=last.Top;
      if l+cur.width > cur.Parent.Width then begin
          l:=marginLeft;
          t:=t+h+rowPadding;
      end;
      cur.Left:=l;
      cur.Top:=t;
    end;
    cur.Show;
    application.ProcessMessages;
    last:=cur;
  end;
end;

procedure TFrmMain.clearPreviews;
begin
  while PanelPreviews.ControlCount>0 do
    PanelPreviews.Controls[0].free;
end;


procedure TFrmMain.clearTagCloud;
begin
  while TagCloud.ControlCount>0 do
    TagCloud.Controls[0].free;
end;

procedure TFrmMain.ReloadTagCloud(limit:Integer = -1; filter: String = '');
begin
  busyReloading:=true;
  application.ProcessMessages;
  if limit=-1 then limit:=300;
  clearTagCloud;
  application.ProcessMessages;
  showTagcloud(GetTagCloud(limit,filter));
  busyReloading:=false;
end;

// Zeigt die TagCloud in Abhängigkeit der aktuell gewählten Tags und Dokumente:
function TFrmMain.GetTagCloud(limit:Integer; filter: String = ''): TSQLiteTable;
var
  query,taggable_ids,tagnames,joinCondition,filterCondition,having: String;
  tmp: TSQLiteTable;
begin
  if limit=0 then begin
    tmp := sldb.GetTable('SELECT COUNT(*) AS anz FROM tags WHERE name LIKE "%'+UTF8Encode(filter)+'%"');
    limit := floor(tmp.FieldAsInteger(tmp.FieldIndex['anz'])*(TrackBar1.Position/Trackbar1.max));
  end;
  joinCondition:='';
  having:='';
  filterCondition:=' WHERE tags.name LIKE "%'+UTF8Encode(filter)+'%" ';
  if (ItemsForSelectedTags<>nil) and (ItemsForSelectedTags.count>0) then begin
    taggable_ids:=getCommaListOf('id',itemsForSelectedTags,'');
//    alert('taggable_ids = '+taggable_ids);
    if taggable_ids<>'' then
      joinCondition:=' AND taggable_type="Fileinfo" AND taggings.taggable_id IN ('+taggable_ids+') '
    else
      joinCondition:=' AND 1=2 '; // unmögliche Bedingung
    tagnames:=quoteConcatStrList(selectedTags);
//    alert('tagnames = '+tagnames);
//    having:=' HAVING tags.name NOT IN ('+UTF8Encode(tagnames)+') ';
  end;
  query:='SELECT name, id, anz '+
    'FROM '+
    '  ( SELECT name, tags.id AS id, count(*) as anz '+
    '    FROM tags '+
    '    JOIN taggings ON taggings.tag_id=tags.id '+
       joinCondition +
       filterCondition +
    '    GROUP BY tags.id '+
       having+
    '    ORDER BY anz DESC '+
    '    LIMIT '+inttostr(limit)+
    '  ) AS temp '+
    'ORDER BY name COLLATE NOCASE';
  result := slDb.GetTable(query);
end;

function TFrmMain.getCommaListOf(attr:String;t:TObjectList;quot:String): String;
var
  val: String;
  i: Integer;
begin
  result:='';
  i:=0;
  while i<t.count do begin
    val:=TFileinfo(t[i]).getAttr(attr);
    if result='' then
      result:=result+quot+val+quot
    else
      result:=result+','+quot+val+quot;
    inc(i);
  end;
end;

procedure TFrmMain.showTagcloud(tags:TSQLIteTable);
var i: Integer;
var tag_item,tag_count: String;
begin
  maxTagCount:=0;
  i:=0;
  if tags.Count > 0 then begin
    while not tags.EOF do begin
      tag_item:=UTF8Decode(tags.FieldAsString(tags.FieldIndex['Name']));
      tag_count:=tags.FieldAsString(tags.FieldIndex['anz']);
      maxTagCount:=max(maxTagCount,StrToInt(tag_count));
      renderTag(tag_item,tag_count,i);
      inc(i);
      tags.Next;
    end;
  end;
  arrangeTagCloud;
end;

procedure TFrmMain.renderTag(tag_item,tag_count:String; i:Integer);
// i ist die "laufende Nummer" der Tags (wenn diese z.B. in ein Stringgrid eingetragen werden sollen)
const
  minFontSize=10; // Minimale Fontgröße für Tags
  incFontBy=15;   // Maximale Fontgröße ist minFontSize+incFontSize
var
  tag: TLabel;
begin
  tag:=TLabel.create(TagCloud);
  tag.Parent:=TagCloud;
  tag.Caption:=tag_item;
  tag.Hint:=tag_count+' mal getagged';
  tag.ShowHint:=true;
  tag.Transparent:=true;
  if (selectedTags<>nil) and (selectedTags.IndexOf(tag.caption)>-1) then begin
      tag.Font.Color:=clBlue;
      tag.tag:=1;
  end
  else begin
      tag.Font.Color:=clBlack;
      tag.tag:=0;
  end;
  tag.Font.Style:=[fsUnderline];
  tag.Font.Name:='Helvetica';
  tag.Font.Size:=floor(minFontSize+(strtoint(tag_count)/maxTagCount)*incFontBy);
  tag.OnMouseEnter:=highlight;
  tag.OnMouseLeave:=unhighlight;
  tag.OnClick:=tagClick;
end;

// EventHandling für dynamisch erzeugte TagLabels:
procedure TFrmMain.tagClick(Sender:TObject);
begin
  pageNo:=1;
  ButtonBack.enabled:=false;
  clickedTagName:=TLabel(Sender).caption;
  clickedTagWasActive:=(TLabel(Sender).tag=1);
  Timer1.Enabled:=true;
end;

procedure TFrmMain.previewClick(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  clickedPreview:=TPreview(Sender);
end;

procedure TFrmMain.selectTag(tag:String);
begin
  if selectedTags.indexOf(tag)=-1 then
    selectedTags.add(tag);
end;

procedure TFrmMain.unselectTag(tag:String);
var p : Integer;
begin
  p := selectedTags.IndexOf(tag);
  if p>-1 then
    selectedTags.Delete(p);
end;

procedure TFrmMain.highlight(Sender:TObject);
begin
  TLabel(Sender).Font.color:=clred;
end;

procedure TFrmMain.unhighlight(Sender:TObject);
var tag: TLabel;
begin
  tag:=TLabel(Sender);
  if tag.tag=1 then
    tag.Font.color:=clBlue
  else
    tag.Font.Color:=clBlack;
end;

// <-- EventHandling für dynamisch erzeugte TagLabels


procedure TFrmMain.updateDocuments(limit: Integer = -1; offset:Integer = -1);
begin
  if limit=-1 then limit:=picsPerCol*picsPerCol;
  if offset=-1 then offset:=pageNo-1;
  ItemsForSelectedTags:=GetItemsFor(selectedTags,chkMatchAll.checked);
  showFileinfos(ItemsForSelectedTags);
end;

procedure TFrmMain.arrangeTagCloud();
const
  rowPadding=2;
  colPadding=10;
  marginLeft=5;
  marginTop=15;
var
  i,l,t,h,voffset:Integer;
  tag: TLabel;
begin
  lastLabel:=nil;
  h:=0;
  for i:=0 to TagCloud.ComponentCount-1 do begin
    tag:=TLabel(TagCloud.Components[i]);
    if tag.Visible then begin
      if lastLabel=nil then begin
          tag.Top:=marginTop;
          tag.Left:=marginLeft;
          h:=tag.height;
      end
      else begin
        h:=max(h,lastLabel.Height);
        l:=lastLabel.Left+lastLabel.width+colPadding;
        t:=lastLabel.Top;
        voffset:=0; // zur schöneren vertikalen Ausrichtung zweier benachbarter stark unterschiedlich großer Tags
        if l+tag.width > tag.Parent.Width then begin
          l:=marginLeft;
          t:=t+h+rowPadding;
          h:=0;
        end
        else begin
          voffset:=floor(lastLabel.Height-tag.height) div 2;
        end;
        tag.Left:=l;
        tag.Top:=t+voffset;
      end;
      lastLabel:=tag;
    end;
  end;
  if lastLabel<>nil then
    TagCloud.Height:=lastLabel.Top+h+rowPadding;
end;

function TFrmMain.Sha2(s:String): String;
var
  HashDigest: array of byte;
  j: integer;
begin
  result:='';
  try
    DCP_sha256.Init;
    DCP_sha256.UpdateStr(s);
    SetLength(HashDigest,DCP_sha256.HashSize div 8);
    DCP_sha256.Final(HashDigest[0]);  // get the output
    s := '';
    for j := 0 to Length(HashDigest) - 1 do  // convert it into a hex string
      s := s + IntToHex(HashDigest[j],2);
    result:=lowercase(s);  // <--- SQLite3 ist case-sensitive!
  except
    MessageDlg('An error occurred while reading the file',mtError,[mbOK],0);
  end;
end;

function TFrmMain.GetFilesize(path_file:string): Integer;
var
  f: File of Byte;
begin
  assignfile(f,path_file);
  reset(f);
  result:=filesize(f);
  closefile(f);
end;

function TFrmMain.GetSha2(filename:String): String;
var
  strmInput: TFileStream;
  HashDigest: array of byte;
  j, read: integer;
  s: string;
  buffer: array[0..16383] of byte;
begin
  try
    DCP_sha256.Init;
    strmInput := TFileStream.Create(filename,fmOpenRead);
    repeat
      read := strmInput.Read(buffer,Sizeof(buffer));
      DCP_sha256.Update(buffer,read);
    until read <> Sizeof(buffer);
    strmInput.Free;
    SetLength(HashDigest,DCP_sha256.HashSize div 8);
    DCP_sha256.Final(HashDigest[0]);  // get the output
    s := '';
    for j := 0 to Length(HashDigest) - 1 do  // convert it into a hex string
      s := s + IntToHex(HashDigest[j],2);
    result:=lowercase(s);  // <--- SQLite3 ist case-sensitive!
  except
    strmInput.Free;
    MessageDlg('An error occurred while reading the file',mtError,[mbOK],0);
  end;
end;


function TFrmMain.StringToArrayOfBytes(s:String):TByteArray;
var
  j: integer;
begin
  SetLength(Result, Length(s)) ;
  for j := 0 to Length(s) - 1 do
    Result[j] := ord(s[j + 1]) - 48;
end;

//procedure TFrmMain.alert(s:String);
//begin
//  messageDlg(s,mtInformation,[mbOK],0);
//end;

procedure TFrmMain.FormResize(Sender: TObject);
begin
  TagCloud.width:=FrmMain.Width div 2 -25;
  TabControl1.width:=FrmMain.Width div 2 -25;
  TagCloud.left:=TabControl1.width+TabControl1.left+25;
  arrangeTagCloud;
  //updatePreviews;
  arrangePreviews;
end;

procedure TFrmMain.TrackBar1Change(Sender: TObject);
var newLimit: Integer;
begin
  if not busyReloading then begin
    sltb:=sldb.GetTable('SELECT COUNT(*) AS anz FROM tags');
    newLimit:=floor(sltb.FieldAsInteger(sltb.FieldIndex['anz'])*Trackbar1.Position/TrackBar1.max);
    reloadTagCloud(newLimit);
  end;
end;

function TFrmMain.quoteConcatStrList(s:TStringlist): string;
var i: Integer;
begin
  result:='';
  for i:=0 to s.Count-1 do begin
    if result='' then
      result:='"'+s[i]+'"'
    else
      result:=result+',"'+s[i]+'"';
  end;
end;

procedure TFrmMain.loadSettingsFromIniFile();
var
  fn,buff: String;
  f: Textfile;
begin
// Zeile 1: String:  Pfad zur DB-Datei
// Zeile 2: String:  Pfad zur Thumb-DB-Datei
// Zeile 3: Integer: picsPerCol
  fn:=ExtractFilepath(application.exename)+ 'tgit.ini';
  if fileExists(fn) then begin
    AssignFile(f,fn);
    Reset(f);
    readln(f,sldbpath);
    if not EOF(f) then
      readln(f,thumbDBPath);
    if not EOF(f) then begin
      readln(f,buff);
      if buff<>'' then picsPerCol:=strtoint(buff);
    end;
    closeFile(f);
  end;
end;

procedure TFrmMain.Datenbankwhlen1Click(Sender: TObject);
begin
  if OpenDialog1.execute then begin
    slDBPath := OpenDialog1.FileName;
    openDB(true);
  end;
end;

procedure TFrmMain.humbDBwhlen1Click(Sender: TObject);
begin
  if OpenDialog1.execute then
    thumbDBPath := OpenDialog1.FileName;
  if fileExists(thumbDBPath) then
    openThumbDB;
end;


procedure TFrmMain.FormDestroy(Sender: TObject);
var
  f: Textfile;
  fname: string;
begin
  fname:=extractfilepath(application.exename)+'\tgit.ini';
  assignfile(f,fname);
  rewrite(f);
  writeln(f,sldbpath);
  writeln(f,thumbdbpath);
  writeln(f,inttostr(picsPerCol));
  closeFile(f);
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=false;
  Screen.Cursor := crHourGlass;
  if clickedTagWasActive then
    unselectTag(clickedTagName)
  else
    selectTag(clickedTagName);
  updateDocuments();
  clearTagcloud;
  showTagCloud(GetTagcloud(0));
  edtTagFilter.text:='';
  Screen.Cursor := crDefault;
end;


procedure TFrmMain.Button2Click(Sender: TObject);
var h:THash;
  s:String;
begin
  h:=THash.create;
  s:='123';
  h.SetString('id',s);
  alert(h.GetString('id'));
end;

procedure TFrmMain.Button3Click(Sender: TObject);
begin
//  updateDocumentList();
end;

procedure TFrmMain.StringGrid2SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  fpath: String;
  i: Integer;
  found: Boolean;
begin
  i:=3;
  found:=false;
  while (not found) and (i<StringGrid2.ColCount) do begin
    fpath:=StringGrid2.cells[i,ARow];
    if fileExists(fpath) then begin
      found:=true;
      //REDO: LoadImage(Image1,fpath,0);
    end
    else
      i:=i+1;
  end;
end;

procedure TFrmMain.N11Click(Sender: TObject);
begin
  picsPerCol:=1;
  TMenuItem(Sender).Checked:=true;
  updatePreviews;
end;

procedure TFrmMain.N21Click(Sender: TObject);
begin
  picsPerCol:=2;
  TMenuItem(Sender).Checked:=true;
  updatePreviews;
end;

procedure TFrmMain.N31Click(Sender: TObject);
begin
  picsPerCol:=3;
  TMenuItem(Sender).Checked:=true;
  updatePreviews;
end;

procedure TFrmMain.N41Click(Sender: TObject);
begin
  picsPerCol:=4;
  TMenuItem(Sender).Checked:=true;
  updatePreviews;
end;

procedure TFrmMain.N51Click(Sender: TObject);
begin
  picsPerCol:=5;
  TMenuItem(Sender).Checked:=true;
  updatePreviews;
end;

procedure TFrmMain.N61Click(Sender: TObject);
begin
  picsPerCol:=6;
  TMenuItem(Sender).Checked:=true;
  updatePreviews;
end;

procedure TFrmMain.N71Click(Sender: TObject);
begin
  picsPerCol:=7;
  TMenuItem(Sender).Checked:=true;
  updatePreviews;
end;

procedure TFrmMain.N81Click(Sender: TObject);
begin
  picsPerCol:=8;
  TMenuItem(Sender).Checked:=true;
  updatePreviews;
end;

procedure TFrmMain.N91Click(Sender: TObject);
begin
  picsPerCol:=9;
  TMenuItem(Sender).Checked:=true;
  updatePreviews;
end;

procedure TFrmMain.N101Click(Sender: TObject);
begin
  picsPerCol:=10;
  TMenuItem(Sender).Checked:=true;
  updatePreviews;
end;

procedure TFrmMain.TabControl1Change(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to  TabControl1.controlCount-1 do
    TabControl1.Controls[i].Hide;
  case TabControl1.tabindex of
    0: PanelTab1.Show;
    1: PanelTab2.Show;
  end;
end;

procedure TFrmMain.ButtonBackClick(Sender: TObject);
begin
  dec(pageNo);
  updatePreviews;
  if(pageNo<=1) then ButtonBack.Enabled:=false;
  if(pageNo*picsPerCol*picsPerCol<curFileinfos.Count) then ButtonNext.Enabled:=true;
end;

procedure TFrmMain.ButtonNextClick(Sender: TObject);
begin
  inc(pageNo);
  updatePreviews;
  if(pageNo>1) then ButtonBack.Enabled:=true;
  if(pageNo*picsPerCol*picsPerCol>=curFileinfos.Count) then ButtonNext.Enabled:=false;
end;

function TFrmMain.LoadImage(var img: TImage; fi: TFileinfo; angle: Integer):Boolean;
var
  fpath: string;
begin
  result:=true;
  fpath:=fi.getAccessibleLocation(selectedCDROMDrive,selectedUSBDrive);
  if fpath='' then
    result:=false
  else
    result:=doLoadImage(fpath,img,0,fi,sldb,thumbsdb,importingThumbs);
end;


procedure TFrmMain.DateiausderDatenbankentfernen1Click(Sender: TObject);
begin
  TFileinfo.db_destroy(sldb,TPreview(clickedPreview).fileinfo.id);
  curFileinfos.Remove(TPreview(clickedPreview).fileinfo);
  updatePreviews;
end;

procedure TFrmMain.Dateiffnen1Click(Sender: TObject);
begin
  TPreview(clickedPreview).OnDblClick(Sender);
end;

procedure TFrmMain.EnthaltendenOrdnerffnen1Click(Sender: TObject);
var
  path:string;
begin
  path:=ExtractFilepath(TPreview(clickedPreview).filepath);
  if DirectoryExists(path) then
    ShellExecute(Handle, 'open', PChar(path), nil, nil, SW_SHOW)
  else
    alert('Dieser Ordner ist auf diesem Computer nicht verfügbar.');
end;

procedure TFrmMain.N90rechts1Click(Sender: TObject);
begin
  clickedPreview.Tag:=((90+ClickedPreview.tag) mod 360);
end;

procedure TFrmMain.N90links1Click(Sender: TObject);
begin
  clickedPreview.Tag:=((270+clickedPreview.tag) mod 360);
end;

procedure TFrmMain.N1801Click(Sender: TObject);
begin
  clickedPreview.Tag:=((180+clickedPreview.tag) mod 360);
end;

procedure TFrmMain.btnCreateAllThumbsClick(Sender: TObject);
var
  query,flid: String;
  h,row: THash;
  tbl: TSQLiteTable;
  f:TFileinfo;
  idx: Integer;
  fl: TFileLocation;
begin
  importingThumbs:=true;
  query:='SELECT fileinfos.*,file_locations.id AS FILE_LOCATION_ID'+
         ' FROM fileinfos'+
         ' LEFT JOIN file_locations ON fileinfos.id=file_locations.fileinfo_id';
  tbl := slDb.GetTable(query);
  h:=THash.create;
  ProgressThumbCreate.min:=0;
  ProgressThumbCreate.max:=tbl.RowCount;
  while not tbl.eof do begin
    row:=tbl.GetRow;
    f:=TFileinfo.create(sldb,row,true);
    row.free;
    if h.GetString(inttostr(f.id))<>'1' then begin
      h.SetString(inttostr(f.id),'1');
      curFileinfos.add(f);
    end;
    if f.getAccessibleLocation(selectedCDROMDrive, selectedUSBDrive)<>'' then
      LoadImage(image1,f,0);
    tbl.Next;
    ProgressThumbCreate.StepIt;
    application.ProcessMessages;
  end;
  alert('done');
  h.free;
end;


procedure TFrmMain.edtTagFilterChange(Sender: TObject);
begin
 filterTagCloud();
end;

procedure TFrmMain.FilterTagCloud;
begin
  reloadTagCloud(-1,edtTagFilter.text);
  arrangeTagCloud;
end;

procedure TFrmMain.edtTagFilterKeyPress(Sender: TObject; var Key: Char);
var
  i: Integer;
  a_label, exact, at_beginning, in_middle: TLabel;
  tag,filter: string;
begin
  exact:=nil;
  at_beginning:=nil;
  in_middle:=nil;
  if Key=Char(VK_RETURN) then begin
    filter:=lowercase(edtTagFilter.Text);
    // exakten Match suchen (bis auf case-Sensitivity):
    for i:=0 to TagCloud.Controlcount-1 do begin
      a_label:=TLabel(TagCloud.Controls[i]);
      tag:=lowercase(a_label.caption);
      if tag=filter then begin
        exact:=a_label;
        break;
      end
      else
        if (at_beginning=nil) and (pos(filter,tag)=1) then
          at_beginning:=a_label
        else
          if (in_middle=nil) and (pos(filter,tag)>0) then
            in_middle:=a_label;
    end; // end for
    if exact<>nil then
      exact.OnClick(exact)
    else
      if at_beginning<>nil then
        at_beginning.OnClick(at_beginning)
      else
        if in_middle<>nil then
          in_middle.OnClick(in_middle);
  end;
end;


function TFrmMain.getDriveLetters(): TCharArray;
var
  i,j,bits : integer;
const
  abc='abcdefghijklmnopqrstuvwxyz';
begin
  j:=0;
  bits := getLogicalDrives();
  for i:=1 to 26 do begin
    if inttobin(bits)[32-i+1]='1' then begin
      setlength(result,length(result)+1);
      result[length(result)-1]:=abc[i];
    end;
  end;
end;

{
 verfügbare Laufwerke herausfinden:
 * DWORD GetLogicalDrives()
 * DWORD GetLogicalDriveStrings( DWORD nBufferLength, LPTSTR lpBuffer )
 * UINT GetDriveType( LPCTSTR lpRootPathName )

 0	The drive type cannot be determined.
 1	The root directory does not exist.
 DRIVE_REMOVABLE	The drive can be removed from the drive.
 DRIVE_FIXED	The disk cannot be removed from the drive.
 DRIVE_REMOTE	The drive is a remote (network) drive.
 DRIVE_CDROM	The drive is a CD-ROM drive.
 DRIVE_RAMDISK	The drive is a RAM disk.
}
function TFrmMain.getDriveTypeOf(drv:Char):string;
var
 s: string;
begin
  s:=drv+':';
  case GetDriveType(PChar(s)) of
  0 : result:='unknown type';
  1 : result:='root dir does not exist';
  DRIVE_REMOVABLE  : result:='removable drive';
  DRIVE_FIXED      : result:='harddisk';
  DRIVE_REMOTE     : result:='network drive';
  DRIVE_CDROM      : result:='CD-ROM';
  DRIVE_RAMDISK	   : result:='RAM disk'
  else
    result:='very unknown type';
  end;
end;


function TFrmMain.getDrivesOfType(typ:Cardinal) : TCharArray;
var
 s: string;
 arr: TCharArray;
 i: integer;
begin
  arr:=getDriveLetters;
  for i:=0 to length(arr)-1 do begin
    s:=arr[i]+':';
    if GetDriveType(PChar(s)) = typ then begin
      setlength(result,length(result)+1);
      result[length(result)-1]:=arr[i];
    end;
  end;
end;


procedure TFrmMain.Button6Click(Sender: TObject);
  var
    arr: TCharArray;
    i: integer;
begin
  arr:=getDriveLetters;
//  arr:=getDrivesOfType(CDROM_DRIVE);
  for i:=0 to length(arr)-1 do
    edtQuery.text:=edtQuery.text+',   '+arr[i]+':\ ('+getDriveTypeOf(arr[i])+')';
end;


procedure TFrmMain.makeDriveLetterMenus;
  var
    arr: TCharArray;
    i,k: integer;
    t: TMenuItem;
    s:string;
    typs: Array[0..1] of Cardinal;
begin
  typs[0]:=DRIVE_CDROM;
  typs[1]:=666;
  for k:=0 to length(typs)-1 do begin
    if typs[k]=666 then
      arr:=getDriveLetters
    else
      arr:=getDrivesOfType(typs[k]);
    for i:=0 to length(arr)-1 do begin
      t:=TMenuItem.Create(MainMenu1);
      with t do begin
        Caption:=arr[i]+':\';
        GroupIndex:=2;
        RadioItem:=true;
        if typs[k]=DRIVE_CDROM then
          OnClick:=selectCDROM
        else
          if typs[k]=666 then OnClick:=selectUSB;
      end;
      Mainmenu1.Items[3].Items[2+k].add(t);
    end;
  end;
end;

procedure TFrmMain.selectCDROM(Sender: TObject);
var
  m: TMenuItem;
begin
  m:=TMenuItem(Sender);
  m.checked:=true;
  selectedCDROMDrive:=copy(m.caption,2,length(m.Caption)-1);
end;

procedure TFrmMain.selectUSB(Sender: TObject);
var
  m: TMenuItem;
begin
  m:=TMenuItem(Sender);
  m.checked:=true;
  selectedUSBDrive:=copy(m.caption,2,length(m.Caption)-1);
end;

function TFrmMain.getCdromDriveLetter():String;
begin
  result:=selectedCDROMDrive;
end;
function TFrmMain.getUSBDriveLetter():String;
begin
  result:=selectedUSBDrive;
end;


procedure TFrmMain.Button7Click(Sender: TObject);
begin
  alert(inttostr(PanelPreviews.Controlcount));
  alert(TPreview(PanelPreviews.Controls[0]).filepath);
  alert(TFrmMain(TPreview(PanelPreviews.Controls[0]).mainForm).caption);
  alert(TPreview(PanelPreviews.Controls[0]).fileinfo.sha2);
//  alert(TPreview(PanelTab2.Controls[0]).fileinfo.getAlternateDriveLetter);
end;


procedure TFrmMain.Button10Click(Sender: TObject);
begin
  with FrmAddFiles do begin
    Hide;
    edtInitialTags.Text:='';
  end;
end;

procedure TFrmMain.hinzufgen2Click(Sender: TObject);
begin
  with TFrmAddFiles.Create(self) do
  try
    ShowModal;
  finally
    Free;
  end;
  updateDocuments;
  reloadTagCloud;
end;

procedure TFrmMain.Schlagwortendern1Click(Sender: TObject);
begin
  with TFrmEditTags.Create(self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

// Wenn das Popup-Menu aufgemacht wird, wird dynamisch das Untermenu
// mit den Tags der angeklickten Preview erzeugt. Die Tags können somit über das
// Kontextmenu entfernt werden!
procedure TFrmMain.PopupPreviewPopup(Sender: TObject);
var
  i: Integer;
  fi: TFileinfo;
  tags: TObjectList;
  subm,mi: TMenuItem;
begin
  fi:=TPreview(clickedPreview).fileinfo;
  tags:=fi.getTags;
  subm:=TPopupMenu(Sender).items[1];
  if subm.count>0 then subm.Clear;
  for i:=0 to tags.Count-1 do begin
    mi:=TTagMenuItem.create(subm,tags[i]);
    with mi do begin
      GroupIndex:=1;
      OnClick:=doRemoveTag;
    end;
    subm.add(mi);
  end;
end;

procedure TFrmMain.doRemoveTag(Sender:TObject);
begin
  TPreview(clickedPreview).fileinfo.removeTagID(TTagMenuItem(Sender).tag.id);
  updateDocuments;
end;

end.

