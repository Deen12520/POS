object W_POS_OtherPayWayForm: TW_POS_OtherPayWayForm
  Left = 24
  Top = 189
  Width = 393
  Height = 214
  Caption = #20854#20182#20184#27454#26041#24335
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 16
    Top = 36
    Width = 129
    Height = 41
    AutoSize = False
    Caption = #20184#27454#26041#24335#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object cbb1: TComboBox
    Left = 160
    Top = 40
    Width = 185
    Height = 21
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = #20154#27665#24065#25903#31080
    Items.Strings = (
      #20154#27665#24065#25903#31080
      #25903#20184#23453)
  end
  object btn1: TBitBtn
    Left = 64
    Top = 120
    Width = 75
    Height = 25
    Caption = #30830#23450'(D)'
    TabOrder = 1
    OnClick = btn1Click
  end
  object btn2: TBitBtn
    Left = 208
    Top = 120
    Width = 75
    Height = 25
    Caption = #36864#20986'(ESC'#65289
    TabOrder = 2
    OnClick = btn2Click
  end
end
