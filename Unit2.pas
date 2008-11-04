unit Unit2;
 {$OPTIMIZATION OFF}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SQLiteTable3, ComCtrls, Grids, StringItWell,
  DCPcrypt2, DCPsha256, Math, TabNotBk, ExtCtrls, Menus, Hashes, Contnrs,
  ExtDlgs, UFileinfo, UFileLocation, FreeBitmap, DBTables,
  //GraphicEx,
  jpeg,
  ShellAPI, UJPGStreamFix, UPreview, MPlayer, ShellCtrls;

const
  rowPadding=2;
  colPadding=10;
  marginLeft=5;
  marginTop=15;

type
  TByteArray = Array of Byte;
  TIntegerArray = Array of Integer;
  TFileinfos = Array of TFileinfo;
  TFileLocations = Array of TFileLocation;
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
  TForm1 = class(TForm)
    edtSelectedTags: TEdit;
    TagCloud: TGroupBox;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Button1: TButton;
    DCP_sha256: TDCP_sha256;
    TrackBar1: TTrackBar;
    Label2: TLabel;
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
    Button5: TButton;
    ProgressBar1: TProgressBar;
    humbDBwhlen1: TMenuItem;
    edtTagFilter: TEdit;
    Label3: TLabel;
    ShellTreeView1: TShellTreeView;
    ChkShowAccessablesOnly: TCheckBox;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSelectedTagsChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Datenbankwhlen1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    function  fileinfo_find(id:Integer; params:TSQLParams):TObjectList;
    function file_location_find_by_id(id:String):TFileLocation;
    procedure StringGrid2SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
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
    procedure Button5Click(Sender: TObject);
    procedure humbDBwhlen1Click(Sender: TObject);
    procedure edtTagFilterChange(Sender: TObject);
    procedure edtTagFilterKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    importingThumbs: Boolean;
    slDBPath, thumbDBPath: String;
    sldb, thumbsdb: TSQLiteDatabase;
    sltb: TSQLiteTable;
