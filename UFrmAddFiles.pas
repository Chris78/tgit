unit UFrmAddFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ShellCtrls, ExtCtrls,ShellAPI,Hashes,StringItWell;

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
    Button10: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button10Click(Sender: TObject);
  private
    { Private declarations }
    mainForm : TObject;
  public
    { Public declarations }
  constructor create(Sender: TObject);
  procedure cmbLocationChange(Sender: TObject);
  procedure ShellTreeView1DblClick(Sender: TObject);
  procedure BtnAddFilesClick(Sender: TObject);
  function getSelectedLocationId(): Integer;
  procedure AddPathToTgit(location_id: Integer; path: String; includeSubfolders:Boolean;initialTags:String);
  procedure AddFileToTgit(location_id: Integer; path,fname: String; initialTags:String);
  end;

var
  FrmAddFiles: TFrmAddFiles;

implementation

uses
  Unit2;

{$R *.dfm}

constructor TFrmAddFiles.create(Sender: TObject);
begin
  inherited create(TComponent(Sender));
  mainForm:=Sender;
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
  location_id: Integer;
  path:String;
begin
  path:=ShellTreeView1.SelectedFolder.PathName;
  location_id:=getSelectedLocationId();
  AddPathToTgit(location_id,path,chkSubfolders.checked,edtInitialTags.text);
end;

function TFrmAddFiles.getSelectedLocationId(): Integer;
begin
end;

procedure TFrmAddFiles.AddPathToTgit(location_id: Integer; path: String; includeSubfolders:Boolean;initialTags:String);
var
  strl: TStringList;
  fname,p: string;
  r: TSearchRec;
  eod: Integer; // end of directory
  h: THash;
begin
  try
    if FileExists(path) then
      begin
        strl:=split(path,'\');
        fname:=strl.strings[strl.count-1];
        strl.Delete(strl.Count-1);
        path:=AssembleItWell(strl,'\');
//        Fileinfo.add_file(location,path,filename,opts)
        AddFileToTgit(location_id,path,fname,initialTags);
      end
    else
      h:=THash.create;
      if DirectoryExists(path) then
        begin
          eod:=FindFirst(path,faAnyFile,r);
          while eod=0 do
            begin
//              h:=
//              Fileinfo.dbcreate(h);
            end;
//        d=Dir.open(path)
//        while d2=d.read
//          next if d2=='.' || d2=='..'
//          if File.directory?(File.join(d.path,d2))
//            Fileinfo.add_path(location,File.join(d.path,d2),opts) if opts[:include_subdirs]
//          else
//            if File.file?(File.join(d.path,d2))
//              Fileinfo.add_file(location,d.path,d2,opts)
//            end
//          end
//        end
//        return true
//          findclose;
        end;
      h.free;
  finally
//    findclose;
    h.Free;
  end
end;

procedure TFrmAddFiles.AddFileToTgit(location_id: Integer; path,fname: String; initialTags:String);
begin
//    path_file=File.join(path,filename)
//    f=File.open(path_file,'rb')
//    s=Digest::SHA2.hexdigest(f.read)
//    f.close
//    inf=Fileinfo.find_or_create_by_sha2_and_filesize(s, File.size(path_file))
//    unless opts[:tag_list].blank?
//      inf.tag_list="#{inf.tag_list.blank? ? '' : inf.tag_list.join(', ')+', '}#{opts[:tag_list]}"
//      inf.save
//    end
//    filename=Iconv.iconv('utf-8','iso-8859-1',filename).first
//    path=Iconv.iconv('utf-8','iso-8859-1',path).first
//    FileLocation.find_or_create_by_fileinfo_id_and_location_id_and_path_and_filename(inf.id,location.id,path,filename) if inf
//  end
end;



procedure TFrmAddFiles.Button10Click(Sender: TObject);
begin
  Close;
end;

end.
