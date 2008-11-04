unit UFileinfo;

interface

uses Hashes,sysutils,Contnrs, UFileLocation, Dialogs;

type
  TFileinfo = class(TObject)

  public
    id: Integer;
    sha2: String;
    filesize: Integer;
    file_locations: TObjectList;
    //preview: TImage;
    constructor create(fields: THash);
    function getAttr(name:String):String;
    function getAccessibleLocation: String;
    function getTags():TObjectList;

    function addTagNames(tags:string) : Boolean;
    function addTagName(tag:string) : Boolean;
    function removeTagNames(tags:string) : Boolean;
    function removeTagName(tag:string) : Boolean;

    function addTagIDs(tag_ids:string) : Boolean;
    function addTagID(tag_id:integer) : Boolean;
    function removeTagIDs(tag_ids:string) : Boolean;
    function removeTagID(tag_id:integer) : Boolean;


  end;

implementation

constructor TFileinfo.create(fields: THash);
var
  s1,s2,s3: String;
begin
s1:=fields.GetString('ID');
s2:=fields.GetString('SHA2');
s3:=fields.GetString('FILESIZE');
if s1='' then   messageDlg('FEHLER: ID ist leer',mtInformation,[mbOK],0)
else
begin
  self.id:=strtoint(fields.GetString('ID'));
  self.sha2:=UTF8Decode(fields.GetString('SHA2'));
  self.filesize:=strtoint(fields.GetString('FILESIZE'));
  self.file_locations:=TObjectList.create;
end;  
end;

function TFileinfo.getAttr(name:String):String;
begin
  if name='id' then result:=inttostr(self.id)
  else if name='sha2' then result:=self.sha2
  else if name='filesize' then result:=inttostr(self.filesize);
end;

function TFileinfo.getAccessibleLocation: String;
var
  i: integer;
begin
  result:='';
  i:=0;
  while (result='') and (i<self.file_locations.count) do
    begin
      if TFileLocation(self.file_locations[i]).accessible
      then result:=TFileLocation(self.file_locations[i]).full_path;
      inc(i);
    end;
end;

function TFileinfo.getTags():TObjectList;
begin
end;

// by Name
function TFileinfo.addTagNames(tags:string) : Boolean;
begin
end;

function TFileinfo.addTagName(tag:string) : Boolean;
begin
end;

function TFileinfo.removeTagNames(tags:string) : Boolean;
begin
end;

function TFileinfo.removeTagName(tag:string) : Boolean;
begin
end;

// by ID
function TFileinfo.addTagIDs(tag_ids:string) : Boolean;
begin
end;

function TFileinfo.addTagID(tag_id:integer) : Boolean;
begin
end;

function TFileinfo.removeTagIDs(tag_ids:string) : Boolean;
begin
end;

function TFileinfo.removeTagID(tag_id:integer) : Boolean;
begin
end;

end.
