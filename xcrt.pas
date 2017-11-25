{
    
   Copyright 2017 xqtr (xqtr.xqtr@gmail.com)
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   _            _   _              ___          _    _       
  /_\  _ _  ___| |_| |_  ___ _ _  |   \ _ _ ___(_)__| |               8888
 / _ \| ' \/ _ \  _| ' \/ -_) '_| | |) | '_/ _ \ / _` |            8 888888 8
/_/ \_\_||_\___/\__|_||_\___|_|   |___/|_| \___/_\__,_|            8888888888
                                                                   8888888888
         DoNt Be aNoTHeR DrOiD fOR tHe SySteM                      88 8888 88
                                                                   8888888888
    .o HaM RaDiO    .o ANSi ARt!       .o MySTiC MoDS              "88||||88"
    .o NeWS         .o WeATheR         .o FiLEs                     ""8888""
    .o GaMeS        .o TeXtFiLeS       .o PrEPardNeSS                  88
    .o TuTors       .o bOOkS/PdFs      .o SuRVaViLiSM          8 8 88888888888
    .o FsxNet       .o SurvNet         .o More...            888 8888][][][888
                                                               8 888888##88888
   TeLNeT : andr01d.zapto.org:9999 [UTC 11:00 - 20:00]         8 8888.####.888
   SySoP  : xqtr                   eMAiL: xqtr.xqtr@gmail.com  8 8888##88##888
   
   
}

{$IFNDEF MSDOS}
  {$IFDEF FPC}
    {$mode tp}
    {$asmmode intel}
    {$PACKRECORDS 1}
    {$packset 1} // Default as of 2.5.1, but doesn't hurt to include
    {$H-}
    {$V-}
    {$DEFINE USE32} // HELPFILE.PAS needs this to use the right ASM block
  {$EndIF}
{$EndIF}
unit xcrt;
interface

{$IFDEF WIN32}
  uses
    Windows;
{$EndIF}
{$IFDEF UNIX}
  uses
    Unix;
{$EndIF}

const
  {$IFDEF UNIX}
    PathSep = '/';
    PathChar = '/';
  {$ELSE}
    PathSep = '\';
    PathChar = '\';
  {$EndIF}
  AnsiColours: Array[0..7] of Integer = (0, 4, 2, 6, 1, 5, 3, 7);
  CHARS_ALL = '`1234567890-=\qwertyuiop[]asdfghjkl;''zxcvbnm,./~!@#$%^&*()_+|'+
              'QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>? ';
  CHARS_ALPHA = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
  CHARS_NUMERIC = '1234567890';
  CHARS_FILENAME = '1234567890-=\qwertyuiop[]asdfghjkl;''zxcvbnm,.~!@#$%^&()_+'+
                   'QWERTYUIOP{}ASDFGHJKL:ZXCVBNM ';
  
  black         =0;
  blue          =1;
  green         =2;
  cyan          =3;
  red           =4;
  magenta       =5;
  brown         =6;
  lightgray     =7;
  darkgray      =8;
  lightblue     =9;
  lightgreen    =10;
  lightcyan     =11;
  lightred      =12;
  lightmagenta  =13;
  yellow        =14;
  white         =15;


  Home          = #71;      
  CursorUp      = #72;     
  PgUp          = #73;
  CursorLeft    = #75;      
  Num5          = #76;     
  CursorRight   = #77;
  EndKey        = #79;
  CursorDown    = #80;
  PgDn          = #81;
  Ins           = #82;
  Del           = #83;
  BackSpace     = #8;
  Tab           = #9;
  Enter         = #13;
  Esc           = #27;
  forwardslash  = #47;
  asterisk      = #42;
  minus         = #45;
  plus          = #43;
  F1            = #59;
  F2            = #60;
  F3            = #61;
  F4            = #62;
  F5            = #63;
  F6            = #64;
  F7            = #65;
  F8            = #66;
  F9            = #67;
  F10           = #68;
  F11           = #69;
  F12           = #70;

type
  {$IFDEF FPC}
    SmallWord = System.Word;
  {$EndIF}
  {$IFNDEF WIN32}
    TCharInfo = packed record
      Ch:   char;
      Attr: byte;
    End;
  {$EndIF}
  TScreenBuf = array[1..25, 1..80] of TCharInfo;

{$IFDEF FPC}
  var
    FileModeReadWrite: Integer;
    TextModeRead: Integer;
    TextModeReadWrite: Integer;
{$EndIF}

Procedure Ansi_Color (FG, BG : Byte);
Procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
Function  GetAttrAt(AX, AY: Byte): Byte;
Function  GetCharAt(AX, AY: Byte): Char;
Procedure RestoreScreen(var screenBuf: TScreenBuf);
Procedure SaveScreen(var screenBuf: TScreenBuf);
Procedure SetAttrAt(AAttr, AX, AY: Byte);
Procedure SetCharAt(ACh: Char; AX, AY: Byte);
Function  CurrentFG: Byte;
Function  CurrentBG: Byte;
Function  LoCase (C: Char): Char;
Procedure WritePipe(Str:String);
Procedure WriteXY (X, Y, A: Byte; Text: String);
Procedure WriteXYPipe (X, Y, Attr:Byte; Text: String);


Function AppName: String;
Function AppPath: String;
Function AddSlash(ALine: String): String;
Function BoolToStr(AValue: Boolean; ATrue, AFalse: String): String;
Function ciPos(ASubStr, ALine: String): LongInt;
Function Center(ALine: String): String;
Function NoSlash(ALine: String): String;
Function PadLeft(ALine: String; ACh: Char; ALen: Integer): String;
Function PadRight(ALine: String; ACh: Char; ALen: Integer): String;
Function Replace(ALine, AOld, ANew: String): String;
Function Right(ALine: String): String;
Function StripChar(ALine: String; ACh: Char): String;
Function Upper   (Str : String) : String;
Function Lower (Str: String) : String;
Function strRep (Ch: Char; Len: Byte) : String;
Function strPadL (Str: String; Len: Byte; Ch: Char): String;
Function strPadC (Str: String; Len: Byte; Ch: Char) : String;
Function strPadR (Str: String; Len: Byte; Ch: Char) : String;
Function strWordGet   (Num: Byte; Str: String; Ch: Char) : String;
Function strWordPos   (Num: Byte; Str: String; Ch: Char) : Byte;
Function strWordCount (Str: String; Ch: Char) : Byte;
Function strStripL    (Str: String; Ch: Char) : String;
Function strStripR    (Str: String; Ch: Char) : String;
Function strStripB    (Str: String; Ch: Char) : String;
Function strStripLow  (Str: String) : String;
Function strStripPipe (Str: String) : String;
Function strStripMCI  (Str: String) : String;
Function strMCILen    (Str: String) : Byte;
Function  Int2Str (N : LongInt) : String;
Function  Str2Int (Str : String) : LongInt;

