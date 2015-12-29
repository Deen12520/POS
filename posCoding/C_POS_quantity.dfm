object W_POS_quantityForm: TW_POS_quantityForm
  Left = 492
  Top = 186
  Width = 446
  Height = 191
  Caption = #25968#37327
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
    Left = 32
    Top = 16
    Width = 48
    Height = 13
    Caption = #36755#20837#25968#37327
  end
  object pnl1: TPanel
    Left = 16
    Top = 40
    Width = 401
    Height = 105
    TabOrder = 1
    object lbl2: TLabel
      Left = 16
      Top = 80
      Width = 161
      Height = 13
      AutoSize = False
      Caption = #25353' Enter '#38190#25552#20132#25968#25454#65281
    end
  end
  object edtnum: TEdit
    Left = 32
    Top = 56
    Width = 345
    Height = 45
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -33
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnKeyDown = edtnumKeyDown
  end
end
