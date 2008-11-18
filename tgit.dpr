program tgit;

uses
  Forms,
  Unit2 in 'Unit2.pas' {Form1},
  StringItWell in 'StringItWell.pas',
  UFileinfo in 'UFileinfo.pas',
  UFileLocation in 'UFileLocation.pas',
  UJPGStreamFix in 'UJPGStreamFix.pas',
  UPreview in 'UPreview.pas',
  ULocation in 'ULocation.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
