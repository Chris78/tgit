unit UFileinfo;

interface

uses Classes,Hashes,sysutils,Contnrs, UFileLocation, Dialogs, Forms, SQLiteTable3, UHelper, UTag, UTagging, StringItWell;

type
//  TFunctionPtr = function : String of Object;
  TTaggings = TObjectList;
  TTags = TObjectList;

  TFileinfo = class(TObject)

  public
    id: Integer;
    sha2: String;
    filesize: Integer;
    file_locations: TObjectList;
    sldb: TSQLiteDatabase;
//    getCDROM : TFunctionPtr;
    alternateDriveLetter: Pointer; // Es kann sein, dass eine CD in Laufwerk d: lag als sie indiziert wurde, aber nun in Laufwerk e: liegt!
    alternateHTTPHost,alternateHTTPPath: String;

    constructor create(db: TSQLiteDatabase; fields: THash; includeFileLocations: Boolean);
    destructor destroy();

    function getAttr(name:String):String;
    function file_location_find_by_id(id:String):TFileLocation;
    function getFileLocations(reload: Boolean = false):TObjectList;
    function getFileLocationNames():string;

    function getAccessibleLocation(CDROMDriveLetter,UsbStickLetter:string): String;
    function getAlternateDriveLetter():string;
    function setDriveLetter(letter,path:string):string;

    function getTaggings(reload: Boolean = false):TObjectList;
    function getTags(reload: Boolean = false):TObjectList;
    function setTaglist(s:String):TObjectList;
    function addTagNames(ts:string) : TObjectList;
    function addTagName(tagName:string) : TObjectList;
    function removeTagNames(ts:string) : TObjectList;
    function removeTagName(tagName:string) : TObjectList;

    function addTagIDs(tag_ids:string) : TObjectList;
    function addTagID(tag_id:integer) : TObjectList;
    function removeTagIDs(tag_ids:string) : TObjectList;
    function removeTagID(tag_id:integer) : TObjectList;
    function fi_destroy():Boolean;

    class function taggable_type : String;
    class function db_find(db:TSQLiteDatabase; id:integer): TFileinfo;
    class function db_create(db: TSQLiteDatabase; sha2:string; fsize:integer): TFileinfo;
    class function db_find_or_create_by_sha2_and_filesize(db: TSQLiteDatabase; sha2:string; fsize:integer):TFileinfo;
    class function db_destroy(db: TSQLiteDatabase; id:integer):Boolean;

    private
      taggings: TTaggings;
      tags: TTags;
  end;

implementation

uses Unit2;

function TFileinfo.getAttr(name:String):String;
begin
  if name='id' then result:=inttostr(id)
  else if name='sha2' then result:=sha2
  else if name='filesize' then result:=inttostr(filesize);
end;

function TFileinfo.file_location_find_by_id(id:String):TFileLocation;
var
  tbl: TSQLiteTable;
begin
  tbl:=sldb.GetTable('SELECT * FROM file_locations WHERE id='+id+' LIMIT 1');
  if not tbl.EOF then
    result:=TFileLocation.create(sldb,tbl.GetRow)
  else
    result:=nil;
end;

function TFileinfo.getFileLocations(reload: Boolean = false):TObjectList;
var
  tbl: TSQLiteTable;
begin
  if (self.file_locations<>nil) or reload then begin
    if self.file_locations<>nil then self.file_locations.free;
    tbl:=sldb.GetTable('SELECT * FROM file_locations WHERE fileinfo_id='+inttostr(self.id));
    file_locations:=TObjectList.create();
    while not tbl.EOF do begin
      file_locations.Add(TFileLocation.Create(sldb, tbl.getRow));
      tbl.Next;
    end;
  end;
  result:=self.file_locations;
end;

function TFileinfo.getAccessibleLocation(CDROMDriveLetter,UsbStickLetter:string): String;
var
  i: integer;
  fl: TFileLocation;
  path: String;
begin
  result:='';
  i:=0;
  while (result='') and (i<self.file_locations.count) do begin
    fl:=TFileLocation(file_locations[i]);
//    if fl.location.loc_type='CdRom' then
//      path:=setDriveLetter(CDROMDriveLetter, fl.full_path)
//    else
//      if fl.location.loc_type='UsbStick' then
//        path:=setDriveLetter(USBStickLetter, fl.full_path)
//      else
        path:=fl.full_path;
    if FileExists(path) then
      result:=path;
    inc(i);
  end;
