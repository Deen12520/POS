object W_POS_SQMaForm: TW_POS_SQMaForm
  Left = 210
  Top = 171
  Width = 461
  Height = 229
  Caption = #25480#26435#30721
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 0
    Top = 168
    Width = 60
    Height = 13
    Caption = #25552#31034#20449#24687#65306
  end
  object lbl2: TLabel
    Left = 72
    Top = 168
    Width = 16
    Height = 13
    Caption = 'lbl2'
  end
  object edtSQM: TEdit
    Left = 56
    Top = 40
    Width = 321
    Height = 40
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = #36755#20837#25480#26435#30721
    OnKeyPress = edtSQMKeyPress
  end
  object btn1: TBitBtn
    Left = 86
    Top = 112
    Width = 93
    Height = 34
    Caption = #30830#23450'(&D)'
    TabOrder = 1
    OnClick = btn1Click
  end
  object btn2: TBitBtn
    Left = 246
    Top = 112
    Width = 93
    Height = 34
    Cancel = True
    Caption = #21462#28040'(ESC)'
    TabOrder = 2
    OnClick = btn2Click
  end
  object uniquerySQMa: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    Left = 400
    Top = 16
  end
end
