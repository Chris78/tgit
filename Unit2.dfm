object Form1: TForm1
  Left = 247
  Top = 166
  Width = 1142
  Height = 656
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
    Width = 369
    Height = 297
    Caption = 'GroupBox1'
    TabOrder = 3
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
    Left = 104
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Test DLL'
    TabOrder = 5
    OnClick = Button1Click
  end
end
