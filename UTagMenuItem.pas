unit UTagMenuItem;

interface

uses Classes, Menus, Forms, UTag;

type
  TTagMenuItem = class(TMenuItem)
    tag: TTag;
  private
  public
    constructor create(aOwner:TComponent; aTag: TObject);
  end;

implementation

constructor TTagMenuItem.create(aOwner:TComponent; aTag: TObject);
begin
  tag:=TTag(aTag);
  caption:=tag.name;
  inherited create(aOwner);
end;

end.
 