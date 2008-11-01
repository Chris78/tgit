unit Unit2;
 {$OPTIMIZATION OFF}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SQLiteTable3, ComCtrls, Grids, StringItWell,
  DCPcrypt2, DCPsha256, Math, TabNotBk, ExtCtrls, Menus, Hashes, Contnrs,
  UFileinfo, UFileLocation, GraphicEx, jpeg;

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
    Button5: TButton;
    Button6: TButton;
    PanelPreviews: TPanel;

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
    function fileinfo_find_by_id(id:String):TFileinfo;
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
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);

  private
    { Private declarations }
    slDBPath: String;
    sldb: TSQLiteDatabase;
    sltb: TSQLiteTable;
//    ItemsForSelectedTags: TSQLIteTable;
    ItemsForSelectedTags: TObjectList;
    lastLabel: TLabel;
    maxTagCount: Integer;
    selectedTags: TStringlist;
    curFileinfos: TObjectList;
    clickedTagName: String;
    clickedTagWasActive: Boolean;
    picsPerCol: Integer;
    pageNo: Integer;
    procedure openDB(promptUser:Boolean);
    procedure loadSettingsFromIniFile();
    procedure highlight(Sender: TObject);
    procedure unhighlight(Sender: TObject);
    procedure updateDocuments(limit,offset:Integer);
    procedure tagClick(Sender: TObject);
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
    procedure renderPreview(fl:TFileLocation);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  slDBPath := ExtractFilepath(application.exename)+ 'db\tgit.db';
  picsPerCol:=3;
  pageNo:=1;
  loadSettingsFromIniFile();
  selectedTags:=TStringlist.create;
  selectedTags.Sorted:=true;
  curFileinfos:=TObjectList.create;
  openDB(false); // try to open DB, but don't prompt user to choose a db-file
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

// Holt die Dokumente zu den angegebenen tags.
//function TForm1.GetItemsFor(tags:TStringList; match_all: Boolean):TSQLiteTable;
function TForm1.GetItemsFor(tags:TStringList; match_all: Boolean; limit,offset:Integer):TObjectList;
var
  idx: Integer;
  query,flid: String;
  tbl: TSQLiteTable;
  h: THash;
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
    f:=TFileinfo.create(tbl.GetRow);
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
  fpath: String;
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
  found:boolean;
begin
  clearPreviews;
  perPage:=picsPerCol*picsPerCol;
  i:=(pageNo-1)*perPage;  // Startindex
  c:=0;
  while (i<curFileinfos.Count) and (c<perPage) do
  begin
    fi:=TFileinfo(curFileinfos[i]);
    k:=0;
    found:=false;
    while not found and (k<fi.file_locations.count) do
    begin
      fl:=TFileLocation(fi.file_locations[k]);
      found:=fl.accessible;
      if found then
        begin
          renderPreview(fl);
          inc(c);
        end;
      inc(k);
    end;
    inc(i);
  end;
  arrangePreviews;
end;

procedure TForm1.renderPreview(fl:TFileLocation);
var
  img: TImage;
  p: TPanel;
begin
  img:=TImage.create(PanelPreviews);
  img.hide;
  img.Parent:=PanelPreviews;
  img.Hint:=fl.full_path;
  img.center:=true;
  img.ShowHint:=true;
  if not DoLoad(img, fl.full_path) then
  DoLoad(img,ExtractFilepath(application.ExeName)+'public\images\no_disk.jpg');
end;

procedure TForm1.arrangePreviews();
const
  rowPadding=2;
  colPadding=10;
  marginLeft=5;
  marginTop=15;
var
  i,imgwidth,imgheight: Integer;
  l,t,h: Integer; // left, top und height
  cur,last: TImage;
