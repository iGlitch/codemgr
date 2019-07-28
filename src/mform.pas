unit mform;

interface

{$I list.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, TntCheckLst, TntStdCtrls, TntDialogs,
  Menus, TntMenus, codelistmgmt,TntForms, ExtCtrls, TntExtCtrls,tntinifiles,
  XPMan;

type
  TMWindow = class(TTntForm)
    CodeBox: TTntCheckListBox;
    GIDBox: TTntGroupBox;
    GmId: TTntEdit;
    GNameBox: TTntGroupBox;
    GMname: TTntEdit;
    MainMenu: TTntMainMenu;
    FileMenu: TTntMenuItem;
    OpenTXTfile: TTntMenuItem;
    Closeprog: TTntMenuItem;
    StBtn: TTntButton;
    OpenDia: TTntOpenDialog;
    AddCode: TTntButton;
    PopupMenu: TTntPopupMenu;
    RemoveSel: TTntMenuItem;
    GCTExport: TTntButton;
    BtnPanel: TTntPanel;
    Panel2: TTntPanel;
    CodeGroup: TTntPanel;
    RPanel: TTntPanel;
    Spliiter: TTntSplitter;
    ExporttoGCT: TTntMenuItem;
    StoreTXT: TTntMenuItem;
    SaveTXT: TTntSaveDialog;
    AllDown: TTntMenuItem;
    AllUp: TTntMenuItem;
    DuplicateSelected: TTntMenuItem;
    N1: TTntMenuItem;
    N2: TTntMenuItem;
    N3: TTntMenuItem;
    BottomSend: TTntMenuItem;
    AboutMenu: TTntMenuItem;
    AboutSelect: TTntMenuItem;
    NewL: TTntMenuItem;
    BRPan: TTntPanel;
    CommentGroup: TTntGroupBox;
    CodeComment: TTntMemo;
    CmtType: TTntComboBox;
    IncCmtFrom: TTntComboBox;
    StoreMods: TTntButton;
    HSplit: TTntSplitter;
    URPan: TTntPanel;
    CodeNameBox: TTntGroupBox;
    CodeName: TTntEdit;
    CodeContBox: TTntGroupBox;
    CodeContents: TTntMemo;
    OptionsMenu: TTntMenuItem;
    LangMenu: TTntMenuItem;
    CrGeckoOS: TTntButton;
    LineCnt: TTntLabel;
    CountTimer: TTimer;
    XPManifest1: TXPManifest;
    procedure CountTimerTimer(Sender: TObject);
    procedure CrGeckoOSClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure HSplitMoved(Sender: TObject);
    procedure NewLClick(Sender: TObject);
    procedure AboutSelectClick(Sender: TObject);
    procedure BottomSendClick(Sender: TObject);
    procedure DuplicateSelectedClick(Sender: TObject);
    procedure AllUpClick(Sender: TObject);
    procedure AllDownClick(Sender: TObject);
    procedure GMnameChange(Sender: TObject);
    procedure GmIdChange(Sender: TObject);
    procedure StoreTXTClick(Sender: TObject);
    procedure TntFormResize(Sender: TObject);
    procedure SpliiterMoved(Sender: TObject);
    procedure IncCmtFromChange(Sender: TObject);
    procedure CmtTypeChange(Sender: TObject);
    procedure CloseprogClick(Sender: TObject);
    procedure GCTExportClick(Sender: TObject);
    procedure RemoveSelClick(Sender: TObject);
    procedure AddCodeClick(Sender: TObject);
    procedure StoreModsClick(Sender: TObject);
    procedure StBtnClick(Sender: TObject);
    procedure CodeBoxClick(Sender: TObject);
    procedure OpenTXTfileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function CodesModified(old:integer):boolean;
  private
    NoFocus:boolean;
    function StoreMod:boolean;
    procedure UnsetFocus;
    procedure LangCall(Language:WideString);
    { Private-Deklarationen }
  public
    CodeData:TListManager;
    StoreIni:TTntIniFile;
    { Public-Deklarationen }
  end;

var
  MWindow: TMWindow;

implementation

{$R *.dfm}

uses list,WideDialogs,tntclasses,savequest,tntsysutils,langdata
 {$IFNDEF NOGOSLIST},geckooslist{$ENDIF}
 ;

procedure TMWindow.AboutSelectClick(Sender: TObject);
begin
 WideShowMessage(GetLangString('CREDITS','Gecko Cheat Code Manager 1.2'#13#10#13#10+
 'Code list concept by James0x57'#13#10+
 'Code Manager by Link'#13#10+
 'Gecko OS by brkirch and Nuke')+#13#10#13#10+
 'This product is not sponsored, endorsed or anything by Nintendo!');
end;

procedure TMWindow.AddCodeClick(Sender: TObject);
var name:WideString;
     new:TCodeContent;
begin
 name:=GetLangString('NEWCODE','New Code');
 if WideInputQuery(GetLangString('QUESTION','Prompt!'),
  GetLangString('NEWNAME','Please enter the code name!'),name) then
  begin
   new:=TCodeContent.Create;
   new.name:=name;
   CodeData.Add(new);
   FreeAndNil(new);
  end;
end;

procedure TMWindow.CloseprogClick(Sender: TObject);
begin
 Close;
end;

procedure TMWindow.CmtTypeChange(Sender: TObject);
var i:integer;
begin
 CodeComment.Clear;
 if CmtType.ItemIndex=0 then
  begin
   IncCmtFrom.Clear;
   IncCmtFrom.Enabled:=false;
   IncCmtFrom.Color:=clInactiveCaption;
   CodeComment.ReadOnly:=false;
  end
 else
  begin
   IncCmtFrom.Clear;
   IncCmtFrom.Enabled:=true;
   IncCmtFrom.Color:=clWindow;
   CodeComment.ReadOnly:=true;
   for i := 0 to CodeData.Count - 1 do
    if CodeData[i].contentType=ctComment then
     IncCmtFrom.Items.Add(CodeData[i].name);
  end;
end;

procedure TMWindow.AllDownClick(Sender: TObject);
var i:integer;
begin
 for i := CodeBox.Count-1 downto 0 do
  if CodeBox.Selected[i] then
   begin
     if i=CodeBox.Count-1 then
      begin
        WideShowMessage(GetLangString('LOWUNMOVABLE','You can''t move down the lowest element in the list!'));
        exit;
      end;
     CodeData.Move(i,i+1);
   end;
 UnsetFocus;
end;

procedure TMWindow.AllUpClick(Sender: TObject);
var i:integer;
begin
 for i := 0 to CodeBox.Count-1 do
  if CodeBox.Selected[i] then
   begin
     if i=0 then
      begin
        WideShowMessage(GetLangString('HIGHUNMOVABLE','You can''t move up the highest element in the list!'));
        exit;
      end;
     CodeData.Move(i,i-1);
   end;
 UnsetFocus;
end;

procedure TMWindow.NewLClick(Sender: TObject);
begin
 CodeData.Clear;
end;

procedure TMWindow.BottomSendClick(Sender: TObject);
var i:integer;
   bt:integer;
   mv:integer;
begin
 bt:=CodeBox.Count-1;
 mv:=0;
 for i := bt downto 0 do
  if CodeBox.Selected[i] then
   begin
     CodeData.Move(i,bt-mv);
     Inc(mv);
   end;
 UnsetFocus;
end;



procedure TMWindow.CodeBoxClick(Sender: TObject);
var old,new:integer;
chg:boolean;
Res:integer;
begin
 old:=CodeData.Selected;
 new:=CodeBox.ItemIndex;