end;

function TFileinfo.setDriveLetter(letter,path:string):string;
var i:integer;
begin
  for i:=0 to length(letter)-1 do
    path[i]:=letter[i];
  result:=path;
end;

function TFileinfo.getAlternateDriveLetter():string;
var
  f : TFrmMain;
begin
//redo?  f:=TForm1(self.mainform);
//       result:=f.caption;
//  getCDROM();
end;

function TFileinfo.getTaggings(reload: Boolean = false):TObjectList;
var
  tbl: TSQLiteTable;
begin
  if (self.taggings<>nil) and not reload then
    result:=self.taggings
  else begin
    if self.taggings<>nil then self.taggings.Free;
    tbl:=sldb.GetTable('SELECT * FROM taggings WHERE taggable_type="'+self.taggable_type+'" AND taggable_id='+inttostr(self.id));
    taggings:=TObjectList.create();
    while not tbl.EOF do begin
      taggings.Add(TTagging.Create(sldb, tbl.getRow));
      tbl.Next;
    end;
    result:=taggings;
  end;
end;

function TFileinfo.getTags(reload: Boolean = false):TObjectList;
var
  tbl: TSQLiteTable;
begin
  if (tags<>nil) and not reload then
    result:=tags
  else begin
    if tags<>nil then tags.free;
    tbl := sldb.GetTable('SELECT tags.* FROM '
                        +' taggings LEFT JOIN tags ON taggings.tag_id=tags.id '
                        +' WHERE taggings.taggable_type="'+UTF8Encode(TFileinfo.taggable_type)+'" '
                        +'   AND taggings.taggable_id='+inttostr(self.id)
                        +' ORDER BY tags.name ASC');
    tags:=TObjectList.create();
    while not tbl.EOF do begin
      tags.Add(TTag.Create(sldb, tbl.getRow));
      tbl.Next;
    end;
    result:=tags;
  end;
end;

function TFileinfo.setTaglist(s:String):TObjectList;
begin
end;

// by Name
function TFileinfo.addTagNames(ts:string) : TObjectList;
var
  pcs: TStringList;
  i: integer;
begin
  try
    pcs:=Split(ts,',');
    for i:=0 to pcs.Count-1 do result:=addTagName(pcs[i]);
  finally
    pcs.Free;
  end;
end;

function TFileinfo.addTagName(tagName:string) : TObjectList;
var
  i: integer;
  t: TTag;
  found: Boolean;
  l: TObjectList;
  tgg: TTagging;
begin
  l:=getTags;
  t:=TTag.db_find_or_create(sldb,tagName);
  found:=false;
  for i:=0 to l.count-1 do begin
    if TTag(l.Items[i]).id=t.id then begin
      found:=true;
      break;
    end;
  end;
  if not found then begin
    tgg:=TTagging.db_create(sldb,TFileinfo.taggable_type,self.id,t.id);
    tgg.free;
  end;
  t.Free;
  result:=getTags(true);
end;

function TFileinfo.removeTagNames(ts:string) : TObjectList;
begin
end;

function TFileinfo.removeTagName(tagName:string) : TObjectList;
var
  i: Integer;
  l : TObjectList;
  t: TTag;
begin
  l:=getTags;
  for i:=0 to l.Count-1 do begin
    t:=TTag(l[i]);
    if lowercase(t.name)=lowercase(tagName) then begin
      removeTagID(t.id);
      break;
    end;
  end;
  result:=getTags(true);
end;

// by ID
function TFileinfo.addTagIDs(tag_ids:string) : TObjectList;
begin
end;

function TFileinfo.addTagID(tag_id:integer) : TObjectList;
begin
end;

function TFileinfo.removeTagIDs(tag_ids:string) : TObjectList;
begin
end;

function TFileinfo.removeTagID(tag_id:integer) : TObjectList;
begin
  TTagging.db_delete_by_taggable_type_and_taggable_id_and_tag_id(sldb,TFileinfo.taggable_type,self.id,tag_id);
  result:=nil; // <-- z.Zt. noch kein Grund hier die aktuelle Taglist zurückzugeben, ansonsten:
  //result:=getTags(true);
end;

function TFileinfo.fi_destroy():Boolean;
var
  i: Integer;
