unit UFrmAddFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ShellCtrls, ExtCtrls,ShellAPI,
  Hashes,StringItWell,
  UFileinfo,UFileLocation,ULocation,UHelper,
  SQLiteTable3, jpeg;

type
  TFrmAddFiles = class(TForm)
    PanelAddFiles: TPanel;
    lblInitialTags: TLabel;
    lblLocationDescription: TLabel;
    ShellTreeView1: TShellTreeView;
    cmbLocation: TComboBox;
    chkSubfolders: TCheckBox;
    edtInitialTags: TEdit;
    BtnAddFiles: TButton;
    btnClose: TButton;
    imgPreview: TImage;
    procedure FormCreate(Sender: TObject);
    procedure BtnAddFilesClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure cmbLocationChange(Sender: TObject);
    procedure ShellTreeView1DblClick(Sender: TObject);
    procedure ShellTreeView1Change(Sender: TObject; Node: TTreeNode);
  private
    { Private declarations }
    mainForm : TObject;
    sldb,thumbsdb: TSQLiteDatabase;
  public
    { Public declarations }
  constructor create(Sender: TComponent);
  function getSelectedLocation(): TLocation;
  procedure AddPathToTgit(location: TLocation; path: String; includeSubfolders:Boolean;initialTags:String);
  procedure AddFileToTgit(location: TLocation; path,fname: String; initialTags:String);
  end;

var
  FrmAddFiles: TFrmAddFiles;

implementation

uses
  Unit2;

{$R *.dfm}
{$OPTIMIZATION OFF}

constructor TFrmAddFiles.create(Sender: TComponent);
begin
  inherited create(Sender);
  mainForm:=TFrmMain(Sender);
  sldb:=TFrmMain(mainForm).sldb;
  thumbsdb:=TFrmMain(mainForm).thumbsdb;
  edtInitialTags.Text:=TFrmMain(mainForm).selectedTags.CommaText;
end;

procedure TFrmAddFiles.cmbLocationChange(Sender: TObject);
begin
//  lblLocationDescription.Caption:=cmbLocation.description;
end;


procedure TFrmAddFiles.FormCreate(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  cmbLocation.Clear;
  for i:=0 to length(TFrmMain(mainForm).locations)-1 do
    begin
      s:=TFrmMain(mainForm).locations[i].name;
      cmbLocation.Items.addObject(s,TFrmMain(mainForm).locations[i]);
    end;
end;

procedure TFrmAddFiles.ShellTreeView1DblClick(Sender: TObject);
var
  fname: String;
begin
  fname:=ShellTreeView1.selectedFolder.PathName;
  if FileExists(fname) then
    ShellExecute(Handle, 'open', PChar(fname), nil, nil, SW_SHOW)
end;

procedure TFrmAddFiles.BtnAddFilesClick(Sender: TObject);
var
  selectedLocation: TLocation;
  path:String;
begin
  if cmbLocation.itemindex>-1 then begin
    path:=ShellTreeView1.SelectedFolder.PathName;
    selectedLocation:=getSelectedLocation();
    AddPathToTgit(selectedlocation,path,chkSubfolders.checked,edtInitialTags.text);
    close;
  end
  else
    alert('Bitte w�hlen Sie eine Location aus!');  
end;

function TFrmAddFiles.getSelectedLocation(): TLocation;
begin
  result:=TLocation(cmbLocation.Items.Objects[cmbLocation.itemIndex]);
end;

procedure TFrmAddFiles.AddPathToTgit(location: TLocation; path: String; includeSubfolders:Boolean;initialTags:String);
var
  strl: TStringList;
  fname: string;
  r: TSearchRec;
  eod: Integer; // end of directory
begin
  try
    if FileExists(path) then begin
        strl:=split(path,'\');
        fname:=strl.strings[strl.count-1];
        strl.Delete(strl.Count-1);
        path:=AssembleItWell(strl,'\');
//        Fileinfo.add_file(location,path,filename,opts)
        AddFileToTgit(location,path,fname,initialTags);
    end
    else begin
      if DirectoryExists(path) then begin
        eod:=FindFirst(path+'\*.*',faAnyFile,r);
        while eod=0 do begin
          if (r.name<>'.') and (r.name<>'..') then begin
            if FileExists(path+'\'+r.Name) then begin
              AddFileToTgit(location,path,r.Name,initialTags);
            end
            else begin
              if includeSubfolders and DirectoryExists(path+'\'+r.Name) then begin
                AddPathToTgit(location,path+'\'+r.Name,includeSubfolders,initialTags);
              end;
            end;
          end;
          eod:=FindNext(r);
        end;
      end;
    end;
  finally
    findclose(r);
  end
end;

procedure TFrmAddFiles.AddFileToTgit(location: TLocation; path,fname: String; initialTags:String);
var
  path_file,sha2: string;
  fsize: Integer;
  fi: TFileinfo;
  fl: TFileLocation;
begin
    path_file:=path+'\'+fname;
    sha2:=TFrmMain(mainform).GetSha2(path_file);
    fsize:=TFrmMain(mainform).GetFilesize(path_file);
    fi:=TFileinfo.db_find_or_create_by_sha2_and_filesize(sldb,sha2,fsize);
    // Jetzt die Tags hinzuf�gen
    fi.addTagNames(initialTags);
    // und die File_Location anlegen, damit man auch wei�, wo die Datei lag:
    fl:=TFileLocation.db_find_or_create_by_fileinfo_id_and_location_id_and_path_and_filename(sldb,fi.id, location.id, path, fname);
  try
    // Thumbnail erzeugen:
    doLoadImage(path+'\'+fname,imgPreview,0,fi,sldb,thumbsdb,true);
  finally
    fi.free;
    fl.free;
    application.ProcessMessages;
  end;
end;



procedure TFrmAddFiles.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmAddFiles.ShellTreeView1Change(Sender: TObject;
  Node: TTreeNode);
var
  fname: String;
begin
  fname:=ShellTreeView1.SelectedFolder.PathName;
  if fileExists(fname) then
    DoLoadImage(fname,imgPreview);
end;

end.
