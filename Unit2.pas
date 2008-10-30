unit Unit2;
 {$OPTIMIZATION OFF}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SQLiteTable3, ComCtrls, Grids, StringItWell,
  DCPcrypt2, DCPsha256, Math, TabNotBk, ExtCtrls;

type
  TByteArray = Array of Byte;
  TIntegerArray = Array of Integer;

  TForm1 = class(TForm)
    edtSelectedTags: TEdit;
    StringGrid2: TStringGrid;
    TagCloud: TGroupBox;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Button1: TButton;
    DCP_sha256: TDCP_sha256;
    TrackBar1: TTrackBar;
    Label2: TLabel;
    Timer1: TTimer;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSelectedTagsChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    slDBPath: String;
    sldb: TSQLiteDatabase;
    sltb: TSQLiteTable;
    ItemsForSelectedTags: TSQLIteTable;
    lastLabel: TLabel;
    maxTagCount: Integer;
    selectedTags: TStringlist;
    clickedTagName: String;
    clickedTagWasActive: Boolean;
    procedure highlight(Sender: TObject);
    procedure unhighlight(Sender: TObject);
    procedure updateDocuments;
    procedure tagClick(Sender: TObject);
    procedure selectTag(tag:String);
    procedure unselectTag(tag:String);
    procedure ReloadTagCloud(limit:Integer);
    procedure showFileinfos(sltb: TSQLiteTable);
    function  GetTagCloud(limit:Integer): TSQLIteTable;
    function  GetItemsFor(tags: TStringList; match_all:Boolean): TSQLIteTable;
    procedure renderTag(tag_item,tag_count:String;i:Integer);
    procedure showTagcloud(tags:TSQLIteTable);
    procedure clearTagcloud;
    procedure arrangeTagCloud;
    function  GetSha2(filename:String): String;
    function  Sha2(s:String): String;
    function  StringToArrayOfBytes(s:String): TByteArray;
    procedure alert(s:String);
    function getCommaListOf(attr:String;t:TSQLiteTable;quot:String): String;
    function quoteConcatStrList(s:TStringlist): string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  res: TSQLiteTable;
  limit: Integer;
begin
  slDBPath := ExtractFilepath(application.exename)+ 'db\tgit.db';
  sldb := TSQLiteDatabase.Create(slDBPath);
  sltb := sldb.GetTable('select count(*) as anz from tags');
  limit := floor(sltb.FieldAsInteger(sltb.FieldIndex['anz'])*(TrackBar1.Position/Trackbar1.max));
  reloadTagCloud(limit);
  lastLabel:=nil;
  selectedTags:=TStringlist.create;
  selectedTags.Sorted:=true;
end;

// Holt die Dokumente zu den angegebenen tags.
function TForm1.GetItemsFor(tags:TStringList; match_all: Boolean):TSQLiteTable;
var query: String;
begin
  query:='SELECT fileinfos.* FROM tags '+
         'LEFT JOIN taggings ON taggings.tag_id=tags.id '+
         'LEFT JOIN fileinfos on fileinfos.id=taggings.taggable_id AND taggings.taggable_type="Fileinfo" '+
         'WHERE tags.name in ("'+
          AssembleItWell(tags,'","')+
         '") '+
         'GROUP BY fileinfos.id';
  if match_all then
  begin
    query := query+' HAVING count(distinct tags.id)='+inttostr(tags.count);
  end;
  Label1.caption:=query;
  sltb := slDb.GetTable(query);
  result:=sltb;
end;

procedure TForm1.showFileinfos(sltb: TSQLiteTable);
var i:Integer;
var s,fileinfo: String;
begin
  for i:=0 to StringGrid2.Rowcount-1 do begin
    StringGrid2.Rows[i].clear;
  end;
  i:=0;
  if sltb.Count > 0 then
  begin
      while not sltb.EOF do
      begin
        fileinfo:=UTF8Decode(sltb.FieldAsString(sltb.FieldIndex['sha2']));
        StringGrid2.rowcount:=i+1;
        StringGrid2.cells[0,i]:=fileinfo;
        inc(i);
        sltb.Next;
      end;
  end;
end;

procedure TForm1.clearTagCloud;
var
  i: Integer;
begin
  i:=0;
  while TagCloud.ControlCount>i do
    begin
//      if TControl(exceptt)=TagCloud.Controls[i] then
//        inc(i)
//      else
        TagCloud.Controls[i].free;
    end;
end;

procedure TForm1.ReloadTagCloud(limit:Integer);
begin
  clearTagCloud;
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
  if ItemsForSelectedTags<>nil then
  begin
    taggable_ids:=getCommaListOf('id',itemsForSelectedTags,'');
//    alert('taggable_ids = '+taggable_ids);
    if taggable_ids<>'' then
      joinCondition:=' AND taggable_type="Fileinfo" AND taggings.taggable_id IN ('+taggable_ids+') '
    else
      joinCondition:=' AND 1=2 '; // unmögliche Bedingung
    tagnames:=quoteConcatStrList(selectedTags);
//    alert('tagnames = '+tagnames);
//    having:=' HAVING tags.name NOT IN ('+tagnames+') ';
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

function TForm1.getCommaListOf(attr:String;t:TSQLiteTable;quot:String): String;
var
  val: String;
begin
  result:='';
  t.MoveFirst;
  while not t.EOF do
  begin
    val:=t.FieldAsString(t.FieldIndex[attr]);
    if result='' then
      result:=result+quot+val+quot
    else
      result:=result+','+quot+val+quot;
    t.Next;
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


procedure TForm1.updateDocuments;
begin
  ItemsForSelectedTags:=GetItemsFor(selectedTags,Checkbox1.checked);
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


procedure TForm1.FormDestroy(Sender: TObject);
begin
  sltb.free;
  //sldb.free;
  clearTagCloud;
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
  updateDocuments;
  clearTagcloud;
  showTagCloud(GetTagcloud(0));
end;

end.

