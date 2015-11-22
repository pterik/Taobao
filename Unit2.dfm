object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 451
  ClientWidth = 683
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  PixelsPerInch = 96
  TextHeight = 13
  object MemoLog: TMemo
    Left = 0
    Top = 240
    Width = 681
    Height = 178
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 24
    Top = 424
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 681
    Height = 209
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object Button1: TButton
    Left = 152
    Top = 424
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 3
    OnClick = Button1Click
  end
end