// ANSI
Procedure DispFile(AFile: String);
Procedure TextBackground(AColour: Byte);

//File
Function JustFileName    (Str: String) : String;
Function JustFile        (Str: String) : String;
Function JustFileExt     (Str: String) : String;
Function JustPath        (Str: String) : String;
Function FileExist  (Str : String) : Boolean;

//input
Function GetYN (X, Y, Attr : Byte; Default: Boolean) : Boolean;
Function Input(ADefault, AChars: String; APass: Char; AShowLen, AMaxLen, AAttr: Byte): String;
Function OneKey (S : String; Echo : Boolean) : Char;

// DateTime
Function SecToDHMS(ASec: LongInt): String;
Function SecToHM(ASec: LongInt): String;
Function SecToHMS(ASec: LongInt): String;
Function SecToMS(ASec: LongInt): String;

implementation

{$IFDEF FPC}
  uses
    Crt, SysUtils,StrUtils,DOS;
{$EndIF}
{$IFDEF VPASCAL}
  uses
    {$IFDEF OS2}OS2Base,{$EndIF} VPUtils, VpSysLow, VpUsrLow;
{$EndIF}

{$IFDEF GO32V2}
  var
    Screen: TScreenBuf absolute $B800:0000;
{$EndIF}
{$IFDEF WIN32}
  var
    StdOut: THandle;
{$EndIF}

 var
  AnsiBracket: Boolean;
  AnsiBuffer: String;
  AnsiCnt: Byte;
  AnsiEscape: Boolean;
  AnsiParams: Array[1..10] of Integer;
  AnsiXY: Word;

