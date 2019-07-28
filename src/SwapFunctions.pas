unit SwapFunctions;

interface

//General byte swap functions for
function BSwap(Input:Cardinal):Cardinal; //32 bit integers
function BSwap16(Input:Word):Word;       //16 bit integers
function BSwap64(Input:int64):int64;     //64 bit integers

implementation

//16 bit byteswap - high speed assembler
function BSwap16(Input:Word):Word;
asm
  xchg al,ah
end;

//64 bit byteswap - high speed assembler
function BSwap64(Input:int64):int64;
asm
 mov edx,dword ptr [Input]
 mov eax,dword ptr [Input+4]
 bswap edx
 bswap eax
end;

//32 bit byteswap -  high speed assembler
function BSwap(Input:Cardinal):Cardinal;
asm
  bswap eax;
end;

end.
