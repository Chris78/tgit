object FrmMain: TFrmMain
  Left = 480
  Top = 0
  Caption = 'Tgit GUI'
  ClientHeight = 939
  ClientWidth = 1139
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001001800680300001600000028000000100000002000
    000001001800000000000000000048000000480000000000000000000000C1BC
    A7E9E2C9F8EDCEFAECC8FCEEC7FCEFC7FCEEC7FBEEC8FBEEC8FBEEC8FBEEC8FB
    EEC8FBEEC8FBEEC8FBEEC8FBEEC87C7868665F4CCEC4ABF8EDCBFAEEC8FAEFC7
    FAEFC7FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8C5BE
    A4312B14918A72F9EBCBFEEEC7FDEDC8FBEDC9FBEEC8FBEEC8FBEEC8FBEEC8FB
    EEC8FBEEC8FBEEC8FBEEC8FBEEC8F3E9CE5C5540D3CBB5FBECCDFFEDC6FEEEC8
    FBEEC9FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8EFE4
    CA615845847B69F9E8CEFFEDC8FDEFC6FAEEC8FBEEC8FBEEC8FBEEC8FBEEC8FB
    EEC8FBEEC8FBEEC8FBEEC8FBEEC8F3E7CD5E54445A4E41ECDAC6FFEDCBFAEEC5
    F9EFC7FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8F8EB
    CD62564555473FCCB9ABFAE8CBF8EEC8F8EFC8FBEEC8FBEEC8FBEEC8FBEEC8FB
    EEC8FBEEC8FBEEC8FBEEC8FBEEC8F8EDC9998D7B47373286716AE2CFBAF9EDCB
    F7EEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FBEEC8FAF0
    C7D5CAB442322D57413DA99686EADCC0F6EBC8FBEDC9FBEDC9FCEEC8FCEEC8FC
    EEC8FBEEC8FBEEC8FCEEC8FBEEC8F8F0C4F5ECCB675B4E4733375A3F44997C74
    D8C2AEDCCDB6E0CFB5A08C70DBC9AAFAEBCBFAEECDFBEBC9FBEBC9FCEDCAFAF0
    C8F6EEC8BFB6A0332422493338593E3C5E4B3FA69E8CDBD2BFC0B49E67593FBA
    AE93EBE1C5F8E9CCF4E4C9EDDDC4F9EDC7F8F0C8EEE9C7655C4D302220463436
    503C3A533F386E5851A188806E554B523A2E5F483A6C5A49715F4F796758FDED
    CDF9F0C5F4F1C5CDCAAE362E262A1E223D292E4B2D3355353D55343C55343B56
    34385131314C353248362ECDBDAFFDECCBFAEFC5F6F1C4F0EDCD7A746727201D
    261E1E271E202B2127342933392D3633262B332526301E1A827167F7E9D3FDED
    CAFAEFC6F7EFC6F4ECCD8B85742D281B2B2B1B23281B1E241B1C211E1C201C21
    221A2D2B1D958876EADDC4F7EDC9FBEDCAFBEFC7F9EFC7DED3B7493F2D928D79
    D6D2B7D9D2B7A39D88827B6C847C6DBEB49FE0D3B8F6EBC9F6EEC6F5EFC20000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesigned
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  DesignSize = (
    1139
    939)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 877
    Width = 32
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Label1'
    ExplicitTop = 782
  end
  object lblLimitTags: TLabel
    Left = 606
    Top = 3
    Width = 51
    Height = 13
    Caption = 'Limit Tags:'
  end
  object lblFilterTags: TLabel
    Left = 608
    Top = 29
    Width = 52
    Height = 13
    Caption = 'Filter Tags:'
  end
  object Label4: TLabel
    Left = 16
    Top = 696
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Image1: TImage
    Left = 332
    Top = 748
    Width = 228
    Height = 145
    Anchors = [akLeft, akBottom]
    Center = True
    Proportional = True
    Stretch = True
    Transparent = True
    ExplicitTop = 691
  end
  object TagCloud: TGroupBox
    Left = 588
    Top = 48
    Width = 541
    Height = 770
    Anchors = [akTop, akRight]
    Caption = 'TagCloud'
    Constraints.MinHeight = 300
    Constraints.MinWidth = 400
    TabOrder = 0
  end
  object chkMatchAll: TCheckBox
    Left = 975
    Top = 29
    Width = 73
    Height = 18
    Caption = 'match all?'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object TrackBar1: TTrackBar
    Left = 664
    Top = -2
    Width = 333
    Height = 25
    Max = 30
    Min = 1
    Position = 15
    TabOrder = 2
    OnChange = TrackBar1Change
  end
  object edtQuery: TEdit
    Left = 8
    Top = 898
    Width = 569
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 3
    Text = 'edtQuery'
  end
  object Button2: TButton
    Left = 64
    Top = 0
    Width = 75
    Height = 25
    Caption = 'Test Hashes'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 144
    Top = 0
    Width = 105
    Height = 25
    Caption = 'Test Fileinfo Model'
    TabOrder = 5
    OnClick = Button3Click
  end
  object TabControl1: TTabControl
    Left = 8
    Top = 53
    Width = 569
    Height = 693
    Margins.Bottom = 200
    Anchors = [akLeft, akTop, akBottom]
    Constraints.MinHeight = 300
    Constraints.MinWidth = 400
    MultiLine = True
    TabOrder = 6
    TabPosition = tpRight
    Tabs.Strings = (
      'Fileinfos'
      'Previews')
    TabIndex = 1
    OnChange = TabControl1Change
    object PanelTab1: TPanel
      Left = 4
      Top = 4
      Width = 542
      Height = 685
      Align = alClient
      TabOrder = 0
      Visible = False
      object StringGrid2: TStringGrid
        Left = 1
        Top = 1
        Width = 540
        Height = 683
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
      Width = 542
      Height = 685
      Align = alClient
      TabOrder = 1
      DesignSize = (
        542
        685)
      object lblPageXOfY: TLabel
        Left = 232
        Top = 659
        Width = 82
        Height = 13
        Anchors = [akRight, akBottom]
        AutoSize = False
        Caption = 'Seite 0 / 0'
        ExplicitTop = 603
      end
      object ButtonBack: TButton
        Left = 320
        Top = 652
        Width = 89
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Seite zur'#252'ck'
        Enabled = False
        TabOrder = 0
        OnClick = ButtonBackClick
      end
      object ButtonNext: TButton
        Left = 424
        Top = 652
        Width = 89
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Seite vor'
        TabOrder = 1
        OnClick = ButtonNextClick
      end
      object PanelPreviews: TPanel
        Left = 1
        Top = 1
        Width = 540
        Height = 647
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
      end
      object ChkShowAccessablesOnly: TCheckBox
        Left = 8
        Top = 657
        Width = 177
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'nur zugreifbare Dateien anzeigen'
        TabOrder = 3
      end
    end
  end
  object Button4: TButton
    Left = 256
    Top = 0
    Width = 89
    Height = 25
    Caption = 'Test JPGThumb'
    TabOrder = 7
  end
  object btnCreateAllThumbs: TButton
    Left = 8
    Top = 821
    Width = 105
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'create all Thumbs'
    TabOrder = 8
    OnClick = btnCreateAllThumbsClick
  end
  object ProgressThumbCreate: TProgressBar
    Left = 8
    Top = 853
    Width = 105
    Height = 16
    Anchors = [akLeft, akBottom]
    Step = 1
    TabOrder = 9
  end
  object edtTagFilter: TEdit
    Left = 671
    Top = 26
    Width = 289
    Height = 21
    TabOrder = 10
    OnChange = edtTagFilterChange
    OnKeyPress = edtTagFilterKeyPress
  end
  object Button6: TButton
    Left = 352
    Top = 0
    Width = 75
    Height = 25
    Caption = 'Drives?'
    TabOrder = 11
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 119
    Top = 821
    Width = 89
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Fileinfo.CDROM'
    TabOrder = 12
    OnClick = Button7Click
  end
  object DCP_sha256: TDCP_sha256
    Id = 28
    Algorithm = 'SHA256'
    HashSize = 256
    Left = 32
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
        OnClick = hinzufgen2Click
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
      object zurErstenSeite: TMenuItem
        Caption = 'zur ersten Seite'
        OnClick = zurErstenSeiteClick
      end
      object zurletztenSeite: TMenuItem
        Caption = 'zur letzten Seite'
        OnClick = zurletztenSeiteClick
      end
    end
    object Optionen1: TMenuItem
      Caption = 'Optionen'
      object Datenbankwhlen1: TMenuItem
        Caption = 'Datenbank w'#228'hlen'
        OnClick = Datenbankwhlen1Click
      end
      object humbDBwhlen1: TMenuItem
        Caption = 'Thumbnail DB w'#228'hlen'
        OnClick = humbDBwhlen1Click
      end
      object CDROMwhlen1: TMenuItem
        Caption = 'CD ROM w'#228'hlen (f'#252'r "CD Locations")'
      end
      object LaufwerksbuchstabefrUSBGerte1: TMenuItem
        Caption = 'Laufwerksbuchstabe f'#252'r USB Ger'#228'te'
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
    OnPopup = PopupPreviewPopup
    Left = 536
    object Schlagwortendern1: TMenuItem
      Caption = 'Schlagworte bearbeiten'
      OnClick = Schlagwortendern1Click
    end
    object Schlagwortentfernen1: TMenuItem
      Caption = 'Schlagwort entfernen'
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
      OnClick = DateiausderDatenbankentfernen1Click
    end
  end
end
