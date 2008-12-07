unit ULocationType;

interface

uses
  Contnrs;

type

  TLocationType = class(TObject)
  public
    name: String;
    function title: String;
    constructor create(aName:String);
    class function toTitle(s:string):String;
    class function toType(s:string):String;
    class function types():TObjectList;
  end;


implementation

constructor TLocationType.create(aName:String);
begin
  name:=aName;
end;

function TLocationType.title:String;
begin
  result:=TLocationType.toTitle(name);
end;


class function TLocationType.toTitle(s:string):String;
begin
  if s='Harddisk' then
    result:='Festplatten'

  else if s='HddCase' then
    result:='HDD-Gehäuse'

  else if s='CdRom' then
    result:='CD'

  else if s='Dvd' then
    result:='DVD'

  else if s='UsbStick' then
    result:='USB'

  else if s='SdMmc' then
    result:='SD/MMC-Card'

  else if s='Web' then
    result:='WWW'
  else
    result:=s;
end;

class function TLocationType.toType(s:string):String;
begin
  if s='Festplatten' then
    result:='Harddisk'

  else if s='HDD-Gehäuse' then
    result:='HddCase'

  else if s='CD' then
    result:='CdRom'

  else if s='DVD' then
    result:='Dvd'

  else if s='USB' then
    result:='UsbStick'

  else if s='SD/MMC-Card' then
    result:='SdMmc'

  else if s='WWW' then
    result:='Web'
  else
    result:=s;
end;

class function TLocationType.types():TObjectList;
begin
  result:=TObjectList.Create;
  result.Add(TLocationType.create('Computer'));
  result.Add(TLocationType.create('HddCase'));
  result.Add(TLocationType.create('Harddisk'));
  result.Add(TLocationType.create('CdRom'));
  result.Add(TLocationType.create('Dvd'));
  result.Add(TLocationType.create('UsbStick'));
  result.Add(TLocationType.create('SdMmc'));
  result.Add(TLocationType.create('Web'));
end;



end.
