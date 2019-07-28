unit list;

interface

uses Classes,TntClasses,SysUtils;

type ECodeExportException=class(Exception)
                  private
               FErrorCode:integer;
                   public
              constructor Create(Message:string;ErrorCode:integer);
                 property ErrorCode:integer read FErrorCode;
end;

type TContentType=(ctCodes,ctComment,ctCategory);

type   TCheckCode=record
          enabled:boolean;
             cval:string;
              end;

type TCodeContent=class
          private
           FCodes:TStringList;
        FComments:TTntStringList;
         function getCodeCount: integer;
         function getCommentCount: integer;
         function getCode(Item: Integer): string;
         function getComment(Item: Integer): WideString;
        procedure SetCode(Item: Integer; const Value: string);
        procedure SetComment(Item: Integer; const Value: WideString);
         function getContentType: TContentType;
           public
             name:WideString;
          enabled:boolean;
      constructor Create;
       destructor Destroy;override;
         function AddCode(code:string):integer;
         function AddComment(comment:WideString):integer;
         function DeleteCode(index:integer):boolean;
         function DeleteComment(index:integer):boolean;
         //property Codes[Item:Integer]:string read getCode write SetCode;
         //property Comments[Item:Integer]:WideString read getComment write SetComment;
         function SerializeToTXT(TextOut:TTntStrings):boolean;
         function SerializeToWGC(TextOut:TTntStrings):boolean;
         function SerializeToGCT(Stream:TStream):boolean;
         property Codes:TStringList read FCodes;
         property Comments:TTntStringList read FComments;
         property CommentCount:integer read getCommentCount;
         property contentType:TContentType read getContentType;
end;

type PCodeContent=^TCodeContent;

type    TCodeList=class
          private
            FList:TList;
         function getCodeCount: integer;
        procedure setItem(Index: integer; const Value: TCodeContent);
         function getCount: integer;
         function getItem(Index: integer): TCodeContent;
           public
           gameid:string;
         gamename:WideString;
        procedure Clear;
         function Add(CodeData:TCodeContent):integer;
         function AddP(CodeData:PCodeContent):integer;
         function Delete(Index:integer):boolean;
         function Move(OldIndex,NewIndex:integer):boolean;
         function SerializeToTXT(TextOut:TTntStrings):boolean;
         function SerializeToWGC(TextOut:TTntStrings;OnlyEnabled:boolean=false):boolean;
         function SerializeToGCT(Stream:TStream):boolean;
      constructor Create;
       destructor Destroy;override;
         property Codes[Index:integer]:TCodeContent read getItem write setItem; default;
         property Count:integer read getCount;
         property ActiveCodeLineCount:integer read getCodeCount;
end;


function CheckCode(input:string;var output:TCheckCode):boolean;
function MakeHex(code:string;var part1,part2:Cardinal):boolean;

function CopyToPtr(Input:TCodeContent):PCodeContent;
function DuplicateCode(Input:TCodeContent):TCodeContent;

Function RemoveHTMLTags( FromWhere : WideString ) : WideString;

implementation

uses TntSysUtils,SwapFunctions;

function CopyToPtr(Input: TCodeContent): PCodeContent;
begin
 new(Result);
 Result^:=TCodeContent.Create;
 with Result^ do
  begin
   name:=Input.name;
   enabled:=Input.enabled;
   FCodes.Assign(Input.FCodes);
   FComments.Assign(Input.FComments);
  end;
end;

function DuplicateCode(Input:TCodeContent):TCodeContent;
begin
 Result:=CopyToPtr(Input)^;
end;

Function RemoveHTMLTags( FromWhere : WideString ) : WideString;
Var
  IdX : Integer;
  IdY : Integer;
  ForceExit : Boolean;
Begin
  Result := FromWhere;
  ForceExit := False;
  Repeat
    IdX := Pos( '<', Result );
    IdY := Pos( '>', Result );
    If ( ( IdX > 0 ) And ( IdY > IdX ) ) Then Begin
      Result := Copy( Result, 1, ( IdX - 1 ) ) + Copy( Result, ( IdY + 1 ), MaxInt );
    End Else Begin
      ForceExit := True;
    End;
  Until ( ( IdX = 0 ) Or ( IdY = 0 ) Or ( ForceExit ) );
End;

function MakeHex(code:string;var part1,part2:Cardinal):boolean;
var TCK:TCheckCode;
  Split:TTntStringList;
  p1,p2:integer;
