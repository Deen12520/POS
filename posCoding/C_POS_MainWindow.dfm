object W_POS_MainWindow: TW_POS_MainWindow
  Left = 11
  Top = 115
  Width = 930
  Height = 605
  Caption = 'POS'#25910#38134#20027#30028#38754
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnl7: TPanel
    Left = 32
    Top = 16
    Width = 841
    Height = 537
    Caption = 'pnl7'
    TabOrder = 0
    object pnl1: TPanel
      Left = 8
      Top = 8
      Width = 817
      Height = 41
      Caption = 'pnl1'
      TabOrder = 0
      object lbl1: TLabel
        Left = 48
        Top = 16
        Width = 273
        Height = 13
        AutoSize = False
        Caption = 'logo'#22909#20048#21830#36152#36830#38145#26377#38480#20844#21496#20415#21033#24215#31649#29702#31995#32479
      end
      object lbl4: TLabel
        Left = 640
        Top = 8
        Width = 16
        Height = 13
        Caption = 'lbl4'
      end
      object lbl5: TLabel
        Left = 368
        Top = 16
        Width = 57
        Height = 13
        AutoSize = False
        Caption = #25910#38134#21592' '#65306' '
      end
      object lbl6: TLabel
        Left = 432
        Top = 16
        Width = 73
        Height = 13
        Caption = 'lbl6'
      end
    end
    object pnl2: TPanel
      Left = 8
      Top = 56
      Width = 553
      Height = 249
      Caption = 'pnl2'
      TabOrder = 1
      object dbgrd1: TDBGrid
        Left = 8
        Top = 16
        Width = 529
        Height = 177
        DataSource = UniDataSource1
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDrawColumnCell = dbgrd1DrawColumnCell
        Columns = <
          item
            Expanded = False
            FieldName = #24207#21495
            Width = 49
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'commodity_id'
            Width = 112
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'commodity_name'
            Width = 144
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'sale_price'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'sale_count'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'sale_total'
            Visible = True
          end>
      end
    end
    object pnl3: TPanel
      Left = 568
      Top = 56
      Width = 257
      Height = 249
      Caption = 'pnl3'
      TabOrder = 2
      object lbl3: TLabel
        Left = 16
        Top = 16
        Width = 65
        Height = 13
        AutoSize = False
        Caption = #39044#35774#21830#21697
      end
      object dbgrdYSSP: TDBGrid
        Left = 8
        Top = 40
        Width = 241
        Height = 193
        DataSource = ds1
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = #24207#21495
            Width = 46
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'short_code'
            Width = 56
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'commodity_id'
            Width = 120
            Visible = True
          end>
      end
    end
    object pnl4: TPanel
      Left = 8
      Top = 312
      Width = 553
      Height = 209
      Caption = 'pnl4'
      TabOrder = 3
      object lbl2: TLabel
        Left = 24
        Top = 184
        Width = 105
        Height = 13
        AutoSize = False
        Caption = #25552#31034#20449#24687#65306
      end
      object lbl15: TLabel
        Left = 168
        Top = 184
        Width = 233
        Height = 13
        AutoSize = False
        Caption = 'lbl15'
      end
      object pnl5: TPanel
        Left = 8
        Top = 8
        Width = 329
        Height = 161
        TabOrder = 0
        object lbl11: TLabel
          Left = 14
          Top = 8
          Width = 65
          Height = 25
          AutoSize = False
          Caption = #20250#21592#20449#24687
        end
        object lbl12: TLabel
          Left = 8
          Top = 40
          Width = 65
          Height = 13
          AutoSize = False
          Caption = ' '#20250' '#21592' '#21495' '#65306
        end
        object lbl13: TLabel
          Left = 8
          Top = 72
          Width = 60
          Height = 13
          AutoSize = False
          Caption = #20250#21592#31215#20998#65306
        end
        object lbl14: TLabel
          Left = 8
          Top = 104
          Width = 60
          Height = 13
          Caption = #38646#38065#24635#39069#65306
        end
        object lblHYH: TLabel
          Left = 80
          Top = 40
          Width = 3
          Height = 13
        end
        object lblHYJF: TLabel
          Left = 83
          Top = 72
          Width = 3
          Height = 13
        end
        object lblLQZE: TLabel
          Left = 83
          Top = 104
          Width = 3
          Height = 13
        end
      end
      object pnl6: TPanel
        Left = 344
        Top = 8
        Width = 201
        Height = 161
        TabOrder = 1
        object lbl7: TLabel
          Left = 16
          Top = 24
          Width = 57
          Height = 25
          AutoSize = False
          Caption = #25968#37327#65306
        end
        object lbl8: TLabel
          Left = 72
          Top = 24
          Width = 89
          Height = 33
          AutoSize = False
          Caption = '0.00'
        end
        object lbl9: TLabel
          Left = 16
          Top = 88
          Width = 73
          Height = 33
          AutoSize = False
          Caption = #21512#35745#37329#39069' '#65306
        end
        object lbl10: TLabel
          Left = 94
          Top = 88
          Width = 81
          Height = 33
          AutoSize = False
          Caption = '0.00'
        end
      end
    end
    object pnl8: TPanel
      Left = 568
      Top = 344
      Width = 257
      Height = 177
      Caption = 'pnl8'
      TabOrder = 4
      object btn1: TButton
        Left = 8
        Top = 6
        Width = 75
        Height = 49
        Caption = #25968#37327'  *'
        TabOrder = 0
        OnClick = btn1Click
      end
      object btn2: TButton
        Left = 8
        Top = 59
        Width = 75
        Height = 49
        Caption = #21024#38500' D'
        TabOrder = 1
        OnClick = btn2Click
      end
      object btn3: TButton
        Left = 8
        Top = 112
        Width = 75
        Height = 49
        Caption = #20854#20182' Z'
        TabOrder = 2
        OnClick = btn3Click
      end
      object btn7: TButton
        Left = 167
        Top = 7
        Width = 84
        Height = 154
        Caption = #32467#31639' +'
        TabOrder = 3
        OnClick = btn7Click
      end
    end
    object edt1: TEdit
      Left = 569
      Top = 306
      Width = 255
      Height = 41
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Text = 'edt1'
      OnKeyDown = edt1KeyDown
      OnKeyPress = edt1KeyPress
    end
  end
  object btn4: TButton
    Left = 689
    Top = 366
    Width = 75
    Height = 49
    Caption = #20250#21592' V'
    TabOrder = 1
    OnClick = btn4Click
  end
  object btn5: TButton
    Left = 689
    Top = 419
    Width = 75
    Height = 49
    Caption = #25346#21333' G'
    TabOrder = 2
    OnClick = btn5Click
  end
  object btn6: TButton
    Left = 689
    Top = 472
    Width = 75
    Height = 49
    Caption = #36864#20986' Q'
    TabOrder = 3
    OnClick = btn6Click
  end
  object mscmIC1: TMSComm
    Left = 880
    Top = 0
    Width = 32
    Height = 32
    ControlData = {
      2143341208000000ED030000ED03000001568A64000006000000010000040000
      00020100802500000000080000000000000000003F00000001000000}
  end
  object UniDataSource1: TUniDataSource
    DataSet = UniQuery1
    Left = 8
    Top = 80
  end
  object UniQuery1: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    SQL.Strings = (
      'select * from t_bi_saledealdetail;')
    Left = 8
    Top = 40
    object intgrfldUniQuery1Xuhao: TIntegerField
      FieldKind = fkCalculated
      FieldName = #24207#21495
      OnGetText = intgrfldUniQuery1XuhaoGetText
      Calculated = True
    end
    object strngfldUniQuery1commodity_id: TStringField
      DisplayLabel = #21830#21697#32534#21495
      FieldName = 'commodity_id'
    end
    object strngfldUniQuery1commodity_name: TStringField
      DisplayLabel = #21830#21697#21517#31216
      FieldName = 'commodity_name'
      Size = 50
    end
    object fltfldUniQuery1sale_price: TFloatField
      DisplayLabel = #21806#20215
      FieldName = 'sale_price'
    end
    object fltfldUniQuery1sale_count: TFloatField
      DisplayLabel = #25968#37327
      FieldName = 'sale_count'
    end
    object fltfldUniQuery1sale_total: TFloatField
      DisplayLabel = #23567#35745#37329#39069
      FieldName = 'sale_total'
    end
    object strngfldUniQuery1tran_seri_num: TStringField
      FieldName = 'tran_seri_num'
    end
    object intgrfldUniQuery1row_id: TIntegerField
      FieldName = 'row_id'
    end
  end
  object unqryedit1: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    SQL.Strings = (
      '')
    Left = 8
    Top = 144
  end
  object unqryeditCX: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    SQL.Strings = (
      '')
    Left = 8
    Top = 208
  end
  object unqryeditTJ: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    Left = 8
    Top = 256
  end
  object unqryeditVip: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    SQL.Strings = (
      'select * from t_mem_membaseinfo')
    Left = 8
    Top = 296
  end
  object uniqueryYSSP: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    SQL.Strings = (
      'SELECT * from t_bi_shortcode;')
    Left = 880
    Top = 56
    object intgrfldYSSP_XH: TIntegerField
      FieldKind = fkCalculated
      FieldName = #24207#21495
      OnGetText = intgrfldYSSP_XHGetText
      Calculated = True
    end
    object strngfldYSSPshort_code: TStringField
      DisplayLabel = #30701#30721
      FieldName = 'short_code'
    end
    object strngfldYSSPcommodity_id: TStringField
      DisplayLabel = #21830#21697#32534#30721#13#10
      FieldName = 'commodity_id'
    end
  end
  object ds1: TUniDataSource
    DataSet = uniqueryYSSP
    Left = 880
    Top = 96
  end
end
