unit goscodes;

interface

uses classes;

type TGeckoOsCodeLine=record
                 left:Cardinal;
                right:Cardinal;
end;

type TGeckoOsCodeType=(gosHeadline,gosMaster,gosDisabled,gosEnabled);

type TGeckoOsCode=class
          private
           FLines:array of Cardinal;
            FName:string;
        FCategory:Word;
            FType:TGeckoOsCodeType;
         function GetCode(Index: Integer): TGeckoOsCodeLine;
         function getCount: integer;
        procedure SetCode(Index: Integer; const Value: TGeckoOsCodeLine);
           public
      constructor Create(Tp:TGeckoOsCodeType);
       destructor Destroy; virtual;
        procedure AddLine(left,right:Cardinal);overload;
        procedure AddLine(line:TGeckoOsCodeLine);overload;
        procedure RemoveLine(Index:integer);
        procedure SaveToStream(Stream:TStream);
         property Lines[Index:Integer]:TGeckoOsCodeLine read GetCode write SetCode;
         property CodeType:TGeckoOsCodeType read FType write FType;
         property LineCount:integer read getCount;
         property Name:string read FName write FName;
         property Category:Word read FCategory write FCategory;
end;

type PGeckoOsCode=^TGeckoOSCode;

type TGeckoOSList=class
          private
           FCodes:TList;
          FGameId:string;
         function getCount: integer;
        procedure CheckFreeCategories; 
        protected
         function getItem(Index: integer): TGeckoOSCode;
        procedure setItem(Index: integer; const Value: TGeckoOSCode); virtual;
           public
        procedure Clear;
        procedure Insert(CodeData:TGeckoOsCode;Index:integer);
        procedure InsertP(CodeData:PGeckoOsCode;Index:integer);
         function Add(CodeData:TGeckoOsCode):integer;
         function AddP(CodeData:PGeckoOsCode):integer;
         function Delete(Index:integer):boolean;
         function Move(OldIndex,NewIndex:integer):boolean;
         function AvailCategory:Word;
      constructor Create;
       destructor Destroy;override;
         property Codes[Index:integer]:TGeckoOSCode read getItem write setItem; default;
         property Count:integer read getCount;
         property GameId:string read FGameId write FGameId;
end;

function GOSCopyToPtr(Input:TGeckoOSCode):PGeckoOsCode;
function GOSDuplicateCode(Input:TGeckoOSCode):TGeckoOSCode;

implementation

uses SysUtils,SwapFunctions;

function GOSCopyToPtr(Input:TGeckoOSCode):PGeckoOsCode;
var i:integer;
begin
 new(Result);
 Result^:=TGeckoOsCode.Create(Input.CodeType);
 with Result^ do
  begin
   Name:=Input.Name;
   Category:=Input.Category;
   SetLength(FLines,length(Input.FLines));
   for i := 0 to length(Input.FLines) - 1 do
    Flines[i]:=Input.FLines[i];
  end;
end;

function GOSDuplicateCode(Input:TGeckoOSCode):TGeckoOSCode;
begin
 Result:=GOSCopyToPtr(Input)^;
end;

{ TGeckoOsCode }

procedure TGeckoOsCode.AddLine(left, right: Cardinal);
begin
 SetLength(FLines,length(FLines)+2);
 FLines[length(FLines)-2]:=left;
 FLines[length(FLines)-1]:=right;
end;

procedure TGeckoOsCode.AddLine(line: TGeckoOsCodeLine);
begin
 AddLine(line.left,line.right);
end;

constructor TGeckoOsCode.Create(Tp:TGeckoOsCodeType);
begin
 SetLength(FLines,0);
 FType:=Tp;
 FCategory:=0;
end;

destructor TGeckoOsCode.Destroy;
begin
 SetLength(FLines,0);
 FName:='';
end;

function TGeckoOsCode.GetCode(Index: Integer): TGeckoOsCodeLine;
begin
 if Index>=LineCount then
  exit;
 Result.left:=FLines[Index*2];
 Result.right:=FLines[Index*2+1];
end;

function TGeckoOsCode.getCount: integer;
begin
 Result:=length(FLines) DIV 2;
end;

procedure TGeckoOsCode.RemoveLine(Index: integer);
var i,cnt:integer;
begin
 cnt:=LineCount;
 if Index>=cnt then
  exit;
 if Index=cnt-1 then
  begin
   SetLength(FLines,length(FLines)-2);
   exit;
  end;
 for i := Index to cnt-1 do
  begin
   FLines[i*2]:=FLines[i*2+2];
   FLines[i*2+1]:=FLines[i*2+3];
  end;
 SetLength(FLines,length(FLines)-2);
end;

procedure TGeckoOsCode.SaveToStream(Stream: TStream);
var TByte:Word;
 OByte:Byte;
 FByte:Cardinal;
 i:integer;
