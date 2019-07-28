unit WideDialogs;

interface

function WideMessageBox(const TextS, CaptionS: WideString; Flags: Longint): Integer;
function WideInputQuery(const ACaption, APrompt: WideString; var Value: WideString): Boolean;


implementation

uses Windows,SysUtils,MultiMon,Forms,TntForms,TntStdCtrls,TntDialogs,Graphics,
 langdata,Controls;

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of WideChar;
  tm: TTextMetric;
begin
  for I := 0 to 25 do Buffer[I] := WideChar(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := WideChar(I + Ord('a'));
  GetTextMetrics(Canvas.Handle, tm);
  GetTextExtentPointW(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := (Result.X div 26 + 1) div 2;
  Result.Y := tm.tmHeight;
end;



function WideInputQuery(const ACaption, APrompt: WideString; var Value: WideString): Boolean;
var
  Form: TTntForm;
  Prompt: TTntLabel;
  Edit: TTntEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Result := False;
  Form := TTntForm.Create(Application);
  with Form do begin
    try
      BorderStyle := bsDialog; // By doing this first, it will work on WINE.
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      Caption := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      Position := poScreenCenter;
      Prompt := TTntLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        Caption := APrompt;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := True;
      end;
      Edit := TTntEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        Text := Value;
        SelectAll;
      end;
      ButtonTop := Edit.Top + Edit.Height + 15;
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TTntButton.Create(Form) do
      begin
        Parent := Form;
        Caption := GetLangString('DIALOGOK','Ok');
        ModalResult := mrOk;
        Default := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TTntButton.Create(Form) do
      begin
        Parent := Form;
        Caption := GetLangString('DIALOGCANCEL','Cancel');
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15, ButtonWidth,
          ButtonHeight);
        Form.ClientHeight := Top + Height + 13;
      end;
      if ShowModal = mrOk then
      begin
        Value := Edit.Text;
        Result := True;
      end;
    finally
      Form.Free;
    end;
  end;
end;

function WideMessageBox(const TextS, CaptionS: WideString; Flags: Longint): Integer;
var
  Text, Caption:PWideChar;
  ActiveWindow, TaskActiveWindow: HWnd;
  WindowList: Pointer;
  MBMonitor, AppMonitor: HMonitor;
  MonInfo: TMonitorInfo;
  Rect: TRect;
  FocusState: TFocusState;
begin
  Text:=PWideChar(TextS);
  Caption:=PWideChar(CaptionS);
  ActiveWindow := Application.MainForm.Handle;
  if ActiveWindow = 0 then
    TaskActiveWindow := Application.Handle
  else
    TaskActiveWindow := ActiveWindow;
  MBMonitor := MonitorFromWindow(ActiveWindow, MONITOR_DEFAULTTONEAREST);
  AppMonitor := MonitorFromWindow(Application.Handle, MONITOR_DEFAULTTONEAREST);
  if MBMonitor <> AppMonitor then
  begin
    MonInfo.cbSize := Sizeof(TMonitorInfo);
    GetMonitorInfo(MBMonitor, @MonInfo);
    GetWindowRect(Application.Handle, Rect);
    SetWindowPos(Application.Handle, 0,
      MonInfo.rcMonitor.Left + ((MonInfo.rcMonitor.Right - MonInfo.rcMonitor.Left) div 2),
      MonInfo.rcMonitor.Top + ((MonInfo.rcMonitor.Bottom - MonInfo.rcMonitor.Top) div 2),
      0, 0, SWP_NOACTIVATE or SWP_NOREDRAW or SWP_NOSIZE or SWP_NOZORDER);
  end;
  WindowList := DisableTaskWindows(ActiveWindow);
  FocusState := SaveFocusState;
  if Application.UseRightToLeftReading then Flags := Flags or MB_RTLREADING;
  try
    Result := Windows.MessageBoxW(TaskActiveWindow, Text, Caption, Flags);
  finally
    if MBMonitor <> AppMonitor then
      SetWindowPos(Application.Handle, 0,
        Rect.Left + ((Rect.Right - Rect.Left) div 2),
        Rect.Top + ((Rect.Bottom - Rect.Top) div 2),
        0, 0, SWP_NOACTIVATE or SWP_NOREDRAW or SWP_NOSIZE or SWP_NOZORDER);
    EnableTaskWindows(WindowList);
    SetActiveWindow(ActiveWindow);
    RestoreFocusState(FocusState);
  end;
end;



end.