//    ItemsForSelectedTags: TSQLIteTable;
    ItemsForSelectedTags: TObjectList;
    lastLabel: TLabel;
    maxTagCount: Integer;
    selectedTags: TStringlist;
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
    procedure updateDocuments(limit,offset:Integer);
    procedure tagClick(Sender: TObject);
    procedure previewClick(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure selectTag(tag:String);
    procedure unselectTag(tag:String);
    procedure ReloadTagCloud(limit:Integer);
//    procedure showFileinfos(sltb: TSQLiteTable);
    procedure showFileinfos(fis: TObjectList);
    function  GetTagCloud(limit:Integer): TSQLIteTable;
//    function  GetItemsFor(tags: TStringList; match_all:Boolean): TSQLIteTable;
    function  GetItemsFor(tags: TStringList; match_all:Boolean; limit,offset:Integer): TObjectList;
    procedure GetFileinfosFor(Sender: TObject);
    procedure renderTag(tag_item,tag_count:String;i:Integer);
    procedure showTagcloud(tags:TSQLIteTable);
    procedure clearTagcloud;
    procedure arrangeTagCloud;
    procedure arrangePreviews();
    function  GetSha2(filename:String): String;
    function  Sha2(s:String): String;
    function  StringToArrayOfBytes(s:String): TByteArray;
    procedure alert(s:String);
    function  getCommaListOf(attr:String;t:TObjectList;quot:String): String;
    function  quoteConcatStrList(s:TStringlist): string;
    procedure updatePreviews;
    procedure clearPreviews;
    function DoLoad(var img:TImage;const FileName: String):Boolean;
    function renderPreview(fi:TFileinfo):Boolean;
    function LoadImage(var img: TImage; fi : TFileinfo; angle:Integer):Boolean;
    procedure previewDblClick(Sender:TObject);
    procedure FilterTagCloud;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses FreeImage;



procedure TForm1.FormCreate(Sender: TObject);
begin
  importingThumbs:=false;
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
end;

procedure TForm1.openDB(promptUser:Boolean);
var
  limit: Integer;
begin
  Form1.Caption:='Tgit GUI';
  if not FileExists(slDBPath) and promptUser then
    begin
      if OpenDialog1.execute then
        slDBPath := OpenDialog1.Filename
      else
        alert('Bitte wählen Sie im Menü "Optionen" eine Datenbank aus!');
    end;
  if FileExists(slDBPath) then
    sldb := TSQLiteDatabase.Create(slDBPath);
  if sldb<>nil then
  begin
    Form1.Caption:='Tgit GUI - '+slDBPath;
    sltb := sldb.GetTable('select count(*) as anz from tags');
    limit := floor(sltb.FieldAsInteger(sltb.FieldIndex['anz'])*(TrackBar1.Position/Trackbar1.max));
    reloadTagCloud(limit);
    lastLabel:=nil;
  end;
end;
procedure TForm1.openThumbDB;
begin
  try
    thumbsdb := TSQLiteDatabase.Create(thumbDBPath);
  except
    alert('Die Thumbnail-Datenbank konnte nicht geöffnet werden.');
  end;
end;

// Holt die Dokumente zu den angegebenen tags.
//function TForm1.GetItemsFor(tags:TStringList; match_all: Boolean):TSQLiteTable;
function TForm1.GetItemsFor(tags:TStringList; match_all: Boolean; limit,offset:Integer):TObjectList;
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
  if match_all then
  begin
    query := query+' HAVING count(distinct tags.id)='+inttostr(tags.count);
  end;
  query:=query+') AS temp'+
               ' LEFT JOIN file_locations ON temp.id=file_locations.fileinfo_id ';

  edtQuery.text:=query;
  tbl := slDb.GetTable(query);
  h:=THash.create;

  while not tbl.eof do
  begin
    r:=tbl.GetRow;
    f:=TFileinfo.create(r);
    r.free;
    if h.GetString(inttostr(f.id))<>'1' then
      begin
        h.SetString(inttostr(f.id),'1');
        curFileinfos.add(f);
      end;
    idx:=tbl.FieldIndex['FILE_LOCATION_ID'];
    flid:=tbl.FieldAsString(idx);
    fl:=file_location_find_by_id(flid);
    fi:=TFileinfo(curFileinfos.Items[curFileinfos.Count-1]);
    fi.file_locations.add(fl);
    tbl.Next;
  end;
  h.free;
  result:=curFileinfos;
end;

procedure TForm1.showFileinfos(fis: TObjectList);
var
  i,j,k:Integer;
  fi:TFileinfo;
  fl: TFileLocation;
begin
  for i:=0 to StringGrid2.Rowcount-1 do begin
    StringGrid2.Rows[i].clear;
  end;
  i:=0;
  if fis.Count > 0 then
  begin
      while i<fis.count do
      begin
        fi:=TFileinfo(fis[i]);
        StringGrid2.rowcount:=i+1;
        StringGrid2.cells[0,i]:=inttostr(fi.id);
        StringGrid2.cells[1,i]:=fi.sha2;
        StringGrid2.cells[2,i]:=inttostr(fi.filesize);
        j:=4;
        for k:=0 to fi.file_locations.Count-1 do
        begin
          fl:=TFileLocation(fi.file_locations[k]);
          if fl.accessible then
            StringGrid2.cells[3,i]:=fl.full_path
          else
            begin
              StringGrid2.cells[j,i]:=fl.full_path;
              inc(j);
            end;
        end;
        inc(i);
      end;
      updatePreviews;
  end;
end;

procedure TForm1.updatePreviews;
var
  i,perPage,c,k: Integer;
  fi: TFileinfo;
  fl:TFileLocation;
  done:boolean;
  accessiblePath: string;
begin
  clearPreviews;
  accessiblePath:='';
  perPage:=picsPerCol*picsPerCol;
  i:=(pageNo-1)*perPage;  // Startindex
  c:=0;
  while (i<curFileinfos.Count) and (c<perPage) do
  begin
    fi:=TFileinfo(curFileinfos[i]);
    if renderPreview(fi) then
    begin
      arrangePreviews();
      application.processMessages;
      inc(c);
    end;
    inc(i);
  end;
end;

function TForm1.renderPreview(fi:TFileinfo): Boolean;
var
  img: TImage;
  accessiblePath: String;
  success: Boolean;
  tbl: TSQLiteTable;
  data: TMemoryStream;
  jp: TJpegImage;
begin
  accessiblePath:=fi.getAccessibleLocation;
  if (accessiblePath='') and ChkShowAccessablesOnly.Checked then
    result:=false  // Falls das Bild nicht erreichbar ist und nicht-erreichbare nicht ausgegeben werden sollen
  else
  begin
    result:=true;
    img:=TPreview.create(PanelPreviews,fi);
    with img do
    begin
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
      OnDblClick:=previewDblClick;
      OnContextPopup:=previewClick;
      PopupMenu:=PopupPreview;
    end;

    // Versuchen den Thumbnail aus der DB zu laden:
    tbl:=thumbsdb.GetTable('SELECT data FROM thumbs WHERE fileinfo_id="'+inttostr(fi.id)+'" LIMIT 1');
    if tbl.RowCount>0 then
      begin
        if not importingThumbs then
        begin
          data:=TMemoryStream.create;
          data:=tbl.FieldAsBlob(tbl.FieldIndex['data']);
          data.Seek(0,0);
          jp:=TJPEGImage.create;
          jp.LoadFromStream(data);
          img.picture.assign(jp);
          jp.free;
          data.free;
        end;
      end
    else
      begin
        success := LoadImage(img,fi,0);
        if not success then // Bild ist nicht-erreichbar oder nicht darstellbar.
          img.Picture.LoadFromFile(ExtractFilepath(application.ExeName)+'public\images\no_disk.jpg');
      end;
  end;
end;

procedure TForm1.arrangePreviews();
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
  for i:=0 to PanelPreviews.controlcount-1 do
  begin
    cur:=TPreview(PanelPreviews.controls[i]);
    // Positionierung:
    if last=nil then
      begin
        cur.left:=colPadding;
        cur.Top:=rowPadding;
      end
    else
      begin
        h:=max(h,last.Height);
        l:=last.Left+last.width+colPadding;
        t:=last.Top;
        if l+cur.width > cur.Parent.Width then
          begin
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

procedure TForm1.clearPreviews;
begin
  while PanelPreviews.ControlCount>0 do
    PanelPreviews.Controls[0].free;
end;


procedure TForm1.clearTagCloud;
begin
  while TagCloud.ControlCount>0 do
    TagCloud.Controls[0].free;
end;

procedure TForm1.ReloadTagCloud(limit:Integer);
begin
  clearTagCloud;
  application.ProcessMessages;
  showTagcloud(GetTagCloud(limit));
end;

// Zeigt die TagCloud in Abhängigkeit der aktuell gewählten Tags und Dokumente:
function TForm1.GetTagCloud(limit:Integer): TSQLiteTable;
var
  query,taggable_ids,tagnames,joinCondition,having: String;
  tmp: TSQLiteTable;
begin
  if limit=0 then
    begin
      tmp := sldb.GetTable('select count(*) as anz from tags');
      limit := floor(tmp.FieldAsInteger(tmp.FieldIndex['anz'])*(TrackBar1.Position/Trackbar1.max));
    end;
  joinCondition:='';
  having:='';
  if (ItemsForSelectedTags<>nil) and (ItemsForSelectedTags.count>0) then
  begin
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
    '    GROUP BY tags.id '+
       having+
    '    ORDER BY anz DESC '+
    '    LIMIT '+inttostr(limit)+
    '  ) AS temp '+
    'ORDER BY name COLLATE NOCASE';
  result := slDb.GetTable(query);
end;

function TForm1.getCommaListOf(attr:String;t:TObjectList;quot:String): String;
var
  val: String;
  i: Integer;
begin
  result:='';
  i:=0;
  while i<t.count do
  begin
    val:=TFileinfo(t[i]).getAttr(attr);
    if result='' then
      result:=result+quot+val+quot
    else
      result:=result+','+quot+val+quot;
    inc(i);
  end;
end;

procedure TForm1.showTagcloud(tags:TSQLIteTable);
var i: Integer;
var tag_item,tag_count: String;
begin
  maxTagCount:=0;
  i:=0;
  if tags.Count > 0 then
  begin
    while not tags.EOF do
    begin
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

procedure TForm1.renderTag(tag_item,tag_count:String; i:Integer);
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
  if (selectedTags<>nil) and (selectedTags.IndexOf(tag.caption)>-1) then
    begin
      tag.Font.Color:=clBlue;
      tag.tag:=1;
    end
  else
    begin
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
procedure TForm1.tagClick(Sender:TObject);
begin
  pageNo:=1;
  ButtonBack.enabled:=false;
  clickedTagName:=TLabel(Sender).caption;
  clickedTagWasActive:=(TLabel(Sender).tag=1);
  Timer1.Enabled:=true;
end;

procedure TForm1.previewClick(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  clickedPreview:=TPreview(Sender);
end;

procedure TForm1.previewDblClick(Sender:TObject);
var
  fname: string;
begin
  fname:=TPreview(Sender).hint;
  if FileExists(fname) then
    ShellExecute(Handle, 'open', PChar(fname), nil, nil, SW_SHOW)
  else
    alert('Diese Datei ist von diesem Computer aus nicht zugreifbar.');
end;
procedure TForm1.selectTag(tag:String);
begin
  if selectedTags.indexOf(tag)=-1 then
    selectedTags.add(tag);
end;

procedure TForm1.unselectTag(tag:String);
var p : Integer;
begin
  p := selectedTags.IndexOf(tag);
  if p>-1 then
    selectedTags.Delete(p);
end;

procedure TForm1.highlight(Sender:TObject);
begin
  TLabel(Sender).Font.color:=clred;
end;

procedure TForm1.unhighlight(Sender:TObject);
var tag: TLabel;
begin
  tag:=TLabel(Sender);
  if tag.tag=1 then
    tag.Font.color:=clBlue
  else
    tag.Font.Color:=clBlack;
end;

// <-- EventHandling für dynamisch erzeugte TagLabels


procedure TForm1.updateDocuments(limit,offset:Integer);
begin
  ItemsForSelectedTags:=GetItemsFor(selectedTags,Checkbox1.checked,limit,offset);
  showFileinfos(ItemsForSelectedTags);
end;

procedure TForm1.arrangeTagCloud();
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
  for i:=0 to TagCloud.ComponentCount-1 do
  begin
    tag:=TLabel(TagCloud.Components[i]);
    if tag.Visible then
    begin
      if lastLabel=nil then
        begin
          tag.Top:=marginTop;
          tag.Left:=marginLeft;
          h:=tag.height;
        end
      else
        begin
          h:=max(h,lastLabel.Height);
          l:=lastLabel.Left+lastLabel.width+colPadding;
          t:=lastLabel.Top;
          voffset:=0; // zur schöneren vertikalen Ausrichtung zweier benachbarter stark unterschiedlich großer Tags
          if l+tag.width > tag.Parent.Width then
            begin
              l:=marginLeft;
              t:=t+h+rowPadding;
              h:=0;
            end
          else
            begin
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

procedure TForm1.edtSelectedTagsChange(Sender: TObject);
begin
Label1.Caption:='_'+strip(edtSelectedTags.text)+'_';
end;

procedure TForm1.Button1Click(Sender: TObject);
var s:string;
begin
  s:='asdf';
  Label1.Caption:='+'+Sha2(edtSelectedTags.text)+'+';
end;

function TForm1.Sha2(s:String): String;
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

function TForm1.GetSha2(filename:String): String;
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


function TForm1.StringToArrayOfBytes(s:String):TByteArray;
var
   j: integer;
begin
   SetLength(Result, Length(s)) ;
   for j := 0 to Length(s) - 1 do
     Result[j] := ord(s[j + 1]) - 48;
end;

procedure TForm1.alert(s:String);
begin
  messageDlg(s,mtInformation,[mbOK],0);
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  TagCloud.width:=Form1.Width div 2 -25;
  TabControl1.width:=Form1.Width div 2 -25;
  TagCloud.left:=TabControl1.width+TabControl1.left+25;
  arrangeTagCloud;
  updatePreviews;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
var newLimit: Integer;
begin
  if not TrackBar1.Dragging then
    begin
      sltb:=sldb.GetTable('select count(*) as anz from tags');
      newLimit:=floor(sltb.FieldAsInteger(sltb.FieldIndex['anz'])*Trackbar1.Position/TrackBar1.max);
      reloadTagCloud(newLimit);
    end;
end;

function TForm1.quoteConcatStrList(s:TStringlist): string;
var i: Integer;
begin
  result:='';
  for i:=0 to s.Count-1 do
  begin
    if result='' then
      result:='"'+s[i]+'"'
    else
      result:=result+',"'+s[i]+'"';
  end;
end;

procedure TForm1.loadSettingsFromIniFile();
var
  fn,buff: String;
  f: Textfile;
begin
// Zeile 1: String:  Pfad zur DB-Datei
// Zeile 2: String:  Pfad zur Thumb-DB-Datei
// Zeile 3: Integer: picsPerCol
  fn:=ExtractFilepath(application.exename)+ 'tgit.ini';
  if fileExists(fn) then
    begin
      AssignFile(f,fn);
      Reset(f);
      readln(f,sldbpath);
      if not EOF(f) then
        readln(f,thumbDBPath);
      if not EOF(f) then
        begin
          readln(f,buff);
          if buff<>'' then picsPerCol:=strtoint(buff);
        end;
      closeFile(f);
    end;
end;

procedure TForm1.Datenbankwhlen1Click(Sender: TObject);
begin
  if OpenDialog1.execute then
    begin
      slDBPath := OpenDialog1.FileName;
      openDB(true);
    end;
end;

procedure TForm1.humbDBwhlen1Click(Sender: TObject);
begin
  if OpenDialog1.execute then
    thumbDBPath := OpenDialog1.FileName;
  if fileExists(thumbDBPath) then
    openThumbDB;
end;


procedure TForm1.FormDestroy(Sender: TObject);
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
  //try
  //sltb.free;
  //except
  //end;
  //sldb.free;
  //clearTagCloud;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=false;
  Screen.Cursor := crHourGlass;
  if clickedTagWasActive then
    unselectTag(clickedTagName)
  else
    selectTag(clickedTagName);
  edtSelectedTags.Text:=selectedTags.CommaText;
  updateDocuments(picsPerCol*picsPerCol,pageNo-1);
  clearTagcloud;
  showTagCloud(GetTagcloud(0));
  edtTagFilter.text:='';
  Screen.Cursor := crDefault;
end;


procedure TForm1.Button2Click(Sender: TObject);
var h:THash;
  s:String;
begin
  h:=THash.create;
  s:='123';
  h.SetString('id',s);
  alert(h.GetString('id'));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
//  updateDocumentList();
end;


procedure TForm1.GetFileinfosFor(Sender: TObject);
var
  a: TObjectList;
  i,j: Integer;
  fi: TFileinfo;
  fl: TFileLocation;
const
  params : TSQLParams = (conditions:'1=1';limit: 1000); // nur ein Beispiel und nur als Konstante, weil man Records anscheinend nur SO in einer Zeile definieren kann... :/
begin
  a:=fileinfo_find(0,params);
  StringGrid2.RowCount:=a.count;
  for i:=0 to a.Count-1 do
    begin
      Stringgrid2.Cells[0,i+1]:=inttostr(TFileinfo(a.Items[i]).id);
      Stringgrid2.Cells[1,i+1]:=TFileinfo(a.Items[i]).sha2;
      Stringgrid2.Cells[2,i+1]:=inttostr(TFileinfo(a.Items[i]).filesize);
      fi:=TFileinfo(a.Items[i]);
      for j:=0 to fi.file_locations.Count-1 do
        begin
          fl:=TFileLocation(fi.file_locations[j]);
          StringGrid2.ColCount:=max(3+j,StringGrid2.ColCount);
          Stringgrid2.Cells[3+j,i+1]:=fl.full_path;
        end;
    end;
  a.free;
end;

// simuliert die Klassen-Methode zum finden einer Fileinfo inkl. ihrer assoziierten FileLocations: 
function TForm1.fileinfo_find(id:Integer; params:TSQLParams):TObjectList;
var
  tbl : TSQLiteTable;
  query,select,joins,conditions,group_by,having,order,limit,offset: String;
  h: THash;
  f,fi: TFileinfo;
  fl: TFileLocation;
  flid: string;
begin
  //result:=TObjectList.create;
  curFileinfos.Clear;
  query:='';
  select:=params.select;
  if select='' then select:='fileinfos.*,file_locations.id AS file_location_id';
  joins:=params.joins;
  // Filelocations eager loaden:
  joins:=joins+' LEFT JOIN file_locations ON fileinfos.id=file_locations.fileinfo_id ';
  if id>0 then
    conditions:='fileinfos.id='+inttostr(id)
  else
    conditions:=params.conditions;
  if conditions<>'' then conditions:='WHERE '+conditions;
  group_by:=params.group_by;
  if group_by<>'' then group_by:='GROUP BY '+group_by;
  having:=params.having;
  if having<>'' then having:='HAVING '+having;
  limit:=inttostr(params.limit);
  order:=params.order;
  if order<>'' then order:='ORDER '+order;
  if limit<>'0' then limit:='LIMIT '+limit;
  offset:=inttostr(params.offset);
  if offset<>'0' then limit:='LIMIT '+offset+','+inttostr(params.limit);
  query:='SELECT '+select+' FROM fileinfos '+joins+' '+group_by+' '+conditions+' '+having+' '+limit;
//alert(query);
  tbl:=sldb.GetTable(query);
  h:=THash.create;
  while not tbl.eof do
  begin
    f:=TFileinfo.create(tbl.GetRow);
    if h.GetString(inttostr(f.id))<>'1' then
      begin
        h.SetString(inttostr(f.id),'1');
        curFileinfos.add(f);
      end
    else  // kann doch sonst weg oder?!
      f.Free;
    flid:=tbl.FieldAsString(tbl.FieldIndex['FILE_LOCATION_ID']);
    fl:=file_location_find_by_id(flid);
    fi:=TFileinfo(curFileinfos.Items[curFileinfos.Count-1]);
    fi.file_locations.add(fl);
    tbl.Next;
  end;
  h.free;
  result:=curFileinfos;
end;

function TForm1.file_location_find_by_id(id:String):TFileLocation;
var
  tbl: TSQLiteTable;
begin
  tbl:=sldb.GetTable('SELECT * FROM file_locations WHERE id='+id+' LIMIT 1');
  if not tbl.EOF then
    result:=TFileLocation.create(tbl.GetRow)
  else
    result:=nil;
end;

procedure TForm1.StringGrid2SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  fpath: String;
  i: Integer;
  found: Boolean;
begin
  i:=3;
  found:=false;
  while (not found) and (i<StringGrid2.ColCount) do
    begin
      fpath:=StringGrid2.cells[i,ARow];
      if fileExists(fpath) then
        begin
          found:=true;
          //DoLoad(Image1,fpath);
          //REDO: LoadImage(Image1,fpath,0);
        end
      else
        i:=i+1;
    end;
end;

// gibt bei Erfolg true zurück
function TForm1.DoLoad(var img:TImage;const FileName: String):Boolean;
//var
//  GraphicClass: TGraphicExGraphicClass;
//  Graphic: TGraphic;
begin
//  try
//    GraphicClass := FileFormatList.GraphicFromContent(FileName);
//    if GraphicClass = nil then
//      img.Picture.LoadFromFile(FileName)
//    else
//      begin
//        Graphic := GraphicClass.Create;
//        Graphic.LoadFromFile(FileName);
//        img.Picture.Graphic := Graphic;
//      end;
//    result:=true;
//  except
//    result:=false;
//  end;
end;

procedure TForm1.N11Click(Sender: TObject);
begin
  picsPerCol:=1;
  TMenuItem(Sender).Checked:=true;
  updatePreviews;
end;

procedure TForm1.N21Click(Sender: TObject);
begin
  picsPerCol:=2;
  TMenuItem(Sender).Checked:=true;
  updatePreviews;
end;

procedure TForm1.N31Click(Sender: TObject);
begin
  picsPerCol:=3;
  TMenuItem(Sender).Checked:=true;
  updatePreviews;
end;

procedure TForm1.N41Click(Sender: TObject);
begin
  picsPerCol:=4;
  TMenuItem(Sender).Checked:=true;
  updatePreviews;
end;

procedure TForm1.N51Click(Sender: TObject);
begin
  picsPerCol:=5;
  TMenuItem(Sender).Checked:=true;
end;

procedure TForm1.N61Click(Sender: TObject);
begin
  picsPerCol:=6;
  TMenuItem(Sender).Checked:=true;
end;

procedure TForm1.N71Click(Sender: TObject);
begin
  picsPerCol:=7;
  TMenuItem(Sender).Checked:=true;
end;

procedure TForm1.N81Click(Sender: TObject);
begin
  picsPerCol:=8;
  TMenuItem(Sender).Checked:=true;
end;

procedure TForm1.N91Click(Sender: TObject);
begin
  picsPerCol:=9;
  TMenuItem(Sender).Checked:=true;
end;

procedure TForm1.N101Click(Sender: TObject);
begin
  picsPerCol:=10;
  TMenuItem(Sender).Checked:=true;
end;

procedure TForm1.TabControl1Change(Sender: TObject);
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

procedure TForm1.ButtonBackClick(Sender: TObject);
begin
dec(pageNo);
updatePreviews;
if(pageNo<=1) then ButtonBack.Enabled:=false;
end;

procedure TForm1.ButtonNextClick(Sender: TObject);
begin
inc(pageNo);
updatePreviews;
if(pageNo>1) then ButtonBack.Enabled:=true;
end;

function TForm1.LoadImage(var img: TImage; fi: TFileinfo; angle: Integer):Boolean;
var
  dib,dib2,tmp : PFIBITMAP;
  PBH : PBITMAPINFOHEADER;
  PBI : PBITMAPINFO;
  t : FREE_IMAGE_FORMAT;
  Ext : string;
  BM : TBitmap;
  DC : HDC;
  jp : TJPEGImage;
  data: TMemoryStream;
  tbl: TSQLiteTable;
  fpath: string;
begin
  result:=true;
  fpath:=fi.getAccessibleLocation;
  if fpath='' then
    result:=false
  else
  begin
  try
    t := FreeImage_GetFileType(PChar(fpath), 16);
     if t = FIF_UNKNOWN then
    begin
      // Check for types not supported by GetFileType
      Ext := UpperCase(ExtractFileExt(fpath));
      if (Ext = '.TGA') or(Ext = '.TARGA') then
        t := FIF_TARGA
      else if Ext = '.MNG' then
        t := FIF_MNG
      else if Ext = '.PCD' then
        t := FIF_PCD
      else if Ext = '.WBMP' then
        t := FIF_WBMP
      else if Ext = '.CUT' then
        t := FIF_CUT
      else
        raise Exception.Create('The file "' + fpath + '" cannot be displayed because SFM does not recognise the file type.');
    end;

    dib := FreeImage_Load(t, PChar(fpath), 0);
    tmp:=dib;
    if importingThumbs then
      dib2 := FreeImage_MakeThumbnail(dib,200)
    else
      dib2 := FreeImage_MakeThumbnail(dib,img.Width);

    dib:=dib2;
    FreeImage_unload(tmp);

    tmp:=dib;
    dib2 := FreeImage_RotateClassic(dib,angle);
    dib:=dib2;
    FreeImage_unload(tmp);

    if Dib = nil then
      Close;
    PBH := FreeImage_GetInfoHeader(dib);
    PBI := FreeImage_GetInfo(dib^);

    begin
      BM := TBitmap.Create;

      BM.Assign(nil);
      DC := GetDC(Handle);

      BM.handle := CreateDIBitmap(DC,
        PBH^,
        CBM_INIT,
        PChar(FreeImage_GetBits(dib)),
        PBI^,
        DIB_RGB_COLORS);

      Img.picture.Bitmap.Assign(BM);

      // Thumb in der Datenbank speichern:
      // falls noch nicht vorhanden:
      tbl:=thumbsdb.GetTable('SELECT data FROM thumbs WHERE fileinfo_id="'+inttostr(fi.id)+'" LIMIT 1');
      if (tbl.RowCount=0) and (true or (pos('no_disk.jpg',fpath)=0)) then
      begin
        jp:=TJPEGImage.create;
        jp.Assign(Img.Picture.Bitmap);
        jp.CompressionQuality:=50;
        jp.compress;
        data:=TMemoryStream.create;
        jp.SaveToStream(data);
        thumbsdb.UpdateBlob('INSERT INTO thumbs (fileinfo_id,data) VALUES ("'+inttostr(fi.id)+'", ?)',data);
        data.Free;
      end;

      BM.Free;
      ReleaseDC(Handle, DC);
    end;
    FreeImage_Unload(dib);
  except
    result:=false;
//  on e:exception do
//  begin
//    Application.BringToFront;
//    MessageDlg(e.message, mtInformation, [mbOK], 0);
//    Close;
//  end;
  end;
  end;
end;


procedure TForm1.Dateiffnen1Click(Sender: TObject);
begin
  previewDblClick(clickedPreview);
end;

procedure TForm1.EnthaltendenOrdnerffnen1Click(Sender: TObject);
var
  path:string;
begin
  path:=ExtractFilepath(clickedPreview.Hint);
  if DirectoryExists(path) then
    ShellExecute(Handle, 'open', PChar(path), nil, nil, SW_SHOW)
  else
    alert('Dieser Ordner ist auf diesem Computer nicht verfügbar.');
end;

//procedure TForm1.N90rechts1Click(Sender: TObject);
//var
//  BM: TBitmap;
//  i,j : Integer;
//  P   : PByteArray;
//  Arr : Array of Array of Byte;
//begin
//  BM:=TBitmap.create;
//  BM.width:=clickedPreview.Picture.Bitmap.height;
//  BM.height:=clickedPreview.Picture.Bitmap.width;
//  setlength(Arr,clickedPreview.Picture.Bitmap.height);
//  for i:=0 to clickedPreview.Picture.Bitmap.height-1 do
//  begin
//    setlength(Arr[i],clickedPreview.Picture.Bitmap.width);
//    P:=clickedPreview.Picture.Bitmap.scanline[i];
//    for j:=0 to clickedPreview.Picture.Bitmap.width-1 do
//      begin
//        setlength(Arr,clickedPreview.Picture.Bitmap.height);
//        Arr[i][j]:=P[j];
//      end;
//  end;
//
//  for i:=0 to BM.height-1 do
//    for j:=0 to BM.width-1 do
//      begin
//        P := BM.ScanLine[i];
//        P[j] := Arr[j][i];
//      end;
//
//  clickedPreview.Picture.Bitmap:=BM;
//end;

procedure TForm1.N90rechts1Click(Sender: TObject);
begin
  clickedPreview.Tag:=((90+ClickedPreview.tag) mod 360);
//  LoadImage(clickedPreview,clickedPreview.Hint,-clickedPreview.Tag);
end;

procedure TForm1.N90links1Click(Sender: TObject);
begin
  clickedPreview.Tag:=((270+clickedPreview.tag) mod 360);
//  LoadImage(clickedPreview,clickedPreview.Hint,-clickedPreview.Tag);
end;

procedure TForm1.N1801Click(Sender: TObject);
begin
  clickedPreview.Tag:=((180+clickedPreview.tag) mod 360);
//  LoadImage(clickedPreview,clickedPreview.Hint,-clickedPreview.tag);
end;





procedure TForm1.Button5Click(Sender: TObject);
var
  query,flid: String;
  h: THash;
  tbl: TSQLiteTable;
  f:TFileinfo;
  idx: Integer;
  fl: TFileLocation;
begin
  importingThumbs:=true;
  query:='SELECT fileinfos.*,file_locations.id AS FILE_LOCATION_ID FROM fileinfos'+
         ' LEFT JOIN file_locations ON fileinfos.id=file_locations.fileinfo_id';
  tbl := slDb.GetTable(query);
  h:=THash.create;
  ProgressBar1.min:=0;
  ProgressBar1.max:=tbl.RowCount;
  while not tbl.eof do
  begin
    f:=TFileinfo.create(tbl.GetRow);
    if h.GetString(inttostr(f.id))<>'1' then
      begin
        h.SetString(inttostr(f.id),'1');
        curFileinfos.add(f);
      end;
    idx:=tbl.FieldIndex['FILE_LOCATION_ID'];
    flid:=tbl.FieldAsString(idx);
    fl:=file_location_find_by_id(flid);
    if fl.accessible then
      begin
        f.file_locations.Add(fl);
        LoadImage(image1,f,0);
      end;
    fl.Free;
    tbl.Next;
    ProgressBar1.StepIt;
    application.ProcessMessages;
  end;
  alert('done');
  h.free;
end;


procedure TForm1.edtTagFilterChange(Sender: TObject);
begin
 filterTagCloud();
end;
procedure TForm1.FilterTagCloud;
var
  i: Integer;
  lbl: TLabel;
begin
  for i:=0 to TagCloud.ControlCount-1 do
    begin
      lbl:=TLabel(TagCloud.Controls[i]);
      if (edtTagFilter.text<>'') and (pos(lowercase(edtTagFilter.text),lowercase(lbl.caption))=0) then
        lbl.hide
      else
        lbl.show;
    end;
  arrangeTagCloud;
end;

procedure TForm1.edtTagFilterKeyPress(Sender: TObject; var Key: Char);
var
  i: Integer;
  a_label, exact, at_beginning, in_middle: TLabel;
  tag,filter: string;
begin
  exact:=nil;
  at_beginning:=nil;
  in_middle:=nil;
  if Key=Char(VK_RETURN) then
  begin
    filter:=lowercase(edtTagFilter.Text);
    // exakten Match suchen (bis auf case-Sensitivity):
    for i:=0 to TagCloud.Controlcount-1 do
    begin
      a_label:=TLabel(TagCloud.Controls[i]);
      tag:=lowercase(a_label.caption);
      if tag=filter then
      begin
        exact:=a_label;
        break;
      end
      else
        if (at_beginning=nil) and (pos(filter,tag)=1) then
          at_beginning:=a_label
        else
          if (in_middle=nil) and (pos(filter,tag)>0) then
            in_middle:=a_label;
    end;
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

end.

