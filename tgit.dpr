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
  UHelper in 'UHelper.pas',
  UTag in 'UTag.pas',
  UTagging in 'UTagging.pas',
  UFrmEditTags in 'UFrmEditTags.pas' {frmEditTags},
  UTagMenuItem in 'UTagMenuItem.pas',
  AVCodec in 'AVCodec.pas',
  UFrmEditLocations in 'UFrmEditLocations.pas' {frmEditLocations},
  ULocationType in 'ULocationType.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  //Application.CreateForm(TfrmEditLocations, frmEditLocations);
  Application.Run;
end.
