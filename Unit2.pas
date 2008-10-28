unit Unit2;
 {$OPTIMIZATION OFF}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SQLiteTable3, ComCtrls, Grids, StringItWell,
  DCPcrypt2, DCPsha256, Math, TabNotBk;

type
  TByteArray = Array of Byte;
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    edtSelectedTags: TEdit;
    StringGrid2: TStringGrid;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Button1: TButton;
    DCP_sha256: TDCP_sha256;
    Label2: TLabel;
    Label3: TLabel;
    TabbedNotebook1: TTabbedNotebook;
    
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure edtSelectedTagsChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    slDBPath: String;
    sldb: TSQLiteDatabase;
    sltb: TSQLiteTable;
    procedure ReloadTagCloud(limit:Integer);
    procedure showFileinfos(sltb: TSQLiteTable);
    procedure showTagcloud(tags:TSQLIteTable);
    function  GetTagCloudAll(limit:Integer): TSQLIteTable;
    function  GetItemsFor(tags: TStringList; match_all:Boolean): TSQLIteTable;
    procedure renderTag(tag_item,tag_count:String;i:Integer);
    function  GetSha2(filename:String): String;
    function  Sha2(s:String): String;
    function  StringToArrayOfBytes(s:String): TByteArray;
    procedure alert(s:String);

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var res:TSQLiteTable;
begin
  slDBPath := ExtractFilepath(application.exename)+ 'db\tgit.db';
  sldb := TSQLiteDatabase.Create(slDBPath);
  reloadTagCloud(8);
end;

function TForm1.GetItemsFor(tags:TStringList; match_all: Boolean):TSQLiteTable;
var query: String;
begin
  query:='SELECT * FROM tags '+
         'LEFT JOIN taggings ON taggings.tag_id=tags.id '+
         'LEFT JOIN fileinfos on fileinfos.id=taggings.taggable_id AND taggings.taggable_type="Fileinfo" '+
         'WHERE tags.name in ("'+
          AssembleItWell(tags,'","')+
         '") '+
         'GROUP BY fileinfos.id';
  if(match_all) then
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

procedure TForm1.ReloadTagCloud(limit:Integer);
begin
  showTagcloud(GetTagCloudAll(limit));
end;

function TForm1.GetTagCloudAll(limit:Integer): TSQLIteTable;
begin
  result := slDb.GetTable('SELECT name, id, anz '+
    'FROM '+
    '  ( SELECT name, tags.id AS id, count(*) as anz '+
    '    FROM tags '+
    '    LEFT JOIN taggings on taggings.tag_id=tags.id '+
    '    GROUP BY tags.id order by anz DESC'+
    '    LIMIT '+inttostr(limit)+
    '  ) AS temp '+
    'ORDER BY name');
end;


procedure TForm1.showTagcloud(tags:TSQLIteTable);
var i: Integer;
var tag_item,tag_count: String;
begin
  i:=0;
  if tags.Count > 0 then
  begin
    while not tags.EOF do
    begin
      tag_item:=UTF8Decode(tags.FieldAsString(tags.FieldIndex['Name']));
      tag_count:=tags.FieldAsString(tags.FieldIndex['anz']);
      renderTag(tag_item,tag_count,i);
      inc(i);
      tags.Next;
    end;
  end;
  TabbedNotebook1.Pages.Delete(0);
  TabbedNotebook1.PageIndex:=0;
  tags.Free;
end;

procedure TForm1.renderTag(tag_item,tag_count:String; i:Integer);
// i ist die "laufende Nummer" der Tags (wenn diese z.B. in ein Stringgrid eingetragen werden sollen)
var tag: TLabel;
j,k:Integer;
begin
// Stringgrid-Variante:
//  StringGrid1.rowcount:=i+1;
//  StringGrid1.cells[0,i]:=tag_item;
//  StringGrid1.cells[1,i]:=tag_count;
  tag:=TLabel.create(GroupBox1);
  tag.Parent:=GroupBox1;
  tag.Caption:=tag_item+' ('+tag_count+')';
  TabbedNotebook1.Pages.Add(tag.Caption);
  j:=i div 5;
  k:=i mod 5;
  tag.Top:=j*tag.Height;
  tag.Left:=k*tag.Width;
  //tag.Transparent:=true;
  tag.align:=alLeft;
  tag.Font.Size:=min(20,floor(8+strtoint(tag_count)/10));
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  sltb.free;
  sldb.free;
  while GroupBox1.ControlCount>0 do
    GroupBox1.Controls[0].free;
end;

procedure TForm1.StringGrid1SelectCell(Sender: TObject; ACol,ARow: Integer; var CanSelect: Boolean);
var a: TStringList;
var res: TSQLiteTable;
var s,t:String;
var i:Integer;
var b: TStringlist;
begin
  b:=TStringlist.create;
  s:=concat(edtSelectedTags.text, ', ', StringGrid1.Cells[0, ARow]);
  a:=Split(s,',');
  edtSelectedTags.text:=assembleItWell(a,', ');
  for i:=0 to a.Count-1 do
  begin
    t:=a[i];
    if(t<>'') then begin
      if(b.IndexOf(t)=-1) then begin
        b.Add(t);
      end;
    end;
  end;
  a.free;
  res:=GetItemsFor(b,Checkbox1.checked);
  b.free;
  showFileinfos(res);
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

end.

