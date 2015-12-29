object W_POS_CashBox: TW_POS_CashBox
  Left = 687
  Top = 192
  Width = 522
  Height = 270
  Caption = #24320#38065#31665
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
  object lblWarn: TLabel
    Left = 56
    Top = 56
    Width = 145
    Height = 25
    AutoSize = False
    Caption = #35831#36755#20837#23494#30721#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object edtPass: TEdit
    Left = 56
    Top = 96
    Width = 361
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 104
    Top = 168
    Width = 89
    Height = 25
    Caption = #30830#23450#65288'Enter'#65289
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnESC: TButton
    Left = 280
    Top = 168
    Width = 75
    Height = 25
    Caption = #21462#28040#65288'ESC'#65289
    TabOrder = 2
    OnClick = btnESCClick
  end
  object unqryPass: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    SQL.Strings = (
      'select * from t_cmp_employee;')
    Left = 288
    Top = 48
  end
  object dsPass: TUniDataSource
    DataSet = unqryPass
    Left = 336
    Top = 48
  end
end
