object Form1: TForm1
  Left = 219
  Top = 153
  Width = 1559
  Height = 873
  Caption = 'Tgit GUI'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  DesignSize = (
    1551
    827)
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
  object Image1: TImage
    Left = 8
    Top = 656
    Width = 281
    Height = 169
    Center = True
    Proportional = True
    Stretch = True
  end
  object edtSelectedTags: TEdit
    Left = 8
    Top = 8
    Width = 481
    Height = 21
    TabOrder = 0
    OnChange = edtSelectedTagsChange
  end
  object TagCloud: TGroupBox
    Left = 744
    Top = 32
    Width = 801
    Height = 786
    Anchors = [akLeft, akTop, akRight]
    Caption = 'TagCloud'
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 496
    Top = 10
    Width = 73
    Height = 18
    Caption = 'match all?'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object Button1: TButton
    Left = 8
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Test SHA2'
    TabOrder = 3
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
    TabOrder = 4
    TickMarks = tmBottomRight
    TickStyle = tsAuto
    OnChange = TrackBar1Change
  end
  object edtQuery: TEdit
    Left = 8
    Top = 624
    Width = 697
    Height = 21
    TabOrder = 5
    Text = 'edtQuery'
  end
  object Button2: TButton
    Left = 120
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Test Hashes'
    TabOrder = 6
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 200
    Top = 32
    Width = 105
    Height = 25
    Caption = 'Test Fileinfo Model'
    TabOrder = 7
    OnClick = Button3Click
  end
  object TabControl1: TTabControl
    Left = 8
    Top = 64
    Width = 729
    Height = 545
    MultiLine = True
    TabOrder = 8
    TabPosition = tpRight
    Tabs.Strings = (
      'Fileinfos'
      'Previews')
    TabIndex = 1
    OnChange = TabControl1Change
    object PanelTab1: TPanel
      Left = 4
      Top = 4
      Width = 702
      Height = 537
      Align = alClient
      TabOrder = 0
      Visible = False
      object StringGrid2: TStringGrid
        Left = 1
        Top = 1
        Width = 700
        Height = 535
        Align = alClient
        DefaultColWidth = 180
        DefaultRowHeight = 16
        FixedCols = 0
        TabOrder = 0
        OnSelectCell = StringGrid2SelectCell
      end
    end
    object PanelTab2: TPanel
      Left = 4
      Top = 4
      Width = 702
      Height = 537
      Align = alClient
      TabOrder = 1
      DesignSize = (
        702
        537)
      object Button5: TButton
        Left = 16
        Top = 504
        Width = 89
        Height = 25
        Caption = 'Seite zur'#252'ck'
        Enabled = False
        TabOrder = 0
        OnClick = Button5Click
      end
      object Button6: TButton
        Left = 600
        Top = 504
        Width = 75
        Height = 25
        Caption = 'Seite vor'
        TabOrder = 1
        OnClick = Button6Click
      end
      object PanelPreviews: TPanel
        Left = -8
        Top = -1
        Width = 710
        Height = 502
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
      end
    end
  end
  object DCP_sha256: TDCP_sha256
    Id = 28
    Algorithm = 'SHA256'
    HashSize = 256
    Left = 88
    Top = 32
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 1512
    Top = 40
  end
  object MainMenu1: TMainMenu
    object Locations1: TMenuItem
      Caption = 'Locations'
      object hinzufgen1: TMenuItem
        Caption = 'hinzuf'#252'gen'
      end
      object bearbeiten1: TMenuItem
        Caption = 'bearbeiten'
      end
    end
    object Datei1: TMenuItem
      Caption = 'Dateien'
      object hinzufgen2: TMenuItem
        Caption = 'hinzuf'#252'gen'
      end
      object agSuche1: TMenuItem
        Caption = 'suchen'
        object nachSchlagwort1: TMenuItem
          Caption = 'nach Schlagworten'
        end
        object nachLocation1: TMenuItem
          Caption = 'nach Location'
        end
        object nachFilter1: TMenuItem
          Caption = 'nach Filter'
        end
      end
      object Filtersuche1: TMenuItem
        Caption = 'taggen'
        object Zufallsmodus1: TMenuItem
          Caption = 'Zufallsmodus'
        end
      end
    end
    object Ansicht1: TMenuItem
      Caption = 'Ansicht'
      object VorschaubilderproSpalte1: TMenuItem
        Caption = 'Bilder pro Spalte'
        object N11: TMenuItem
          Caption = '1'
          RadioItem = True
          OnClick = N11Click
        end
        object N21: TMenuItem
          Caption = '2'
          RadioItem = True
          OnClick = N21Click
        end
        object N31: TMenuItem
          Caption = '3'
          Checked = True
          RadioItem = True
          OnClick = N31Click
        end
        object N41: TMenuItem
          Caption = '4'
          RadioItem = True
          OnClick = N41Click
        end
        object N51: TMenuItem
          Caption = '5'
          RadioItem = True
          OnClick = N51Click
        end
        object N61: TMenuItem
          Caption = '6'
          RadioItem = True
          OnClick = N61Click
        end
        object N71: TMenuItem
          Caption = '7'
          RadioItem = True
          OnClick = N71Click
        end
        object N81: TMenuItem
          Caption = '8'
          RadioItem = True
          OnClick = N81Click
        end
        object N91: TMenuItem
          Caption = '9'
          RadioItem = True
          OnClick = N91Click
        end
        object N101: TMenuItem
          Caption = '10'
          RadioItem = True
          OnClick = N101Click
        end
      end
    end
    object Optionen1: TMenuItem
      Caption = 'Optionen'
      object Datenbankwhlen1: TMenuItem
        Caption = 'Datenbank w'#228'hlen'
        OnClick = Datenbankwhlen1Click
      end
    end
    object Hilfe1: TMenuItem
      Caption = 'Hilfe'
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'tgit - SQLite Database|*.db'
    Left = 568
  end
end