Procedure Ansi_Color (FG, BG : Byte);
Begin

  Case FG of
    00: Write (#27 + '[0;30m');
    01: Write (#27 + '[0;34m');
    02: Write (#27 + '[0;32m');
    03: Write (#27 + '[0;36m');
    04: Write (#27 + '[0;31m');
    05: Write (#27 + '[0;35m');
    06: Write (#27 + '[0;33m');
    07: Write (#27 + '[0;37m');
    08: Write (#27 + '[1;30m');
    09: Write (#27 + '[1;34m');
    10: Write (#27 + '[1;32m');
    11: Write (#27 + '[1;36m');
    12: Write (#27 + '[1;31m');
    13: Write (#27 + '[1;35m');
    14: Write (#27 + '[1;33m');
    15: Write (#27 + '[1;37m');
  End;

  Case BG of
    00: Write (#27 + '[40m');
    01: Write (#27 + '[44m');
    02: Write (#27 + '[42m');
    03: Write (#27 + '[46m');
    04: Write (#27 + '[41m');
    05: Write (#27 + '[45m');
    06: Write (#27 + '[43m');
    07: Write (#27 + '[47m');
  End;
End;

Procedure WritePipe (Str : String);
Var
  A    : Byte;
  Code : String[2];
  FG   : Byte;
  BG   : Byte;
Begin
  For A := 1 to Length(Str) Do Begin
    If (Str[A] = '|') and (A + 2 <= Length(Str)) Then Begin
      FG   := TextAttr And $F;
      BG   := (TextAttr SHR 4) And 7;
      Code := Copy(Str, A + 1, 2);
      Inc (A, 2);
      If Code = '00' Then ansi_Color (00, BG) Else
      If Code = '01' Then ansi_Color (01, BG) Else
      If Code = '02' Then ansi_Color (02, BG) Else
      If Code = '03' Then ansi_Color (03, BG) Else
      If Code = '04' Then ansi_Color (04, BG) Else
      If Code = '05' Then ansi_Color (05, BG) Else
      If Code = '06' Then ansi_Color (06, BG) Else
      If Code = '07' Then ansi_Color (07, BG) Else
      If Code = '08' Then ansi_Color (08, BG) Else
      If Code = '09' Then ansi_Color (09, BG) Else
      If Code = '10' Then ansi_Color (10, BG) Else
      If Code = '11' Then ansi_Color (11, BG) Else
      If Code = '12' Then ansi_Color (12, BG) Else
      If Code = '13' Then ansi_Color (13, BG) Else
      If Code = '14' Then ansi_Color (14, BG) Else
      If Code = '15' Then ansi_Color (15, BG) Else
      If Code = '16' Then ansi_Color (FG, 00) Else
      If Code = '17' Then ansi_Color (FG, 01) Else
      If Code = '18' Then ansi_Color (FG, 02) Else
      If Code = '19' Then ansi_Color (FG, 03) Else
      If Code = '20' Then ansi_Color (FG, 04) Else
      If Code = '21' Then ansi_Color (FG, 05) Else
      If Code = '22' Then ansi_Color (FG, 06) Else
      If Code = '23' Then ansi_Color (FG, 07) Else
      If Code = 'CL' Then ClrScr              Else
      If Code = 'CR' Then Write(#13#10)       Else
      Begin
        Write('|');
        Dec (A, 2);
      End;

    End Else
      Write(Str[A]);
  End;
End;


{$IFDEF GO32V2}
Procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
var
  I: Integer;
Begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

  { Trim to fit within 80 columns }
  if (Length(ALine) > (80 - AX + 1)) then ALine := Copy(ALine, 1, 80 - AX + 1);

  for I := 1 to Length(ALine) do
  Begin
    Screen[AY, AX + (I - 1)].Ch := ALine[I];
    Screen[AY, AX + (I - 1)].Attr := AAttr;
  End;
End;
{$EndIF}
{$IFDEF OS2}
Procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
Begin
  SysWrtCharStrAtt(@ALine[1], Length(ALine), AX - 1, AY - 1, AAttr);
End;
{$EndIF}
{$IFDEF UNIX}
  {$IFDEF FPC}
  Procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
  var
    NeedWindow: Boolean;
    SavedAttr: Integer;
    SavedWindMinX: Integer;
    SavedWindMinY: Integer;
    SavedWindMaxX: Integer;
    SavedWindMaxY: Integer;
    SavedXY: Integer;
  Begin
    { Validate parameters }
    if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

    { Trim to fit within 80 columns }
    if (Length(ALine) > (80 - AX + 1)) then ALine := Copy(ALine, 1, 80 - AX + 1);

    // Save
    NeedWindow := ((WindMinX > 1) OR (WindMinY > 1) OR (WindMaxX < 80) OR (WindmaxY < 25));
    SavedAttr := TextAttr;
    SavedWindMinX := WindMinX;
    SavedWindMinY := WindMinY;
    SavedWindMaxX := WindMaxX;
    SavedWindMaxY := WindMaxY;
    SavedXY := WhereX + (WhereY SHL 8);

    // Update
    if (NeedWindow) then Window(1, 1, 80, 25);
    GotoXY(AX, AY);
    TextAttr := AAttr;

    // Trim to fit within 79 columns if on line 25
    if ((AY = 25) AND (Length(ALine) > (79 - AX + 1))) then ALine := Copy(ALine, 1, 79 - AX + 1);

    // Output
    Write(ALine);

    // Restore
    TextAttr := SavedAttr;
    if (NeedWindow) then Window(SavedWindMinX, SavedWindMinY, SavedWindMaxX, SavedWindMaxY);
    GotoXY(SavedXY AND $00FF, (SavedXY AND $FF00) SHR 8);
  End;
  {$EndIF}
  {$IFDEF VPASCAL}
  Procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
  Begin
    SysWrtCharStrAtt(@ALine[1], Length(ALine), AX - 1, AY - 1, AAttr);
  End;
  {$EndIF}
{$EndIF}
{$IFDEF WINDOWS}
Procedure FastWrite(ALine: String; AX, AY, AAttr: Byte);
var
  Buffer: Array[0..255] of TCharInfo;
  BufferCoord: TCoord;
  BufferSize: TCoord;
  I: Integer;
  WriteRegion: TSmallRect;
Begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

  { Trim to fit within 80 columns }
  if (Length(ALine) > (80 - AX + 1)) then ALine := Copy(ALine, 1, 80 - AX + 1);

  for I := 0 to Length(ALine) - 1 do
  Begin
    Buffer[I].Attributes := AAttr;
    Buffer[I].AsciiChar := ALine[I + 1];
  End;
  BufferSize.X := Length(ALine);
  BufferSize.Y := 1;
  BufferCoord.X := 0;
  BufferCoord.Y := 0;
  WriteRegion.Left := AX - 1;
  WriteRegion.Top := AY - 1;
  WriteRegion.Right := AX + Length(ALine) - 2;
  WriteRegion.Bottom := AY - 1;
  WriteConsoleOutput(StdOut, @Buffer, BufferSize, BufferCoord, WriteRegion);
End;
{$EndIF}

{$IFDEF GO32V2}
Function GetAttrAt(AX, AY: Byte): Byte;
Begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then
  Begin
    GetAttrAt := 7;
    Exit;
  End;

  GetAttrAt := Screen[AY, AX].Attr;
End;
{$EndIF}
{$IFDEF OS2}
Function GetAttrAt(AX, AY: Byte): Byte;
Begin
  GetAttrAt := SysReadAttributesAt(AX - 1, AY - 1);
End;
{$EndIF}
{$IFDEF UNIX}
  {$IFDEF FPC}
  Function GetAttrAt(AX, AY: Byte): Byte;
  Begin
    { Validate parameters }
    if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then
    Begin
      GetAttrAt := 7;
      Exit;
    End;

    GetAttrAt := ConsoleBuf^[((AY - 1) * ScreenWidth) + (AX - 1)].attr;
  End;
  {$EndIF}
  {$IFDEF VPASCAL}
  Function GetAttrAt(AX, AY: Byte): Byte;
  Begin
    GetAttrAt := SysReadAttributesAt(AX - 1, AY - 1);
  End;
  {$EndIF}
{$EndIF}
{$IFDEF WINDOWS}
Function GetAttrAt(AX, AY: Byte): Byte;
var
  Attr: Word;
  Coord: TCoord;
  {$IFDEF FPC}NumRead: Cardinal;{$EndIF}
  {$IFDEF VPASCAL}NumRead: Integer;{$EndIF}
Begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then
  Begin
    GetAttrAt := 7;
    Exit;
  End;

  Coord.X := AX - 1;
  Coord.Y := AY - 1;
  ReadConsoleOutputAttribute(StdOut, @Attr, 1, Coord, NumRead);
  GetAttrAt := Attr;
End;
{$EndIF}

{$IFDEF GO32V2}
Function GetCharAt(AX, AY: Byte): Char;
Begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then
  Begin
    GetCharAt := ' ';
    Exit;
  End;

  GetCharAt := Screen[AY, AX].Ch;
End;
{$EndIF}
{$IFDEF OS2}
Function GetCharAt(AX, AY: Byte): Char;
Begin
  GetCharAt := SysReadCharAt(AX - 1, AY - 1);
End;
{$EndIF}
{$IFDEF UNIX}
  {$IFDEF FPC}
  Function GetCharAt(AX, AY: Byte): Char;
  Begin
    { Validate parameters }
    if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then
    Begin
      GetCharAt := ' ';
      Exit;
    End;

    GetCharAt := ConsoleBuf^[((AY - 1) * ScreenWidth) + (AX - 1)].ch;
  End;
  {$EndIF}
  {$IFDEF VPASCAL}
  Function GetCharAt(AX, AY: Byte): Char;
  Begin
    GetCharAt := SysReadCharAt(AX - 1, AY - 1);
  End;
  {$EndIF}
{$EndIF}
{$IFDEF WINDOWS}
Function GetCharAt(AX, AY: Byte): Char;
var
  Ch: Char;
  Coord: TCoord;
  {$IFDEF FPC}NumRead: Cardinal;{$EndIF}
  {$IFDEF VPASCAL}NumRead: Integer;{$EndIF}
Begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then
  Begin
    GetCharAt := ' ';
    Exit;
  End;

  Coord.X := AX - 1;
  Coord.Y := AY - 1;
  ReadConsoleOutputCharacter(StdOut, @Ch, 1, Coord, NumRead);
  if (NumRead = 0) then
  Begin
    GetCharAt := #32
  End else
  Begin
    GetCharAt := Ch;
  End;
End;
{$EndIF}

{ REETODO Should detect screen size }
{$IFDEF WIN32}
Procedure RestoreScreen(var screenBuf: TScreenBuf);
var
  BufSize:  TCoord;
  WritePos: TCoord;
  DestRect: TSmallRect;
Begin
  // REETODO Don't hardcode to 80x25
  BufSize.X := 80;
  BufSize.Y := 25;
  WritePos.X := 0;
  WritePos.Y := 0;
  DestRect.Left := 0;
  DestRect.Top := 0;
  DestRect.Right := 79;
  DestRect.Bottom := 24;
  WriteConsoleOutput(GetStdHandle(STD_OUTPUT_HANDLE), @screenBuf[1][1], BufSize, WritePos, DestRect);
End;
{$EndIF}
{$IFDEF OS2}
Procedure RestoreScreen(var screenBuf: TScreenBuf);
var
  Size: SmallWord;
Begin
  Size := SizeOf(TScreenBuf);
  VioWrtCellStr(@screenBuf, Size, 0, 0, 0);
End;
{$EndIF}
{$IFDEF UNIX}
Procedure RestoreScreen(var screenBuf: TScreenBuf);
var
  X, Y: integer;
Begin
  // REETODO Don't hardcode to 80x25
  for Y := 1 to 25 do
  Begin
    for X := 1 to 80 do
    Begin
      FastWrite(screenBuf[Y][X].Ch, X, Y, screenBuf[Y][X].Attr);
    End;
  End;
End;
{$EndIF}
{$IFDEF GO32V2}
Procedure RestoreScreen(var screenBuf: TScreenBuf);
var
  X, Y: integer;
Begin
  // REETODO Don't hardcode to 80x25
  for Y := 1 to 25 do
  Begin
    for X := 1 to 80 do
    Begin
      FastWrite(screenBuf[Y][X].Ch, X, Y, screenBuf[Y][X].Attr);
    End;
  End;
End;
{$EndIF}

{ REETODO Should detect screen size }
{$IFDEF WIN32}
Procedure SaveScreen(var screenBuf: TScreenBuf);
var
  BufSize:    TCoord;
  ReadPos:    TCoord;
  SourceRect: TSmallRect;
Begin
  // REETODO Don't hardcode to 80x25
  BufSize.X := 80;
  BufSize.Y := 25;
  ReadPos.X := 0;
  ReadPos.Y := 0;
  SourceRect.Left := 0;
  SourceRect.Top := 0;
  SourceRect.Right := 79;
  SourceRect.Bottom := 24;
  ReadConsoleOutput(GetStdHandle(STD_OUTPUT_HANDLE), @screenBuf[1][1], BufSize, ReadPos, SourceRect);
End;
{$EndIF}
{$IFDEF OS2}
Procedure SaveScreen(var screenBuf: TScreenBuf);
var
  Size: SmallWord;
Begin
  Size := SizeOf(TScreenBuf);
  VioReadCellStr(screenBuf, Size, 0, 0, 0);
End;
{$EndIF}
{$IFDEF UNIX}
Procedure SaveScreen(var screenBuf: TScreenBuf);
var
  X, Y: integer;
Begin
  {$IFDEF VPASCAL}
    Move(SysTVGetSrcBuf^, screenBuf, SizeOf(TScreenBuf));
  {$EndIF}
  {$IFNDEF VPASCAL}
    for Y := 1 to 25 do
    Begin
      for X := 1 to 80 do
      Begin
        screenBuf[Y][X].Ch := GetCharAt(X, Y);
        screenBuf[Y][X].Attr := GetAttrAt(X, Y);
      End;
    End;
  {$EndIF}
End;
{$EndIF}
{$IFDEF GO32V2}
Procedure SaveScreen(var screenBuf: TScreenBuf);
var
  X, Y: integer;
Begin
  for Y := 1 to 25 do
  Begin
    for X := 1 to 80 do
    Begin
      screenBuf[Y][X].Ch := GetCharAt(X, Y);
      screenBuf[Y][X].Attr := GetAttrAt(X, Y);
    End;
  End;
End;
{$EndIF}

{$IFDEF GO32V2}
Procedure SetAttrAt(AAttr, AX, AY: Byte);
Begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

  Screen[AY, AX].Attr := AAttr;
End;
{$EndIF}
{$IFDEF WIN32}
Procedure SetAttrAt(AAttr, AX, AY: Byte);
var
  NumWritten: longint;
  WriteCoord: TCoord;
Begin
  WriteCoord.X := AX - 1;
  WriteCoord.Y := AY - 1;
  WriteConsoleOutputAttribute(StdOut, @AAttr, 1, WriteCoord, NumWritten);
End;
{$EndIF}
{$IFDEF OS2}
Procedure SetAttrAt(AAttr, AX, AY: Byte);
var
  Ch: char;
Begin
  Ch := SysReadCharAt(AX - 1, AY - 1);
  SysWrtCharStrAtt(@Ch, 1, AX - 1, AY - 1, AAttr);
End;
{$EndIF}
{$IFDEF UNIX}
  {$IFDEF FPC}
  Procedure SetAttrAt(AAttr, AX, AY: Byte);
  var
    NeedWindow: Boolean;
    SavedAttr: Integer;
    SavedWindMinX: Integer;
    SavedWindMinY: Integer;
    SavedWindMaxX: Integer;
    SavedWindMaxY: Integer;
    SavedXY: Integer;
  Begin
    { Validate parameters }
    if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

    // Save
    NeedWindow := ((WindMinX > 1) OR (WindMinY > 1) OR (WindMaxX < 80) OR (WindmaxY < 25));
    SavedAttr := TextAttr;
    SavedWindMinX := WindMinX;
    SavedWindMinY := WindMinY;
    SavedWindMaxX := WindMaxX;
    SavedWindMaxY := WindMaxY;
    SavedXY := WhereX + (WhereY SHL 8);

    // Update
    if (NeedWindow) then Window(1, 1, 80, 25);
    GotoXY(AX, AY);
    TextAttr := AAttr;

    // Output
    Write(GetCharAt(AX, AY));

    // Restore
    TextAttr := SavedAttr;
    if (NeedWindow) then Window(SavedWindMinX, SavedWindMinY, SavedWindMaxX, SavedWindMaxY);
    GotoXY(SavedXY AND $00FF, (SavedXY AND $FF00) SHR 8);
  End;
  {$EndIF}
  {$IFDEF VPASCAL}
  Procedure SetAttrAt(AAttr, AX, AY: Byte);
  var
    Ch: char;
  Begin
    Ch := SysReadCharAt(AX - 1, AY - 1);
    SysWrtCharStrAtt(@Ch, 1, AX - 1, AY - 1, AAttr);
  End;
  {$EndIF}
{$EndIF}

{$IFDEF GO32V2}
Procedure SetCharAt(ACh: Char; AX, AY: Byte);
Begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

  Screen[AY, AX].Ch := ACh;
End;
{$EndIF}
{$IFDEF OS2}
Procedure SetCharAt(ACh: Char; AX, AY: Byte);
var
  Attr: byte;
Begin
  Attr := SysReadAttributesAt(AX - 1, AY - 1);
  SysWrtCharStrAtt(@ACh, 1, AX - 1, AY - 1, Attr);
End;
{$EndIF}
{$IFDEF UNIX}
  {$IFDEF FPC}
  Procedure SetCharAt(ACh: Char; AX, AY: Byte);
  var
    NeedWindow: Boolean;
    SavedAttr: Integer;
    SavedWindMinX: Integer;
    SavedWindMinY: Integer;
    SavedWindMaxX: Integer;
    SavedWindMaxY: Integer;
    SavedXY: Integer;
  Begin
    { Validate parameters }
    if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

    // Save
    NeedWindow := ((WindMinX > 1) OR (WindMinY > 1) OR (WindMaxX < 80) OR (WindmaxY < 25));
    SavedAttr := TextAttr;
    SavedWindMinX := WindMinX;
    SavedWindMinY := WindMinY;
    SavedWindMaxX := WindMaxX;
    SavedWindMaxY := WindMaxY;
    SavedXY := WhereX + (WhereY SHL 8);

    // Update
    if (NeedWindow) then Window(1, 1, 80, 25);
    GotoXY(AX, AY);
    TextAttr := GetAttrAt(AX, AY);

    // Output
    Write(ACh);

    // Restore
    TextAttr := SavedAttr;
    if (NeedWindow) then Window(SavedWindMinX, SavedWindMinY, SavedWindMaxX, SavedWindMaxY);
    GotoXY(SavedXY AND $00FF, (SavedXY AND $FF00) SHR 8);
  End;
  {$EndIF}
  {$IFDEF VPASCAL}
  Procedure SetCharAt(ACh: Char; AX, AY: Byte);
  var
    Attr: byte;
  Begin
    Attr := SysReadAttributesAt(AX - 1, AY - 1);
    SysWrtCharStrAtt(@ACh, 1, AX - 1, AY - 1, Attr);
  End;
  {$EndIF}
{$EndIF}
{$IFDEF WINDOWS}
Procedure SetCharAt(ACh: Char; AX, AY: Byte);
var
  WriteCoord: TCoord;
  {$IFDEF FPC}NumWritten: Cardinal;{$EndIF}
  {$IFDEF VPASCAL}NumWritten: Integer;{$EndIF}
Begin
  { Validate parameters }
  if ((AX < 1) OR (AX > 80) OR (AY < 1) OR (AY > 25)) then Exit;

  WriteCoord.X := AX - 1;
  WriteCoord.Y := AY - 1;
  WriteConsoleOutputCharacter(StdOut, @ACh, 1, WriteCoord, NumWritten);
End;
{$EndIF}

Function CurrentFG: Byte;
Begin
  CurrentFG := TextAttr and $0f
End;


{ù-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ù}
{  Returns current background color                                          }
{ù-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ù}

Function CurrentBG: Byte;
Begin
  CurrentBG := (TextAttr and $f0) shr 4     { shift right beyotch }
End;
 
Function LoCase (C: Char): Char;
Begin
  If (C in ['A'..'Z']) Then
    LoCase := Chr(Ord(C) + 32)
  Else
    LoCase := C;
End; 

Procedure GotoX(B: Byte);
 Begin
  if b > wherex then Begin  { this means you have to move right }
   Write(#27+'['+IntToStr(b-wherex)+'C');
   End;
  if b < wherex then Begin  { this means you gotta go left }
   Write(#27+'['+IntToStr(wherex-b)+'D');
   End;
  { and if it's equal, you're already there }
 End;

Procedure GotoY(B: Byte); { fixed }
 Begin
  if b < wherey then Begin  { this means you have to move up }
   Write(#27+'['+IntToStr(wherey-b)+'A');
   End;
  if b > wherey then Begin  { this means you gotta go down }
   Write(#27+'['+IntToStr(b-wherey)+'B');
   End;
  { and if it's equal, you're already there }
 End;

{
  Works like Pos(), only case insensitive
}
Function ciPos(ASubStr, ALine: String): LongInt;
Begin
     ciPos := Pos(UpperCase(ASubStr), UpperCase(ALine));
End;
 
Function AddSlash(ALine: String): String;
Begin
     if (ALine[Length(ALine)] <> PathSep) then
        ALine := ALine + PathSep;
     AddSlash := ALine;
End;

{
  Return string ATRUE or AFALSE depEnding on the value of AVALUE
}
Function BoolToStr(AValue: Boolean; ATrue, AFalse: String): String;
Begin
     if (AValue) then
        BoolToStr := ATrue
     else
         BoolToStr := AFalse;
End;
 
Function Center(ALine: String): String;
var
  Width: Integer;
Begin
     Width := Lo(WindMax) - Lo(WindMin) + 1;
     if (Length(ALine) < Width) then
        ALine := PadLeft(ALine, ' ', Length(ALine) + (Width - Length(ALine)) div 2);
     Center := ALine;
End;

{
  A fancy input routine

  ADefault - The text initially displayed in the edit box
  AChars   - The characters ALLOWED to be part of the string
             Look in MSTRINGS.PAS for some defaults
  APass    - The password character shown instead of the actual text
             Use #0 if you dont want to hide the text
  AShowLen - The number of characters big the edit box should be on screen
  AMaxLen  - The number of characters the edit box should allow
             AMaxLen can be larger than AShowLen, it will just scroll
             if that happens.
  AAttr    - The text attribute of the editbox's text and background
             Use formula Attr = Foreground + (Background * 16)

  If the user pressed ESCAPE then ADefault is returned.  If they hit enter
  the current string is returned.  They cannot hit enter on a blank line.
}
Function Input(ADefault, AChars: String; APass: Char; AShowLen, AMaxLen, AAttr: Byte): String;
var
   Ch: Char;
   S: String;
   SavedAttr: Byte;
   XPos: Byte;

  Procedure UpdateText;
  Begin
       GotoX(XPos);
       if (Length(S) > AShowLen) then
       Begin
            if (APass = #0) then
               Write(Copy(S, Length(S) - AShowLen + 1, AShowLen))
            else
                Write(PadRight('', APass, AShowLen));
            GotoX(XPos + AShowLen);
       End else
       Begin
            if (APass = #0) then
               Write(S)
            else
                Write(PadRight('', APass, Length(S)));
            Write(PadRight('', ' ', AShowLen - Length(S)));
            GotoX(XPos + Length(S));
       End;
  End;

Begin
     if (Length(ADefault) > AMaxLen) then
        ADefault := Copy(ADefault, 1, AMaxLen);
     S := ADefault;

     SavedAttr := TextAttr;
     TextAttr:=AAttr;
     XPos := WhereX;

     UpdateText;

     repeat
           Ch := ReadKey;
           if (Ch = #8) and (Length(S) > 0) then
           Begin
                Delete(S, Length(S), 1);
                Write(#8 + ' ' + #8);
                if (Length(S) >= AShowLen) then
                   UpdateText;
           End else
           if (Ch = #25) and (S <> '') then {CTRL-Y}
           Begin
                S := '';
                UpdateText;
           End else
           if (Pos(Ch, AChars) > 0) and (Length(S) < AMaxLen) then
           Begin
                S := S + Ch;
                if (Length(S) > AShowLen) then
                   UpdateText
                else
                if (APass = #0) then
                   Write(Ch)
                else
                    Write(APass);
           End;
     until (Ch = #27) or ((Ch = #13) and (S <> ''));

     TextAttr:=SavedAttr;
     Write(#13#10);

     if (Ch = #27) then
        S := ADefault;
     Input := S;
End;

{
  Return ALINE with no trailing backslash
}
Function NoSlash(ALine: String): String;
Begin
     if (ALine[Length(ALine)] = PathSep) then
        Delete(ALine, Length(ALine), 1);
     NoSlash := ALine;
End;

{
  Return ALINE padded on the left side with ACH until it is ALEN characters
  long.  Cut ALINE if it is more than ALEN characters
}
Function PadLeft(ALine: String; ACh: Char; ALen: Integer): String;
Begin
     while (Length(ALine) < ALen) do
           ALine := ACh + ALine;
     PadLeft := Copy(ALine, 1, ALen);
End;

{
  Same as PadLeft(), but pad the right of the string
}
Function PadRight(ALine: String; ACh: Char; ALen: Integer): String;
Begin
     while (Length(ALine) < ALen) do
           ALine := ALine + ACh;
     PadRight := Copy(ALine, 1, ALen)
End;

Function Replace(ALine, AOld, ANew: String): String;
var
  MatchPos: LongInt;
Begin
     if (ciPos(AOld, ANew) = 0) then
     Begin
          MatchPos := ciPos(AOld, ALine);
          while (MatchPos > 0) do
          Begin
               Delete(ALine, MatchPos, Length(AOld));
               Insert(ANew, ALine, MatchPos);
               MatchPos := ciPos(AOld, ALine);
          End;
     End;
     Replace := ALine;
End;

{
  Same as Center() but makes string right aligned
}
Function Right(ALine: String): String;
var
  Width: Integer;
Begin
     Width := Lo(WindMax) - Lo(WindMin) + 1;
     Right := PadLeft(ALine, ' ', Width);
End;

Function StripChar(ALine: String; ACh: Char): String;
Begin
     while (Pos(ACh, ALine) > 0) do
           Delete(ALine, Pos(ACh, ALine), 1);
     StripChar := ALine;
End;

Function AppName: String;
Begin
     AppName := ExtractFileName(ParamStr(0));
End;

{
  Return the path name with trailing backslash of the currently running app.
}
Function AppPath: String;
Begin
     AppPath := AddSlash(ExtractFilePath(ParamStr(0)));
End;

Function Upper (Str: String) : String;
Var
  A : Byte;
Begin
  For A := 1 to Length(Str) Do Str[A] := UpCase(Str[A]);
  Upper := Str;
End;

Function FileExist (Str : String) : Boolean;
Var
  DF   : File;
  Attr : Word;
Begin
  Assign   (DF, Str);
  GetFattr (DF, Attr);

  FileExist := (DosError = 0) and (Attr And Directory = 0);
End;

Procedure AnsiCommand(Cmd: Char);
var
  I: Integer;
  Colour: Integer;
Begin
     case Cmd of
          'A': Begin { Cursor Up }
                    if (AnsiParams[1] < 1) then
                       AnsiParams[1] := 1;
                    I := WhereY - AnsiParams[1];
                    if (I < 1) then
                       I := 1;
                    GotoXY(WhereX, I);
               End;
          'B': Begin { Cursor Down }
                    if (AnsiParams[1] < 1) then
                       AnsiParams[1] := 1;
                    I := WhereY + AnsiParams[1];
                    if (I > Hi(WindMax) - Hi(WindMin)) then
                       I := Hi(WindMax) - Hi(WindMin) + 1;
                    GotoXY(WhereX, I);
               End;
          'C': Begin { Cursor Right }
                    if (AnsiParams[1] < 1) then
                       AnsiParams[1] := 1;
                    I := WhereX + AnsiParams[1];
                    if (I > Lo(WindMax) - Lo(WindMin)) then
                       I := Lo(WindMax) - Lo(WindMin) + 1;
                    GotoXY(I, WhereY);
               End;
          'D': Begin { Cursor Left }
                    if (AnsiParams[1] < 1) then
                       AnsiParams[1] := 1;
                    I := WhereX - AnsiParams[1];
                    if (I < 1) then
                       I := 1;
                    GotoXY(I, WhereY);
               End;
     'f', 'H': Begin { Cursor Placement }
                    if (AnsiParams[1] < 1) then
                       AnsiParams[1] := 1;
                    if (AnsiParams[2] < 1) then
                       AnsiParams[2] := 1;
                    GotoXY(AnsiParams[2], AnsiParams[1]);
               End;
          'J': if (AnsiParams[1] = 2) then { Clear Screen }
                  ClrScr;
          'K': ClrEol; { Clear To End Of Line }
          'm': Begin { Change Text Appearance }
                    if (AnsiParams[1] < 1) then
                       AnsiParams[1] := 0;
                    I := 0;
                    while (AnsiParams[I + 1] <> -1) do
                    Begin
                         Inc(I);
                         case AnsiParams[I] of
                              0: TextAttr := 7; { Normal Video }
                              1: HighVideo; { High Video }
                              7: TextAttr := ((TextAttr and $70) shr 4) + ((TextAttr and $07) shl 4); { Reverse Video }
                              8: TextAttr := 0; { Video Off }
                         30..37: Begin
                                      Colour := AnsiColours[AnsiParams[I] - 30];
                                      if (TextAttr mod 16 > 7) then
                                         Inc(Colour, 8);
                                      TextColor(Colour);
                                 End;
                         40..47: TextBackground(AnsiColours[AnsiParams[I] - 40]);
                         End;
                    End;
               End;
          's': AnsiXY := WhereX + (WhereY shl 8);
          'u': GotoXY(AnsiXY and $00FF, (AnsiXY and $FF00) shr 8);
     End;
End;

Procedure aWrite(ALine: String);
var
  Buf: String;
  I, J: Integer;
 
Begin
     Buf := '';
     for I := 1 to Length(ALine) do
     Begin
          if (ALine[I] = #27) then
          Begin
               AnsiBracket := False;
               AnsiEscape := True;
          End else
          if (AnsiEscape) and (ALine[I] = '[') then
          Begin
               AnsiBracket := True;
               AnsiBuffer := '';
               AnsiCnt := 1;
               AnsiEscape := False;
               for J := Low(AnsiParams) to High(AnsiParams) do
                   AnsiParams[J] := -1;
          End else
          if (AnsiBracket) then
          Begin
               if (ALine[I] in ['?', '=', '<', '>', ' ']) then
                  { ignore these characters }
               else
               if (ALine[I] in ['0'..'9']) then
                  AnsiBuffer := AnsiBuffer + ALine[I]
               else
               if (ALine[I] = ';') then
               Begin
                    AnsiParams[AnsiCnt] := StrToIntDef(AnsiBuffer, 0);
                    AnsiBuffer := '';
                    Inc(AnsiCnt);
                    if (AnsiCnt > High(AnsiParams)) then
                       AnsiCnt := High(AnsiParams);
               End else
               Begin
                    Write(Buf);
                    Buf := '';
                    
                    AnsiParams[AnsiCnt] := StrToIntDef(AnsiBuffer, 0);
                    AnsiCommand(ALine[I]);
                    AnsiBracket := False;
               End;
          End else
              Buf := Buf + ALine[I];
     End;
     Write(Buf);
End;

Procedure DispFile(AFile: String);
var
  F: Text;
  S: String;
Begin
     if (FileExists(AFile)) then
     Begin
          Assign(F, AFile);
          {$I-}Reset(F);{$I+}
          if (IOResult = 0) then
          Begin
               while Not(EOF(F)) do
               Begin
                    ReadLn(F, S);
                    if (EOF(F)) then
                       aWrite(S)
                    else
                        aWrite(S+ #13#10);
               End;
               Close(F);
          End;
     End;
End;

Procedure TextBackground(AColour: Byte);
Begin
    Ansi_Color (255, Acolour);
End;

Function strRep (Ch: Char; Len: Byte) : String;
Var
  Count : Byte;
  Str   : String;
Begin
  Str := '';
  For Count := 1 to Len Do Str := Str + Ch;
  strRep := Str;
End;

Function Lower (Str: String) : String;
Var
  Count : Byte;
Begin
  For Count := 1 to Length(Str) Do
    Str[Count] := LoCase(Str[Count]);

  Lower := Str;
End;

Function strPadR (Str: String; Len: Byte; Ch: Char) : String;
Begin
  If Length(Str) > Len Then
    Str := Copy(Str, 1, Len)
  Else
    While Length(Str) < Len Do Str := Str + Ch;

  strPadR := Str;
End;

Function strPadC (Str: String; Len: Byte; Ch: Char) : String;
Var
  Space : Byte;
  Temp  : Byte;
Begin
  If Length(Str) > Len Then Begin
    Str[0] := Chr(Len);
    strPadC := Str;

    Exit;
  End;

  Space  := (Len - Length(Str)) DIV 2;
  Temp   := Len - ((Space * 2) + Length(Str));
  strPadC := strRep(Ch, Space) + Str + strRep(Ch, Space + Temp);
End;

Function strPadL (Str: String; Len: Byte; Ch: Char): String;
Var
  TStr : String;
Begin
  If Length(Str) >= Len Then
    strPadL := Copy(Str, 1, Len)
  Else Begin
    FillChar  (TStr[1], Len, Ch);
    SetLength (TStr, Len - Length(Str));

    strPadL  := TStr + Str;
  End;
End;

Procedure WriteXY (X, Y, A: Byte; Text: String);
Var
  OldAttr : Byte;
Begin
  OldAttr:=TextAttr;
  GotoXY(X,Y);
  TextAttr:=A;
  Write(Text);
  TextAttr:=OldAttr;
End;

Procedure WriteXYPipe (X, Y, Attr: Byte; Text: String);
Var
  OldAttr : Byte;
Begin
  OldAttr:=TextAttr;
  GotoXY(X,Y);
  TextAttr:=Attr;
  WritePipe(Text);
  TextAttr:=OldAttr;
End;

Function strStripL (Str: String; Ch: Char) : String;
Begin
  While ((Str[1] = Ch) and (Length(Str) > 0)) Do
    Str := Copy(Str, 2, Length(Str));

  strStripL := Str;
End;

Function strStripR (Str: String; Ch: Char) : String;
Begin
  While Str[Length(Str)] = Ch Do Dec(Str[0]);
  strStripR := Str;
End;

Function strStripB (Str: String; Ch: Char) : String;
Begin
  strStripB := strStripR(strStripL(Str, Ch), Ch);
End;
Function strWordCount (Str: String; Ch: Char) : Byte;
Var
  Start : Byte;
  Res   : Byte;
Begin
  Res := 0;

  If Ch = ' ' Then
    While Str[1] = Ch Do
      Delete (Str, 1, 1);

  If Str = '' Then Exit;

  Res := 1;

  While Pos(Ch, Str) > 0 Do Begin
    Inc (Res);

    Start := Pos(Ch, Str);

    If Ch = ' ' Then Begin
      While Str[Start] = Ch Do
        Delete (Str, Start, 1);
    End Else
      Delete (Str, Start, 1);
  End;
  strWordCount := Res;
End;

Function strWordPos (Num: Byte; Str: String; Ch: Char) : Byte;
Var
  Count : Byte;
  Temp  : Byte;
  Res   : Byte;
Begin
  Res := 1;
  Count  := 1;

  While Count < Num Do Begin
    Temp := Pos(Ch, Str);

    If Temp = 0 Then Exit;

    Delete (Str, 1, Temp);

    While Str[1] = Ch Do Begin
      Delete (Str, 1, 1);
      Inc (Temp);
    End;

    Inc (Count);

    Inc (Res, Temp);
    strWordPos := Res;
  End;
End;

Function strWordGet (Num: Byte; Str: String; Ch: Char) : String;
Var
  Count : Byte;
  Temp  : String;
  Start : Byte;
Begin
  strWordGet := '';
  Count  := 1;
  Temp   := Str;

  If Ch = ' ' Then
    While Temp[1] = Ch Do
      Delete (Temp, 1, 1);

  While Count < Num Do Begin
    Start := Pos(Ch, Temp);

    If Start = 0 Then Exit;

    If Ch = ' ' Then Begin
      While Temp[Start] = Ch Do
        Inc (Start);

      Dec(Start);
    End;

    Delete (Temp, 1, Start);
    Inc    (Count);
  End;

  If Pos(Ch, Temp) > 0 Then
    strWordGet := Copy(Temp, 1, Pos(Ch, Temp) - 1)
  Else
    strWordGet := Temp;
End;

Function strStripLow (Str: String) : String;
Var
  Count : Byte;
Begin
  Count := 1;

  While Count <= Length(Str) Do
   If Str[Count] in [#00..#31] Then
     Delete (Str, Count, 1)
   Else
     Inc(Count);

  strStripLow := Str;
End;

Function strStripPipe (Str: String) : String;
Var
  Count : Byte;
  Code  : String[2];
  Res   : String;
Begin
  Res := '';
  Count  := 1;

  While Count <= Length(Str) Do Begin
    If (Str[Count] = '|') and (Count < Length(Str) - 1) Then Begin
      Code := Copy(Str, Count + 1, 2);
      If (Code = '00') or ((StrToInt(Code) > 0) and (StrToInt(Code) < 24)) Then
      Else
        Res := Res + '|' + Code;

      Inc (Count, 2);
    End Else
      Res := Res + Str[Count];

    Inc (Count);
  End;
  strStripPipe := Res;
End;

Function strStripMCI (Str: String) : String;
Begin
  While Pos('|', Str) > 0 Do
    Delete (Str, Pos('|', Str), 3);

  strStripMCI := Str;
End;

Function strMCILen (Str: String) : Byte;
Var
  A : Byte;
Begin
  Repeat
    A := Pos('|', Str);
    If (A > 0) and (A < Length(Str) - 1) Then
      Delete (Str, A, 3)
    Else
      Break;
  Until False;

  strMCILen := Length(Str);
End;

Function JustPath (Str: String) : String;
Var
  Count : Byte;
Begin
  For Count := Ord(Str[0]) DownTo 1 Do
    If (Str[Count] = '/') or (Str[Count] = '\') Then Begin
      Delete (Str, Count + 1, 255);
      Break;
    End;

  JustPath := Str;
End;

Function JustFile (Str: String) : String;
Var
  Count : Byte;
Begin
  For Count := Length(Str) DownTo 1 Do
    If (Str[Count] = '/') or (Str[Count] = '\') Then Begin
      Delete (Str, 1, Count);
      Break;
    End;

  JustFile := Str;
End;

Function JustFileName (Str: String) : String;
Var
  Temp : Byte;
  Res  : String;
Begin
  Res := Str;

  For Temp := Length(Res) DownTo 1 Do
    If Res[Temp] = '.' Then Begin
      Delete (Res, Temp, 255);
      Break;
    End;
    
  JustFileName := Res;
End;

Function JustFileExt (Str: String) : String;
Var
  Temp : Byte;
Begin
  JustFileExt := '';

  For Temp := Length(Str) DownTo 1 Do
    If Str[Temp] = '.' Then Begin
      JustFileExt := Copy(Str, Temp + 1, Length(Str));
      Exit;
    End;
End;

Function GetYN (X, Y, Attr: Byte; Default: Boolean) : Boolean;
Var
  Ch  : Char;
  Res : Boolean;
  YS  : Array[False..True] of String[3];
  LoChars : String;
  HiChars : String;
  ExitCode : Char;
  CHanged : Boolean;
Begin
  ExitCode := #0;
  Changed  := False;
  YS[True] := 'Yes';
  YS[False] := 'No ';
  LoChars := #13+' ';
  HiChars := ''+CursorLeft+CursorRight;

  GotoXY (X, Y);

  Res := Default;

  Repeat
    WriteXY (X, Y, Attr, YS[Res]);

    Ch := ReadKey;
    Case Ch of
      #00 : Begin
              Ch := ReadKey;
              If Pos(Ch, HiChars) > 0 Then Begin
                Res := Not Res;
              End;
            End;
      #13,
      #32 : Break;
    Else
      If Pos(Ch, LoChars) > 0 Then Begin
        ExitCode := Ch;
        Break;
      End;
    End;
  Until False;

  Changed := (Res <> Default);
  GetYN   := Res;
End;

Function OneKey (S : String; Echo : Boolean) : Char;
Var
  Ch : Char;
Begin
  Repeat
    Ch := UpCase(ReadKey);
  Until Pos(Ch, S) > 0;
  If Echo Then WriteLn(Ch);
  OneKey := Ch;
End;

{
  Returns a number of seconds formatted as:
  1d 1h 1m 1s
  0 values are not returned, so 3601 becomes
  1h 1s
}
Function SecToDHMS(ASec: LongInt): String;
var
  D, H, M, S: Integer;
Begin
     D := ASec div 86400;
     ASec := ASec mod 86400;
     H := ASec div 3600;
     ASec := ASec mod 3600;
     M := ASec div 60;
     S := ASec mod 60;
     SecToDHMS := IntToStr(D) + 'd ' + IntToStr(H) + 'h ' + IntToStr(M) + 'm ' + IntToStr(S) + 's';
End;

{
  Returns a number of seconds formatted as:
  HH:MM
}
Function SecToHM(ASec: LongInt): String;
var
  H, M: Integer;
Begin
     H := ASec div 3600;
     ASec := ASec mod 3600;
     M := ASec div 60;
     SecToHM := PadLeft(IntToStr(H), '0', 2) + ':' + PadLeft(IntToStr(M), '0', 2);
End;

{
  Returns a number of seconds formatted as:
  HH:MM:SS
}
Function SecToHMS(ASec: LongInt): String;
var
  H, M, S: Integer;
Begin
     H := ASec div 3600;
     ASec := ASec mod 3600;
     M := ASec div 60;
     S := ASec mod 60;
     SecToHMS := PadLeft(IntToStr(H), '0', 2) + ':' + PadLeft(IntToStr(M), '0', 2) + ':' + PadLeft(IntToStr(S), '0', 2);
End;

{
  Returns a number of seconds formatted as:
  MM:SS
}
Function SecToMS(ASec: LongInt): String;
var
  M, S: Integer;
Begin
     M := ASec div 60;
     S := ASec mod 60;
     SecToMS := PadLeft(IntToStr(M), '0', 2) + ':' + PadLeft(IntToStr(S), '0', 2);
End;

Function Str2Int (Str: String): LongInt;
Var
  N : LongWord;
  T : LongInt;
Begin
  Val(Str, T, N);
  Str2Int := T;
End;

Function Int2Str (N: LongInt): String;
Var
  T : String;
Begin
  Str(N, T);
  Int2Str := T;
End;

Begin
{$IFDEF WIN32}
  StdOut := GetStdHandle(STD_OUTPUT_HANDLE);
{$EndIF}
{$IFDEF UNIX}
  {$IFDEF VPASCAL}
    SysTVSetScrMode($FB); { $FB = COL2 = Color, graphics chars }
  {$EndIF}
{$EndIF}
AnsiBracket := False;
     AnsiBuffer := '';
     AnsiCnt := 1;
     AnsiEscape := False;
     AnsiXY := $0101;
End.
