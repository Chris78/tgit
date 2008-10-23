unit Unit2;
 {$OPTIMIZATION OFF}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SQLiteTable3, ComCtrls, Grids, StringItWell;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    edtSelectedTags: TEdit;
    StringGrid2: TStringGrid;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
//    procedure GetTagCloudAll(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure showFileinfos(sltb: TSQLiteTable);
    procedure showTagcloud(tags:TSQLIteTable);
    procedure ReloadTagCloud();
    procedure edtSelectedTagsChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    slDBPath: String;
    sldb: TSQLiteDatabase;
    sltb: TSQLiteTable;
    function GetTagCloudAll(): TSQLIteTable;
    function GetItemsFor(tags: TStringList; match_all:Boolean): TSQLIteTable;
  public
    { Public declarations }
  end;

  const
  dieDll = 'libeay32.dll';
  function EVP_sha256(var s : PChar) : String; external dieDll;


var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var res:TSQLiteTable;
begin
  slDBPath := ExtractFilepath(application.exename)+ 'tgit.db';
  sldb := TSQLiteDatabase.Create(slDBPath);
  reloadTagCloud();
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

procedure TForm1.ReloadTagCloud();
begin
  showTagcloud(GetTagCloudAll());
end;

function TForm1.GetTagCloudAll(): TSQLIteTable;
begin
  result := slDb.GetTable('SELECT *, count(*) as anz '+
    'FROM tags LEFT JOIN taggings on taggings.tag_id=tags.id '+
    'group by tags.id order by anz desc, name');
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
      StringGrid1.rowcount:=i+1;
      StringGrid1.cells[0,i]:=tag_item;
      StringGrid1.cells[1,i]:=tag_count;
      inc(i);
      tags.Next;
    end;
  end;
  tags.Free;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  sltb.free;
  sldb.free;
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
var p: PChar;
begin
  s:='asdf';
  p:=PChar(s);
  Label1.Caption:='+'+EVP_sha256(p)+'+';
end;

end.

