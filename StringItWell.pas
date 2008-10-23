unit StringItWell;

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SQLiteTable3, ComCtrls, Grids;

  function PosEx(split,str:String; offset:Integer) : Integer;
  function AssembleItWell( stringList : TStringList; sep : String ) : String;
  function Split( str, delim : String ) : TStringList;
  function SplitItWell( str, split : String ) : TStringList;
  function SortStringBySeperator( str, sep : String ) : String;
  function strip(str:String) : String;

implementation


function PosEx(split,str:String; offset:Integer) : Integer;
var prt : String;
begin
  prt:=Copy(str,offset,length(str));
  PosEx:=offset+Pos(prt,str)+1;
end;

function strip(str:String) : String;
begin
while Copy(str,0,1)=' ' do begin
  str:=Copy(str,2,length(str));
end;
while Copy(str,length(str),1)=' ' do begin
  str:=Copy(str,1,length(str)-1);
end;
strip:=str;
end;

function Split(str, delim : String) : TStringList;
var offset,p: integer;
begin
  Result := TStringList.Create;
  offset:=0;
  p:=Pos(delim,str);
  while p<>0 do
  begin
    Result.Add(strip(Copy(str,0,p-1)));
    str:=Copy(str,p+1,length(str));
    p:=Pos(delim,str);
  end;
  Result.Add(strip(str));
end;

function SplitItWell( str, split : String ) : TStringList;
var
offset, last : integer;
begin
offset := 1;
last := 1;
Result := TStringList.Create;
if str = '' then Exit;
if length( str ) <= length( split ) then
begin
Result.Add( str );
Exit;
end;

repeat
offset := PosEx( split, str, offset );

if offset = 0 then
Result.Add( Copy( str, last, length( str ) ) )
else
begin
Result.Add( Copy( str, last, offset - last ) );
offset := offset + length( split );
last := offset;
end;

until offset = 0;
end;


function AssembleItWell( stringList : TStringList; sep : String ) : String;
var
I : Integer;
begin
Result := '';

for I := 0 to stringList.Count - 1 do
if I = stringList.Count - 1 then
Result := Result + stringList[ i ]
else
Result := Result + stringList[ i ] + sep

end;


function SortStringBySeperator( str, sep : String ) : String;
var
SplitList : TStringList;
begin

SplitList := SplitItWell( str, sep );
SplitList.Sorted := True;
Result := AssembleItWell( SplitList, sep );
FreeAndNil( SplitList );

end;

end.
