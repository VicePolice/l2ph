object L2PacketHackMain: TL2PacketHackMain
  Left = 231
  Top = 212
  Width = 914
  Height = 686
  Caption = 'L2ph'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object JvLabel1: TJvLabel
    Left = 0
    Top = 0
    Width = 906
    Height = 613
    Align = alClient
    Alignment = taCenter
    AutoSize = False
    Caption = 'L2Packet Hack'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Layout = tlCenter
    ParentFont = False
    AutoOpenURL = False
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -19
    HotTrackFont.Name = 'MS Sans Serif'
    HotTrackFont.Style = []
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 613
    Width = 906
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object pcClientsConnection: TJvPageControl
    Left = 0
    Top = 0
    Width = 906
    Height = 613
    Align = alClient
    TabOrder = 1
    Visible = False
    ClientBorderWidth = 0
  end
  object XPManifest1: TXPManifest
    Left = 622
    Top = 14
  end
  object MainMenu1: TMainMenu
    Left = 588
    Top = 13
    object N4: TMenuItem
      Caption = #1060#1072#1081#1083
      object Log1: TMenuItem
        Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1083#1086#1075' l2ph'
        OnClick = Log1Click
      end
      object N7: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1083#1086#1075' '#1087#1072#1082#1077#1090#1086#1074
        OnClick = N7Click
      end
      object RAW1: TMenuItem
        Caption = #1054#1087#1077#1088#1072#1094#1080#1080' '#1089' RAW '#1083#1086#1075#1072#1084#1080' '#1087#1072#1082#1077#1090#1086#1074
        OnClick = RAW1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object packetsini1: TMenuItem
        Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1102' '#1080#1079' packets*.ini'
        OnClick = packetsini1Click
      end
      object N10: TMenuItem
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
        OnClick = N10Click
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object N5: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = N5Click
      end
    end
    object N3: TMenuItem
      Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1079#1072#1094#1080#1103
      object N16: TMenuItem
        Caption = #1057#1082#1088#1080#1087#1090#1099
        OnClick = N16Click
      end
      object N17: TMenuItem
        Caption = #1055#1083#1072#1075#1080#1085#1099
        OnClick = N17Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object ShowUserForm: TMenuItem
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100#1089#1082#1072#1103' '#1092#1086#1088#1084#1072
        Enabled = False
        OnClick = ShowUserFormClick
      end
    end
    object l1: TMenuItem
      Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086
      object N1: TMenuItem
        Caption = #1060#1080#1083#1100#1090#1088' '#1087#1072#1082#1077#1090#1086#1074
        OnClick = N1Click
      end
      object N13: TMenuItem
        Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1103
        OnClick = N13Click
      end
      object N12: TMenuItem
        Caption = #1055#1088#1086#1094#1077#1089#1089#1099
        OnClick = N12Click
      end
    end
    object N8: TMenuItem
      Caption = #1055#1086#1084#1086#1096#1100
      object N9: TMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        OnClick = N9Click
      end
    end
  end
  object UnUsedObjectsDestroyer: TTimer
    Interval = 250
    OnTimer = UnUsedObjectsDestroyerTimer
    Left = 552
    Top = 12
  end
  object ApplicationEvents1: TApplicationEvents
    OnHint = ApplicationEvents1Hint
    OnRestore = FormActivate
    Left = 656
    Top = 16
  end
  object dlgOpenLog: TOpenDialog
    DefaultExt = '*.pLog'
    Filter = #1051#1086#1075' '#1087#1072#1082#1077#1090#1086#1074' (*.pLog)|*.pLog|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 519
    Top = 12
  end
  object trayMenu: TPopupMenu
    Left = 737
    Top = 22
    object nScripts: TMenuItem
      Caption = #1057#1082#1088#1080#1087#1090#1099
      object MenuItem1: TMenuItem
        Caption = '-'
      end
    end
    object nPlugins: TMenuItem
      Caption = #1055#1083#1072#1075#1080#1085#1099
      object MenuItem2: TMenuItem
        Caption = '-'
      end
    end
    object dasdas1: TMenuItem
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100'/'#1057#1082#1088#1099#1090#1100
      Default = True
      OnClick = dasdas1Click
    end
    object MenuItem4: TMenuItem
      Caption = '-'
    end
    object MenuItem5: TMenuItem
      Caption = '&'#1042#1099#1093#1086#1076
      ImageIndex = 0
    end
  end
  object JvTrayIcon1: TJvTrayIcon
    Active = True
    Icon.Data = {
      0000010001001010080000000000680500001600000028000000100000002000
      0000010008000000000000010000000000000000000000000000000000000000
      0000000080000080000000808000800000008000800080800000C0C0C000C0DC
      C000F0CAA6000020400000206000002080000020A0000020C0000020E0000040
      0000004020000040400000406000004080000040A0000040C0000040E0000060
      0000006020000060400000606000006080000060A0000060C0000060E0000080
      0000008020000080400000806000008080000080A0000080C0000080E00000A0
      000000A0200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0
      000000C0200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0
      000000E0200000E0400000E0600000E0800000E0A00000E0C00000E0E0004000
      0000400020004000400040006000400080004000A0004000C0004000E0004020
      0000402020004020400040206000402080004020A0004020C0004020E0004040
      0000404020004040400040406000404080004040A0004040C0004040E0004060
      0000406020004060400040606000406080004060A0004060C0004060E0004080
      0000408020004080400040806000408080004080A0004080C0004080E00040A0
      000040A0200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0
      000040C0200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0
      000040E0200040E0400040E0600040E0800040E0A00040E0C00040E0E0008000
      0000800020008000400080006000800080008000A0008000C0008000E0008020
      0000802020008020400080206000802080008020A0008020C0008020E0008040
      0000804020008040400080406000804080008040A0008040C0008040E0008060
      0000806020008060400080606000806080008060A0008060C0008060E0008080
      0000808020008080400080806000808080008080A0008080C0008080E00080A0
      000080A0200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0
      000080C0200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0
      000080E0200080E0400080E0600080E0800080E0A00080E0C00080E0E000C000
      0000C0002000C0004000C0006000C0008000C000A000C000C000C000E000C020
      0000C0202000C0204000C0206000C0208000C020A000C020C000C020E000C040
      0000C0402000C0404000C0406000C0408000C040A000C040C000C040E000C060
      0000C0602000C0604000C0606000C0608000C060A000C060C000C060E000C080
      0000C0802000C0804000C0806000C0808000C080A000C080C000C080E000C0A0
      0000C0A02000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C0
      0000C0C02000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A0008080
      80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
      000000000000000000000000000000000000A4A40000000000A3A40000000000
      00633119A40000005B1911A4000007A4ADA4A3FA5AA4ADA46A3062A4ADA4F608
      0808F7ACFA5AF7A439315B08F6ADF608080807A4B4315B62396AF70708A5F608
      08080807A3BB3931285B070708A5F60808080808F7A37BFA61A4070708A5F608
      0808080808AD73395AAD070708A5F6080808080807A37AFA025BF70708A5F607
      07070707F76A7A6B7A295BF708A5F4D8E0E1E1E19B3939A3A37B21A4F5A409F4
      F40909EC6B7A6AF7EDA37A62F7070000000000A5BCBC630000F7AC7A6A070000
      00000000A59BF7000000F79BF70000000000000000000000000000000000FFFF
      0000F3E70000E1C3000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F8600000FC710000FFFF0000}
    IconIndex = 0
    PopupMenu = trayMenu
    OnClick = JvTrayIcon1Click
    Left = 704
    Top = 23
  end
end