begin
 if CheckCode(code,tck) then
  begin
   Split:=TTntStringList.Create;
   Split.Delimiter:=' ';
   Split.DelimitedText:=tck.cval;
   if TryStrToInt('$'+Split[0],p1) then
    if TryStrToInt('$'+Split[1],p2) then
     begin
      Result:=true;
      part1:=p1;
      part2:=p2;
     end
    else
     Result:=false
   else
    Result:=false;
  end
 else
  Result:=false;
end;

function CheckCode(input:string;var output:TCheckCode):boolean;
var Check:TStringList;
       p1:string;
       p2:string;
        v:string;
begin
 Check:=TStringList.Create;
 Check.Delimiter:=' ';
 Check.StrictDelimiter:=true;
 Check.DelimitedText:=input;
 case Check.Count of
  2: begin
      v:='';
      p1:=Check[0];
      p2:=Check[1];
     end;
  3: begin
       v:=Check[0];
      p1:=Check[1];
      p2:=Check[2];
     end;
  else
   begin
    FreeAndNil(Check);
    Result:=false;
    exit;
   end;
 end;
 FreeAndNil(Check);

 if (length(p1)<>8) or (length(p2)<>8) then
  begin
   Result:=false;
   exit;
  end;

 if v='*' then output.enabled:=true
 else output.enabled:=false;
 output.cval:=p1+' '+p2;
 Result:=true;
end;

{ TCodeContent }

function TCodeContent.AddCode(code: string): integer;
var CodeData:TCheckCode;
begin
 if CheckCode(code,CodeData) then
  begin
   Result:=FCodes.Add(CodeData.cval);
   enabled:=CodeData.enabled;
  end
 else
  raise EInOutError.Create('Invalid input data');
end;

function TCodeContent.AddComment(comment: WideString): integer;
begin
 Result:=FComments.Add(comment);
end;

constructor TCodeContent.Create;
begin
 FCodes:=TStringList.Create;
 FComments:=TTntStringList.Create;
end;

function TCodeContent.DeleteCode(index: integer): boolean;
begin
 Result:=true;
 if index>=FCodes.Count then
  FCodes.Delete(index)
 else
  Result:=false;
end;

function TCodeContent.DeleteComment(index: integer): boolean;
begin
 Result:=true;
 if index>=FComments.Count then
  FComments.Delete(index)
 else
  Result:=false;
end;

destructor TCodeContent.Destroy;
begin
 FreeAndNil(FCodes);
 FreeAndNil(FComments);
end;

function TCodeContent.getCode(Item: Integer): string;
begin
 Result:=FCodes[Item];
end;

function TCodeContent.getCodeCount: integer;
begin
 Result:=FCodes.Count;
end;

function TCodeContent.getComment(Item: Integer): WideString;
begin
 Result:=FComments[Item];
end;

function TCodeContent.getCommentCount: integer;
begin
 Result:=FComments.Count;
end;

function TCodeContent.getContentType: TContentType;
begin
 Result:=ctCategory;
 if Fcomments.Count>0 then Result:=ctComment;
 if Fcodes.Count>0 then Result:=ctCodes;
end;

function TCodeContent.SerializeToGCT(Stream: TStream): boolean;
var cc:TCheckCode;
     i:integer;
part1,part2:Cardinal;

begin
 if enabled then
  begin
   for I := 0 to FCodes.Count - 1 do
    if not MakeHex(FCodes[i],part1,part2) then
     begin
      Result:=false;
      exit;
     end;
   for I := 0 to FCodes.Count - 1 do
    begin
     MakeHex(FCodes[i],part1,part2);
     part1:=BSwap(part1);
     part2:=BSwap(part2);
     Stream.Write(part1,4);
     Stream.Write(part2,4);
    end;
   Result:=true;
  end
 else
  Result:=true;
end;

function TCodeContent.SerializeToTXT(TextOut: TTntStrings): boolean;
var i:integer;
begin
 TextOut.Add(name);

 for I := 0 to FCodes.Count - 1 do
  if enabled then
   TextOut.Add('* '+FCodes[i])
  else
   TextOut.Add(FCodes[i]);

 for I := 0 to FComments.Count - 1 do
  begin
   if FComments[i]='' then
    TextOut.Add('&nbsp;')
   else
    TextOut.Add(FComments[i]);
  end;
 TextOut.Add('');
 Result:=true;
end;

