unit gosmgmt;

interface

uses goscodes,tntstdctrls, Graphics, Controls, Types, ComCtrls, CLasses;

type TGeckoOSManager=class(TGeckoOSList)
             private
        FGeckoOSList:TTntListBox;
           procedure SetGOSList(const Value: TTntListBox);
           procedure GeckoListDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
           protected
           procedure setItem(Index: integer; const Value: TGeckoOSCode); override;
              public
         constructor Create;
          destructor Destroy;virtual;  
           procedure Clear;
            function Add(CodeData:TGeckoOsCode):integer;
            function AddP(CodeData:PGeckoOsCode):integer;
           procedure Insert(CodeData:TGeckoOsCode;Index:integer);
           procedure InsertP(CodeData:PGeckoOsCode;Index:integer);
            function Delete(Index:integer):boolean;
            function Move(OldIndex, NewIndex: integer): boolean;
           procedure SaveToStream(Stream:TStream);
           procedure LoadFromFile(FileName:WideString);
            property GeckoOSList:TTntListBox read FGeckoOSList write SetGOSList;
end;

implementation

uses StdCtrls,SwapFunctions,TntClasses,TntSysUtils,SysUtils;

{ TGeckoOSManager }

function TGeckoOSManager.Add(CodeData: TGeckoOsCode): integer;
begin
 inherited Add(CodeData);
 if Assigned(FGeckoOSList) then
  begin
   FGeckoOSList.Items.Add(CodeData.Name);
   FGeckoOSList.Repaint;
  end;
end;

function TGeckoOSManager.AddP(CodeData: PGeckoOsCode): integer;
begin
 inherited AddP(CodeData);
 if Assigned(FGeckoOSList) then
  begin
   FGeckoOSList.Items.Add(CodeData^.Name);
   FGeckoOSList.Repaint;
  end;
end;

procedure TGeckoOSManager.Insert(CodeData: TGeckoOsCode; Index: integer);
begin
 inherited Insert(CodeData,Index);
 if Assigned(FGeckoOSList) then
  begin
   FGeckoOSList.Items.Insert(Index,CodeData.Name);
   FGeckoOSList.Repaint;
  end;
end;

procedure TGeckoOSManager.InsertP(CodeData: PGeckoOsCode; Index: integer);
begin
 inherited InsertP(CodeData,Index);
 if Assigned(FGeckoOSList) then
  begin
   FGeckoOSList.Items.Insert(Index,CodeData^.Name);
   FGeckoOSList.Repaint;
  end;
end;


procedure TGeckoOSManager.Clear;
begin
 inherited Clear;
 if Assigned(FGeckoOSList) then
  begin
   FGeckoOSList.Clear;
   FGeckoOSList.Repaint;
  end;
end;

constructor TGeckoOSManager.Create;
begin
 inherited Create;
 FGeckoOsList:=nil;
end;

function TGeckoOSManager.Delete(Index: integer): boolean;
begin
 if Index>=Count then
  exit;
 inherited Delete(Index);
 if Assigned(FGeckoOSList) then
  begin
   FGeckoOSList.Items.Delete(Index);
   FGeckoOSList.Repaint;
  end;
end;

destructor TGeckoOSManager.Destroy;
begin
 FGeckoOsList:=nil;
 inherited Destroy;
end;

procedure TGeckoOSManager.GeckoListDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var ct:TGeckoOsCodeType;
    fr:TRect;
