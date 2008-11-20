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
    function getAccessibleLocation(CDROMDriveLetter,UsbStickLetter:string): String;
    function getAlternateDriveLetter():string;
    function setDriveLetter(letter,path:string):string;

    function getTags(reload: Boolean = false):TObjectList;
    function setTaglist(s:String):TObjectList;
    function addTagNames(ts:string) : TObjectList;
    function addTagName(t:string) : TObjectList;
    function removeTagNames(ts:string) : TObjectList;
    function removeTagName(t:string) : TObjectList;

    function addTagIDs(tag_ids:string) : TObjectList;
    function addTagID(tag_id:integer) : TObjectList;
    function removeTagIDs(tag_ids:string) : TObjectList;
    function removeTagID(tag_id:integer) : TObjectList;
    class function db_find(db:TSQLiteDatabase; id:integer): TFileinfo;
    class function db_create(db: TSQLiteDatabase; sha2:string; fsize:integer): TFileinfo;
    class function db_find_or_create_by_sha2_and_filesize(db: TSQLiteDatabase; sha2:string; fsize:integer):TFileinfo;

    private
      taggings: TTaggings;
      tags: TTags;
  end;

implementation

uses Unit2;

constructor TFileinfo.create(db: TSQLiteDatabase; fields: THash; includeFileLocations: Boolean);
var
  s1,s2,s3,query,flid: String;
  tbl: TSQLiteTable;
  idx: Integer;
  fl: TFileLocation;
begin
  s1:=fields.GetString('ID');
  s2:=fields.GetString('SHA2');
  s3:=fields.GetString('FILESIZE');
  if s1='' then begin
    messageDlg('FEHLER: ID ist leer',mtInformation,[mbOK],0);
    self.Free;
  end  
  else
    begin
//      taggings:=TObjectList.create;
//      tags:=TObjectList.create;
      id:=strtoint(s1);
      sha2:=UTF8Decode(s2);
      filesize:=strtoint(s3);
      file_locations:=TObjectList.create;
      sldb:=DB;
      if includeFileLocations then
      begin
        query:='SELECT fileinfos.*,file_locations.id AS FILE_LOCATION_ID'+
               ' FROM fileinfos'+
               ' LEFT JOIN file_locations ON fileinfos.id=file_locations.fileinfo_id '+
               ' WHERE fileinfos.id='+s1+' AND FILE_LOCATION_ID!=""';
         tbl := slDb.GetTable(query);
         while not tbl.eof do
         begin
           idx:=tbl.FieldIndex['FILE_LOCATION_ID'];
           flid:=tbl.FieldAsString(idx);
           fl:=file_location_find_by_id(flid);
           self.file_locations.Add(fl);
           tbl.next;
         end;
       end;
    end;
end;

destructor TFileinfo.destroy();
begin
  file_locations.free;
  tags.free;
  taggings.free;
end;

function TFileinfo.getAttr(name:String):String;
begin
  if name='id' then result:=inttostr(self.id)
  else if name='sha2' then result:=self.sha2
  else if name='filesize' then result:=inttostr(self.filesize);
end;

function TFileinfo.file_location_find_by_id(id:String):TFileLocation;
var
  tbl: TSQLiteTable;
begin
  tbl:=sldb.GetTable('SELECT * FROM file_locations WHERE id='+id+' LIMIT 1');
  if not tbl.EOF then
    result:=TFileLocation.create(tbl.GetRow,self)
  else
    result:=nil;
end;

function TFileinfo.getAccessibleLocation(CDROMDriveLetter,UsbStickLetter:string): String;
var
  i: integer;
  fl: TFileLocation;
  path: String;
begin
  result:='';
  i:=0;
  while (result='') and (i<self.file_locations.count) do
    begin
      fl:=TFileLocation(self.file_locations[i]);
//      if fl.location.location_type='CdRom' then
//        path:=setDriveLetter(CDROMDriveLetter, fl.full_path)
//      else
//        if fl.location.location_type='UsbStick' then
          path:=setDriveLetter(USBStickLetter, fl.full_path);
//        else
//          path:=fl.full_path;
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

function TFileinfo.getTags(reload: Boolean = false):TObjectList;
var
  tbl: TSQLiteTable;
begin
  if (tags<>nil) and not reload then
    result:=tags
  else begin
    if tags<>nil then tags.free;
    tbl := sldb.GetTable('SELECT tags.* FROM taggings LEFT JOIN tags ON taggings.tag_id=tags.id WHERE taggings.taggable_type="Fileinfo" AND taggings.taggable_id="'+inttostr(self.id)+'"');
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
  l: TObjectList;
  pcs: TStringList;
  i,j: integer;
  t: TTag;
  tgg: TTagging;
  found: Boolean;
begin
  try
    l:=getTags;
    pcs:=Split(ts,',');
    for i:=0 to pcs.Count-1 do begin
      t:=TTag.db_find_or_create(sldb,pcs[i]);
      found:=false;
      for j:=0 to l.count-1 do begin
        if TTag(l.Items[j]).id=t.id then begin
          found:=true;
          break;
        end;
      end;
      if not found then begin
        tgg:=TTagging.db_create(sldb,'Fileinfo',self.id,t.id);
        tgg.free;
      end;
      t.Free;
    end;
    result:=getTags(true);
  finally
    pcs.Free;
  end;
end;

function TFileinfo.addTagName(t:string) : TObjectList;
begin
end;

function TFileinfo.removeTagNames(ts:string) : TObjectList;
begin
end;

function TFileinfo.removeTagName(t:string) : TObjectList;
begin
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
end;

// =============================================================================
//                             Klassen-Methoden
// =============================================================================

class function TFileinfo.db_find(db:TSQLiteDatabase; id:integer): TFileinfo;
var
  tbl: TSQLiteTable;
begin
  tbl:=db.GetTable('SELECT * FROM fileinfos WHERE id="'+inttostr(id)+'"');
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
  db.ExecSQL('INSERT INTO fileinfos (sha2,filesize) VALUES ("'+sha2+'","'+inttostr(fsize)+'")');
  id:=db.GetLastInsertRowID;
  result:=TFileinfo.db_find(db,id);
end;

class function TFileinfo.db_find_or_create_by_sha2_and_filesize(db: TSQLiteDatabase; sha2:string; fsize:integer):TFileinfo;
var
  tbl: TSQLiteTable;
begin
  tbl:=db.GetTable('SELECT * FROM fileinfos WHERE sha2="'+sha2+'" AND filesize="'+inttostr(fsize)+'"');
  if tbl.Count>0 then begin
    result:=TFileinfo.create(db,tbl.getRow,true);
  end
  else begin
    result:=TFileinfo.db_create(db,sha2,fsize);
  end;
end;



end.
