object FrmAddFiles: TFrmAddFiles
  Left = 434
  Top = 239
  Caption = 'Dateien zu tgit hinzuf'#252'gen'
  ClientHeight = 541
  ClientWidth = 792
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PanelAddFiles: TPanel
    Left = 0
    Top = 0
    Width = 792
    Height = 541
    Align = alClient
    TabOrder = 0
    DesignSize = (
      792
      541)
    object lblInitialTags: TLabel
      Left = 5
      Top = 467
      Width = 62
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Schlagworte:'
    end
    object lblLocationDescription: TLabel
      Left = 276
      Top = 3
      Width = 3
      Height = 13
    end
    object imgPreview: TImage
      Left = 408
      Top = 24
      Width = 377
      Height = 441
      Anchors = [akTop, akRight, akBottom]
      Center = True
      Proportional = True
    end
    object ShellTreeView1: TShellTreeView
      Left = 1
      Top = 24
      Width = 400
      Height = 441
      ObjectTypes = [otFolders, otNonFolders, otHidden]
      Root = 'rfMyComputer'
      UseShellImages = True
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoRefresh = False
      HideSelection = False
      Indent = 19
      ParentColor = False
      RightClickSelect = True
      ShowRoot = False
      TabOrder = 0
      OnChange = ShellTreeView1Change
    end    
    object cmbLocation: TComboBox
      Left = 1
      Top = 1
      Width = 270
      Height = 21
      ItemHeight = 0
      TabOrder = 0
      Text = 'cmbLocation'
    end
    object chkSubfolders: TCheckBox
      Left = 276
      Top = 3
      Width = 258
      Height = 17
      Caption = 'Unterverzeichnisse einschlie'#223'en?'
      TabOrder = 1
    end
    object edtInitialTags: TEdit
      Left = 5
      Top = 483
      Width = 639
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      AutoSelect = False
      TabOrder = 2
    end
    object BtnAddFiles: TButton
      Left = 650
      Top = 481
      Width = 138
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Dateien/Ordner hinzuf'#252'gen'
      TabOrder = 4
      OnClick = BtnAddFilesClick
    end
    object btnClose: TButton
      Left = 329
      Top = 515
      Width = 137
      Height = 25
      Anchors = [akBottom]
      Caption = 'schlie'#223'en'
      TabOrder = 3
      OnClick = btnCloseClick
    end
  end
end
