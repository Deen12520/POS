object W_POS_SaleCheckForm: TW_POS_SaleCheckForm
  Left = 34
  Top = 122
  Width = 527
  Height = 331
  Caption = #25910#38134#23545#36134
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblCashier: TLabel
    Left = 56
    Top = 32
    Width = 59
    Height = 13
    AutoSize = False
    Caption = #25910#38134#21592'ID'#65306
  end
  object lblCashierId: TLabel
    Left = 128
    Top = 32
    Width = 65
    Height = 13
    AutoSize = False
    Caption = 'lblCashierId'
  end
  object lblSTime: TLabel
    Left = 264
    Top = 32
    Width = 60
    Height = 13
    AutoSize = False
    Caption = #20132#26131#26085#26399#65306
  end
  object lblSDate: TLabel
    Left = 336
    Top = 32
    Width = 97
    Height = 13
    AutoSize = False
    Caption = 'lblSDate'
  end
  object lblRMB: TLabel
    Left = 24
    Top = 80
    Width = 49
    Height = 13
    AutoSize = False
    Caption = ' '#29616'    '#37329#65306
  end
  object lblBank: TLabel
    Left = 24
    Top = 112
    Width = 49
    Height = 13
    AutoSize = False
    Caption = #38134#34892#21345#65306
  end
  object lblCZK: TLabel
    Left = 24
    Top = 144
    Width = 49
    Height = 13
    AutoSize = False
    Caption = #20648#20540#21345#65306
  end
  object lblGWQ: TLabel
    Left = 24
    Top = 176
    Width = 49
    Height = 13
    AutoSize = False
    Caption = #36141#29289#21048#65306
  end
  object lblTotal: TLabel
    Left = 24
    Top = 208
    Width = 49
    Height = 13
    AutoSize = False
    Caption = ' '#24635'    '#35745#65306
  end
  object btnOK: TButton
    Left = 96
    Top = 248
    Width = 81
    Height = 25
    Caption = #30830#35748#65288'&D'#65289
    TabOrder = 0
    OnClick = btnOKClick
  end
  object edtRMB: TEdit
    Left = 88
    Top = 72
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '0'
    OnKeyDown = edtRMBKeyDown
    OnKeyPress = edtRMBKeyPress
  end
  object edtBank: TEdit
    Left = 88
    Top = 104
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '0'
    OnKeyDown = edtBankKeyDown
    OnKeyPress = edtBankKeyPress
  end
  object edtCZK: TEdit
    Left = 88
    Top = 136
    Width = 121
    Height = 21
    TabOrder = 3
    Text = '0'
    OnKeyDown = edtCZKKeyDown
    OnKeyPress = edtCZKKeyPress
  end
  object edtGWQ: TEdit
    Left = 88
    Top = 168
    Width = 121
    Height = 21
    TabOrder = 4
    Text = '0'
    OnKeyDown = edtGWQKeyDown
    OnKeyPress = edtGWQKeyPress
  end
  object edtTotal: TEdit
    Left = 88
    Top = 200
    Width = 121
    Height = 21
    TabOrder = 5
    Text = '0'
  end
  object pnlPMoney: TPanel
    Left = 264
    Top = 64
    Width = 225
    Height = 169
    TabOrder = 6
    Visible = False
    object lblPTotal: TLabel
      Left = 16
      Top = 140
      Width = 49
      Height = 13
      AutoSize = False
      Caption = ' '#24635'    '#35745#65306
    end
    object lbl_PTotal: TLabel
      Left = 73
      Top = 139
      Width = 118
      Height = 20
      AutoSize = False
      Caption = 'lbl_PTotal'
    end
    object dbgrdPMoney: TDBGrid
      Left = 16
      Top = 16
      Width = 201
      Height = 112
      DataSource = dsSaleCheck
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
  end
  object btnESC: TButton
    Left = 312
    Top = 248
    Width = 75
    Height = 25
    Cancel = True
    Caption = #36864#20986#65288'ESC'#65289
    TabOrder = 7
    OnClick = btnESCClick
  end
  object unqrySaleCheck: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    SQL.Strings = (
      'select * from t_bi_storeturnwork,t_dealpaydetail;')
    Left = 224
    Top = 80
  end
  object dsSaleCheck: TUniDataSource
    DataSet = unqrySaleCheck
    Left = 224
    Top = 136
  end
  object unqrySelect: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    Left = 224
    Top = 184
  end
end
