object W_POS_BankForm: TW_POS_BankForm
  Left = 63
  Top = 140
  Width = 319
  Height = 336
  Caption = #38134#34892#21345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblFKFS: TLabel
    Left = 24
    Top = 32
    Width = 73
    Height = 25
    AutoSize = False
    Caption = #20184#27454#26041#24335#65306
  end
  object lblYSJE: TLabel
    Left = 24
    Top = 80
    Width = 73
    Height = 25
    AutoSize = False
    Caption = #24212#25910#37329#39069#65306
  end
  object lblSFJE: TLabel
    Left = 21
    Top = 128
    Width = 60
    Height = 13
    Caption = #23454#20184#37329#39069#65306
  end
  object lblBZ: TLabel
    Left = 18
    Top = 171
    Width = 54
    Height = 13
    Caption = #22791'      '#27880#65306
  end
  object lbl1: TLabel
    Left = 8
    Top = 280
    Width = 60
    Height = 13
    Caption = #25552#31034#20449#24687#65306
  end
  object lbl2: TLabel
    Left = 88
    Top = 280
    Width = 16
    Height = 13
    Caption = 'lbl2'
  end
  object edt1: TEdit
    Left = 112
    Top = 26
    Width = 177
    Height = 21
    ReadOnly = True
    TabOrder = 0
    Text = #38134#34892#21345
  end
  object edt2: TEdit
    Left = 112
    Top = 76
    Width = 178
    Height = 21
    ReadOnly = True
    TabOrder = 1
    Text = 'edt2'
  end
  object edt3: TEdit
    Left = 112
    Top = 124
    Width = 178
    Height = 21
    TabOrder = 2
    Text = 'edt3'
    OnKeyDown = edt3KeyDown
    OnKeyPress = edt3KeyPress
  end
  object edt4: TEdit
    Left = 112
    Top = 168
    Width = 177
    Height = 21
    TabOrder = 3
    Text = 'edt4'
  end
  object btnQD: TBitBtn
    Left = 40
    Top = 224
    Width = 90
    Height = 33
    Caption = #30830#23450'(D)'
    TabOrder = 4
    OnClick = btnQDClick
  end
  object btnTC: TBitBtn
    Left = 160
    Top = 224
    Width = 90
    Height = 33
    Cancel = True
    Caption = #36864#20986'(ESC)'
    TabOrder = 5
    OnClick = btnTCClick
  end
end
