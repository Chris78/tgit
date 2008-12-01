object frmEditTags: TfrmEditTags
  Left = 455
  Top = 284
  Caption = 'Schlagworte bearbeiten'
  ClientHeight = 426
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object imgPreview: TImage
    Left = 8
    Top = 56
    Width = 240
    Height = 289
    Center = True
  end
  object btnSaveTags: TButton
    Left = 504
    Top = 399
    Width = 121
    Height = 23
    Caption = 'Schlagworte speichern'
    TabOrder = 0
    OnClick = btnSaveTagsClick
  end
  object pnlCurTags: TPanel
    Left = 264
    Top = 37
    Width = 361
    Height = 353
    TabOrder = 1
  end
  object edtEditTags: TEdit
    Left = 264
    Top = 8
    Width = 267
    Height = 21
    TabOrder = 2
    OnKeyPress = edtEditTagsKeyPress
  end
  object btnAddTag: TButton
    Left = 544
    Top = 7
    Width = 81
    Height = 22
    Caption = 'hinzuf'#252'gen'
    TabOrder = 3
    OnClick = btnAddTagClick
  end
end
