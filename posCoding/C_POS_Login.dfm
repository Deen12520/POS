object W_POS_LoginForm: TW_POS_LoginForm
  Left = 824
  Top = 189
  Width = 500
  Height = 354
  Caption = #30331#38470
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl2: TLabel
    Left = 89
    Top = 104
    Width = 104
    Height = 29
    AutoSize = False
    Caption = #29992#25143#21517#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbl3: TLabel
    Left = 88
    Top = 168
    Width = 85
    Height = 24
    Caption = #23494'     '#30721#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object pnl1: TPanel
    Left = 8
    Top = -1
    Width = 473
    Height = 59
    Caption = 'pnl1'
    TabOrder = 0
    object lbl1: TLabel
      Left = 184
      Top = 16
      Width = 145
      Height = 41
      AutoSize = False
      Caption = 'POS'#30331#38470
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object edt1: TEdit
    Left = 192
    Top = 96
    Width = 233
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Text = 'edt1'
  end
  object edt2: TEdit
    Left = 192
    Top = 160
    Width = 233
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 2
    Text = 'edt2'
  end
  object btnQD: TBitBtn
    Left = 190
    Top = 240
    Width = 100
    Height = 39
    Caption = #30830#23450
    Default = True
    TabOrder = 3
    OnClick = btnQDClick
  end
  object btnQX: TBitBtn
    Left = 318
    Top = 240
    Width = 100
    Height = 39
    Cancel = True
    Caption = #21462#28040
    TabOrder = 4
    OnClick = btnQXClick
  end
  object uniqueryP_login: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    Left = 440
    Top = 72
  end
end
