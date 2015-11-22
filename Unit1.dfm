object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1055#1072#1088#1089#1077#1088' 3 tmall.com'
  ClientHeight = 641
  ClientWidth = 909
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    909
    641)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 100
    Height = 13
    Caption = #1057#1089#1099#1083#1082#1072' '#1085#1072' '#1084#1072#1075#1072#1079#1080#1085':'
  end
  object Label2: TLabel
    Left = 8
    Top = 54
    Width = 107
    Height = 13
    Caption = 'shop57745215, z8888'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsItalic]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 104
    Width = 102
    Height = 13
    Caption = #1053#1072#1081#1076#1077#1085#1086' 0 '#1090#1086#1074#1072#1088#1086#1074':'
  end
  object Label4: TLabel
    Left = 297
    Top = 11
    Width = 117
    Height = 13
    Anchors = [akTop, akRight]
    Caption = #1053#1072#1094#1077#1085#1082#1072' '#1085#1072' '#1090#1086#1074#1072#1088' (%):'
    ExplicitLeft = 240
  end
  object Label5: TLabel
    Left = 294
    Top = 35
    Width = 106
    Height = 13
    Anchors = [akTop, akRight]
    Caption = #1057#1087#1072#1088#1089#1077#1085#1086' 0 '#1090#1086#1074#1072#1088#1086#1074':'
    ExplicitLeft = 240
  end
  object LabelTimer: TLabel
    Left = 298
    Top = 331
    Width = 102
    Height = 13
    Anchors = [akTop, akRight]
    Caption = #1046#1091#1088#1085#1072#1083' '#1089#1082#1072#1095#1080#1074#1072#1085#1080#1103
    ExplicitLeft = 244
  end
  object url: TEdit
    Left = 8
    Top = 27
    Width = 274
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'http://rbeauty.tmall.com/'
    OnChange = urlChange
  end
  object ButtonLinks: TButton
    Left = 8
    Top = 73
    Width = 271
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = #1053#1072#1081#1090#1080' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
    TabOrder = 1
    OnClick = ButtonLinksClick
  end
  object list: TMemo
    Left = 8
    Top = 120
    Width = 271
    Height = 512
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object ButtonParse: TButton
    Left = 480
    Top = 8
    Width = 114
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1055#1072#1088#1089#1080#1084' '#1090#1086#1074#1072#1088#1099
    TabOrder = 3
    OnClick = ButtonParseClick
  end
  object Edit1: TEdit
    Left = 420
    Top = 8
    Width = 54
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 4
    Text = '0'
  end
  object MemoSite: TMemo
    Left = 285
    Top = 54
    Width = 612
    Height = 83
    Anchors = [akTop, akRight]
    Lines.Strings = (
      
        #1072#1088#1090#1080#1082#1091#1083'; '#1085#1072#1079#1074#1072#1085#1080#1077'; url '#1082#1072#1088#1090#1080#1085#1082#1080'; '#1094#1077#1085#1072'; '#1076#1086#1089#1090#1072#1074#1082#1072'; '#1094#1074#1077#1090'; '#1088#1072#1079#1084#1077#1088';  ' +
        #1087#1086#1083#1085#1086#1077' '#1086#1087#1080#1089#1072#1085#1080#1077'; '#1087#1086#1076#1088#1086#1073#1085#1086#1077' '#1086#1087#1080#1089#1072#1085#1080#1077)
    ScrollBars = ssBoth
    TabOrder = 5
    WordWrap = False
  end
  object ButtonSite: TButton
    Left = 668
    Top = 607
    Width = 74
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Site'
    TabOrder = 6
    OnClick = ButtonSiteClick
  end
  object ButtonClear: TButton
    Left = 306
    Top = 607
    Width = 74
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 7
    OnClick = ButtonClearClick
  end
  object MemoLog: TMemo
    Left = 294
    Top = 350
    Width = 603
    Height = 251
    Anchors = [akTop, akRight]
    ScrollBars = ssBoth
    TabOrder = 8
  end
  object CBChinaText: TCheckBox
    Left = 303
    Top = 239
    Width = 272
    Height = 17
    Anchors = [akTop, akRight]
    Caption = #1059#1073#1080#1088#1072#1077#1084' '#1080#1079' '#1086#1087#1080#1089#1072#1085#1080#1103' '#1090#1077#1082#1089#1090' '#1085#1072' '#1082#1080#1090#1072#1081#1089#1082#1086#1084' '#1103#1079#1099#1082#1077
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object ButtonVK: TButton
    Left = 473
    Top = 607
    Width = 74
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'VK'
    TabOrder = 10
    OnClick = ButtonVKClick
  end
  object MemoVK: TMemo
    Left = 285
    Top = 143
    Width = 612
    Height = 82
    Anchors = [akTop, akRight]
    Lines.Strings = (
      #1072#1088#1090#1080#1082#1091#1083'; '#1085#1072#1079#1074#1072#1085#1080#1077'; url '#1082#1072#1088#1090#1080#1085#1082#1080'; '#1094#1077#1085#1072'; '#1094#1074#1077#1090'; '#1088#1072#1079#1084#1077#1088)
    ScrollBars = ssBoth
    TabOrder = 11
    WordWrap = False
  end
  object ButtonExit: TButton
    Left = 825
    Top = 607
    Width = 74
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 12
    OnClick = ButtonExitClick
  end
  object Memo1: TMemo
    Left = 581
    Top = 237
    Width = 316
    Height = 107
    Anchors = [akTop, akRight]
    ScrollBars = ssBoth
    TabOrder = 13
  end
  object CheckBoxLocal: TCheckBox
    Left = 303
    Top = 279
    Width = 144
    Height = 17
    Anchors = [akTop, akRight]
    Caption = #1058#1077#1082#1089#1090' '#1089#1072#1081#1090#1072' '#1080#1079' '#1086#1082#1085#1072
    TabOrder = 14
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    HandleRedirects = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 16
    Top = 160
  end
  object IdAntiFreeze1: TIdAntiFreeze
    IdleTimeOut = 100
    Left = 64
    Top = 184
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.csv'
    Filter = 'CSV|*.csv'
    Left = 120
    Top = 192
  end
end
