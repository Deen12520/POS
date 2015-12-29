object Form1: TForm1
  Left = 248
  Top = 94
  Width = 870
  Height = 640
  Caption = 'test'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 608
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object adoQuery1: TUniQuery
    Connection = DM_ZB_Common.VG_ZB_ADOConnection
    Left = 200
    Top = 176
  end
end
