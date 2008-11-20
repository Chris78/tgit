unit UFrmAddFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ShellCtrls, ExtCtrls,ShellAPI,
  Hashes,StringItWell,UFileinfo,ULocation,UHelper;

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
    procedure FormCreate(Sender: TObject);
    procedure BtnAddFilesClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure cmbLocationChange(Sender: TObject);
    procedure ShellTreeView1DblClick(Sender: TObject);
  private
    { Private declarations }
    mainForm : TObject;
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
  mainForm:=Sender;
  inherited create(Sender);
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
  if cmbLocation.itemindex>-1 then
  begin
    path:=ShellTreeView1.SelectedFolder.PathName;
    selectedLocation:=getSelectedLocation();
    AddPathToTgit(selectedlocation,path,chkSubfolders.checked,edtInitialTags.text);
  end
  else
    alert('Bitte wählen Sie eine Location aus!');  
end;

function TFrmAddFiles.getSelectedLocation(): TLocation;
begin
  result:=TLocation(cmbLocation.Items.Objects[cmbLocation.itemIndex]);
end;

procedure TFrmAddFiles.AddPathToTgit(location: TLocation; path: String; includeSubfolders:Boolean;initialTags:String);
var
  strl: TStringList;
  fname,p: string;
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
//      d=Dir.open(path)
//      while d2=d.read
//        next if d2=='.' || d2=='..'
//        if File.directory?(File.join(d.path,d2))
//          Fileinfo.add_path(location,File.join(d.path,d2),opts) if opts[:include_subdirs]
//        else
//          if File.file?(File.join(d.path,d2))
//            Fileinfo.add_file(location,d.path,d2,opts)
//          end
//        end
//      end
//      return true
        end;
    end;
  finally
    findclose(r);
  end
end;

procedure TFrmAddFiles.AddFileToTgit(location: TLocation; path,fname: String; initialTags:String);
var
  path_file,sha2: string;
  f: File of Byte;
  fsize: Integer;
  fi: TFileinfo;
begin
  try
    path_file:=path+'\'+fname;
    sha2:=TFrmMain(mainform).GetSha2(path_file);
    fsize:=TFrmMain(mainform).GetFilesize(path_file);
    fi:=TFileinfo.db_find_or_create_by_sha2_and_filesize(TFrmMain(mainForm).sldb,sha2,fsize);
  // Jetzt die Tags hinzufügen
    fi.addTagNames(initialTags);
// und die File_Location anlegen, damit man auch weiß, wo die Datei lag:
//    filename=Iconv.iconv('utf-8','iso-8859-1',filename).first
//    path=Iconv.iconv('utf-8','iso-8859-1',path).first
//    FileLocation.find_or_create_by_fileinfo_id_and_location_id_and_path_and_filename(inf.id,location.id,path,filename) if inf
//  end
  finally
  end;
end;



procedure TFrmAddFiles.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