begin
    with Control as TTntListBox do
    begin
        if Selected[Index] then
         Canvas.Brush.Color:=$3F0000
        else
         Canvas.Brush.Color:=clWhite;

        Canvas.FillRect(Rect);

        ct:=Codes[Index].CodeType;

        if ct=gosHeadline then
         begin
          if Selected[Index] then
           Canvas.Font.Color := clWhite
          else
           Canvas.Font.Color := clBlack;
          Canvas.Font.Style := [fsBold];
         end
        else if ct=gosMaster then
         begin
          if Selected[Index] then
           Canvas.Font.Color := $7FFF
          else
           Canvas.Font.Color := clRed;
          Canvas.Font.Style := [fsItalic];
         end
        else if ct=gosEnabled then
         begin
          if Selected[Index] then
           Canvas.Font.Color := clYellow
          else
           Canvas.Font.Color := clBlue;
          Canvas.Font.Style := [];
         end
        else
         begin
          if Selected[Index] then
           Canvas.Font.Color := clWhite
          else
           Canvas.Font.Color := clBlack;
          Canvas.Font.Style := [];
         end;

        Canvas.TextOut(Rect.Left + 2, Rect.Top, Items[Index]);
    end;
end;
procedure TGeckoOSManager.LoadFromFile(FileName: WideString);

 function ReadString(Data:TStream):string;
 var Output:string;
       RChr:Char;
 begin
  Output:='';
  repeat
   Data.Read(RChr,1);
   if RChr<>#0 then Output:=Output+RChr;
  until RCHr=#0;
  Result:=Output;
 end;

var Data:TTntFileStream;
      Cd:TGeckoOsCode;
   OByte:Byte;
   TByte:Word;
   FByte:Cardinal;
   Lines:WOrd;
       i:Word;
   left,right:Cardinal;
begin
 Clear;
 if not WideFileExists(FileName) then
  exit;

 Data:=TTntFileStream.Create(FileName,fmOpenRead or fmShareDenyWrite);
 Data.Seek(2,soFromBeginning);
 while Data.Position<Data.Size do
  begin
   Data.Read(OByte,1);
   case OByte of
    1: Cd:=TGeckoOsCode.Create(gosHeadline);
    2: Cd:=TGeckoOSCode.Create(gosMaster);
    3: Cd:=TGeckoOSCode.Create(gosDisabled);
    else Cd:=TGeckoOSCode.Create(gosEnabled);
   end;
   Cd.Name:=ReadString(Data);
   if Cd.CodeType<>gosHeadline then
    begin
     Data.Read(TByte,2);
     Cd.Category:=BSwap16(TByte);
     Data.Read(TByte,2);
     Lines:=BSwap16(TByte);
     for i := 1 to Lines do
      begin
       Data.Read(FByte,4);
       left:=BSwap(FByte);
       Data.Read(FByte,4);
       right:=BSwap(FByte);
       Cd.AddLine(left,right);
      end;
    end;
   Add(Cd);
   FreeAndNil(Cd);
  end;

end;

function TGeckoOSManager.Move(OldIndex, NewIndex: integer): boolean;
begin
 if OldIndex>=Count then
  exit;
 if NewIndex>=Count then
  exit;
 inherited Move(OldIndex,NewIndex);
 if Assigned(FGeckoOSList) then
  begin
   FGeckoOSList.Items.Move(OldIndex,NewIndex);
   FGeckoOSList.Repaint;
  end;
end;

procedure TGeckoOSManager.SaveToStream(Stream: TStream);
var TByte:Word;
 i:integer;
begin
 TByte:=Count;
 TByte:=BSwap16(TByte);
 Stream.Write(TByte,2);
 for i := 0 to Count-1 do
  Codes[i].SaveToStream(Stream);
end;

procedure TGeckoOSManager.SetGOSList(const Value: TTntListBox);
begin
 FGeckoOSList := Value;
 FGeckoOSList.Clear;
 FGeckoOSList.OnDrawItem:=GeckoListDrawItem;
end;

procedure TGeckoOSManager.setItem(Index: integer; const Value: TGeckoOSCode);
begin
 if Index>=Count then
  exit;
 inherited setItem(index,value);
 if Assigned(FGeckoOsList) then
  begin
   FGeckoOsList.Items[Index]:=Value.Name;
   FGeckoOsList.Repaint;
  end;
end;

end.
