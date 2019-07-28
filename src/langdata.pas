unit langdata;

interface

uses TntForms,TntClasses,TntMenus;

type TLangCallBack=procedure(LangId:WideString) of object;

procedure ApplyLangForForm(formname:WideString;Form:TTntForm;langcode:WideString);
function GetLangString(StrName,Default:WideString):WideString;
procedure FillLangMenu(Menu:TTntMenuItem;start:WideString);

var LangCallBack:TLangCallBack=nil;

implementation

uses Menus,Classes,TntSysUtils,SysUtils,TntStdCtrls,TntExtCtrls, WideStrings;

type TLanguage=record
            id:WideString;
          name:WideString;
end;

var langs:array of TLanguage;

type TMenuCallBack=class
  procedure LangSelect(Sender:TObject);
end;

procedure TMenuCallBack.LangSelect(Sender:TObject);
var tag:integer;
begin
 tag:=(Sender as TTntMenuItem).Tag;
 (Sender as TTntMenuItem).Checked:=true;
 if (tag<length(langs)) and (tag>=0) then
  begin
   if Assigned(LangCallBack) then
    LangCallBack(langs[tag].id);
  end;
end;

var CbClass:TMenuCallBack;
CLangStrings:TTntStringList;


function ReplaceStr(s, OldSubStr, NewSubStr: WideString): WideString;
var
  i: integer;
  OldSubLen, TotalLength: integer;
begin
  Result := '';
  if s <> '' then
  begin
    OldSubLen := Length(OldSubStr); // für die Performance - for performance
    TotalLength := Length(s);
    i := 1;
    while i <= TotalLength do
    begin
      if (i <= TotalLength - OldSubLen) and (Copy(s, i, OldSubLen) = OldSubStr) then
      begin
        Result := Result + NewSubStr;
        Inc(i, OldSubLen);
      end
      else
      begin
        Result := Result + s[i];
        Inc(i);
      end;
    end;
  end;
end;



