object fSettings: TfSettings
  Left = 291
  Top = 319
  Width = 387
  Height = 406
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl3: TPageControl
    Left = 0
    Top = 0
    Width = 379
    Height = 345
    ActivePage = TabSheet8
    Align = alClient
    TabOrder = 0
    object TabSheet8: TTabSheet
      Caption = #1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
      object isIgnorePorts: TLabeledEdit
        Left = 6
        Top = 59
        Width = 360
        Height = 21
        Hint = #1055#1086#1088#1090#1099', '#1082#1086#1085#1085#1077#1082#1090#1099' '#1085#1072' '#1082#1086#1090#1086#1088#1099#1077' '#1085#1077' '#1085#1072#1076#1086' '#1087#1077#1088#1077#1093#1074#1072#1090#1099#1074#1072#1090#1100
        EditLabel.Width = 94
        EditLabel.Height = 13
        EditLabel.Caption = #1053#1077#1080#1075#1088#1086#1074#1099#1077' '#1087#1086#1088#1090#1099':'
        TabOrder = 0
      end
      object isClientsList: TLabeledEdit
        Left = 6
        Top = 20
        Width = 360
        Height = 21
        Hint = #1055#1088#1086#1075#1088#1072#1084#1084#1099' '#1091' '#1082#1086#1090#1086#1088#1099#1093' '#1073#1091#1076#1077#1084' '#1087#1077#1088#1077#1093#1074#1072#1090#1099#1074#1072#1090#1100' '#1090#1088#1072#1092#1080#1082
        EditLabel.Width = 205
        EditLabel.Height = 13
        EditLabel.Caption = #1057#1095#1080#1090#1072#1090#1100' '#1082#1083#1080#1077#1085#1090#1072#1084#1080'/'#1073#1086#1090#1072#1084#1080' '#1087#1088#1086#1075#1088#1072#1084#1084#1099':'
        TabOrder = 1
      end
      object rgProtocolVersion: TRadioGroup
        Left = 6
        Top = 213
        Width = 355
        Height = 82
        Caption = #1042#1077#1088#1089#1080#1103' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' ('#1043#1083#1086#1073#1072#1083#1100#1085#1086')'
        ItemIndex = 0
        Items.Strings = (
          #1057'4 - ProtocolVersion<660'
          #1057'5 - 660<ProtocolVersion<737'
          #1058'0 - Interlude  - 736<ProtocolVersion<827'
          #1058'1 - Kamael-Hellbound-Gracia - ProtocolVersion>827')
        TabOrder = 2
        OnClick = rgProtocolVersionClick
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 83
        Width = 353
        Height = 126
        Hint = #1053#1077' '#1073#1091#1076#1077#1090' '#1074#1083#1080#1103#1090#1100' '#1085#1072' '#1091#1078#1077' '#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1077
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1076#1083#1103' '#1085#1086#1074#1086#1075#1086' '#1087#1077#1088#1077#1093#1074#1072#1095#1077#1085#1086#1075#1086' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103
        TabOrder = 3
        object ChkNoDecrypt: TCheckBox
          Left = 6
          Top = 18
          Width = 300
          Height = 17
          Hint = #1055#1086#1082#1072#1079#1099#1074#1072#1077#1090' '#1090#1088#1072#1092#1080#1082' '#1082#1072#1082' '#1086#1085' '#1087#1088#1080#1093#1086#1076#1080#1090
          Caption = #1053#1077' '#1076#1077#1096#1080#1092#1088#1086#1074#1099#1074#1072#1090#1100' '#1090#1088#1072#1092#1080#1082
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = ChkNoDecryptClick
        end
        object ChkChangeXor: TCheckBox
          Left = 6
          Top = 34
          Width = 300
          Height = 17
          Hint = #1054#1073#1093#1086#1076' '#1079#1072#1097#1080#1090' '#1084#1077#1085#1103#1102#1097#1080#1093' '#1085#1072#1095#1072#1083#1100#1085#1099#1081' '#1082#1083#1102#1095' '#1096#1080#1092#1088#1072#1094#1080#1080' XOR'
          Caption = #1054#1073#1093#1086#1076' '#1089#1084#1077#1085#1099' XOR '#1082#1083#1102#1095#1072
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = ChkNoDecryptClick
        end
        object ChkKamael: TCheckBox
          Left = 6
          Top = 50
          Width = 300
          Height = 17
          Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' '#1089#1077#1088#1074#1077#1088#1086#1074' '#1090#1080#1087#1072' Kamael - Hellbound - Gracia'
          Caption = 'Kamael-Hellbound-Gracia'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 2
          OnClick = ChkKamaelClick
        end
        object ChkGraciaOff: TCheckBox
          Left = 6
          Top = 66
          Width = 300
          Height = 17
          Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1088#1091#1089#1089#1082#1086#1075#1086' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086#1075#1086' '#1089#1077#1088#1074#1077#1088#1072' L2.RU'
          Caption = 'Gracia (off server) ('#1091#1089#1090#1072#1088#1077#1083#1086' '#1085#1072' '#1083'2.'#1088#1091')'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 3
          OnClick = ChkGraciaOffClick
        end
        object isNewxor: TLabeledEdit
          Left = 24
          Top = 99
          Width = 156
          Height = 21
          Hint = #1041#1080#1073#1083#1080#1086#1090#1077#1082#1072' '#1076#1083#1103' '#1089#1077#1088#1074#1077#1088#1086#1074' '#1089' '#1085#1077#1089#1090#1072#1085#1076#1072#1088#1090#1085#1086#1081' '#1096#1080#1092#1088#1072#1094#1080#1077#1081
          EditLabel.Width = 97
          EditLabel.Height = 13
          EditLabel.Caption = #1055#1089#1077#1074#1076#1086#1085#1080#1084' Newxor'
          TabOrder = 4
          Text = 'newxor.dll'
        end
        object iNewxor: TCheckBox
          Left = 6
          Top = 102
          Width = 15
          Height = 17
          Hint = #1047#1072#1075#1088#1091#1078#1072#1077#1090' '#1091#1082#1072#1079#1072#1085#1091#1102' '#1073#1080#1073#1083#1080#1086#1090#1077#1082#1091
          TabOrder = 5
          OnClick = iNewxorClick
        end
      end
    end
    object TabSheet9: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1077#1088#1077#1093#1074#1072#1090#1072
      ImageIndex = 1
      object Bevel1: TBevel
        Left = 5
        Top = 5
        Width = 357
        Height = 118
        Shape = bsFrame
      end
      object Bevel2: TBevel
        Left = 5
        Top = 204
        Width = 357
        Height = 34
        Shape = bsFrame
      end
      object Bevel3: TBevel
        Left = 5
        Top = 129
        Width = 357
        Height = 70
        Shape = bsFrame
      end
      object isInject: TLabeledEdit
        Left = 30
        Top = 93
        Width = 323
        Height = 21
        Hint = #1041#1080#1073#1083#1080#1086#1090#1077#1082#1072' '#1086#1073#1077#1089#1087#1077#1095#1080#1074#1072#1102#1097#1072#1103' '#1087#1077#1088#1077#1093#1074#1072#1090' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103
        EditLabel.Width = 243
        EditLabel.Height = 13
        EditLabel.Caption = #1080#1084#1103' '#1073#1080#1073#1083#1080#1086#1090#1082#1077#1080' '#1087#1077#1088#1077#1093#1074#1072#1090#1099#1074#1072#1102#1097#1077#1081' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103
        TabOrder = 0
        Text = 'inject.dll'
      end
      object HookMethod: TRadioGroup
        Left = 12
        Top = 40
        Width = 343
        Height = 34
        Caption = #1057#1087#1086#1089#1086#1073' '#1074#1085#1077#1076#1088#1077#1085#1080#1103' '#1074' '#1082#1083#1080#1077#1085#1090'/'#1073#1086#1090':'
        Columns = 3
        ItemIndex = 0
        Items.Strings = (
          #1053#1072#1076#1077#1078#1085#1099#1081
          #1057#1082#1088#1099#1090#1085#1099#1081
          #1040#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1085#1099#1081)
        TabOrder = 1
      end
      object ChkIntercept: TCheckBox
        Left = 12
        Top = 14
        Width = 309
        Height = 17
        Hint = #1056#1072#1079#1088#1077#1096#1072#1077#1090' '#1087#1086#1080#1089#1082' '#1085#1086#1074#1099#1093' '#1082#1083#1080#1077#1085#1090#1086#1074', '#1080' '#1087#1077#1088#1077#1093#1074#1072#1090' '#1080#1093' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1081'.'
        Caption = #1055#1077#1088#1077#1093#1074#1072#1090';  '#1048#1089#1082#1072#1090#1100' '#1082#1083#1080#1077#1085#1090'                    '#1089#1077#1082'.'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = ChkInterceptClick
      end
      object JvSpinEdit1: TJvSpinEdit
        Left = 166
        Top = 12
        Width = 52
        Height = 21
        Hint = #1050#1072#1082' '#1095#1072#1089#1090#1086' '#1080#1089#1082#1072#1090#1100' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1076#1083#1103' '#1087#1077#1088#1077#1093#1074#1072#1090#1072
        Increment = 0.500000000000000000
        MaxValue = 10.000000000000000000
        MinValue = 0.100000000000000000
        ValueType = vtFloat
        Value = 5.000000000000000000
        TabOrder = 2
        BevelInner = bvNone
        BevelOuter = bvNone
      end
      object ChkSocks5: TCheckBox
        Left = 12
        Top = 213
        Width = 309
        Height = 17
        Hint = #1055#1072#1082#1077#1090#1093#1072#1082' '#1088#1072#1073#1086#1090#1072#1077#1090' '#1082#1072#1082' '#1087#1088#1086#1082#1089#1080'-'#1089#1077#1088#1074#1077#1088
        Caption = 'Socks5 '#1089#1077#1088#1074#1077#1088
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = ChkSocks5Click
      end
      object iInject: TCheckBox
        Left = 12
        Top = 94
        Width = 13
        Height = 17
        Hint = #1047#1072#1075#1088#1091#1078#1072#1077#1090' '#1091#1082#1072#1079#1072#1085#1091#1102' '#1073#1080#1073#1083#1080#1086#1090#1077#1082#1091
        TabOrder = 5
        OnClick = iInjectClick
      end
      object ChkLSPIntercept: TCheckBox
        Left = 12
        Top = 137
        Width = 317
        Height = 17
        Hint = #1048#1089#1087#1086#1083#1100#1079#1091#1077#1090' LSP '#1076#1083#1103' '#1087#1077#1088#1077#1093#1074#1072#1090#1072' '#1090#1088#1072#1092#1092#1080#1082#1072'.'
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' LSP '#1087#1077#1088#1077#1093#1074#1072#1090
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        OnClick = ChkLSPInterceptClick
      end
      object isLSP: TLabeledEdit
        Left = 14
        Top = 171
        Width = 339
        Height = 21
        Hint = 'LSP '#1041#1080#1073#1083#1080#1086#1090#1077#1082#1072' ('#1040#1073#1089#1086#1083#1102#1090#1085#1099#1081' '#1087#1091#1090#1100', '#1083#1080#1073#1086' '#1088#1072#1079#1084#1077#1089#1090#1080#1090#1100' '#1074' SYSTEM32)'
        EditLabel.Width = 142
        EditLabel.Height = 13
        EditLabel.Caption = #1055#1086#1083#1085#1099#1081' '#1087#1091#1090#1100' '#1082' LSP '#1084#1086#1076#1091#1083#1102'.'
        TabOrder = 7
        Text = 'c:\windows\system32\lsp.dll'
        OnChange = isLSPChange
      end
    end
    object TabSheet1: TTabSheet
      Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086
      ImageIndex = 2
      object ChkAllowExit: TCheckBox
        Left = 6
        Top = 10
        Width = 274
        Height = 17
        Hint = #1056#1072#1079#1088#1077#1096#1072#1077#1090' '#1074#1099#1093#1086#1076#1080#1090#1100' '#1080#1079' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1073#1077#1079' '#1085#1072#1076#1086#1077#1076#1083#1080#1074#1086#1075#1086' "'#1074#1099' '#1091#1074#1077#1088#1077#1085#1085#1099'"'
        Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1074#1099#1093#1086#1076' '#1080#1079' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1073#1077#1079' '#1079#1072#1087#1088#1086#1089#1072
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = ChkNoDecryptClick
      end
      object ChkShowLogWinOnStart: TCheckBox
        Left = 6
        Top = 26
        Width = 347
        Height = 17
        Hint = #1040' '#1095#1090#1086' '#1090#1091#1090' '#1085#1077#1087#1086#1085#1103#1090#1085#1086#1075#1086' ? =0)'
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1086#1082#1085#1086' '#1083#1086#1075#1072' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = ChkNoDecryptClick
      end
      object chkNoFree: TCheckBox
        Left = 6
        Top = 43
        Width = 347
        Height = 17
        Hint = 
          #1059#1089#1090#1072#1085#1086#1074#1080#1090' '#1072#1085#1072#1083#1086#1075#1080#1095#1085#1091#1102' '#1086#1087#1094#1080#1102' '#1076#1083#1103' '#1082#1072#1078#1076#1086#1075#1086' '#1092#1088#1077#1081#1084#1072' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1102#1097#1077#1075#1086#1089#1103' ' +
          #1082' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1102'.'
        Caption = #1053#1077' '#1079#1072#1082#1088#1099#1074#1072#1090#1100' "'#1086#1082#1085#1086'" '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103' '#1087#1086#1089#1083#1077' '#1044#1080#1089#1082#1086#1085#1085#1077#1082#1090#1072
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = ChkNoDecryptClick
      end
      object chkRaw: TCheckBox
        Left = 6
        Top = 59
        Width = 347
        Height = 17
        Hint = 
          #1056#1072#1079#1088#1077#1096#1080#1090' '#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1087#1072#1084#1103#1090#1080' '#1090#1086' '#1095#1090#1086' '#1087#1088#1086#1080#1089#1093#1086#1076#1080#1090' '#1085#1072' '#1091#1088#1086#1074#1085#1077' '#1089#1077#1090#1077#1074#1086#1075#1086' '#1087 +
          #1088#1086#1090#1086#1082#1086#1083#1072'.'
        Caption = #1044#1072#1090#1100' '#1074#1086#1079#1084#1086#1078#1085#1086#1089#1090#1100' '#1089#1086#1093#1088#1072#1085#1103#1090#1100' RAW '#1083#1086#1075#1080' '#1090#1088#1072#1092#1080#1082#1072
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = ChkNoDecryptClick
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 345
    Width = 379
    Height = 27
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object Panel3: TPanel
      Left = 204
      Top = 0
      Width = 175
      Height = 27
      Align = alRight
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      object Button1: TButton
        Left = 11
        Top = 2
        Width = 75
        Height = 23
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 94
        Top = 2
        Width = 75
        Height = 23
        Caption = #1054#1090#1084#1077#1085#1072
        TabOrder = 1
        OnClick = Button2Click
      end
    end
  end
  object lang: TsiLang
    Version = '6.1.0.1'
    IsInheritedOwner = True
    StringsTypes.Strings = (
      'TIB_STRINGLIST'
      'TSTRINGLIST')
    SmartExcludeProps.Strings = (
      'Action4.Caption'
      'Action5.Caption'
      'Action6.Caption'
      'Action7.Caption'
      'Action8.Caption'
      'Action9.Caption'
      'Action10.Caption'
      'TL2PacketHackMain.Caption')
    UseInheritedData = True
    AutoSkipEmpties = True
    NumOfLanguages = 2
    LangDelim = 1
    DoNotTranslate.Strings = (
      'Action2'
      'Action3')
    LangNames.Strings = (
      'Rus'
      'Eng')
    Language = 'Rus'
    ExcludedProperties.Strings = (
      'Category'
      'SecondaryShortCuts'
      'HelpKeyword'
      'InitialDir'
      'HelpKeyword'
      'ActivePage'
      'ImeName'
      'DefaultExt'
      'FileName'
      'FieldName'
      'PickList'
      'DisplayFormat'
      'EditMask'
      'KeyList'
      'LookupDisplayFields'
      'DropDownSpecRow'
      'TableName'
      'DatabaseName'
      'IndexName'
      'MasterFields')
    ExtendedTranslations = <
      item
        Identifier = 'isLSP.EditLabel.Caption'
        PropertyType = tkLString
        ValuesEx = {
          CFEEEBEDFBE920EFF3F2FC20EA204C535020ECEEE4F3EBFE2E01446972726563
          74207061746820746F204C5350206D6F64756C652E01}
      end
      item
        Identifier = 'isInject.EditLabel.Caption'
        PropertyType = tkLString
        ValuesEx = {
          E8ECFF20E1E8E1EBE8EEF2EAE5E820EFE5F0E5F5E2E0F2FBE2E0FEF9E5E920F1
          EEE5E4E8EDE5EDE8FF014E616D65206F6620746865206C69627261727901}
      end
      item
        Identifier = 'isNewxor.EditLabel.Caption'
        PropertyType = tkLString
        ValuesEx = {CFF1E5E2E4EEEDE8EC204E6577786F7201C8ECFF204E6577586F7201}
      end
      item
        Identifier = 'isIgnorePorts.EditLabel.Caption'
        PropertyType = tkLString
        ValuesEx = {
          CDE5E8E3F0EEE2FBE520EFEEF0F2FB3A01446F206E6F7420696E746572636570
          7420636F6E6E656374696F6E73206F6E20706F7274733A01}
      end
      item
        Identifier = 'isClientsList.EditLabel.Caption'
        PropertyType = tkLString
        ValuesEx = {
          D1F7E8F2E0F2FC20EAEBE8E5EDF2E0ECE82FE1EEF2E0ECE820EFF0EEE3F0E0EC
          ECFB3A01496E7465726365707420636F6E6E656374696F6E7320696E20746865
          657365206170706C69636174696F6E733A01}
      end>
    Left = 16
    Top = 16
    TranslationData = {
      737443617074696F6E730D0A546653657474696E677301CDE0F1F2F0EEE9EAE8
      0153657474696E6773010D0A54616253686565743801CEE1F9E8E520EDE0F1F2
      F0EEE9EAE8015072696D6172792073657474696E6773010D0A726750726F746F
      636F6C56657273696F6E01C2E5F0F1E8FF20EFF0EEF2EEEAEEEBE02028C3EBEE
      E1E0EBFCEDEE290150726F746F636F6C2076657273696F6E2028676C6F62616C
      29010D0A47726F7570426F783101CDE0F1F2F0EEE9EAE820E4EBFF20EDEEE2EE
      E3EE20EFE5F0E5F5E2E0F7E5EDEEE3EE20F1EEE5E4E8EDE5EDE8FF0153657474
      696E677320666F72206E657720696E74657263657074656420636F6E6E656374
      696F6E73010D0A43686B4E6F4465637279707401CDE520E4E5F8E8F4F0EEE2FB
      E2E0F2FC20F2F0E0F4E8EA01446F206E6F742064656372797074207472616666
      6963010D0A43686B4368616E6765586F7201CEE1F5EEE420F1ECE5EDFB20584F
      5220EAEBFEF7E00174727920746F2067657420786F72206B657920696E20616C
      7465726E617469766520776179010D0A43686B4B616D61656C014B616D61656C
      2D48656C6C626F756E642D477261636961014B616D61656C2D48656C6C626F75
      6E642D477261636961010D0A43686B4772616369614F66660147726163696120
      286F666620736572766572292028F3F1F2E0F0E5EBEE20EDE020EB322EF0F329
      0147726163696120286C322E7275292028646F6E7420776F726B29010D0A5461
      6253686565743901CDE0F1F2F0EEE9EAE820EFE5F0E5F5E2E0F2E001496E7465
      72636570742073657474696E6773010D0A486F6F6B4D6574686F6401D1EFEEF1
      EEE120E2EDE5E4F0E5EDE8FF20E220EAEBE8E5EDF22FE1EEF23A01496E6A6563
      74207761793A010D0A43686B496E7465726365707401CFE5F0E5F5E2E0F23B20
      20C8F1EAE0F2FC20EAEBE8E5EDF2202020202020202020202020202020202020
      2020F1E5EA2E01496E746572636570743B202065616368202020202020202020
      2020202020202020202020202020202020202020202020202020202020202020
      2020207365632E010D0A43686B536F636B733501536F636B733520F1E5F0E2E5
      F001576F726B20617320736F636B3520736572766572010D0A43686B4C535049
      6E7465726365707401C8F1EFEEEBFCE7EEE2E0F2FC204C535020EFE5F0E5F5E2
      E0F201557365204C535020647269766572010D0A54616253686565743101C4EE
      EFEEEBEDE8F2E5EBFCEDEE014164646974696F6E616C010D0A43686B416C6C6F
      774578697401D0E0E7F0E5F8E8F2FC20E2FBF5EEE420E8E720EFF0EEE3F0E0EC
      ECFB20E1E5E720E7E0EFF0EEF1E001416C6C6F7720746F20657869742066726F
      6D206C32706820776974686F7574207175657374696F6E73010D0A43686B5368
      6F774C6F6757696E4F6E537461727401C0E2F2EEECE0F2E8F7E5F1EAE820EFEE
      EAE0E7FBE2E0F2FC20EEEAEDEE20EBEEE3E020EFF0E820E7E0EFF3F1EAE50153
      686F77206C6F672077696E646F77206F6E2073746172747570010D0A63686B4E
      6F4672656501CDE520E7E0EAF0FBE2E0F2FC2022EEEAEDEE2220F1EEE5E4E8ED
      E5EDE8FF20EFEEF1EBE520C4E8F1EAEEEDEDE5EAF2E001446F206E6F7420636C
      6F736520636F6E6E656374696F6E206672616D6573206F6E20646973636F6E6E
      656374010D0A63686B52617701C4E0F2FC20E2EEE7ECEEE6EDEEF1F2FC20F1EE
      F5F0E0EDFFF2FC2052415720EBEEE3E820F2F0E0F4E8EAE001416C6C6F772074
      6F2072656D656D62657220616E64207361766520524157206C6F6773010D0A42
      7574746F6E3101D1EEF5F0E0EDE8F2FC0153617665010D0A427574746F6E3201
      CEF2ECE5EDE00143616E63656C010D0A737448696E74730D0A6973436C69656E
      74734C69737401CFF0EEE3F0E0ECECFB20F320EAEEF2EEF0FBF520E1F3E4E5EC
      20EFE5F0E5F5E2E0F2FBE2E0F2FC20F2F0E0F4E8EA0150726F6772616D732077
      6861742077696C6C20626520696E7465726365707465642E010D0A43686B416C
      6C6F774578697401D0E0E7F0E5F8E0E5F220E2FBF5EEE4E8F2FC20E8E720EFF0
      EEE3F0E0ECECFB20E1E5E720EDE0E4EEE5E4EBE8E2EEE3EE2022E2FB20F3E2E5
      F0E5EDEDFB2201416C6C6F772065786974696E6720776974686F757420616E6F
      79696E67202261726520796F7520737572653F22010D0A697349676E6F726550
      6F72747301CFEEF0F2FB2C20EAEEEDEDE5EAF2FB20EDE020EAEEF2EEF0FBE520
      EDE520EDE0E4EE20EFE5F0E5F5E2E0F2FBE2E0F2FC015468697320706F727473
      2077696C6C6E277420626520696E746572636570746564010D0A43686B536F63
      6B733501CFE0EAE5F2F5E0EA20F0E0E1EEF2E0E5F220EAE0EA20EFF0EEEAF1E8
      2DF1E5F0E2E5F0016C3270682077696C6C20626520737769746368656420746F
      20776F726B20617320736F636B7320736572766572010D0A43686B4E6F446563
      7279707401CFEEEAE0E7FBE2E0E5F220F2F0E0F4E8EA20EAE0EA20EEED20EFF0
      E8F5EEE4E8F20157696C6C2073686F7720747261666669632061736973010D0A
      43686B4B616D61656C01D3F1F2E0EDEEE2E8F2FC20E4EBFF20F1E5F0E2E5F0EE
      E220F2E8EFE0204B616D61656C202D2048656C6C626F756E64202D2047726163
      6961014D75737420626520636B65636B656420666F7220746861742074797065
      206F662073657276657273010D0A43686B4772616369614F666601D3F1F2E0ED
      EEE2E8F2FC20F2EEEBFCEAEE20E4EBFF20F0F3F1F1EAEEE3EE20EEF4E8F6E8E0
      EBFCEDEEE3EE20F1E5F0E2E5F0E0204C322E5255014F6E6C7920666F72206C32
      2E7275010D0A63686B4E6F4672656501D3F1F2E0EDEEE2E8F220E0EDE0EBEEE3
      E8F7EDF3FE20EEEFF6E8FE20E4EBFF20EAE0E6E4EEE3EE20F4F0E5E9ECE020EF
      F0E8E2FFE7FBE2E0FEF9E5E3EEF1FF20EA20F1EEE5E4E8EDE5EDE8FE2E015769
      6C6C206265207365742073616D65206F7074696F6E20746F20616C6C206E6577
      20636F6E6E656374696F6E206672616D6573010D0A43686B496E746572636570
      7401D0E0E7F0E5F8E0E5F220EFEEE8F1EA20EDEEE2FBF520EAEBE8E5EDF2EEE2
      2C20E820EFE5F0E5F5E2E0F220E8F520F1EEE5E4E8EDE5EDE8E92E01416C6C6F
      7720666F2075736520696E6A6563742E646C6C20666F7220636F6E6E65637469
      6F6E7320696E74657263657074010D0A63686B52617701D0E0E7F0E5F8E8F220
      F5F0E0EDE8F2FC20E220EFE0ECFFF2E820F2EE20F7F2EE20EFF0EEE8F1F5EEE4
      E8F220EDE020F3F0EEE2EDE520F1E5F2E5E2EEE3EE20EFF0EEF2EEEAEEEBE02E
      01416C6C6F77206C32706820746F2073746F726520616C6C2072656369766564
      20616E642073656E64656420646174612069206D656D6F72792E202872617720
      7472616666696329010D0A6973496E6A65637401C1E8E1EBE8EEF2E5EAE020EE
      E1E5F1EFE5F7E8E2E0FEF9E0FF20EFE5F0E5F5E2E0F220F1EEE5E4E8EDE5EDE8
      FF01496E74657263657074206C696272617279010D0A694E6577786F7201C7E0
      E3F0F3E6E0E5F220F3EAE0E7E0EDF3FE20E1E8E1EBE8EEF2E5EAF3014C6F6164
      207468697320646C6C010D0A69734E6577786F7201C1E8E1EBE8EEF2E5EAE020
      E4EBFF20F1E5F0E2E5F0EEE220F120EDE5F1F2E0EDE4E0F0F2EDEEE920F8E8F4
      F0E0F6E8E5E9014C69627261727920666F722073657276657220776865726520
      656E6372797074696F6E20676F657320696E20756E757375616C20776179010D
      0A69734C5350014C535020C1E8E1EBE8EEF2E5EAE02028C0E1F1EEEBFEF2EDFB
      E920EFF3F2FC2C20EBE8E1EE20F0E0E7ECE5F1F2E8F2FC20E22053595354454D
      333229014C5350206C6962726172792028444952524543542057415921212121
      2129010D0A43686B53686F774C6F6757696E4F6E537461727401C020F7F2EE20
      F2F3F220EDE5EFEEEDFFF2EDEEE3EE203F203D302901736F6D657468696E6720
      77726F6E67203F010D0A47726F7570426F783101CDE520E1F3E4E5F220E2EBE8
      FFF2FC20EDE020F3E6E520F1F3F9E5F1F2E2F3FEF9E8E50157696C6C206E6F74
      2061666665637420746865206578697374696E6720636F6E6E656374696F6E73
      010D0A43686B4368616E6765586F7201CEE1F5EEE420E7E0F9E8F220ECE5EDFF
      FEF9E8F520EDE0F7E0EBFCEDFBE920EAEBFEF720F8E8F4F0E0F6E8E820584F52
      0157696C6C2074727920746F20626179706173732070726F74656374696F6E20
      6368616E67696E672074686520696E697469616C20656E6372797074696F6E20
      6B6579010D0A4A765370696E456469743101CAE0EA20F7E0F1F2EE20E8F1EAE0
      F2FC20EFF0EEE3F0E0ECECFB20E4EBFF20EFE5F0E5F5E2E0F2E001486F77206F
      6674656E206C3270682077696C6C2073656172636820666F72206E6577206C32
      20636C69656E7473010D0A69496E6A65637401C7E0E3F0F3E6E0E5F220F3EAE0
      E7E0EDF3FE20E1E8E1EBE8EEF2E5EAF3014C6F6164207468697320646C6C010D
      0A43686B4C5350496E7465726365707401C8F1EFEEEBFCE7F3E5F2204C535020
      E4EBFF20EFE5F0E5F5E2E0F2E020F2F0E0F4F4E8EAE02E014C53502070726F76
      696465722077696C6C206265207573656420666F72207472616666696320696E
      74657263657074010D0A7374446973706C61794C6162656C730D0A7374466F6E
      74730D0A546653657474696E6773014D532053616E7320536572696601010D0A
      73744D756C74694C696E65730D0A726750726F746F636F6C56657273696F6E2E
      4974656D730122D134202D2050726F746F636F6C56657273696F6E3C36363022
      2C22D135202D203636303C50726F746F636F6C56657273696F6E3C373337222C
      22D230202D20496E7465726C75646520202D203733363C50726F746F636F6C56
      657273696F6E3C383237222C22D231202D204B616D61656C2D48656C6C626F75
      6E642D477261636961202D2050726F746F636F6C56657273696F6E3E38323722
      0122D134202D2050726F746F636F6C56657273696F6E3C363630222C22D13520
      2D203636303C50726F746F636F6C56657273696F6E3C373337222C22D230202D
      20496E7465726C75646520202D203733363C50726F746F636F6C56657273696F
      6E3C383237222C22D231202D204B616D61656C2D48656C6C626F756E642D4772
      61636961202D2050726F746F636F6C56657273696F6E3E38323722010D0A486F
      6F6B4D6574686F642E4974656D7301CDE0E4E5E6EDFBE92CD1EAF0FBF2EDFBE9
      2CC0EBFCF2E5F0EDE0F2E8E2EDFBE90152656C6961626C652C436C616D2C416C
      7465726E6174697665010D0A7374446C677343617074696F6E730D0A5761726E
      696E67015761726E696E67015761726E696E67010D0A4572726F72014572726F
      72014572726F72010D0A496E666F726D6174696F6E01496E666F726D6174696F
      6E01496E666F726D6174696F6E010D0A436F6E6669726D01436F6E6669726D01
      436F6E6669726D010D0A59657301265965730126596573010D0A4E6F01264E6F
      01264E6F010D0A4F4B014F4B014F4B010D0A43616E63656C0143616E63656C01
      43616E63656C010D0A41626F7274012641626F7274012641626F7274010D0A52
      657472790126526574727901265265747279010D0A49676E6F7265012649676E
      6F7265012649676E6F7265010D0A416C6C0126416C6C0126416C6C010D0A4E6F
      20546F20416C6C014E266F20746F20416C6C014E266F20746F20416C6C010D0A
      59657320546F20416C6C0159657320746F2026416C6C0159657320746F202641
      6C6C010D0A48656C70012648656C70012648656C70010D0A7374537472696E67
      730D0A4944535F313801C2FB20F3E2E5F0E5EDFB20F7F2EE20F5EEF2E8F2E520
      E2FBE9F2E820E8E720EFF0EEE3F0E0ECECFB3F0141726520796F752073757265
      203F010D0A4944535F313901C2F1E520F1EEE5E4E8EDE5EDE8FF20EFF0E5F0E2
      F3F2F1FF2101416C6C20636F6E6E656374696F6E732077696C6C20626520636C
      6F73656421010D0A4944535F3601CFEEE4E4E5F0E6E0F2FC20EFF0EEE5EAF23A
      01537570706F727420746869732070726F6A6563743A010D0A4944535F3901D1
      F2E0F0F2F3E5F2204C32706820760153746172747570206F66204C3270682076
      010D0A73744F74686572537472696E67730D0A69734E6577786F722E54657874
      016E6577786F722E646C6C016E6577786F722E646C6C010D0A6973496E6A6563
      742E5465787401696E6A6563742E646C6C01696E6A6563742E646C6C010D0A69
      734C53502E5465787401633A5C77696E646F77735C73797374656D33325C6C73
      702E646C6C01633A5C77696E646F77735C73797374656D33325C6C73702E646C
      6C010D0A73744C6F63616C65730D0A7374436F6C6C656374696F6E730D0A7374
      43686172536574730D0A546653657474696E67730144454641554C545F434841
      525345540144454641554C545F43484152534554010D0A}
  end
end