 if old<>-1 then
  CodeData[old].enabled:=CodeBox.Checked[old];
 if new<>-1 then
  CodeData[new].enabled:=CodeBox.Checked[new];

 if noFocus then
  begin
   noFocus:=false;
   CodeData.SelectCode(new);
   exit;
  end;
 if new=old then exit;
 if old=-1 then
  CodeData.SelectCode(new)
 else begin
   chg:=CodesModified(old);
   if chg then
    begin
     Res:=WideMessageBox(GetLangString('CODECHANGE','The codes have changed, do you want to store them?'#13#10+
     'This modification will only be done in application memory, your TXT file won''t be modified!'#13#10+
     'If you deny, the code changes will be dropped!'),
     GetLangString('ATTENTION','Caution'),MB_YESNOCANCEL or MB_ICONQUESTION);
     if Res=ID_YES then
      begin
       if StoreMod then
        CodeData.SelectCode(new)
      end
     else if Res=ID_NO then
      CodeData.SelectCode(new)
     else
      begin
       CodeBox.ItemIndex:=old;
      end;
    end
   else
    CodeData.SelectCode(new)
  end;
end;

function TMWindow.CodesModified(old: integer): boolean;
begin
 Result:=false;
 Result:=Result or (CodeName.Text<>CodeData[old].name);
 Result:=Result or (CodeContents.Text<>CodeData[old].Codes.Text);
 Result:=Result or ((not CodeComment.ReadOnly) and
                (CodeComment.Text<>CodeData[old].Comments.Text));
 Result:=Result or (CodeComment.ReadOnly and ((CodeData[old].CommentCount=0) or
                (('<!--[!include:'+IncCmtFrom.Text+']-->')<>CodeData[old].Comments[0])));
end;

procedure TMWindow.CountTimerTimer(Sender: TObject);
begin
 if Assigned(CodeData) then
  LineCnt.Caption:=IntToStr(CodeData.ActiveCodeLineCount+2)+' / 256';
end;

procedure TMWindow.CrGeckoOSClick(Sender: TObject);
begin
 {$IFNDEF NOGOSLIST}
  GOSList.Show;
 {$ENDIF}
end;

procedure TMWindow.DuplicateSelectedClick(Sender: TObject);
var CodeInfo:TCodeContent;
   Duplicate:TCodeContent;
           i:integer;
begin
 for I := 0 to CodeData.Count - 1 do
  if CodeBox.Selected[i] then
   begin
    CodeInfo:=CodeData[i];
    Duplicate:=DuplicateCode(CodeInfo);
    Duplicate.name:=CodeInfo.name+' ('+GetLangString('DUPLICATED','duplicated')+')';
    CodeData.Add(Duplicate);
    FreeAndNil(Duplicate);
   end;
 UnsetFocus;
end;

procedure TMWindow.FormCreate(Sender: TObject);
begin
 NoFocus:=false;
 CodeData:=TListManager.Create;
 CodeData.CodeBox:=CodeBox;
 CodeBox.MultiSelect:=true;
 CodeData.GameIdEditField:=GmId;
 CodeData.GameNameEditField:=GMname;
 CodeData.CodeNameEditField:=CodeName;
 CodeData.CodesMemo:=CodeContents;
 CodeData.CommentMemo:=CodeComment;
 CodeData.UniqueOrNotCBox:=CmtType;
 CodeData.NotUniqueSelectionBox:=IncCmtFrom;
 SaveTXT.InitialDir:=WideExtractFilePath(TntApplication.ExeName);
 OpenDia.InitialDir:=WideExtractFilePath(TntApplication.ExeName);
 LangCallBack:=LangCall;
 StoreIni:=TTntIniFile.Create(WideChangeFileExt(TntApplication.ExeName,'.ini'));
 {$IFDEF NOGOSLIST}
  CrGeckoOS.Visible:=false;
  BtnPanel.Height:=29;
 {$ELSE}
  CrGeckoOS.Visible:=true;
  BtnPanel.Height:=59;
 {$ENDIF}
end;

procedure TMWindow.GCTExportClick(Sender: TObject);

var output:TTntMemoryStream;