function TCodeContent.SerializeToWGC(TextOut: TTntStrings): boolean;
var i:integer;
hex1,hex2:Cardinal;
begin
 for i := 0 to FCodes.Count - 1 do
  if not MakeHex(Fcodes[i],hex1,hex2) then
   begin
    Result:=false;
    exit;
   end;
 TextOut.Add(name);
 for i := 0 to FCodes.Count - 1 do
  if enabled then
   TextOut.Add('* '+FCodes[i])
  else
   TextOut.Add(FCodes[i]);
 TextOut.Add('');
end;

procedure TCodeContent.SetCode(Item: Integer; const Value: string);
begin
 FCodes.Strings[Item]:=Value;
end;

procedure TCodeContent.SetComment(Item: Integer; const Value: WideString);
begin
 FComments.Strings[Item]:=Value;
end;

{ TCodeList }

function TCodeList.Add(CodeData: TCodeContent): integer;
begin
 Result:=AddP(CopyToPtr(CodeData));
end;

function TCodeList.AddP(CodeData: PCodeContent): integer;
begin
 FList.Add(CodeData);
end;

procedure TCodeList.Clear;
var i:integer;
  Res:PCodeContent;
begin
 for i := FList.Count-1 downto 0 do
  begin
   Res:=FList[i];
   FreeAndNil(Res^);
   Delete(I);
  end;
 gamename:='';
 gameid:='';
end;

constructor TCodeList.Create;
begin
 FList:=TList.Create;
end;

function TCodeList.Delete(Index: integer): boolean;
var Item:PCodeContent;
begin
 Result:=true;
 if Index<FList.Count then
  begin
   Item:=FList.Items[Index];
   FreeAndNil(Item^);
   FList.Delete(Index);
  end
 else
  Result:=false;
end;

destructor TCodeList.Destroy;
begin
 Clear;
 FreeAndNil(FList);
  inherited;
end;

function TCodeList.getCodeCount: integer;
var i:Integer;
   cd:PCodeContent;
begin
 Result:=0;
 for i := 0 to FList.Count - 1 do
  begin
   cd:=FList[i];
   if cd^.enabled then
    Inc(Result,cd^.Codes.Count);
  end;
end;

function TCodeList.getCount: integer;
begin
 Result:=FList.Count;
end;

function TCodeList.getItem(Index: integer): TCodeContent;
var Item:PCodeContent;
begin
 if Index>=FList.Count then
  raise EOutOfMemory.Create('Index out or range');
 Item:=FList[Index];
 Result:=Item^;
end;

function TCodeList.Move(OldIndex, NewIndex: integer): boolean;
begin
 if (OldIndex>=FList.Count) or (NewIndex>=FList.Count) then
  begin
   Result:=false;
   exit;
  end;
 FList.Move(OldIndex,NewIndex);
 Result:=true;
end;

function TCodeList.SerializeToGCT(Stream: TStream): boolean;
var dt:Cardinal;
i:integer;
cd:PCodeContent;
begin
 dt:=BSwap($00D0C0DE);
 Stream.Write(dt,4);
 Stream.Write(dt,4);

 for i := 0 to FList.Count - 1 do
  begin
   cd:=FList[i];
   if not cd^.SerializeToGCT(Stream) then
    raise ECodeExportException.Create('Code invalid',i);
  end; 

 dt:=BSwap($F0000000);
 Stream.Write(dt,4);
 dt:=BSwap($00000000);
 Stream.Write(dt,4);
end;

function TCodeList.SerializeToTXT(TextOut: TTntStrings): boolean;
var i:integer;
   pc:PCodeContent;
begin
 TextOut.Add('');
 TextOut.Add(gameid);
 TextOut.Add(gamename);
 TextOut.Add('');
 for i := 0 to FList.Count-1 do
  begin
   pc:=FList[i];
   pc^.SerializeToTXT(TextOut);
  end;
end;

function TCodeList.SerializeToWGC(TextOut: TTntStrings;OnlyEnabled:boolean=false): boolean;
var i:integer;
   cd:PCodeContent;
begin
 for I := 0 to FList.Count - 1 do
  begin
   cd:=FList[i];
   if not OnlyEnabled or cd^.enabled then
    if not cd^.SerializeToWGC(TextOut) and cd^.enabled then
     raise ECodeExportException.Create('Code incorrect',i);
  end; 
end;

procedure TCodeList.setItem(Index: integer; const Value: TCodeContent);
var PtrCC:PCodeContent;
begin
 PtrCC:=@Value;
 FList.Add(PtrCC);
end;

{ ECodeExportException }

constructor ECodeExportException.Create(Message: string; ErrorCode: integer);
begin
 inherited Create(Message);
 FErrorCode:=ErrorCode;
end;

end.
