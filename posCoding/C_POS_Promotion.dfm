object W_POS_PromotionForm: TW_POS_PromotionForm
  Left = 65
  Top = 165
  Width = 643
  Height = 409
  Caption = #20419#38144#26597#35810
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblFinPro: TLabel
    Left = 240
    Top = 24
    Width = 129
    Height = 29
    AutoSize = False
    Caption = #20419#38144#26597#35810
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbl1: TLabel
    Left = 16
    Top = 352
    Width = 60
    Height = 13
    Caption = #25552#31034#20449#24687#65306
  end
  object lbl2: TLabel
    Left = 96
    Top = 352
    Width = 233
    Height = 13
    Caption = 'lbl2'
  end
  object dbgrdFinPro: TDBGrid
    Left = 24
    Top = 64
    Width = 569
    Height = 169
    DataSource = dsFinPro
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
        FieldName = 'promotion_name'
        Title.Caption = #20419#38144#27963#21160#21517#31216
        Width = 88
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'begin_date'
        Title.Caption = #24320#22987#26085#26399
        Width = 73
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'begin_time'
        Title.Caption = #24320#22987#26102#38388
        Width = 74
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'end_date'
        Title.Caption = #32467#26463#26085#26399
        Width = 75
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'end_time'
        Title.Caption = #32467#26463#26102#38388
        Width = 74
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'designated_week'
        Title.Caption = #25351#23450#26143#26399
        Width = 73
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'designated_date'
        Title.Caption = #25351#23450#26085#26399
        Width = 69
        Visible = True
      end>
  end
  object btnFinPro_esc: TButton
    Left = 464
    Top = 328
    Width = 75
    Height = 25
    Caption = #36864#20986#65288'ESC'#65289
    TabOrder = 1
    OnClick = btnFinPro_escClick
  end
  object dbmmoProDetail: TDBMemo
    Left = 24
    Top = 248
    Width = 569
    Height = 49
    DataField = 'promotion_detail'
    DataSource = dsFinPro
    TabOrder = 2
  end
  object btnRef: TButton
    Left = 368
    Top = 328
    Width = 75
    Height = 25
    Caption = #21047#26032#65288'F5'#65289
    TabOrder = 3
    OnClick = btnRefClick
  end
  object unqryFinPro: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    SQL.Strings = (
      'select * from t_bi_promotion;')
    Left = 32
    Top = 312
    object unqryFinPropromotion_id: TStringField
      FieldName = 'promotion_id'
    end
    object unqryFinPropromotion_name: TStringField
      FieldName = 'promotion_name'
      Size = 50
    end
    object unqryFinPropromotion_brief: TStringField
      FieldName = 'promotion_brief'
      Size = 50
    end
    object unqryFinProbegin_date: TDateField
      FieldName = 'begin_date'
    end
    object unqryFinProend_date: TDateField
      FieldName = 'end_date'
    end
    object unqryFinPropromotion_detail: TStringField
      FieldName = 'promotion_detail'
      Size = 255
    end
    object unqryFinProdesignated_week: TStringField
      FieldName = 'designated_week'
      FixedChar = True
      Size = 7
    end
    object unqryFinProdesignated_date: TSmallintField
      FieldName = 'designated_date'
    end
    object unqryFinProstatus: TStringField
      FieldName = 'status'
      FixedChar = True
      Size = 1
    end
    object unqryFinProis_allow_point: TStringField
      FieldName = 'is_allow_point'
      FixedChar = True
      Size = 1
    end
    object unqryFinProis_mem_prom: TStringField
      FieldName = 'is_mem_prom'
      FixedChar = True
      Size = 1
    end
    object unqryFinPromodify_oper: TStringField
      FieldName = 'modify_oper'
      Size = 4
    end
    object unqryFinPromodify_date: TDateField
      FieldName = 'modify_date'
    end
    object unqryFinProbegin_time: TTimeField
      FieldName = 'begin_time'
    end
    object unqryFinProend_time: TTimeField
      FieldName = 'end_time'
    end
  end
  object dsFinPro: TUniDataSource
    DataSet = unqryFinPro
    Left = 72
    Top = 312
  end
end