 procedure SaveToFile(filename:WideString);
 begin
  try
   output.SaveToFile(filename);
   WideShowMessage(WideFormat(
    GetLangString('STOREDTO','GCT file stored to: %s'),[filename]));
  except
   WideShowMessage(GetLangString('SAVEERROR','Saving error!'));
  end;
 end;

var mr:TModalResult;
   err:WideString;
     i:integer;
   gid:WideString;
begin
 SaveForm.SetUpDialog('.gct',GetLangString('GCTFILES','Ocarina code file'));
 SaveForm.StoreIni:=StoreIni;
 
 if (CodeData.Selected<>-1) and CodesModified(CodeData.Selected) then
  if WideMessageBox(GetLangString('CHANGEBEFOREEXPORT','Codes have been modified. Do you want to store modifications '
  +'to application memory them before export?'),
   'Store?',MB_YESNO or MB_ICONQUESTION)=ID_YES then
     StoreMod;
  
 output:=TTntMemoryStream.Create;
 try CodeData.SerializeToGCT(output);
 except on E:ECodeExportException do
    begin
      err:=GetLangString('CODEERROR1','Error at code: ')+#13#10#13#10;
      for I := 0 to CodeData[E.ErrorCode].Codes.Count-1 do
       err:=err+CodeData[E.ErrorCode].Codes[i]+#13#10;
      err:=err+#13#10+GetLangString('CODEERROR2','Maybe you have to replace placeholders first (like XX)');
      WideShowMessage(err);
      FreeAndNil(output);
      exit;
    end;
 end;
 if output.Size>=2048 then
  begin
   mr:=WideMessageBox(GetLangString('TOOMANYCODES','More than 256 lines of code active!'#13#10'Do you want to continue anyway?'),
   GetLangString('ERROR','Error!'),MB_YESNO);
   if mr=ID_NO then
    begin
     FreeAndNil(output);
     exit;
    end;
  end;
 if output.Size<=16 then
  begin
   WideShowMessage(GetLangString('NOSELECTION','No codes selected!'));
   FreeAndNil(output);
   exit;
  end;
 if (length(CodeData.gameid)<>6) and (length(CodeData.gameid)<>4) then
  begin
   if WideMessageBox(GetLangString('NOGAMEID','No game ID given! Do you want to continue anyway?'),
     GetLangString('ERROR','Error!'),
    MB_YESNO or MB_ICONQUESTION)=ID_YES then
     if SaveForm.SaveDialog.Execute then
      SaveToFile(SaveForm.SaveDialog.FileName);
  end
 else
  begin
   gid:=CodeData.gameid;
   if length(gid)=6 then
    begin
     if Copy(gid,5,2) = '00' then
      gid:=Copy(gid,1,4);
    end;
   SaveForm.outname:='data\gecko\codes\'+gid+'.gct';
   mr:=SaveForm.ShowModal;
   if (mr=mrOk) and (SaveForm.outfile<>'') then
    begin
     SaveToFile(SaveForm.outfile);
    end;
  end;
 FreeAndNil(Output);
 (*if SaveDia.Execute then
  begin
   if (CodeData.Selected<>-1) and CodesModified(CodeData.Selected) then
    if MBoxW('Codes have been modified. Do you want to save them before export?',
       'Store?',MB_YESNO or MB_ICONQUESTION)=ID_YES then
     StoreMod;
   fn:=SaveDia.FileName;
   if FileExists(fn) then
    DeleteFile(fn);
   test:=TFileStream.Create(fn,fmCreate);
   try CodeData.SerializeToGCT(test);
   except on E:ECodeExportException do
    begin
      err:='Error at code: '#13#10;
      for I := 0 to CodeData[E.ErrorCode].Codes.Count-1 do
       err:=err+CodeData[E.ErrorCode].Codes[i]+#13#10;
      err:=err+'Maybe you have to replace placeholders first (like XX)';
      ShowMessage(err);
    end
   else
    begin
      ShowMessage('Gen error');
    end;
   end;
   FreeAndNIL(test);
  end;*)
end;

procedure TMWindow.GmIdChange(Sender: TObject);
begin
 CodeData.gameid:=GmId.Text;
end;

procedure TMWindow.GMnameChange(Sender: TObject);
begin
 CodeData.gamename:=Gmname.Text;
end;

procedure TMWindow.HSplitMoved(Sender: TObject);
begin
 if URPan.Height<160 then
  begin
   BRPan.Height:=RPanel.Height-163;
  end;
 if BRPan.Height<160 then
  begin
   BRPan.Height:=160;
  end;
end;

procedure TMWindow.IncCmtFromChange(Sender: TObject);
var i:integer;
  nme:WIdeString;
begin
 if IncCmtFrom.ItemIndex=-1 then
  exit;
 CodeComment.Clear;
 nme:=IncCmtFrom.Items[IncCmtFrom.ItemIndex];
 for i := 0 to CodeData.Count - 1 do
  if CodeData[i].contentType=ctComment  then
   begin
    if nme=CodeData[i].name then
     begin
      CodeComment.Lines.AddStrings(CodeData[i].Comments);
      exit;
     end;
   end;
end;

procedure TMWindow.LangCall(Language: WideString);
begin
 //WideShowMessage(Language);
 ApplyLangForForm('MainForm',MWindow,Language);
 ApplyLangForForm('SaveForm',SaveForm,Language);
 {$IFNDEF NOGOSLIST}
  ApplyLangForForm('GeckoForm',GOSList,Language);
  GOSList.CodeCatInfo.Caption:=GetLangString('CODECATINFO',
   'Only one code of each code category is selectable!'#13#10+
   'Codes in code category 0 are freely selectable!');
  {$ENDIF}
 StoreIni.WriteString('Main','Language',UTF8Encode(Language));
end;

procedure TMWindow.OpenTXTfileClick(Sender: TObject);
begin
 SaveForm.SetupDialog('.txt',GetLangString('TXTFILES','Text cheat list files'));
 if OpenDia.Execute then
  begin
   CodeData.ImportCodePage(OpenDia.FileName);
  end;
end;

procedure TMWindow.RemoveSelClick(Sender: TObject);
var i:integer;
begin
 if CodeBox.SelCount>0 then
  if WideMessageBox(GetLangString('REMOVEQUEST','Are you sure - this step cannot be undone!'),
   GetLangString('ATTENTION','Caution'),
   MB_ICONEXCLAMATION or MB_YESNO)=ID_NO then
     exit;
 for i := CodeBox.Count-1 downto 0 do
  if CodeBox.Selected[i] then
   begin
     CodeData.Delete(i);
   end;
 UnsetFocus;
 CodeData.SelectCode(-1);
end;

procedure TMWindow.SpliiterMoved(Sender: TObject);
var wdt:integer;
    offset:integer;
    sngwdt:integer;
begin
 if CodeGroup.Width<200 then
  begin
   offset:=200-CodeGroup.Width;
   RPanel.Width:=RPanel.Width-offset;
  end;
 wdt:=CommentGroup.Width;
 if wdt<200 then
  begin
   RPanel.Width:=210;
   wdt:=CommentGroup.Width;
  end;
 sngwdt:=wdt DIV 2 - 15;
 CmtType.Width:=sngwdt;
 IncCmtFrom.Left:=20+sngwdt;
 IncCmtFrom.Width:=sngwdt;
end;

procedure TMWindow.StBtnClick(Sender: TObject);
var err:boolean;
begin
 if length(GmId.Text)<>6 then
  begin
   WideShowMessage(GetLangString('INVALIDID','Invalid game ID - only game name will be stored!'));
   err:=true;
  end
 else
  begin
   CodeData.gameid:=GmId.Text;
   err:=false;
  end;
 CodeData.gamename:=GMname.Text;
 if not err then
  WideShowMessage(GetLangString('STORED','Data stored!'));
end;

function TMWindow.StoreMod: boolean;
var sel:Integer;
      i:integer;
    tmp:TCheckCode;
   line:string;
begin
 Sel:=CodeData.Selected;
 if Sel=-1 then
  begin
   WideShowMessage(GetLangString('NOSELECTION','No code selected!'));
   Result:=false;
   exit;
  end;
 if CodeName.Text='' then
  begin
   WideShowMessage(GetLangString('NAMEMISSING','Please enter a name!'));
   Result:=false;
   exit;
  end;
 for i := 0 to CodeContents.Lines.Count - 1 do
  begin
   line:=Trim(CodeContents.Lines[i]);
   if line='' then continue;
   if not CheckCode(line,tmp) then
    begin
     WideShowMessage(WideFormat(
      GetLangString('INVALIDLINE','Invalid code line: %s'),[line]));
     Result:=false;
     exit;
    end;
  end;

 CodeData[Sel].name:=CodeName.Text;
 CodeBox.Items[Sel]:=CodeName.Text;

 {$IFNDEF NOGOSLIST}
  GOSList.MainList.Items[Sel]:=CodeName.Text;
 {$ENDIF}

 CodeData[Sel].Codes.Clear;
 for i := 0 to CodeContents.Lines.Count - 1 do
  begin
   line:=Trim(CodeContents.Lines[i]);
   if line='' then continue;
   CodeData[Sel].Codes.Add(line);
  end;

 CodeData[Sel].Comments.Clear;
 if CodeComment.ReadOnly then
  CodeData[Sel].Comments.Add('<!--[!include:'+IncCmtFrom.Text+']-->')
 else
  CodeData[Sel].Comments.AddStrings(CodeComment.Lines);

 CodeBox.Repaint;
 Result:=true;
end;

procedure TMWindow.StoreModsClick(Sender: TObject);
begin
 if StoreMod then
  WideShowMessage(GetLangString('STORED','Data stored!'));
end;

procedure TMWindow.StoreTXTClick(Sender: TObject);
var Txt:TTntStringList;
begin
 if SaveTXT.Execute then
  begin
   Txt:=TTntStringList.Create;
   CodeData.SerializeToTXT(Txt);
   Txt.SaveToFile(SaveTXT.FileName);
   FreeAndNil(TXT);
  end;
end;

procedure TMWindow.TntFormResize(Sender: TObject);
begin
 if RPanel.Width>(ClientWidth-200) then
  RPanel.Width:=ClientWidth-200;
 SpliiterMoved(Sender);
 HSplitMoved(Sender);
end;

procedure TMWindow.TntFormShow(Sender: TObject);
var lng:WideString;
begin
 lng:=UTF8Decode(StoreIni.ReadString('Main','Language','-'));
 FillLangMenu(LangMenu,lng);
end;

procedure TMWindow.UnsetFocus;
var i:integer;
begin
 for i := 0 to CodeBox.Count - 1 do
  CodeBox.Selected[i]:=false;
 NoFocus:=True;
 GMname.SetFocus;
 CodeName.Text:='';
 CodeContents.Clear;
 CodeComment.Clear;
 CmtType.ItemIndex:=0;
end;

end.
