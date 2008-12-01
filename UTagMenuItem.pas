unit UTagMenuItem;

interface

uses
  Classes, Menus, Forms,
  UTag, UTagging;

type
  TTagMenuItem = class(TMenuItem)
    tagging: TTagging;
  private
  public
    constructor create(aOwner:TComponent; aTagging: TObject);
  end;

implementation

constructor TTagMenuItem.create(aOwner:TComponent; aTagging: TObject);
begin
  tagging:=TTagging(aTagging);
  caption:=tagging.getTag().name;
  inherited create(aOwner);
end;

end.
 