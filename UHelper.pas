unit UHelper;

interface

uses Dialogs;

procedure alert(s:String);

implementation


procedure alert(s:String);
begin
  messageDlg(s,mtInformation,[mbOK],0);
end;

end.
 