object Form1: TForm1
  Left = 48
  Top = 10
  Width = 1559
  Height = 873
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
  OnResize = FormResize
  DesignSize = (
    1551
    846)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 608
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 750
    Top = 13
    Width = 51
    Height = 13
    Caption = 'Limit Tags:'
  end
  object edtSelectedTags: TEdit
    Left = 8
    Top = 8
    Width = 481
    Height = 21
    TabOrder = 0
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
    TabOrder = 1
  end
  object TagCloud: TGroupBox
    Left = 744
    Top = 32
    Width = 801
    Height = 786
    Anchors = [akLeft, akTop, akRight]
    Caption = 'TagCloud'
    TabOrder = 2
  end
  object CheckBox1: TCheckBox
    Left = 496
    Top = 10
    Width = 73
    Height = 18
    Caption = 'match all?'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object Button1: TButton
    Left = 40
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Test SHA2'
    TabOrder = 4
    OnClick = Button1Click
  end
  object TrackBar1: TTrackBar
    Left = 808
    Top = 8
    Width = 745
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Max = 30
    Min = 1
    Orientation = trHorizontal
    Frequency = 1
    Position = 15
    SelEnd = 0
    SelStart = 0
    TabOrder = 5
    TickMarks = tmBottomRight
    TickStyle = tsAuto
    OnChange = TrackBar1Change
  end
  object DCP_sha256: TDCP_sha256
    Id = 28
    Algorithm = 'SHA256'
    HashSize = 256
    Left = 8
    Top = 32
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 1512
    Top = 40
  end
end
