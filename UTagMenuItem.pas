unit UTagMenuItem;

interface

uses
  Classes, Menus, Forms,
  UTag, UTagging, UPreview;

type
  TTagMenuItem = class(TMenuItem)
    tagging: TTagging;
    preview: TPreview;
  private
  public
    constructor create(aOwner:TComponent; aTagging: TObject; aPreview:TPreview);
  end;

implementation

constructor TTagMenuItem.create(aOwner:TComponent; aTagging: TObject; aPreview:TPreview);
begin
  tagging:=TTagging(aTagging);
  caption:=tagging.getTag().name;
  preview:=aPreview;
  inherited create(aOwner);
end;

end.
 