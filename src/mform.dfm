object MWindow: TMWindow
  Left = 0
  Top = 0
  Caption = 'Gecko Cheat Code Manager'
  ClientHeight = 446
  ClientWidth = 582
  Color = clBtnFace
  Constraints.MinHeight = 440
  Constraints.MinWidth = 590
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = TntFormResize
  OnShow = TntFormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Spliiter: TTntSplitter
    Left = 203
    Top = 41
    Height = 346
    Align = alRight
    Beveled = True
    Color = clBtnShadow
    ParentColor = False
    OnMoved = SpliiterMoved
    ExplicitLeft = 251
    ExplicitHeight = 501
  end
  object BtnPanel: TTntPanel
    Left = 0
    Top = 387
    Width = 582
    Height = 59
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      582
      59)
    object LineCnt: TTntLabel
      Left = 528
      Top = 8
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = '2 / 256'
    end
    object GCTExport: TTntButton
      Left = 3
      Top = 3
      Width = 526
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Export to GCT'
      TabOrder = 0
      OnClick = GCTExportClick
    end
    object CrGeckoOS: TTntButton
      Left = 2
      Top = 33
      Width = 578
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Create Gecko OS code list'
      TabOrder = 1
      OnClick = CrGeckoOSClick
    end
  end
  object Panel2: TTntPanel
    Left = 0
    Top = 0
    Width = 582
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      582
      41)
    object StBtn: TTntButton
      Left = 453
      Top = 4
      Width = 127
      Height = 37
      Anchors = [akTop, akRight]
      Caption = 'Store name/id'
      TabOrder = 0
      OnClick = StBtnClick
    end
    object GIDBox: TTntGroupBox
      Left = 0
      Top = 0
      Width = 197
      Height = 41
      Caption = 'Game ID'
      TabOrder = 1
      DesignSize = (
        197
        41)
      object GmId: TTntEdit
        Left = 8
        Top = 16
        Width = 181
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        MaxLength = 6
        ParentFont = False
        TabOrder = 0
        Text = 'BLNK01'
        OnChange = GmIdChange
      end
    end
    object GNameBox: TTntGroupBox
      Left = 203
      Top = 0
      Width = 248
      Height = 41
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Game Name'
      TabOrder = 2
      DesignSize = (
        248
        41)
      object GMname: TTntEdit
        Left = 5
        Top = 16
        Width = 237
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Text = 'Blank game'
        OnChange = GMnameChange
      end
    end
  end
  object CodeGroup: TTntPanel
    Left = 0
    Top = 41
    Width = 203
    Height = 346
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      203
      346)
    object CodeBox: TTntCheckListBox
      Left = 1
      Top = 2
      Width = 199
      Height = 308
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      PopupMenu = PopupMenu
      Style = lbOwnerDrawFixed
      TabOrder = 0
      OnClick = CodeBoxClick
    end
    object AddCode: TTntButton
      Left = 2
      Top = 317
      Width = 198
      Height = 25
      Anchors = [akLeft, akRight, akBottom]
      Caption = 'Add a code/comment/category'
      TabOrder = 1
      OnClick = AddCodeClick
    end
  end
  object RPanel: TTntPanel
    Left = 206
    Top = 41
    Width = 376
    Height = 346
    Align = alRight
    BevelOuter = bvNone
    Caption = 'RPanel'
    TabOrder = 3
    object HSplit: TTntSplitter
      Left = 0
      Top = 183
      Width = 376
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      Beveled = True
      Color = clBtnShadow
      ParentColor = False
      OnMoved = HSplitMoved
      ExplicitLeft = -3
      ExplicitTop = 256
    end
    object BRPan: TTntPanel
      Left = 0
      Top = 186
      Width = 376
      Height = 160
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        376
        160)
      object CommentGroup: TTntGroupBox
        Left = 6
        Top = 0
        Width = 371
        Height = 126
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Code comment (leave empty for a category)'
        TabOrder = 0
        DesignSize = (
          371
          126)
        object CodeComment: TTntMemo
          Left = 9
          Top = 44
          Width = 352
          Height = 74
          Anchors = [akLeft, akTop, akRight, akBottom]
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object CmtType: TTntComboBox
          Left = 9
          Top = 17
          Width = 172
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 1
          Text = 'Unique comment'
          OnChange = CmtTypeChange
          Items.Strings = (
            'Unique comment'
            'Import comment from:')
        end
        object IncCmtFrom: TTntComboBox
          Left = 192
          Top = 17
          Width = 173
          Height = 21
          Style = csDropDownList
          Color = clInactiveCaption
          Enabled = False
          ItemHeight = 13
          TabOrder = 2
          OnChange = IncCmtFromChange
        end
      end
      object StoreMods: TTntButton
        Left = 4
        Top = 132
        Width = 370
        Height = 25
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'Store modifications'
        TabOrder = 1
        OnClick = StoreModsClick
      end
    end
    object URPan: TTntPanel
      Left = 0
      Top = 0
      Width = 376
      Height = 183
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        376
        183)
      object CodeNameBox: TTntGroupBox
        Left = 6
        Top = 2
        Width = 368
        Height = 43
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Code/Comment/Category name'
        TabOrder = 0
        DesignSize = (
          368
          43)
        object CodeName: TTntEdit
          Left = 8
          Top = 16
          Width = 352
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
      end
      object CodeContBox: TTntGroupBox
        Left = 6
        Top = 45
        Width = 369
        Height = 135
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Code contents (simply leave empty to add a comment/category)'
        TabOrder = 1
        DesignSize = (
          369
          135)
        object CodeContents: TTntMemo
          Left = 9
          Top = 15
          Width = 351
          Height = 112
          Anchors = [akLeft, akTop, akRight, akBottom]
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
  end
  object MainMenu: TTntMainMenu
    Left = 132
    Top = 76
    object FileMenu: TTntMenuItem
      Caption = 'File'
      object NewL: TTntMenuItem
        Caption = 'New list'
        OnClick = NewLClick
      end
      object OpenTXTfile: TTntMenuItem
        Caption = 'Open TXT file'
        OnClick = OpenTXTfileClick
      end
      object StoreTXT: TTntMenuItem
        Caption = 'Save as TXT file'
        OnClick = StoreTXTClick
      end
      object ExporttoGCT: TTntMenuItem
        Caption = 'Export to GCT'
        OnClick = GCTExportClick
      end
      object Closeprog: TTntMenuItem
        Caption = 'Close program'
        OnClick = CloseprogClick
      end
    end
    object OptionsMenu: TTntMenuItem
      Caption = 'Options'
      object LangMenu: TTntMenuItem
        Caption = 'Language'
      end
    end
    object AboutMenu: TTntMenuItem
      Caption = '?'
      object AboutSelect: TTntMenuItem
        Caption = 'About'
        OnClick = AboutSelectClick
      end
    end
  end
  object OpenDia: TTntOpenDialog
    DefaultExt = '.txt'
    Filter = 'TXT files (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofEnableSizing, ofForceShowHidden]
    Left = 132
    Top = 48
  end
  object PopupMenu: TTntPopupMenu
    Left = 104
    Top = 48
    object RemoveSel: TTntMenuItem
      Caption = 'Delete all selected'
      OnClick = RemoveSelClick
    end
    object N2: TTntMenuItem
      Caption = '-'
    end
    object AllDown: TTntMenuItem
      Caption = 'Move down all selected'
      OnClick = AllDownClick
    end
    object AllUp: TTntMenuItem
      Caption = 'Move up all selected'
      OnClick = AllUpClick
    end
    object N1: TTntMenuItem
      Caption = '-'
    end
    object DuplicateSelected: TTntMenuItem
      Caption = 'Duplicate all selected'
      OnClick = DuplicateSelectedClick
    end
    object N3: TTntMenuItem
      Caption = '-'
    end
    object BottomSend: TTntMenuItem
      Caption = 'Send to bottom of list'
      OnClick = BottomSendClick
    end
  end
  object SaveTXT: TTntSaveDialog
    DefaultExt = '.txt'
    Filter = 'TXT files (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 104
    Top = 76
  end
  object CountTimer: TTimer
    Interval = 100
    OnTimer = CountTimerTimer
    Left = 104
    Top = 104
  end
  object XPManifest1: TXPManifest
    Left = 132
    Top = 216
  end
end
