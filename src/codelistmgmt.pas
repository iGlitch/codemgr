unit codelistmgmt;

interface

uses list,TntCheckLst,Windows,Controls,TntStdCtrls,Classes;

type TListManager=class(TCodeList)
          private
         FCodeBox:TTntCheckListBox;
        FCodeList:TTntListBox;
         FCBStart:TPoint;

       FGameIdEdt:TTntEdit;
       FGameNmEdt:TTntEdit;
       FCodeNmEdt:TTntEdit;
       FCodesMemo:TTntMemo;
     FCommentMemo:TTntMemo;
       FUniqueNot:TTntComboBox;
     FNUSelection:TTntComboBox;
        FSelected:integer;

        procedure SetFCodeList(const Value: TTntListBox);
        procedure CodeListDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);

        procedure CodeBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
        procedure CodeBoxDragDrop(Sender, Source: TObject; X, Y: Integer) ;
        procedure CodeBoxDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean) ;
        procedure CodeBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) ;

        procedure SetGameIdEdt(const Value: TTntEdit);
        procedure SetFCodeBox(const Value: TTntCheckListBox);
           public
      constructor Create;
       destructor Destroy;override;
        procedure ImportCodePage(cp:WideString);
        procedure ApplyList;
        procedure Clear;
        procedure SelectCode(Index:integer);
         function Add(CodeData:TCodeContent):integer;
         function AddP(CodeData:PCodeContent):integer;
         function Delete(Index:integer):boolean;
         function Move(OldIndex, NewIndex: integer): boolean;
         property CodeBox:TTntCheckListBox read FCodeBox write SetFCodeBox;
         property CodeList:TTntListBox read FCodeList write SetFCodeList;
         property GameIdEditField:TTntEdit read FGameIdEdt write SetGameIdEdt;
         property GameNameEditField:TTntEdit read FGameNmEdt write FGameNmEdt;
         property CodeNameEditField:TTntEdit read FCodeNmEdt write FCodeNmEdt;
         property CodesMemo:TTntMemo read FCodesMemo write FCodesMemo;
         property CommentMemo:TTntMemo read FCommentMemo write FCommentMemo;
         property UniqueOrNotCBox:TTntcombobox read FUniqueNot write FUniqueNot;
         property NotUniqueSelectionBox:TTntCombobox read FNUSelection write FNUSelection;
         property Selected:integer read FSelected write SelectCode;
end;

implementation

{ TListCreator }

uses SysUtils,TntSysUtils,Graphics,TntClasses,StdCtrls, CheckLst;

function TListManager.Add(CodeData: TCodeContent): integer;
begin
 Result:=inherited Add(CodeData);
 if Assigned(FCodeBox) then
  begin
   FCodeBox.Items.Add(CodeData.name);
   FCodeBox.Repaint;
  end;
 if Assigned(FCodeList) then
  begin
   FCodeList.Items.Add(CodeData.name);
   FCodeList.Repaint;
  end;
end;

function TListManager.AddP(CodeData: PCodeContent): integer;
begin
 Result:=inherited AddP(CodeData);
 if Assigned(FCodeBox) then
  begin
   FCodeBox.Items.Add(CodeData^.name);
   FCodeBox.Repaint;
  end;
 if Assigned(FCodeList) then
  begin
   FCodeList.Items.Add(CodeData^.name);
   FCodeList.Repaint;
  end;
end;

procedure TListManager.ApplyList;
var i:integer;
begin
 if Assigned(FCodeNmEdt) then
  FCodeNmEdt.Text:='';
 if Assigned(FGameNmEdt) then
  FGameNmEdt.Text:=GameName;
 if Assigned(FGameIdEdt) then
  FGameIdEdt.Text:=gameid;
 if Assigned(FCodesMemo) then
  FCodesMemo.Clear;
 if Assigned(FCommentMemo) then
  FCommentMemo.Clear;
 if Assigned(FCodeBox) then
  begin
   FCodeBox.Clear;
   for i := 0 to Count - 1 do
    begin
     FCodeBox.Items.Add(Codes[i].name);
     FCodeBox.Checked[i]:=Codes[i].enabled;
    end;
  end;
end;

procedure TListManager.Clear;
begin
 inherited Clear;
 FSelected:=-1;
 if Assigned(FCodeBox) then
  FCodeBox.Clear;
 if Assigned(FCodeList) then
  FCodeList.Clear;
 if Assigned(FCommentMemo) then
  begin
   FCommentMemo.Clear;
   FCommentMemo.ReadOnly:=false;
  end;
 if Assigned(FCodeNmEdt) then
  FCodeNmEdt.Text:='';
 if Assigned(FGameIdEdt) then
  FGameIdEdt.Text:='';
 if Assigned(FGameNmEdt) then
  FGameNmEdt.Text:='';
 if Assigned(FCodesMemo) then
  FCodesMemo.Clear;
 if Assigned(FUniqueNot) then
  FUniqueNot.ItemIndex:=0;
 if Assigned(FNUSelection) then
  begin
   FNUSelection.Clear;
   FNUSelection.Color:=clInactiveCaption;
   FNUSelection.Enabled:=false;
  end;
