object GOSList: TGOSList
  Left = 0
  Top = 0
  Caption = 'Gecko OS Code List'
  ClientHeight = 430
  ClientWidth = 621
  Color = clBtnFace
  Constraints.MinHeight = 457
  Constraints.MinWidth = 629
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = TntFormCreate
  DesignSize = (
    621
    430)
  PixelsPerInch = 96
  TextHeight = 13
  object OcarinaBox: TTntGroupBox
    Left = 0
    Top = 0
    Width = 241
    Height = 201
    Caption = 'Ocarina Code List'
    TabOrder = 0
    DesignSize = (
      241
      201)
    object MainList: TTntListBox
      Left = 8
      Top = 16
      Width = 225
      Height = 177
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 0
      OnClick = MainListClick
      ExplicitHeight = 189
    end
  end
  object GOSBox: TTntGroupBox
    Left = 0
    Top = 207
    Width = 241
    Height = 223
    Anchors = [akLeft, akTop, akBottom]
    Caption = 'Gecko OS code list'
    TabOrder = 1
    DesignSize = (
      241
      223)
    object GeckoList: TTntListBox
      Left = 8
      Top = 41
      Width = 225
      Height = 133
      Style = lbOwnerDrawFixed
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = clWhite
      ItemHeight = 13
      PopupMenu = GOSPopup
      TabOrder = 0
      OnClick = GeckoListClick
    end
    object AddHeadLine: TTntButton
      Left = 8
      Top = 177
      Width = 225
      Height = 20
      Anchors = [akLeft, akRight, akBottom]
      Caption = 'Add Headline/Code category'
      TabOrder = 1
      OnClick = AddHeadLineClick
      ExplicitTop = 165
    end
    object ExportList: TTntButton
      Left = 8
      Top = 200
      Width = 225
      Height = 20
      Anchors = [akLeft, akRight, akBottom]
      Caption = 'Export Code List'
      TabOrder = 2
      OnClick = ExportListClick
      ExplicitTop = 188
    end
    object ImportList: TTntButton
      Left = 8
      Top = 15
      Width = 225
      Height = 20
      Anchors = [akLeft, akRight, akBottom]
      Caption = 'Import code list'
      TabOrder = 3
      OnClick = ImportListClick
    end
  end
  object StatusBox: TTntGroupBox
    Left = 247
    Top = 0
    Width = 374
    Height = 33
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Code status'
    TabOrder = 2
    DesignSize = (
      374
      33)
    object CodeStatus: TTntLabel
      Left = 8
      Top = 13
      Width = 357
      Height = 16
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'No code selected'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object ContentBox: TTntGroupBox
    Left = 247
    Top = 35
    Width = 374
    Height = 66
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Orginal code content'
    TabOrder = 3
    DesignSize = (
      374
      66)
    object CodeContent: TTntMemo
      Left = 8
      Top = 12
      Width = 357
      Height = 49
      Anchors = [akLeft, akTop, akRight]
      Color = 11513855
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object EditBox: TTntGroupBox
    Left = 247
    Top = 102
    Width = 374
    Height = 328
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Editing options'
    TabOrder = 4
    DesignSize = (
      374
      328)
    object PlaceHolderLabel: TTntLabel
      Left = 8
      Top = 20
      Width = 165
      Height = 13
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Placeholders'
    end
    object PlcValuesLabel: TTntLabel
      Left = 184
      Top = 20
      Width = 181
      Height = 13
      Alignment = taCenter
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'Placeholder values'
    end
    object CodeNmLabel: TTntLabel
      Left = 8
      Top = 146
      Width = 170
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = 'Code name:'
    end
    object CodeCatLabel: TTntLabel
      Left = 8
      Top = 171
      Width = 170
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = 'Code category:'
    end
    object CodeCatInfo: TTntLabel
      Left = 8
      Top = 192
      Width = 357
      Height = 29
      Alignment = taCenter
      Anchors = [akLeft, akRight, akBottom]
      AutoSize = False
      Caption = 
        'Only one code of each code category is selectable!\nCodes in cod' +
        'e category 0 are freely selectable!'
    end
    object PlcName: TTntEdit
      Left = 184
      Top = 36
      Width = 181
      Height = 21
      Anchors = [akTop, akRight]
      Enabled = False
      ReadOnly = True
      TabOrder = 0
    end
    object PlcHolderList: TTntListBox
      Left = 8
      Top = 36
      Width = 165
      Height = 81
      Anchors = [akLeft, akTop, akRight, akBottom]
      Enabled = False
      ItemHeight = 13
      Sorted = True
      TabOrder = 1
      OnClick = PlcHolderListClick
    end
    object PlcInput: TTntEdit
      Left = 184
      Top = 62
      Width = 181
      Height = 21
      Anchors = [akTop, akRight]
      CharCase = ecUpperCase
      Enabled = False
      TabOrder = 2
      OnChange = PlcInputChange
      OnKeyPress = PlcInputKeyPress
    end
    object SetPlcValue: TTntButton
      Left = 184
      Top = 97
      Width = 181
      Height = 20
      Anchors = [akRight, akBottom]
      Caption = 'Set placeholder value'
      Enabled = False
      TabOrder = 3
      OnClick = SetPlcValueClick
    end
    object PlcContent: TTntMemo
      Left = 8
      Top = 223
      Width = 357
      Height = 52
      Anchors = [akLeft, akRight, akBottom]
      Color = 11513855
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object MMasterCode: TTntCheckBox
      Left = 183
      Top = 123
      Width = 175
      Height = 17
      Anchors = [akRight, akBottom]
      Caption = 'Master code (always on)'
      Enabled = False
      TabOrder = 5
      OnClick = MMasterCodeClick
    end
    object MEnabled: TTntCheckBox
      Left = 8
      Top = 123
      Width = 175
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = 'Enabled'
      Enabled = False
      TabOrder = 6
    end
    object ACodeNm: TTntEdit
      Left = 184
      Top = 142
      Width = 181
      Height = 21
      Anchors = [akRight, akBottom]
      Enabled = False
      TabOrder = 7
    end
    object ACodeCat: TSpinEdit
      Left = 184
      Top = 167
      Width = 181
      Height = 22
      Anchors = [akRight, akBottom]
      Enabled = False
      MaxValue = 65535
      MinValue = 0
      TabOrder = 8
      Value = 0
    end
    object AddRCodeToGOSList: TTntButton
      Left = 8
      Top = 305
      Width = 357
      Height = 20
      Anchors = [akLeft, akRight, akBottom]
      Caption = 'Add/Edit code to/in Gecko OS list'
      Enabled = False
      TabOrder = 9
      OnClick = AddCodeTooList
      ExplicitTop = 263
    end
    object InsertCode: TTntButton
      Left = 8
      Top = 281
      Width = 357
      Height = 20
      Anchors = [akLeft, akRight, akBottom]
      Caption = 
        'Insert Code after currently selected (on top if no code selected' +
        ')'
      Enabled = False
      TabOrder = 10
      OnClick = InsertCodeClick
    end
  end
  object OpenGOSList: TTntOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofForceShowHidden]
    Left = 200
    Top = 20
  end
  object GOSPopup: TTntPopupMenu
    OnPopup = GOSPopupPopup
    Left = 200
    Top = 52
    object DelCode: TTntMenuItem
      Caption = 'Delete code'
      OnClick = DelCodeClick
    end
    object MoveUpCode: TTntMenuItem
      Caption = 'Move up'
      OnClick = MoveUpCodeClick
    end
    object MoveDownCode: TTntMenuItem
      Caption = 'Move down'
      OnClick = MoveDownCodeClick
    end
  end
end
