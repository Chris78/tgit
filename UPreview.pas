unit UPreview;

interface

uses
  Classes, Graphics, ExtCtrls, Controls, UFileinfo;

type

  TPreview = class(TImage)
    fileinfo: TFileinfo;

  private

  public
    constructor create(aOwner:TComponent; aFileinfo: TFileinfo);
  end;


implementation

constructor TPreview.create(aOwner:TComponent; aFileinfo: TFileinfo);
begin
  self.fileinfo:=aFileinfo;
  inherited create(aOwner);
end;



end.