end;

procedure TListManager.CodeBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
var
   DropPosition, StartPosition: Integer;
   DropPoint: TPoint;
begin
   DropPoint.X := X;
   DropPoint.Y := Y;
   with Source as TTntCheckListBox do
   begin
     StartPosition := ItemAtPos(FCBStart,True) ;
     DropPosition := ItemAtPos(DropPoint,True) ;

     Items.Move(StartPosition, DropPosition) ;
     Move(StartPosition, DropPosition);
     FCodeBox.Repaint;
   end;
end;

procedure TListManager.CodeBoxDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
 Accept := Source = FCodeBox;
end;

procedure TListManager.CodeBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var ct:TContentType;
    fr:TRect;
begin
    with Control as TTntCheckListBox do
    begin
        Canvas.FillRect(Rect);

        ct:=Codes[Index].contentType;

        if True then

        if ct<>ctCodes then
         begin
          fr.Left:=0;
          fr.Top:=Rect.Top;
          fr.Right:=Rect.Left;
          fr.Bottom:=Rect.Bottom;
          Canvas.FillRect(fr);
          if ct=ctCategory then
            Canvas.Font.Style := [fsBold]
          else if ct=ctComment then
            Canvas.Font.Style := [fsItalic]
         end
        else
            Canvas.Font.Style := [];

        Canvas.TextOut(Rect.Left + 2, Rect.Top, Items[Index]);
    end;
end;

procedure TListManager.CodeListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var ct:TContentType;
    fr:TRect;
begin
    with Control as TTntListBox do
    begin
        Canvas.FillRect(Rect);

        ct:=Codes[Index].contentType;

        (*if True then

        if ct<>ctCodes then
         begin
          fr.Left:=0;
          fr.Top:=Rect.Top;
          fr.Right:=Rect.Left;
          fr.Bottom:=Rect.Bottom;
          Canvas.FillRect(fr);*)
        if ct=ctCategory then
          Canvas.Font.Style := [fsBold]
        else if ct=ctComment then
          Canvas.Font.Style := [fsItalic]
       //end
        else
            Canvas.Font.Style := [];

        Canvas.TextOut(Rect.Left + 2, Rect.Top, Items[Index]);
    end;
end;


procedure TListManager.CodeBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 FCBStart.X := X;
 FCBStart.Y := Y;
end;

constructor TListManager.Create;
begin
 inherited Create;
 FSelected:=-1;
end;

function TListManager.Delete(Index: integer): boolean;
begin
 Result:=inherited Delete(Index);
 if Result and Assigned(FCodeBox) then
  begin
   FCodeBox.Items.Delete(Index);
   FCodeBox.Repaint;
  end;
 if Result and Assigned(FCodeList) then
  begin
   FCodeList.Items.Delete(Index);
   FCodeList.Repaint;
  end;
end;

destructor TListManager.Destroy;
begin
  inherited;
end;

procedure TListManager.ImportCodePage(cp: WideString);
var Page:TTntStringList;
    Code:TCheckCode;
    line:WideString;
    gidset:boolean;
    gnmset:boolean;
    empty:boolean;
    AddCode:PCodeContent;
    codeactive:Boolean;
    codecontents:boolean;
    emptycommentpossible:boolean;
    i:integer;
begin
 Clear;
 if WideFileExists(cp) then
  begin
   Page:=TTntStringList.Create;
   Page.LoadFromFile(cp);
   gnmset:=False;
   codeactive:=false;
   codecontents:=false;
   gidset:=false;
   empty:=true;
   new(AddCode);
   AddCode^:=TCodeContent.Create;
   for i := 0 to Page.Count - 1 do
    begin
     emptycommentpossible:=false;
     if (length(line)>0) and (Trim(line)='') then
      emptycommentpossible:=true;

     line:=Trim(Page.Strings[i]);
     if Copy(line,1,14)<>'<!--[!include:' then
      line:=Trim(RemoveHTMLTags(line));
     if (line='') and not emptycommentpossible then
      empty:=true;
     if empty and codeactive then
      begin
       AddP(AddCode);
       New(AddCode);
       AddCode^:=TCodeContent.Create;
       codeactive:=false;
      end;
     if (line<>'') then
      begin
       if not gidset and  (length(line)=6) then
        begin
         gameid:=line;
         gidset:=true;
         empty:=false;
         continue;
        end
       else if not gnmset then
        begin
         gamename:=line;
         gidset:=true;
         gnmset:=true;
         empty:=false;
         continue;
        end;
       if empty and gidset and gnmset then
        begin
         codeactive:=True;
         codecontents:=true;
         AddCode.name:=line;
        end
       else if codeactive then
        begin
         if codecontents then
          begin
           if CheckCode(line,Code) then
            AddCode.AddCode(line)
           else
            begin
             codecontents:=false;
             if (WideLowerCase(line)='&nbsp;') or emptycommentpossible then
              AddCode.AddComment('')
             else
              AddCode.AddComment(line);
            end;
          end
         else
          begin
           if (WideLowerCase(line)='&nbsp;') or emptycommentpossible then
            AddCode.AddComment('')
           else
            AddCode.AddComment(line);
          end;
        end;
       empty:=false;
      end;
    end;
   if codeactive then
    AddP(AddCode)
   else
    FreeAndNil(AddCode^);
   FreeAndNil(Page);
   ApplyList;
  end;
