object W_MD_ReturnForm: TW_MD_ReturnForm
  Left = 123
  Top = 62
  Width = 680
  Height = 667
  Caption = #36864#36135
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
  object lblTranNum: TLabel
    Left = 24
    Top = 91
    Width = 41
    Height = 15
    AutoSize = False
    Caption = #21333#21495#65306
  end
  object lblPOSID: TLabel
    Left = 216
    Top = 91
    Width = 57
    Height = 15
    AutoSize = False
    Caption = 'POS'#26426#21495#65306
  end
  object lblCashID: TLabel
    Left = 440
    Top = 91
    Width = 49
    Height = 15
    AutoSize = False
    Caption = #25910#38134#21592#65306
  end
  object lblTranTime: TLabel
    Left = 424
    Top = 115
    Width = 65
    Height = 15
    AutoSize = False
    Caption = #20132#26131#26102#38388#65306
  end
  object lblTotal: TLabel
    Left = 232
    Top = 115
    Width = 36
    Height = 13
    Caption = #24635#35745#65306
  end
  object lblCash: TLabel
    Left = 23
    Top = 115
    Width = 36
    Height = 13
    Caption = #29616#37329#65306
  end
  object lblCommId: TLabel
    Left = 34
    Top = 27
    Width = 121
    Height = 19
    AutoSize = False
    Caption = #35831#36755#20837#23567#31080#21333#21495#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbl7: TLabel
    Left = 96
    Top = 592
    Width = 60
    Height = 13
    Caption = #25552#31034#20449#24687#65306
  end
  object lbl8: TLabel
    Left = 168
    Top = 592
    Width = 16
    Height = 13
    Caption = 'lbl8'
  end
  object grp1: TGroupBox
    Left = 16
    Top = 374
    Width = 625
    Height = 203
    Caption = #36864#36135#20449#24687#21015#34920
    TabOrder = 4
    object lbl3: TLabel
      Left = 24
      Top = 176
      Width = 72
      Height = 13
      Caption = #24635#36864#36135#25968#37327#65306
    end
    object lbl4: TLabel
      Left = 112
      Top = 176
      Width = 16
      Height = 13
      Caption = 'lbl4'
    end
    object lbl5: TLabel
      Left = 328
      Top = 176
      Width = 60
      Height = 13
      Caption = #36864#36135#37329#39069#65306
    end
    object lbl6: TLabel
      Left = 424
      Top = 176
      Width = 21
      Height = 13
      Caption = '0.00'
    end
  end
  object edtRetrn: TEdit
    Left = 159
    Top = 19
    Width = 457
    Height = 29
    AutoSize = False
    TabOrder = 0
    Text = #36755#20837#23567#31080#21333#21495
    OnChange = edtRetrnChange
    OnKeyDown = edtRetrnKeyDown
  end
  object btnRetrn_Esc: TBitBtn
    Left = 504
    Top = 582
    Width = 93
    Height = 35
    Caption = #36864#20986#65288'ESC'#65289
    TabOrder = 1
    OnClick = btnRetrn_EscClick
  end
  object dbgrdTH: TDBGrid
    Left = 22
    Top = 394
    Width = 611
    Height = 142
    DataSource = dsFinProRetrn_Detail
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
    ParentShowHint = False
    ReadOnly = True
    ShowHint = False
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = #34892#21495
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'commodity_id'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'commodity_name'
        Width = 206
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
  object btnRetrn: TButton
    Left = 390
    Top = 582
    Width = 93
    Height = 35
    Caption = #36864#36135#65288'T'#65289
    TabOrder = 3
    OnClick = btnRetrnClick
  end
  object grp2: TGroupBox
    Left = 17
    Top = 144
    Width = 624
    Height = 217
    Caption = #20132#26131#20449#24687#34920
    TabOrder = 5
    object lbl1: TLabel
      Left = 17
      Top = 184
      Width = 81
      Height = 17
      AutoSize = False
      Caption = #21830#21697#21517#31216#65306
    end
    object lbl2: TLabel
      Left = 358
      Top = 183
      Width = 68
      Height = 15
      AutoSize = False
      Caption = #36864#36135#25968#37327#65306
    end
    object dbgrdJY: TDBGrid
      Left = 13
      Top = 19
      Width = 604
      Height = 150
      DataSource = dsJY
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
      ParentShowHint = False
      ReadOnly = True
      ShowHint = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDrawColumnCell = dbgrdJYDrawColumnCell
      Columns = <
        item
          Expanded = False
          FieldName = #34892#21495
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'commodity_id'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'commodity_name'
          Width = 192
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
    object edtSPMC: TEdit
      Left = 90
      Top = 181
      Width = 184
      Height = 21
      ReadOnly = True
      TabOrder = 1
      Text = 'edtSPMC'
    end
    object edtTHSL: TEdit
      Left = 432
      Top = 178
      Width = 170
      Height = 21
      TabOrder = 2
      Text = 'edtTHSL'
      OnKeyDown = edtTHSLKeyDown
    end
  end
  object edtDH: TEdit
    Left = 72
    Top = 88
    Width = 121
    Height = 21
    TabOrder = 6
    Text = 'edtDH'
  end
  object edtPOS: TEdit
    Left = 280
    Top = 88
    Width = 121
    Height = 21
    TabOrder = 7
    Text = 'edtPOS'
  end
  object edtSYY: TEdit
    Left = 496
    Top = 88
    Width = 121
    Height = 21
    TabOrder = 8
    Text = 'edtSYY'
  end
  object edtXJ: TEdit
    Left = 71
    Top = 112
    Width = 121
    Height = 21
    TabOrder = 9
    Text = 'edtXJ'
  end
  object edtZJ: TEdit
    Left = 280
    Top = 112
    Width = 121
    Height = 21
    TabOrder = 10
    Text = 'edtZJ'
  end
  object edtJYSJ: TEdit
    Left = 496
    Top = 112
    Width = 121
    Height = 21
    TabOrder = 11
    Text = 'edtJYSJ'
  end
  object uniqueryTH: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    SQL.Strings = (
      'select * from t_bi_saledeal,t_bi_saledealdetail;')
    Left = 8
    Top = 583
    object intgrfldTHField: TIntegerField
      FieldKind = fkCalculated
      FieldName = #34892#21495
      OnGetText = intgrfldTHFieldGetText
      Calculated = True
    end
    object strngfldRetrn_Detailcommodity_id: TStringField
      DisplayLabel = #21830#21697#32534#30721
      FieldName = 'commodity_id'
      ReadOnly = True
    end
    object strngfldRetrn_Detailcommodity_name: TStringField
      DisplayLabel = #21830#21697#21517#31216#13#10
      FieldName = 'commodity_name'
      ReadOnly = True
      Size = 50
    end
    object fltfldRetrn_Detailsale_price: TFloatField
      DisplayLabel = #21806#20215
      FieldName = 'sale_price'
      ReadOnly = True
    end
    object fltfldRetrn_Detailsale_count: TFloatField
      DisplayLabel = #25968#37327
      FieldName = 'sale_count'
      ReadOnly = True
    end
    object fltfldRetrn_Detailsale_total: TFloatField
      DisplayLabel = #23567#35745
      FieldName = 'sale_total'
      ReadOnly = True
    end
  end
  object dsFinProRetrn_Detail: TUniDataSource
    DataSet = uniqueryTH
    Left = 48
    Top = 583
  end
  object unqrySelect: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    SQL.Strings = (
      '')
    Top = 11
  end
  object uniqueryJY: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    SQL.Strings = (
      'select * from t_bi_saledeal,t_bi_saledealdetail;')
    Top = 48
    object intgrflduniquery2HH: TIntegerField
      FieldKind = fkCalculated
      FieldName = #34892#21495
      OnGetText = intgrflduniquery2HHGetText
      Calculated = True
    end
    object strngflduniquery2commodity_id: TStringField
      DisplayLabel = #21830#21697#32534#30721
      FieldName = 'commodity_id'
      ReadOnly = True
    end
    object strngflduniquery2commodity_name: TStringField
      DisplayLabel = #21830#21697#21517#31216#13#10
      FieldName = 'commodity_name'
      ReadOnly = True
      Size = 50
    end
    object fltflduniquery2sale_price: TFloatField
      DisplayLabel = #21806#20215
      FieldName = 'sale_price'
      ReadOnly = True
    end
    object fltflduniquery2sale_count: TFloatField
      DisplayLabel = #25968#37327
      FieldName = 'sale_count'
      ReadOnly = True
    end
    object fltflduniquery2sale_total: TFloatField
      DisplayLabel = #23567#35745
      FieldName = 'sale_total'
      ReadOnly = True
    end
  end
  object dsJY: TUniDataSource
    DataSet = uniqueryJY
    OnDataChange = dsJYDataChange
    Left = 40
    Top = 48
  end
  object uniqueryTJ: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    Left = 48
    Top = 600
  end
end
