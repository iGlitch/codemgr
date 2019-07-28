unit WideFileCtrl;

interface

uses FileCtrl,Controls;

function WideSelectDirectory(const Caption: WideString; const Root: WideString;
  var Directory: WideString; Options: TSelectDirExtOpts = [sdNewUI]; Parent: TWinControl = nil): Boolean;


implementation

uses ShlObj,ActiveX,Windows,Forms,Dialogs,SysUtils,Consts,TntSysUtils;

type
  TSelectDirCallback = class(TObject)
  private
    FDirectory: WideString;
  protected
    function SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer;
  public
    constructor Create(const ADirectory: WideString);
  end;

{ TSelectDirCallback }

function SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
  Result := TSelectDirCallback(lpData).SelectDirCB(Wnd, uMsg, lParam, lpData);
end;


constructor TSelectDirCallback.Create(const ADirectory: WideString);
begin
  inherited Create;
  FDirectory := ADirectory;
end;

function TSelectDirCallback.SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer;
var
  Rect: TRect;
  Monitor: TMonitor;
begin
  Result := 0;
  if uMsg = BFFM_INITIALIZED then
  begin
    Monitor := Screen.MonitorFromWindow(Application.MainForm.Handle);
    GetWindowRect(Wnd, Rect);
    SetWindowPos(Wnd, 0, (Monitor.Width - (Rect.Right - Rect.Left)) div 2,
      (Monitor.Height - (Rect.Bottom - Rect.Top)) div 2, 0, 0, SWP_NOSIZE or SWP_NOZORDER);
    if FDirectory <> '' then
      SendMessage(Wnd, BFFM_SETSELECTIONW, Integer(True), Windows.LPARAM(PWideChar(FDirectory)));
  end else if uMsg = BFFM_VALIDATEFAILED then
  begin
    MessageDlg(Format(SInvalidPath, [PChar(lParam)]), mtError, [mbOK], 0);
    Result := 1;
  end;
end;

function WideSelectDirectory(const Caption: WideString; const Root: WideString;
  var Directory: WideString; Options: TSelectDirExtOpts; Parent: TWinControl): Boolean;
var
  WindowList: Pointer;
  BrowseInfo: TBrowseInfoW;
  Buffer: PWideChar;
  OldErrorMode: Cardinal;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
  CoInitResult: HRESULT;
  SelectDirCallback: TSelectDirCallback;
begin
  Result := False;
  if not WideDirectoryExists(Directory) then
    Directory := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      RootItemIDList := nil;
      if Root <> '' then
      begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(Application.Handle, nil,
          POleStr(Root), Eaten, RootItemIDList, Flags);
      end;
      with BrowseInfo do
      begin
        if (Parent = nil) or not Parent.HandleAllocated then
          hwndOwner := Application.Handle
        else
          hwndOwner := Parent.Handle;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PWideChar(Caption);
        ulFlags := BIF_EDITBOX;
        if sdNewUI in Options then
          ulFlags := ulFlags or BIF_NEWDIALOGSTYLE;
        if not (sdNewFolder in Options) then
          ulFlags := ulFlags or BIF_NONEWFOLDERBUTTON;
        if sdShowEdit in Options then
          ulFlags := ulFlags or BIF_EDITBOX;
        if sdShowShares in Options then
          ulFlags := ulFlags or BIF_SHAREABLE;
        if sdShowFiles in Options then
          ulFlags := ulFlags or BIF_BROWSEINCLUDEFILES;
        if sdValidateDir in Options then
          ulFlags := ulFlags or BIF_VALIDATE;
        lpfn := SelectDirCB;
      end;
      SelectDirCallback := TSelectDirCallback.Create(Directory);
      try
        BrowseInfo.lParam := Integer(SelectDirCallback);
        if sdNewUI in Options then
        begin
          CoInitResult := CoInitializeEx(nil, COINIT_APARTMENTTHREADED);
          if CoInitResult = RPC_E_CHANGED_MODE then
            BrowseInfo.ulFlags := BrowseInfo.ulFlags and not BIF_NEWDIALOGSTYLE;
        end;
        try
          WindowList := DisableTaskWindows(0);
          OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
          try
            ItemIDList := SHBrowseForFolderW(BrowseInfo);
          finally
            SetErrorMode(OldErrorMode);
            EnableTaskWindows(WindowList);
          end;
        finally
          if sdNewUI in Options then
            CoUninitialize;
        end;
      finally
        SelectDirCallback.Free;
      end;
      Result :=  ItemIDList <> nil;
      if Result then
      begin
        ShGetPathFromIDListW(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

end.