end;



function TListManager.Move(OldIndex, NewIndex: integer): boolean;
begin
 Result:=inherited Move(OldIndex,NewIndex);
 if Result and Assigned(FCodeBox) then
  begin
   FCodeBox.Items.Move(OldIndex,NewIndex);
   FCodeBox.Repaint;
  end;
 if Result and Assigned(FCodeList) then
  begin
   FCodeList.Items.Move(OldIndex,NewIndex);
   FCodeList.Repaint;
  end;
end;

procedure TListManager.SelectCode(Index: integer);
var cmtin,cname:WideString;
        i:integer;
begin
 if Assigned(FCodesMemo) then
  FCodesMemo.Clear;
 if Assigned(FCommentMemo) then
  FCommentMemo.Clear;

 if Index>=Count then
  begin
   FSelected:=-1;
   if Assigned(FCodeNmEdt) then
    FCodeNmEdt.Text:='';
   exit;
  end;

 FSelected:=Index;

 if FSelected=-1 then
  begin
   if Assigned(FCodeNmEdt) then
    FCodeNmEdt.Text:='';
   if Assigned(FNuSelection) then
    begin
     FNUSelection.Clear;
     FNUSelection.Enabled:=false;
     FNUSelection.Color:=clInactiveCaption;
    end;
   if Assigned(FUniqueNot) then
    FUniqueNot.ItemIndex:=-1;
   exit;
  end;


 if Assigned(FCodeNmEdt) then
  FCodeNmEdt.Text:=Codes[Index].name;
 if Assigned(FCodesMemo) then
   FCodesMemo.Lines.AddStrings(Codes[Index].Codes);
 if Assigned(FCommentMemo) then
  begin
   if (Codes[Index].CommentCount>0) and
      (Copy(Codes[Index].Comments[0],1,14)='<!--[!include:') then
    begin
     cmtin:=Codes[Index].Comments[0];
     cmtin:=Trim(Copy(cmtin,15,length(cmtin)-18));
     FCommentMemo.ReadOnly:=true;
     if Assigned(FUniqueNot) then
      FUniqueNot.ItemIndex:=1;
     if Assigned(FNuSelection) then
      begin
       FNUSelection.Clear;
       FNUSelection.Enabled:=true;
       FNUSelection.Color:=clWindow;
      end;
     for i := 0 to Count-1 do
      if Codes[i].contentType=ctComment then
       begin
        cname:=Codes[i].name;
        if Assigned(FNUSelection) then
         begin
          FNUSelection.Items.Add(cname);
          if cname=cmtin then
           FNUSelection.ItemIndex:=
            FNUSelection.Items.Count-1;
         end;
        if cname=cmtin then
         FCommentMemo.Lines.AddStrings(Codes[i].Comments);
       end;
    end
   else
    begin
     FCommentMemo.Lines.AddStrings(Codes[Index].Comments);
     FUniqueNot.ItemIndex:=0;
     FCommentMemo.ReadOnly:=false;
     if Assigned(FNuSelection) then
      begin
       FNUSelection.Clear;
       FNUSelection.Enabled:=false;
       FNUSelection.Color:=clInactiveCaption;
      end;
    end;
  end;
 if Assigned(FCodeBox) then
  Codes[Index].enabled:=FCodeBox.Checked[Index];
end;

procedure TListManager.SetFCodeBox(const Value: TTntCheckListBox);
begin
 if(Assigned(FCodeBox)) then
  begin
   FCodeBox.Style:=lbStandard;
   FCodeBox.OnDrawItem:=nil;
   FCodeBox.DragMode:=dmManual;
   FCodeBox.OnDragOver:=nil;
   FCodeBox.OnDragDrop:=nil;
   FCodeBox.OnMouseDown:=nil;
   FCodeBox.OnMouseUp:=nil;
  end;
 FCodeBox := Value;
 FCodeBox.Style:=lbOwnerDrawFixed;
 FCodeBox.OnDrawItem:=CodeBoxDrawItem;
 FCodeBox.DragMode:=dmManual;
 FCodeBox.OnDragOver:=CodeBoxDragOver;
 FCodeBox.OnDragDrop:=CodeBoxDragDrop;
 FCodeBox.OnMouseDown:=CodeBoxMouseDown;
end;

procedure TListManager.SetFCodeList(const Value: TTntListBox);
begin
 if(Assigned(FCodeList)) then
  begin
   FCodeList.Style:=lbStandard;
   FCodeList.OnDrawItem:=nil;
  end;
 FCodeList := Value;
 FCodeList.Style:=lbOwnerDrawFixed;
 FCodeList.OnDrawItem:=CodeListDrawItem;
end;

procedure TListManager.SetGameIdEdt(const Value: TTntEdit);
begin
 FGameIdEdt := Value;
 FGameIdEdt.MaxLength := 6;
 FGameIdEdt.CharCase := ecUpperCase;
end;

end.
