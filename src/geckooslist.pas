unit geckooslist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls, ComCtrls,
  TntComCtrls,list,goscodes, Spin,gosmgmt, TntDialogs, Menus, TntMenus;

type TPlaceHolder=record
           holder:char;
           amount:integer;
             line:integer;
            start:integer;
             nval:string;
end;

type
  TGOSList = class(TTntForm)
    OcarinaBox: TTntGroupBox;
    GOSBox: TTntGroupBox;
    GeckoList: TTntListBox;
    MainList: TTntListBox;
    StatusBox: TTntGroupBox;
    ContentBox: TTntGroupBox;
    CodeContent: TTntMemo;
    CodeStatus: TTntLabel;
    EditBox: TTntGroupBox;
    PlaceHolderLabel: TTntLabel;
    PlcName: TTntEdit;
    PlcValuesLabel: TTntLabel;
    PlcHolderList: TTntListBox;
    PlcInput: TTntEdit;
    SetPlcValue: TTntButton;
    PlcContent: TTntMemo;
    MMasterCode: TTntCheckBox;
    MEnabled: TTntCheckBox;
    ACodeNm: TTntEdit;
    CodeNmLabel: TTntLabel;
    CodeCatLabel: TTntLabel;
    ACodeCat: TSpinEdit;
    CodeCatInfo: TTntLabel;
    AddRCodeToGOSList: TTntButton;
    AddHeadLine: TTntButton;
    ExportList: TTntButton;
    ImportList: TTntButton;
    OpenGOSList: TTntOpenDialog;
    InsertCode: TTntButton;
    GOSPopup: TTntPopupMenu;
    DelCode: TTntMenuItem;
    MoveUpCode: TTntMenuItem;
    MoveDownCode: TTntMenuItem;
    procedure GOSPopupPopup(Sender: TObject);
    procedure MoveDownCodeClick(Sender: TObject);
    procedure MoveUpCodeClick(Sender: TObject);
    procedure DelCodeClick(Sender: TObject);
    procedure InsertCodeClick(Sender: TObject);
    procedure ImportListClick(Sender: TObject);
    procedure AddCodeTooList(Sender: TObject);
    procedure ExportListClick(Sender: TObject);
    procedure GeckoListClick(Sender: TObject);
    procedure AddHeadLineClick(Sender: TObject);
    procedure MMasterCodeClick(Sender: TObject);
    procedure SetPlcValueClick(Sender: TObject);
    procedure PlcInputKeyPress(Sender: TObject; var Key: Char);
    procedure PlcInputChange(Sender: TObject);
    procedure PlcHolderListClick(Sender: TObject);
    procedure MainListClick(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
  private
 placeholders:array of TPlaceHolder;
     plcindex:integer;
      PlcCode:TCodeContent;
     EditCode:TGeckoOsCode;
       EditId:integer;
    procedure ExtractPlaceHolders;
    { Private declarations }
  public
  GeckoOSMgmt:TGeckoOSManager;
    { Public declarations }
  end;

var
  GOSList: TGOSList;

implementation

uses mform,codelistmgmt,langdata,WideDialogs,savequest,TntClasses;

const colorNO=$AFAFFF;
     colorYES=$AFFFAF;

{$R *.DFM}

procedure OverwriteStr(var input:string;start:integer;overwr:string);
var i:integer;
begin
 for i := 1 to length(overwr) do
  input[i+start-1]:=overwr[i];
end;

procedure TGOSList.AddHeadLineClick(Sender: TObject);
var Value:WideString;
     Code:TGeckoOsCode;
begin
 if Assigned(PlcCode) then
  Value:=PlcCode.name
 else
  Value:=GetLangString('DEFAULTCATNAME','New headline');
 if WideInputQuery(GetLangString('QUESTION','Prompt!'),
  GetLangString('NEWCAT','Please enter the category name!'),Value) then
   begin
    Code:=TGeckoOSCode.Create(gosHeadline);
    Code.Name:=Value;
    GeckoOSMgmt.Add(Code);
    FreeAndNil(Code);
   end;
end;

procedure TGOSList.DelCodeClick(Sender: TObject);
begin
 if GeckoList.ItemIndex=-1 then
  exit;
 GeckoOSMgmt.Delete(GeckoList.ItemIndex);
end;

procedure TGOSList.AddCodeTooList(Sender: TObject);
var Code:TGeckoOSCode;
 left,right:Cardinal;
  i:integer;
begin
 if EditId=-1 then
  begin
   if PlcCode.contentType=ctCategory then
    Code:=TGeckoOsCode.Create(gosHeadline)
   else if MMasterCode.Checked then
    Code:=TGeckoOsCode.Create(gosMaster)
   else if MEnabled.Checked then
    Code:=TGeckoOsCode.Create(gosEnabled)
   else
    Code:=TGeckoOsCode.Create(gosDisabled);
   Code.Name:=ACodeNm.Text;
   Code.Category:=ACodeCat.Value;
   for i := 0 to PlcCode.Codes.Count-1 do
    begin
     MakeHex(PlcCode.Codes[i],left,right);
     Code.AddLine(left,right);
    end;
   GeckoOSMgmt.Add(Code);
   FreeAndNil(Code);
  end
 else
  begin
   if EditCode.CodeType=gosHeadline then
    Code:=TGeckoOsCode.Create(gosHeadline)
   else if MMasterCode.Checked then
    Code:=TGeckoOsCode.Create(gosMaster)
   else if MEnabled.Checked then
    Code:=TGeckoOsCode.Create(gosEnabled)
   else
    Code:=TGeckoOsCode.Create(gosDisabled);
   Code.Name:=ACodeNm.Text;
   Code.Category:=ACodeCat.Value;
   for i := 0 to EditCode.LineCount-1 do
    Code.AddLine(EditCode.Lines[i]);
   GeckoOSMgmt.Codes[EditId]:=Code;
   FreeAndNil(Code);
  end;
end;

procedure TGOSList.ExportListClick(Sender: TObject);

var output:TTntMemoryStream;
 procedure SaveToFile(filename:WideString);
 begin
  try
   output:=TTntMemoryStream.Create;
   GeckoOSMgmt.SaveToStream(output);
   output.SaveToFile(filename);
   FreeAndNil(Output);
   WideShowMessage(WideFormat(
    GetLangString('STOREDTOBIN','Bin file stored to: %s'),[filename]));
  except
   WideShowMessage(GetLangString('SAVEERROR','Saving error!'));
  end;
 end;

var mr:TModalResult;
begin
 SaveForm.SetUpDialog('.bin',GetLangString('BINFILES','Code list files'));
 SaveForm.StoreIni:=MWindow.StoreIni;
 if GeckoOSMgmt.Count=0 then
  begin
   WideShowMessage('No codes added to the list');
   exit;
  end;

 if length(MWIndow.CodeData.gameid)<>6 then
  begin
   if WideMessageBox(GetLangString('NOGAMEID','No game ID given! Do you want to continue anyway?'),
     GetLangString('ERROR','Error!'),
    MB_YESNO or MB_ICONQUESTION)=ID_YES then
     if SaveForm.SaveDialog.Execute then
      SaveToFile(SaveForm.SaveDialog.FileName);
  end
 else
  begin
   SaveForm.outname:='codes\'+MWindow.CodeData.GameId+'.bin';
   mr:=SaveForm.ShowModal;
   if (mr=mrOk) and (SaveForm.outfile<>'') then
    begin
     SaveToFile(SaveForm.outfile);
    end;
  end;
 FreeAndNil(Output);
end;

procedure TGOSList.ExtractPlaceHolders;
 procedure AddPlaceHolder(h:char;a,l,s:integer);
 begin
  SetLength(placeholders,length(placeholders)+1);
  placeholders[length(placeholders)-1].holder:=h;
  placeholders[length(placeholders)-1].amount:=a;
  placeholders[length(placeholders)-1].line:=l;
  placeholders[length(placeholders)-1].start:=s-a;
 end;

var Code:string;
     i,j:integer;
   lc,cc:Char;
   charc,offset:integer;
   placeholder:string;
begin
 PlcHolderList.Clear;
 SetLength(placeholders,0);
 for i := 0 to CodeContent.Lines.Count - 1 do
  begin
   Code:=CodeContent.Lines[i];
   offset:=0;
   while offset<10 do
    begin
     charc:=0;
     lc:=' ';
     for j := 1 to 8 do
      begin
       cc:=Code[j+offset];
       if not (UpCase(cc) in ['0'..'9','A'..'F']) then
        begin
         if cc=lc then
          Inc(charc)
         else if lc<>' ' then
          begin
           AddPlaceHolder(lc,charc,i,j+offset);
           lc:=cc;
           charc:=1;
          end
         else
          begin
           lc:=cc;
           charc:=1;
          end;
        end
       else
        begin
         if lc<>' ' then
          AddPlaceHolder(lc,charc,i,j+offset);
         charc:=0;
         lc:=' ';
        end;
      end;
     if lc<>' ' then
      AddPlaceHolder(lc,charc,i,9+offset);
     Inc(offset,9);
    end;
  end;
 PlcHolderList.Enabled:=length(placeholders)>0;
 for i := 0 to length(placeholders)-1 do
  begin
   placeholder:='';
   for j := 1 to placeholders[i].amount do
    placeholder:=placeholder+placeholders[i].holder;
   PlcHolderList.Items.Add(placeholder);
  end;
end;

procedure TGOSList.GeckoListClick(Sender: TObject);
var Cd:TGeckoOsCode;
     i:integer;
  line:string;
begin
 GeckoList.Repaint;

 if GeckoList.ItemIndex=-1 then
  exit;

 EditId:=GeckoList.ItemIndex;
 PlcHolderList.Clear;
 PlcHolderList.Enabled:=false;
 PlcName.Enabled:=false;
 PlcInput.Enabled:=false;
 SetPlcValue.Enabled:=false;
 Cd:=GOSDuplicateCode(GeckoOSMgmt.Codes[GeckoList.ItemIndex]);
 if Assigned(EditCode) then
  FreeAndNil(EditCode);
 EditCode:=Cd;
 ACodeNm.Enabled:=true;
 ACodeNm.Text:=Cd.Name;
 CodeContent.Clear;
 CodeContent.Color:=colorYes;
 PlcContent.Clear;
 PlcContent.Color:=colorYes;
 AddRCodeToGOSList.Enabled:=true;
 InsertCode.Enabled:=true;
 if cd.CodeType=gosHeadLine then
  begin
   MEnabled.Enabled:=false;
   MMasterCode.Enabled:=false;
   ACodeCat.Enabled:=false;
  end
 else
  begin
   MEnabled.Enabled:=not (cd.CodeType=gosMaster);
   MEnabled.Checked:=(cd.CodeType=gosEnabled) or (cd.CodeType=gosMaster);
   MMasterCode.Enabled:=true;
   MMasterCode.Checked:=cd.Codetype=gosMaster;
   ACodeCat.Enabled:=true;
   ACodeCat.Value:=cd.Category;
   for i := 0 to Cd.LineCount-1 do
    begin
     line:=IntToHex(Cd.Lines[i].left,8)+' '+IntToHex(Cd.Lines[i].right,8);
     CodeContent.Lines.Add(line);
     PlcContent.Lines.Add(line);
    end;
  end;
end;

procedure TGOSList.GOSPopupPopup(Sender: TObject);
begin
 if GeckoList.ItemIndex=-1 then
  exit;
 MoveUpCode.Enabled:=not (GeckoList.ItemIndex=0);
 MoveDownCode.Enabled:=not (GeckoList.ItemIndex=GeckoList.Items.Count-1);
end;

procedure TGOSList.ImportListClick(Sender: TObject);
begin
 SaveForm.SetUpDialog('.bin',GetLangString('BINFILES','Gecko OS code list files'));
 if OpenGOSList.Execute then
  GeckoOSMgmt.LoadFromFile(OpenGOSList.FileName);
end;

procedure TGOSList.InsertCodeClick(Sender: TObject);
var Code:TGeckoOSCode;
 left,right:Cardinal;
  i:integer;
begin
 if EditId=-1 then
  begin
   if PlcCode.contentType=ctCategory then
    Code:=TGeckoOsCode.Create(gosHeadline)
   else if MMasterCode.Checked then
    Code:=TGeckoOsCode.Create(gosMaster)
   else if MEnabled.Checked then
    Code:=TGeckoOsCode.Create(gosEnabled)
   else
    Code:=TGeckoOsCode.Create(gosDisabled);
   Code.Name:=ACodeNm.Text;
   Code.Category:=ACodeCat.Value;
   for i := 0 to PlcCode.Codes.Count-1 do
    begin
     MakeHex(PlcCode.Codes[i],left,right);
     Code.AddLine(left,right);
    end;
   GeckoOSMgmt.Insert(Code,GeckoList.ItemIndex+1);
   FreeAndNil(Code);
  end
 else
  begin
   if EditCode.CodeType=gosHeadline then
    Code:=TGeckoOsCode.Create(gosHeadline)
   else if MMasterCode.Checked then
    Code:=TGeckoOsCode.Create(gosMaster)
   else if MEnabled.Checked then
    Code:=TGeckoOsCode.Create(gosEnabled)
   else
    Code:=TGeckoOsCode.Create(gosDisabled);
   Code.Name:=ACodeNm.Text;
   Code.Category:=ACodeCat.Value;
   for i := 0 to EditCode.LineCount-1 do
    Code.AddLine(EditCode.Lines[i]);
   GeckoOSMgmt.Insert(Code,GeckoList.ItemIndex+1);
   FreeAndNil(Code);
  end;
end;

procedure TGOSList.MainListClick(Sender: TObject);

var SelCode:TCodeContent;

 procedure CodeCategory;
 begin
  CodeStatus.Caption:=GetLangString('CODECAT','Code category selected!');
  CodeContent.Color:=colorYes;
  PlcContent.Color:=colorYes;
  ACodeNm.Enabled:=true;
  ACodeNm.Text:=SelCode.name;
  AddRCodeToGOSList.Enabled:=true;
  InsertCode.Enabled:=true;
 end;

 procedure NoCode;
 begin
  CodeStatus.Caption:=GetLangString('NOCODE','No code selected!');
  CodeContent.Color:=colorNo;
  PlcContent.Color:=colorNo;
 end;

 procedure GoodCode;
 begin
  CodeStatus.Caption:=GetLangString('GOODCODE','Code can be added immediately!');
  CodeContent.Color:=colorYes;
  PlcContent.Color:=colorYes;
  ACodeNm.Enabled:=true;
  ACodeNm.Text:=SelCode.name;
  MEnabled.Checked:=false;
  MMasterCode.Checked:=false;

  MEnabled.Enabled:=true;
  MMasterCode.Enabled:=true;
  ACodeNm.Text:=SelCode.name;
  ACodeNm.Enabled:=true;
  ACodeCat.Enabled:=true;
  ACodeCat.Value:=0;
  AddRCodeToGOSList.Enabled:=true;
  InsertCode.Enabled:=true;
 end;

 procedure BadCode;
 begin
  CodeStatus.Caption:=GetLangString('BADCODE','Code needs to be adjusted!');
  CodeContent.Color:=colorNo;
  PlcContent.Color:=colorNo;

  MEnabled.Checked:=false;
  MMasterCode.Checked:=false;

  MEnabled.Enabled:=true;
  MMasterCode.Enabled:=true;
  ACodeNm.Text:=SelCode.name;
  ACodeNm.Enabled:=true;
  ACodeCat.Enabled:=true;
  ACodeCat.Value:=GeckoOSMgmt.AvailCategory;
 end;

var i,index:integer;
       good:boolean;
      t1,t2:Cardinal;
begin
 EditId:=-1;
 MEnabled.Enabled:=false;
 MMasterCode.Enabled:=false;
 ACodeNm.Text:='';
 ACodeNm.Enabled:=false;
 ACodeCat.Enabled:=false;

 index:=MainList.ItemIndex;
 SelCode:=MWindow.CodeData[index];

 if Assigned(PlcCode) then
  FreeAndNil(PlcCode);

 PlcCode:=DuplicateCode(SelCode);
 CodeContent.Clear;
 PlcContent.Clear;
 AddRCodeToGOSList.Enabled:=false;
 InsertCode.Enabled:=false;
 PlcName.Text:='';
 PlcInput.Text:='';
 PlcInput.Enabled:=false;
 PlcName.Enabled:=false;
 SetPlcValue.Enabled:=false;
 if SelCode.contentType=ctCategory then
  CodeCategory
 else if SelCode.Codes.Count=0 then
  NoCode
 else
  begin
   good:=true;
   for i:=0 to SelCode.Codes.Count-1 do
    begin
     good:=good and MakeHex(SelCode.Codes[i],t1,t2);
     CodeContent.Lines.Add(SelCode.Codes[i]);
     PlcContent.Lines.Add(SelCode.Codes[i]);
    end;
   if good then
    GoodCode
   else
    BadCode;
  end;
 ExtractPlaceHolders;
end;

procedure TGOSList.MMasterCodeClick(Sender: TObject);
begin
 if MMasterCode.Checked then
  begin
   MEnabled.Checked:=true;
   MEnabled.Enabled:=false;
  end
 else
   MEnabled.Enabled:=true;
end;

procedure TGOSList.MoveDownCodeClick(Sender: TObject);
begin
 if GeckoList.ItemIndex=-1 then
  exit;
 GeckoOSMgmt.Move(GeckoList.ItemIndex,GeckoList.ItemIndex+1);
end;

procedure TGOSList.MoveUpCodeClick(Sender: TObject);
begin
 if GeckoList.ItemIndex=-1 then
  exit;
 GeckoOSMgmt.Move(GeckoList.ItemIndex,GeckoList.ItemIndex-1);
end;

procedure TGOSList.PlcHolderListClick(Sender: TObject);
var index:integer;
     data:TPlaceHolder;
       nm:string;
        i:integer;
begin
 index:=PlcHolderList.ItemIndex;
 plcindex:=index;

 if index=-1 then
  begin
   PlcName.Text:='';
   PlcInput.Text:='';
   PlcInput.Enabled:=false;
   PlcName.Enabled:=false;

   exit;
  end;

 data:=placeholders[index];
 nm:='';
 for i := 1 to data.amount do
  nm:=nm+data.holder;
 PlcName.Text:=nm;
 PlcInput.MaxLength:=data.amount;
 PlcInput.Enabled:=true;
 PlcName.Enabled:=true;
end;

procedure TGOSList.PlcInputChange(Sender: TObject);
var txt:string;
    ou:integer;
begin
 SetPlcValue.Enabled:=false;
 txt:=PlcInput.Text;
 if length(txt)<>placeholders[plcindex].amount then
  exit;
 if not TryStrToInt('$'+txt,ou) then
  exit;
 SetPlcValue.Enabled:=true;
end;

procedure TGOSList.PlcInputKeyPress(Sender: TObject; var Key: Char);
begin
 Key:=UpCase(Key);
 if not (Key in ['0'..'9','A'..'F', #8]) then
  Key := #0;
end;

procedure TGOSList.SetPlcValueClick(Sender: TObject);
var txt:string;
    ou:integer;
    plcnm:string;
    cline:string;
    i:integer;
    tm1,tm2:Cardinal;
    good:boolean;
begin
 txt:=PlcInput.Text;
 if length(txt)<>placeholders[plcindex].amount then
  exit;
 if not TryStrToInt('$'+txt,ou) then
  exit;
 plcnm:=PlcName.Text;
 PlcHolderList.Items[plcindex]:=plcnm+' = '+txt;
 placeholders[plcindex].nval:=txt;
 cline:=PlcCode.Codes[placeholders[plcindex].line];
 OverWriteStr(cline,placeholders[plcindex].start,txt);
 PlcCode.Codes[placeholders[plcindex].line]:=cline;
 PlcContent.Lines[placeholders[plcindex].line]:=cline;
 good:=true;
 for i := 0 to PlcCode.Codes.Count-1 do
  good:=good and MakeHex(PlcCode.Codes[i],tm1,tm2);
 if good then
  begin
   PlcContent.Color:=colorYES;
   AddRCodeToGOSList.Enabled:=true;
   InsertCode.Enabled:=true;
  end
 else
  begin
   PlcContent.Color:=colorNO;
   AddRCodeToGOSList.Enabled:=false;
   InsertCode.Enabled:=false;
  end;
end;

procedure TGOSList.TntFormCreate(Sender: TObject);
begin
 MWindow.CodeData.CodeList:=MainList;
 GeckoOSMgmt:=TGeckoOSManager.Create;
 GeckoOSMgmt.GeckoOSList:=GeckoList;
 CodeCatInfo.Caption:=GetLangString('CODECATINFO',
  'Only one code of each code category is selectable!'#13#10+
  'Codes in code category 0 are freely selectable!');
end;

end.