begin
  // TODO: folgenden Schritte immer als Transaktion durchführen!!
  try
    // Taggings löschen
    for i:=0 to self.getTaggings().Count-1 do begin
      TTagging(self.taggings.Items[i]).tgg_destroy();
    end;
    // FileLocations löschen
    for i:=0 to self.getFileLocations().Count-1 do begin
      TFileLocation(self.file_locations.Items[i]).fl_destroy();
    end;
    // Fileinfo selbst löschen:
    sldb.ExecSQL('DELETE FROM fileinfos WHERE id='+inttostr(self.id));
    result:=true;
  except
    result:=false;
  end;
end;


function TFileinfo.getFileLocationNames():string;
var
  i: Integer;
begin
  result:='';
  for i:=0 to self.getFileLocations().count-1 do
    result:=result+TFileLocation(self.file_locations[i]).location_and_full_path+#13#10;
end;


// =============================================================================
//                             Klassen-Methoden
// =============================================================================

constructor TFileinfo.create(db: TSQLiteDatabase; fields: THash; includeFileLocations: Boolean);
var
  s1,query,flid: String;
  tbl: TSQLiteTable;
  idx: Integer;
  fl: TFileLocation;
begin
  s1:=fields.GetString('ID');
  if s1='' then begin
    messageDlg('FEHLER: ID ist leer',mtInformation,[mbOK],0);
    self.Free;
  end
  else begin
//      taggings:=TObjectList.create;
//      tags:=TObjectList.create;
      id:=strtoint(s1);
      sha2:=UTF8Decode(fields.GetString('SHA2'));
      filesize:=strtoint(fields.GetString('FILESIZE'));
      file_locations:=TObjectList.create;
      sldb:=db;
      if includeFileLocations then begin
        query:='SELECT fileinfos.*,file_locations.id AS FILE_LOCATION_ID'+
               ' FROM fileinfos'+
               ' LEFT JOIN file_locations ON fileinfos.id=file_locations.fileinfo_id '+
               ' WHERE fileinfos.id='+s1+' AND FILE_LOCATION_ID IS NOT NULL';
         tbl := slDb.GetTable(query);
         while not tbl.eof do begin
           idx:=tbl.FieldIndex['FILE_LOCATION_ID'];
           flid:=tbl.FieldAsString(idx);
           fl:=file_location_find_by_id(flid);
           self.file_locations.Add(fl);
           tbl.next;
         end;
      end;
  end;
end;

class function TFileinfo.taggable_type : String;
begin
  result:='Fileinfo';
end;

class function TFileinfo.db_find(db:TSQLiteDatabase; id:integer): TFileinfo;
var
  tbl: TSQLiteTable;
begin
  tbl:=db.GetTable('SELECT * FROM fileinfos WHERE id='+inttostr(id));
  if tbl.Count>0 then begin
    result:=TFileinfo.create(db,tbl.getRow,true);
  end
  else begin
    alert('Fileinfo '+inttostr(id)+' nicht gefunden!');
  end;
end;

class function TFileinfo.db_create(db: TSQLiteDatabase; sha2:string; fsize:integer):TFileinfo;
var
  id: Int64;
begin
  db.ExecSQL('INSERT INTO fileinfos (sha2,filesize) VALUES ("'+sha2+'",'+inttostr(fsize)+')');
  id:=db.GetLastInsertRowID;
  result:=TFileinfo.db_find(db,id);
end;

class function TFileinfo.db_find_or_create_by_sha2_and_filesize(db: TSQLiteDatabase; sha2:string; fsize:integer):TFileinfo;
var
  tbl: TSQLiteTable;
begin
  tbl:=db.GetTable('SELECT * FROM fileinfos WHERE sha2="'+sha2+'" AND filesize='+inttostr(fsize));
  if tbl.Count>0 then begin
    result:=TFileinfo.create(db,tbl.getRow,true);
  end
  else begin
    result:=TFileinfo.db_create(db,sha2,fsize);
  end;
end;

class function TFileinfo.db_destroy(db: TSQLiteDatabase; id:integer):Boolean;
var
  fi: TFileinfo;
begin
  fi:=TFileinfo.db_find(db,id);
  result:=fi.fi_destroy;
  fi.Free;
end;

destructor TFileinfo.destroy();
begin
  if file_locations<>nil then file_locations.free;
  if tags<>nil then tags.free;
  if taggings<>nil then taggings.free;
end;

end.
