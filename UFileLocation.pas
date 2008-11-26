unit UFileLocation;

interface

uses Hashes,sysutils, ULocation, SQLiteTable3, UHelper;

type

  TFileLocation = class(TObject)

  public
    id,fileinfo_id,location_id: Integer;
    path,filename: String;
    sldb: TSQLiteDatabase;
    alternateDriveLetter: String; // Es kann sein, dass eine CD in Laufwerk d: lag als sie indiziert wurde, aber nun in Laufwerk e: liegt!
    alternateHTTPHost,alternateHTTPPath: String;
    location: TLocation;  // "file_location belongs_to :location"
    fileinfo : TObject; // "file_location belongs_to :fileinfo"

    function getFileinfo: TObject;
    function getLocation: TLocation;
    function full_path:String;
    function location_and_full_path:String;
    function accessible: Boolean;
    function fl_destroy():Boolean;

    constructor create(db:TSQLiteDatabase; fields: THash);
    class function db_find(db:TSQLiteDatabase; id:integer): TFileLocation;    
    class function db_create(db: TSQLiteDatabase; fileinfo_id, location_id: Integer; path, fname: String) : TFileLocation;    
    class function db_find_or_create_by_fileinfo_id_and_location_id_and_path_and_filename(db: TSQLiteDatabase; fileinfo_id, location_id: Integer; path, fname: String): TFileLocation;
  end;

implementation

uses UFileinfo;

function TFileLocation.getFileinfo():TObject;
begin
  if fileinfo=nil then
    fileinfo:=TFileinfo.db_find(sldb,fileinfo_id);
  result:=fileinfo;
end;

function TFileLocation.getLocation():TLocation;
begin
  if location=nil then
    location:=TLocation.db_find(sldb,location_id);
  result:=location;
end;

function TFileLocation.full_path():String;
begin
  result:=self.path+'\'+self.filename;
  while pos('/',result)<>0 do
  begin
    result[pos('/',result)]:='\';
  end;
end;

function TFileLocation.location_and_full_path():String;
begin
  result:=path+'\'+filename;
  while pos('/',result)<>0 do
  begin
    result[pos('/',result)]:='\';
  end;
  result:=getLocation().name+':///'+result;
end;

function TFileLocation.accessible():Boolean;
begin
  result:=FileExists(self.full_path);
end;

function TFileLocation.fl_destroy():Boolean;
begin
  try
    sldb.ExecSQL('DELETE FROM file_locations WHERE id='+inttostr(self.id));
    result:=true;
  finally
    result:=false;
  end;
end;

// =============================================================================
//                             Klassen-Methoden
// =============================================================================


constructor TFileLocation.create(db:TSQLiteDatabase; fields: THash);
begin
  self.id:=strtoint(fields.GetString('ID'));
  self.fileinfo_id:=strtoint(fields.GetString('FILEINFO_ID'));
  self.location_id:=strtoint(fields.GetString('LOCATION_ID'));
  self.path:=UTF8Decode(fields.GetString('PATH'));
  self.filename:=UTF8Decode(fields.GetString('FILENAME'));
  sldb:=db;
  //if fileinfo<>nil then self.fileinfo:=finfo;  // eager loaden?
end;


class function TFileLocation.db_find(db:TSQLiteDatabase; id:integer): TFileLocation;
var
  tbl: TSQLiteTable;
begin
  tbl:=db.GetTable('SELECT * FROM file_locations WHERE id="'+inttostr(id)+'"');
  if tbl.Count>0 then begin
    result:=TFileLocation.create(db,tbl.getRow);
  end
  else begin
    alert('FileLocaton '+inttostr(id)+' nicht gefunden!');
  end;
end;


class function TFileLocation.db_create(db: TSQLiteDatabase; fileinfo_id, location_id: Integer; path, fname: String) : TFileLocation;
var
  id: Int64;
begin
  db.ExecSQL('INSERT INTO file_locations (fileinfo_id,location_id,path,filename) VALUES ("'+inttostr(fileinfo_id)+'","'+inttostr(location_id)+'", "'+UTF8Encode(path)+'", "'+UTF8Encode(fname)+'")');
  id:=db.GetLastInsertRowID;
  result:=TFileLocation.db_find(db,id);
end;

class function TFileLocation.db_find_or_create_by_fileinfo_id_and_location_id_and_path_and_filename(db: TSQLiteDatabase; fileinfo_id, location_id: Integer; path, fname: String): TFileLocation;
var
  tbl: TSQLiteTable;
begin
  tbl:=db.GetTable('SELECT * FROM file_locations '
                  +'WHERE fileinfo_id="'+inttostr(fileinfo_id)+'"'
                  +'  AND location_id="'+inttostr(location_id)+'"'
                  +'  AND path="'+UTF8Encode(path)+'"'
                  +'  AND filename="'+UTF8Encode(fname)+'"');
  if tbl.Count>0 then begin
    result:=TFileLocation.create(db,tbl.getRow);
  end
  else begin
    result:=TFileLocation.db_create(db,fileinfo_id,location_id,path,fname);
  end;
end;

end.
