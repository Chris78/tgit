unit UFrmEditTags;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SqliteTable3, StdCtrls, ExtCtrls, UHelper;

type
  TfrmEditTags = class(TForm)
    Image1: TImage;
    btnSaveTags: TButton;
    Panel1: TPanel;
    edtEditTags: TEdit;
    btnAddTag: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    mainForm : TObject;
    sldb: TSQLiteDatabase;
  public
    { Public declarations }
    constructor create(Sender: TComponent);
  end;

var
  frmEditTags: TfrmEditTags;

implementation

uses
  Unit2;

{$OPTIMIZATION OFF}
{$R *.dfm}



procedure TFrmEditTags.FormCreate(Sender: TObject);
begin
alert('created');
end;

constructor TFrmEditTags.create(Sender: TComponent);
begin
  mainForm:=Sender;
  sldb:=TFrmMain(mainForm).sldb;
  inherited create(Sender);
end;


end.
