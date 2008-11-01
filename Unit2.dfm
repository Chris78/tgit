object Form1: TForm1
  Left = 59
  Top = 78
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
    Top = 784
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
    Left = 424
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
    Width = 793
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
    Top = 800
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
    Top = 56
    Width = 729
    Height = 689
    Anchors = [akLeft, akTop, akBottom]
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
      Height = 681
      Align = alClient
      TabOrder = 0
      Visible = False
      object StringGrid2: TStringGrid
        Left = 1
        Top = 1
        Width = 700
        Height = 679
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
      Height = 681
      Align = alClient
      TabOrder = 1
      DesignSize = (
        702
        681)
      object ButtonBack: TButton
        Left = 240
        Top = 648
        Width = 89
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Seite zur'#252'ck'
        Enabled = False
        TabOrder = 0
        OnClick = ButtonBackClick
      end
      object ButtonNext: TButton
        Left = 360
        Top = 648
        Width = 89
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Seite vor'
        TabOrder = 1
        OnClick = ButtonNextClick
      end
      object PanelPreviews: TPanel
        Left = -1
        Top = 0
        Width = 710
        Height = 643
        Anchors = [akLeft, akTop, akBottom]
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
  object PopupPreview: TPopupMenu
    Left = 680
    Top = 64
    object Schlagwortendern1: TMenuItem
      Caption = 'Schlagworte '#228'ndern'
    end
    object Dateiffnen1: TMenuItem
      Caption = 'Datei '#246'ffnen'
      OnClick = Dateiffnen1Click
    end
    object EnthaltendenOrdnerffnen1: TMenuItem
      Caption = 'Enthaltenden Ordner '#246'ffnen'
      OnClick = EnthaltendenOrdnerffnen1Click
    end
    object Bilddrehen1: TMenuItem
      Caption = 'Bild drehen'
      object N90rechts1: TMenuItem
        Caption = '90'#176' rechts'
        OnClick = N90rechts1Click
      end
      object N90links1: TMenuItem
        Caption = '90'#176' links'
        OnClick = N90links1Click
      end
      object N1801: TMenuItem
        Caption = '180'#176
        OnClick = N1801Click
      end
    end
    object DateiausderDatenbankentfernen1: TMenuItem
      Bitmap.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000130B0000130B00000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000D02028F01015D00000000
        000000000000000000000001016402028B000009000000000000000000000000
        0000000000000101480404FA01013900000000000000000001013B0404EA0101
        3C0000000000000000000000000000000000000000000000000202940303D600
        00110000000000160404DC020288000000000000000000000000000000000000
        0000000000000000000000090303C00303B10000030303BB0303B60000070000
        0000000000000000000000000000000000000000000000000000000001012104
        04F60303B80404EF00001D000000000000000000000000000000000000000000
        0000000000000000000000000000000202710404FC0202640000000000000000
        0000000000000000000000000000000000000000000000000000000000000B04
        04E20303CA0303D7000009000000000000000000000000000000000000000000
        0000000000000000000000000303B70303BD0000110303C40303AB0000000000
        0000000000000000000000000000000000000000000000000002026B0404E401
        012500000001012E0404E701015F000000000000000000000000000000000000
        0000000000000101380404DF0101430000000000000000000101670404DB0101
        3100000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      Caption = 'Datei aus der Datenbank entfernen'
    end
  end
end