begin
  last:=nil;
  h:=0;
  imgwidth:=(PanelPreviews.Width div picsPerCol)-colPadding;
  imgheight:=(PanelPreviews.height div picsPerCol)-rowPadding;
  for i:=0 to PanelPreviews.controlcount-1 do
  begin
    cur:=TImage(PanelPreviews.controls[i]);
    // Eigenschaften für alle:
    cur.Width:=imgwidth;
    cur.Height:=imgheight;
    cur.stretch:=true;
    cur.Proportional:=true;
    // Positionierung:
    if last=nil then
    begin
      cur.left:=colPadding;
      cur.Top:=rowPadding;
      l:=cur.Left+cur.width+colPadding;
      t:=cur.Top+cur.Height+rowPadding;
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
  clickedTagName:=TLabel(Sender).caption;
  clickedTagWasActive:=(TLabel(Sender).tag=1);
  Timer1.Enabled:=true;
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
  for i:=0 to TagCloud.ComponentCount-1 do
  begin
    tag:=TLabel(TagCloud.Components[i]);
    if lastLabel=nil then
      begin
        tag.Top:=marginTop;
        tag.Left:=marginLeft;
        l:=tag.Left+tag.width+colPadding;
        t:=tag.Top+tag.Height+rowPadding;
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
  i, j, read: integer;
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
    i, j, read: integer;
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
  arrangeTagCloud;
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
// Zeile 2: Integer: picsPerCol
  fn:=ExtractFilepath(application.exename)+ 'tgit.ini';
  if fileExists(fn) then
    begin
      AssignFile(f,fn);
      Reset(f);
      readln(f,sldbpath);
      while not EOF(f) do
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

procedure TForm1.FormDestroy(Sender: TObject);
begin
  //try
  //sltb.free;
  //except
  //end;
  //sldb.free;
  //clearTagCloud;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  tag: TLabel;
begin
  Timer1.Enabled:=false;
  if clickedTagWasActive then
    unselectTag(clickedTagName)
  else
    selectTag(clickedTagName);
  edtSelectedTags.Text:=selectedTags.CommaText;
  updateDocuments(picsPerCol*picsPerCol,pageNo-1);
  clearTagcloud;
  showTagCloud(GetTagcloud(0));
end;


procedure TForm1.Button2Click(Sender: TObject);
var h:THash;
  i:Integer;
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


function TForm1.fileinfo_find(id:Integer; params:TSQLParams):TObjectList;
var
  tbl : TSQLiteTable;
  query,select,joins,conditions,group_by,having,order,limit,offset: String;
  h: THash;
  f: TFileinfo;
  fLocs: TObjectList;
  cur_id,i: Integer;
  test,flid:string;
  fi: TFileinfo;
  fl: TFileLocation;
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
      end;
      flid:=tbl.FieldAsString(tbl.FieldIndex['FILE_LOCATION_ID']);
      fl:=file_location_find_by_id(flid);
      fi:=TFileinfo(curFileinfos.Items[curFileinfos.Count-1]);
      fi.file_locations.add(fl);
    tbl.Next;
  end;
  h.free;
  result:=curFileinfos;
end;

function TForm1.fileinfo_find_by_id(id:String):TFileinfo;
var
  tbl: TSQLiteTable;
begin
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
          DoLoad(Image1,fpath);
        end
      else
        i:=i+1;
    end;
end;

// gibt bei Erfolg true zurück
function TForm1.DoLoad(var img:TImage;const FileName: String):Boolean;
var
  GraphicClass: TGraphicExGraphicClass;
  Graphic: TGraphic;
begin
  try
    GraphicClass := FileFormatList.GraphicFromContent(FileName);
    if GraphicClass = nil then
      img.Picture.LoadFromFile(FileName)
    else
      begin
        Graphic := GraphicClass.Create;
        Graphic.LoadFromFile(FileName);
        img.Picture.Graphic := Graphic;
      end;
    result:=true;
  except
    result:=false;
  end;
end;

procedure TForm1.N11Click(Sender: TObject);
begin
  picsPerCol:=1;
end;

procedure TForm1.N101Click(Sender: TObject);
begin
  picsPerCol:=10;
end;

procedure TForm1.N91Click(Sender: TObject);
begin
  picsPerCol:=9;
end;

procedure TForm1.N21Click(Sender: TObject);
begin
  picsPerCol:=2;
end;

procedure TForm1.N31Click(Sender: TObject);
begin
  picsPerCol:=3;
end;

procedure TForm1.N41Click(Sender: TObject);
begin
  picsPerCol:=4;
end;

procedure TForm1.N51Click(Sender: TObject);
begin
  picsPerCol:=5;
end;

procedure TForm1.N61Click(Sender: TObject);
begin
  picsPerCol:=6;
end;

procedure TForm1.N71Click(Sender: TObject);
begin
  picsPerCol:=7;
end;

procedure TForm1.N81Click(Sender: TObject);
begin
  picsPerCol:=8;
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

procedure TForm1.Button5Click(Sender: TObject);
begin
dec(pageNo);
updatePreviews;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
inc(pageNo);
updatePreviews;
end;

end.

