object SaveForm: TSaveForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'GCT export manager'
  ClientHeight = 198
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = TntFormShow
  DesignSize = (
    432
    198)
  PixelsPerInch = 96
  TextHeight = 13
  object HardGroup: TTntGroupBox
    Left = 0
    Top = 0
    Width = 431
    Height = 45
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Store to file'
    TabOrder = 0
    DesignSize = (
      431
      45)
    object StoreHard: TTntButton
      Left = 8
      Top = 17
      Width = 414
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Store to file'
      TabOrder = 0
      OnClick = StoreHardClick
    end
  end
  object SDGroup: TTntGroupBox
    Left = 0
    Top = 48
    Width = 431
    Height = 117
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Store to SD card'
    TabOrder = 1
    DesignSize = (
      431
      117)
    object DriveLabel: TTntLabel
      Left = 8
      Top = 20
      Width = 126
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Drive letter:'
    end
    object StoreSecure: TTntButton
      Left = 8
      Top = 85
      Width = 414
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Store'
      TabOrder = 0
      OnClick = StoreSecureClick
    end
    object DriveSel: TShellComboBox
      Left = 140
      Top = 17
      Width = 282
      Height = 22
      Root = 'rfMyComputer'
      UseShellImages = True
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnChange = DriveSelChange
    end
    object StoreTo: TTntPanel
      Left = 8
      Top = 45
      Width = 412
      Height = 34
      Caption = 'No valid drive selected'
      TabOrder = 2
    end
  end
  object CncButton: TTntButton
    Left = 0
    Top = 171
    Width = 431
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object SaveDialog: TTntSaveDialog
    DefaultExt = '.gct'
    Filter = 'GCT files (*.gct)|*.gct|All files (*.*)|*.*'
    Left = 256
    Top = 44
  end
end
