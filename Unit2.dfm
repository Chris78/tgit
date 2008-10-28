object Form1: TForm1
  Left = 41
  Top = 141
  Width = 1567
  Height = 1058
  Caption = 'Tgit GUI'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    1559
    1031)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 608
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object StringGrid1: TStringGrid
    Left = 744
    Top = 336
    Width = 369
    Height = 249
    ColCount = 2
    DefaultColWidth = 300
    DefaultRowHeight = 16
    FixedCols = 0
    FixedRows = 0
    TabOrder = 0
    OnSelectCell = StringGrid1SelectCell
  end
  object edtSelectedTags: TEdit
    Left = 8
    Top = 8
    Width = 481
    Height = 21
    TabOrder = 1
    OnChange = edtSelectedTagsChange
  end
  object StringGrid2: TStringGrid
    Left = 8
    Top = 72
    Width = 697
    Height = 529
    DefaultColWidth = 180
    DefaultRowHeight = 16
    FixedCols = 0
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 744
    Top = 16
    Width = 794
    Height = 699
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'GroupBox1'
    TabOrder = 3
    object Label2: TLabel
      Left = 2
      Top = 28
      Width = 32
      Height = 669
      Align = alLeft
      BiDiMode = bdLeftToRight
      Caption = 'Label2'
      ParentBiDiMode = False
    end
    object Label3: TLabel
      Left = 2
      Top = 15
      Width = 790
      Height = 13
      Align = alTop
      BiDiMode = bdLeftToRight
      Caption = 'Label3'
      ParentBiDiMode = False
    end
  end
  object CheckBox1: TCheckBox
    Left = 496
    Top = 10
    Width = 73
    Height = 18
    Caption = 'match all?'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object Button1: TButton
    Left = 40
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Test SHA2'
    TabOrder = 5
    OnClick = Button1Click
  end
  object TabbedNotebook1: TTabbedNotebook
    Left = 16
    Top = 16
    Width = 705
    Height = 577
    TabsPerRow = 15
    TabFont.Charset = DEFAULT_CHARSET
    TabFont.Color = clBtnText
    TabFont.Height = -11
    TabFont.Name = 'MS Sans Serif'
    TabFont.Style = []
    TabOrder = 6
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Default'
    end
  end
  object DCP_sha256: TDCP_sha256
    Id = 28
    Algorithm = 'SHA256'
    HashSize = 256
    Left = 8
    Top = 32
  end
end