begin
 OByte:=Ord(CodeType)+1;
 Stream.Write(Obyte,1);
 Stream.Write(Name[1],length(Name));
 OByte:=0;
 Stream.Write(OByte,1);
 if CodeType<>gosHeadline then
  begin
   TByte:=Category;
   Tbyte:=BSwap16(TByte);
   Stream.Write(TByte,2);
   TByte:=LineCount;
   Tbyte:=BSwap16(TByte);
   Stream.Write(TByte,2);
   for i := 0 to length(FLines)-1 do
    begin
     FByte:=FLines[i];
     FByte:=BSwap(FByte);
     Stream.Write(FByte,4);
    end;
  end;
end;

procedure TGeckoOsCode.SetCode(Index: Integer; const Value: TGeckoOsCodeLine);
begin
 if Index>=LineCount then
  exit;
 FLines[Index*2]:=Value.left;
 FLines[Index*2+1]:=Value.right;
end;

{ TGeckoOSList }

function TGeckoOSList.Add(CodeData: TGeckoOsCode): integer;
begin
 AddP(GOSCopyToPtr(CodeData));
end;

function TGeckoOSList.AddP(CodeData: PGeckoOsCode): integer;
begin
 FCodes.Add(CodeData);
 CheckFreeCategories;
end;

function TGeckoOSList.AvailCategory: Word;
var cat,i:integer;
    avail:boolean;
    SelCode:TGeckoOsCode;
begin
 cat:=0;
 repeat
  Inc(cat);
  avail:=true;
  for i := 0 to Count-1 do
   begin
    SelCode:=Codes[i];
    if not ((SelCode.CodeType=gosEnabled) or (SelCode.CodeType=gosDisabled)) then
     continue;
    if SelCode.Category=cat then
     begin
      avail:=false;
      break;
     end;
   end;
 until avail;
 Result:=cat;
end;

procedure TGeckoOSList.CheckFreeCategories;
var i,j:integer;
     ca:array of boolean;
CurCode:PGeckoOsCode;
 oldlen:integer;
begin
 for i := 0 to FCodes.Count-1 do
  begin
   CurCode:=FCodes[i];
   if CurCode.CodeType=gosMaster then
    CurCode.Category:=0;
   if CurCode.Category=0 then
    continue;
   if length(ca)<CurCode.Category then
    begin
     oldlen:=length(ca);
     SetLength(ca,CurCode.Category);
     for j := oldlen to length(ca)-1 do
      ca[j]:=false; 
    end;
   if ca[CurCode.Category-1] then
    CurCode.CodeType:=gosDisabled
   else if CurCode.CodeType=gosEnabled then
    ca[CurCode.Category-1]:=true;
  end;
end;

procedure TGeckoOSList.Clear;
var i:integer;
  gos:PGeckoOsCode;
begin
 for i := FCodes.Count-1 downto 0 do
  begin
   gos:=FCodes[i];
   FreeAndNil(gos^);
   FCodes.Delete(i);
  end;
 FCodes.Clear;
end;

constructor TGeckoOSList.Create;
begin
 FCodes:=TList.Create;
 FGameId:='';
end;

function TGeckoOSList.Delete(Index: integer): boolean;
var gos:PGeckoOsCode;
begin
 if Index>=FCodes.Count then exit;
 gos:=FCodes[Index];
 FreeAndNil(gos^);
 FCodes.Delete(Index);
end;

destructor TGeckoOSList.Destroy;
begin
 Clear;
 FGameId:='';
  inherited;
end;

function TGeckoOSList.getCount: integer;
begin
 Result:=FCodes.Count;
end;

function TGeckoOSList.getItem(Index: integer): TGeckoOSCode;
var gos:PGeckoOsCode;
begin
 gos:=FCodes.Items[Index];
 Result:=gos^;
end;

procedure TGeckoOSList.Insert(CodeData: TGeckoOsCode; Index: integer);
begin
 InsertP(GOSCopyToPtr(CodeData),Index);
end;

procedure TGeckoOSList.InsertP(CodeData: PGeckoOsCode; Index: integer);
begin
 FCodes.Insert(Index,CodeData);
 CheckFreeCategories;
end;

function TGeckoOSList.Move(OldIndex, NewIndex: integer): boolean;
begin
 FCodes.Move(OldIndex,NewIndex);
end;

procedure TGeckoOSList.setItem(Index: integer; const Value: TGeckoOSCode);
var CodeCopy:PGeckoOsCode;
     CurCode:PGeckoOsCode;
begin
 CurCode:=FCodes[Index];
 FreeAndNil(CurCode^);
 CodeCopy:=GOSCopyToPtr(Value);
 FCodes[Index]:=CodeCopy;
end;

end.
