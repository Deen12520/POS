object W_MD_SPFinForm: TW_MD_SPFinForm
  Left = 38
  Top = 184
  Width = 1040
  Height = 473
  Caption = #21830#21697#26597#35810
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
  object edtSPFin: TEdit
    Left = 12
    Top = 32
    Width = 657
    Height = 33
    AutoSize = False
    TabOrder = 0
    Text = #35831#36755#20837#20851#38190#23383#65306#21830#21697#32534#30721#12289#21830#21697#21517#31216#12289#21830#21697#26465#30721#12289#21830#21697#21161#35760#30721#12289#21830#21697#33258#32534#30721
    OnChange = edtSPFinChange
    OnKeyDown = edtSPFinKeyDown
  end
  object btnSPF_Fin: TButton
    Left = 724
    Top = 32
    Width = 89
    Height = 33
    Caption = #30830#23450#65288'Enter'#65289
    TabOrder = 1
    OnClick = btnSPF_FinClick
  end
  object btnSPF_Esc: TButton
    Left = 844
    Top = 32
    Width = 81
    Height = 33
    Caption = #36864#20986#65288'ESC'#65289
    TabOrder = 2
    OnClick = btnSPF_EscClick
  end
  object dbgrdSPF: TDBGrid
    Left = 12
    Top = 80
    Width = 1001
    Height = 377
    DataSource = dsSPFin
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = dbgrdSPFDrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = #34892#21495
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'commodity_name'
        Width = 123
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'commodity_id'
        Width = 140
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'comm_self_code'
        Width = 115
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'commodity_bar'
        Width = 157
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'comm_type_id'
        Width = 69
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'unit'
        Width = 41
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'guige'
        Width = 92
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'is_expensive'
        Width = 58
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'is_allow_point'
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'is_direct'
        Width = 65
        Visible = True
      end>
  end
  object unqrySPFin: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    SQL.Strings = (
      'select * from t_bi_commbaseinfo;')
    Left = 932
    Top = 40
    object intgrfldSPFinField: TIntegerField
      FieldKind = fkCalculated
      FieldName = #34892#21495
      OnGetText = intgrfldSPFinFieldGetText
      Calculated = True
    end
    object strngfldSPFincommodity_name: TStringField
      DisplayLabel = #21830#21697#21517#31216
      FieldName = 'commodity_name'
      Size = 50
    end
    object strngfldSPFincommodity_id: TStringField
      DisplayLabel = #21830#21697#32534#21495
      FieldName = 'commodity_id'
    end
    object strngfldSPFincomm_self_code: TStringField
      DisplayLabel = #21830#21697#33258#32534#30721
      FieldName = 'comm_self_code'
    end
    object strngfldSPFincommodity_bar: TStringField
      DisplayLabel = #21830#21697#26465#30721
      FieldName = 'commodity_bar'
      Size = 13
    end
    object strngfldSPFincomm_type_id: TStringField
      DisplayLabel = #21830#21697#31867#21035
      FieldName = 'comm_type_id'
      Size = 6
    end
    object strngfldSPFinunit: TStringField
      DisplayLabel = #21333#20301
      FieldName = 'unit'
      Size = 10
    end
    object strngfldSPFinguige: TStringField
      DisplayLabel = #35268#26684
      FieldName = 'guige'
      Size = 30
    end
    object strngfldSPFinis_expensive: TStringField
      DisplayLabel = #26159#21542#39640#20540
      FieldName = 'is_expensive'
      FixedChar = True
      Size = 1
    end
    object strngfldSPFinis_allow_point: TStringField
      DisplayLabel = #26159#21542#31215#20998
      FieldName = 'is_allow_point'
      FixedChar = True
      Size = 1
    end
    object strngfldSPFinis_direct: TStringField
      DisplayLabel = #26159#21542#30452#36865
      FieldName = 'is_direct'
      FixedChar = True
      Size = 1
    end
  end
  object dsSPFin: TUniDataSource
    DataSet = unqrySPFin
    Left = 932
    Top = 8
  end
end