function GetLangString(StrName,Default:WideString):WideString;
begin
  if CLangStrings.IndexOfName(StrName)>-1 then
   Result:=ReplaceStr(CLangStrings.Values[StrName],'\n',#13#10)
  else
   Result:=Default;
end;

procedure ApplyLine(formname:WideString;Form:TTntForm;line:WideString);
var Split1:TTntStringList;
     Ident:TTntStringList;
        lv:WideString;
         i:integer;
        fc:TComponent;
        cn:ShortString;
        id3:WideString;
       rest,oi:integer;
begin
 Split1:=TTntStringList.Create;
 Split1.StrictDelimiter:=true;
 Split1.Delimiter:='=';
 Split1.DelimitedText:=line;

 lv:='';

 if Split1.Count<2 then
  begin
    FreeAndNil(Split1);
    exit;
  end;

 for i := 1 to Split1.Count - 1 do
  if i>1 then
   lv:=lv+'='+Split1[i]
  else
   lv:=Split1[i];

 Ident:=TTntStringList.Create;
 Ident.Delimiter:=':';
 Ident.DelimitedText:=Split1[0];
 FreeAndNil(Split1);

 if (Ident.Count=2) and (WideUpperCase(Ident[0])='STRINGS') then
  begin
   CLangStrings.Values[WideUpperCase(Ident[1])]:=lv;
   FreeAndNil(Ident);
   exit;
  end;

 if Ident.Count<4 then
  begin
   FreeAndNil(Ident);
   exit;
  end;

 if WideUpperCase(Ident[0])=WideUpperCase(formname) then
  begin
   if (Ident[1]='_') and (Ident[2]='_') and (WideUpperCase(Ident[3])=
    'CAPTION') then
     Form.Caption:=lv;
   fc:=Form.FindComponent(Ident[1]);
   if Assigned(fc) then
    begin
      Ident[2]:=WideUpperCase(Ident[2]);
      Ident[3]:=WideUpperCase(Ident[3]);
      cn:=AnsiUpperCase(fc.ClassName);
      if (Ident[2]='WCHECKBOX') and (cn='TTNTCHECKBOX') then
        if (Ident[3]='CAPTION') then (fc as TTntCheckBox).Caption:=lv;
      if (Ident[2]='WBUTTON') and (cn='TTNTBUTTON') then
        if (Ident[3]='CAPTION') then (fc as TTntButton).Caption:=lv;
      if (Ident[2]='WLABEL') and (cn='TTNTLABEL') then
        if (Ident[3]='CAPTION') then (fc as TTntLabel).Caption:=lv;
      if (Ident[2]='WMENUITEM') and (cn='TTNTMENUITEM') then
        if (Ident[3]='CAPTION') then (fc as TTntMenuItem).Caption:=lv;
      if (Ident[2]='WGROUPBOX') and (cn='TTNTGROUPBOX') then
        if (Ident[3]='CAPTION') then (fc as TTntGroupBox).Caption:=lv;
      if (Ident[2]='WPANEL') and (cn='TTNTPANEL') then
        if (Ident[3]='CAPTION') then (fc as TTntPanel).Caption:=lv;
      if (Ident[2]='WCOMBOBOX') and (cn='TTNTCOMBOBOX') then
       begin
        id3:=Ident[3];
        if(Copy(id3,1,4)='ITEM') then begin
          try
           rest:=StrToInt(Copy(id3,5,length(id3)-4));
           if (fc as TTntComboBox).Items.Count>rest then
            begin
             oi:=(fc as TTntComboBox).ItemIndex;
             (fc as TTntComboBox).Items[rest]:=lv;
             (fc as TTntComboBox).ItemIndex:=oi;
            end;
          except end;
         end;
       end;
    end;
  end;

 FreeAndNil(Ident);
end;

procedure ApplyLangForForm(formname:WideString;Form:TTntForm;langcode:WideString);
var id:integer;
   fnm:WideString;
langct:TTntStringList;
     i:integer;
begin
 for id := 0 to length(langs) - 1 do
  if langcode=langs[id].id then
   begin
    fnm:=WideIncludeTrailingPathDelimiter(
     WideExtractFilePath(TntApplication.ExeName))+langcode+'.lng';
    if WideFileExists(fnm) then
     begin
      CLangStrings.Clear;
      langct:=TTntStringList.Create;
      langct.LoadFromFile(fnm);
      for i := 1 to langct.Count - 1 do
       ApplyLine(formname,Form,langct[i]);
      FreeAndNil(langct);
     end;
   end;

end;

procedure FillLangMenu(Menu:TTntMenuItem;start:WideString);
var AddMenu:TMenuItem;
          i:integer;
begin
 Menu.Clear;
 if(length(langs))=0 then
  begin
    AddMenu:=TTntMenuItem.Create(Menu);
    AddMenu.Caption:='No language found!';
    AddMenu.Enabled:=false;
    AddMenu.Tag:=0;
    Menu.Add(AddMenu);
  end;
 for I := 0 to length(langs) - 1 do
  begin
    AddMenu:=TTntMenuItem.Create(Menu);
    Menu.Add(AddMenu);
    AddMenu.Caption:=langs[i].name;
    AddMenu.Enabled:=true;
    AddMenu.RadioItem:=true;
    AddMenu.Tag:=i;
    AddMenu.OnClick:=CbClass.LangSelect;
    if langs[i].id=start then
     CbClass.LangSelect(AddMenu);
  end;
end;



var FileCont:TTntStringList;
          SW:TSearchRecW;
        path:WideString;
         fnm:WideString;
          l1:WideString;
initialization
 CbClass:=TMenuCallBack.Create;
 CLangStrings:=TTntStringList.Create;
 path:=WideIncludeTrailingPathDelimiter(
  WideExtractFilePath(TntApplication.ExeName));
 if WideFindFirst(path+'*.lng',faAnyFile,SW) = 0 then
   try repeat
     fnm:=path+WideExtractFileName(SW.Name);
     FileCont:=TTntStringList.Create;
     FileCont.LoadFromFile(fnm);
     if FileCont.Count>0 then
      begin
       l1:=FileCont[0];
       if Copy(WideUpperCase(l1),1,5)='LANG:' then
        begin
         SetLength(langs,length(langs)+1);
         langs[length(langs)-1].id:=
          WideChangeFileExt(WideExtractFileName(fnm),'');
         langs[length(langs)-1].name:=
          Copy(l1,6,length(l1)-5);
        end;
      end;
     FreeAndNil(FileCont);
    until WideFindNext(SW)<>0;
   finally
     WideFindClose(SW);
   end;

finalization
 FreeAndNiL(CBClass);
 FreeAndNil(CLangStrings);
end.
