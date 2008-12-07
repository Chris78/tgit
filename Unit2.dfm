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
    Visible = False
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
    Visible = False
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
    OnClick = chkMatchAllClick
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
    Visible = False
  end
  object Button2: TButton
    Left = 64
    Top = 0
    Width = 75
    Height = 25
    Caption = 'Test Hashes'
    TabOrder = 4
    Visible = False
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 144
    Top = 0
    Width = 105
    Height = 25
    Caption = 'Test Fileinfo Model'
    TabOrder = 5
    Visible = False
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
      object btnAbort: TSpeedButton
        Left = 203
        Top = 654
        Width = 24
        Height = 22
        Hint = 'Einladen weiterer Dateien abbrechen'
        Anchors = [akRight, akBottom]
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000FF0000FF0000FF0000FF00
          00FF0000FF0000FF0000FF0000FF0000FF000000000000000000000000000000
          0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
          FF0000000000000000000000000000000000000000FF0000FF0000FF0000FF00
          00FF0000FF0000FF0000FF0000FF0000FF000000000000000000000000000000
          0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
          FF0000000000000000000000000000000000000000FF0000FF0000FF0000FF00
          00FF0000FF0000FF0000FF0000FF0000FF000000000000000000000000000000
          0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
          FF0000000000000000000000000000000000000000FF0000FF0000FF0000FF00
          00FF0000FF0000FF0000FF0000FF0000FF000000000000000000000000000000
          0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
          FF0000000000000000000000000000000000000000FF0000FF0000FF0000FF00
          00FF0000FF0000FF0000FF0000FF0000FF000000000000000000000000000000
          0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
          FF00000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        OnClick = btnAbortClick
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
    Visible = False
  end
  object btnCreateAllThumbs: TButton
    Left = 8
    Top = 821
    Width = 105
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'create all Thumbs'
    TabOrder = 8
    Visible = False
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
    Visible = False
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
    Visible = False
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
    Visible = False
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
      object bearbeiten1: TMenuItem
        Caption = 'bearbeiten'
        OnClick = bearbeiten1Click
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
          Enabled = False
        end
        object nachLocation1: TMenuItem
          Caption = 'nach Location'
          Enabled = False
        end
        object nachFilter1: TMenuItem
          Caption = 'nach Filter'
          Enabled = False
        end
      end
      object Filtersuche1: TMenuItem
        Caption = 'taggen'
        object Zufallsmodus1: TMenuItem
          Caption = 'Zufallsmodus'
          Enabled = False
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
      object hmmja1: TMenuItem
        Caption = #228'hmm... ja...'
        Enabled = False
      end
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
        36050000424D3605000000000000360400002800000010000000100000000100
        0800000000000001000000000000000000000001000000000000F9F9F900122B
        D5005C66B600F2F2FC00102CD7001C32CE005F64A2008387B3007184F700BEBF
        DE008587B1006B7DF200BCBEDD001B35E7004B5BD700E8E8E900112DDC00485D
        F7001932E0002A3ABA00324CDE00F7F7FD00DADBFA00D0D1EA007888ED00E3E3
        E400F2F2F3001831D300172FE4009EA0BE00021CCF00404CC100969DDF002537
        CB00D0D0D300F3F4FC002437C400F5F5FD00878BBA00FEFEFE00E0E0E2007275
        D2009899B3006772E7009799B100E8E9FA00C0C0C600CFD2F4006B6FA2007D85
        E900EEEEF000464EA1004D50B800BEBED3002844F3004B53AD00B2B3CB003C55
        E800374AD6002C3FC7002E40CD00E6E7F900D4D6F800001CD700031AC1001430
        D4001C31CA00BEC3E700081FBF006D7BF500F1F2FD006F76BB00CCD1F600B8B9
        C600FAFAFB00C3C3C800DCDEFA00F0F0F100DFE0EF00EDEDFC008490EE00B5B9
        F8008B9BFD00B3B6E9008F91B1000820C9006A78E2002E46DB00A5A8C200B9BD
        F7009699BD008292F0009CA0EC001933DB00F5F5F5004658D800071DC300D7D7
        DD00EEEFFC002938AF00E3E3E6003540B200FCFCFC00BFBFC700A3ACF100E3E4
        ED004F63F100B2B4F700D9D9F700767EC400BFBFC9005D62A400DEDDDF00F8F8
        FA00DDDDDF00B4B7E0005B6BE400FBFCFF00787FB6004755C700C4C4CE00A4A4
        B6006776EB00F1F1F3002038EA00FFFFFF000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000000000007D692C287D7D
        7D7D7D7D7D7D7D7D7D7D716D116F7D7D7D7D7D7D7D7D1A0F7D7D2D7A3924727D
        7D7D7D7D7D7D0A6E7D7D032B1405677D7D7D7D7D7D7834327D7D7D5C575D0666
        7D7D7D7D7D1F267D7D7D7D25564142797D7D7D7D763C7B7D7D7D7D7D3D5F0413
        227D7D5A7C587D7D7D7D7D7D7D6C3A1037701D0D027D7D7D7D7D7D7D7D7D160E
        1B65013B7D7D7D7D7D7D7D7D7D7D7D09441E40387D7D7D7D7D7D7D7D7D4D5421
        3F556033197D7D7D7D7D7D7D49476A361273531C632E7D7D7D7D610750520874
        0C7D7D7D45772A007D7D430B185B204E7D7D7D7D7D7D31307D7D7548682F277D
        7D7D7D7D7D7D625129357D464C237D7D7D7D7D7D7D7D7D4F6B17}
      Caption = 'Datei aus der Datenbank entfernen'
      OnClick = DateiausderDatenbankentfernen1Click
    end
  end
end
