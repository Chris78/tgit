object FrmAddFiles: TFrmAddFiles
  Left = 619
  Top = 43
  Width = 800
  Height = 568
  Caption = 'Dateien zu tgit hinzuf'#252'gen'
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
    object ShellTreeView1: TShellTreeView
      Left = 1
      Top = 24
      Width = 790
      Height = 441
      ObjectTypes = [otFolders, otNonFolders]
      Root = 'rfMyComputer'
      UseShellImages = True
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoRefresh = False
      Indent = 19
      ParentColor = False
      RightClickSelect = True
      ShowRoot = False
      TabOrder = 0
    end
    object cmbLocation: TComboBox
      Left = 1
      Top = 1
      Width = 270
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = 'cmbLocation'
    end
    object chkSubfolders: TCheckBox
      Left = 276
      Top = 3
      Width = 258
      Height = 17
      Caption = 'Unterverzeichnisse einschlie'#223'en?'
      TabOrder = 2
    end
    object edtInitialTags: TEdit
      Left = 5
      Top = 483
      Width = 639
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      AutoSelect = False
      TabOrder = 3
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
      TabOrder = 5
      OnClick = btnCloseClick
    end
  end
end
