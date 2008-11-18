program tgit;

uses
  Forms,
  Unit2 in 'Unit2.pas' {FrmMain},
  StringItWell in 'StringItWell.pas',
  UFileinfo in 'UFileinfo.pas',
  UFileLocation in 'UFileLocation.pas',
  UJPGStreamFix in 'UJPGStreamFix.pas',
  UPreview in 'UPreview.pas',
  ULocation in 'ULocation.pas',
  UFrmAddFiles in 'UFrmAddFiles.pas' {FrmAddFiles},
  UHelper in 'UHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
