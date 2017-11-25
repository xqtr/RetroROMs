program Retroroms;

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

Uses
  {$IFDEF DEBUG}
    LineInfo,
    HeapTrc,
  {$ENDIF}
  {$IFDEF UNIX}
    Unix,
  {$ENDIF}
  DOS,
  crt,
  xcrt,
  f_door,
  classes,
  //f_fileutils,
  strutils,
  math,
  db, 
  sqlite3ds;
  
Type
  CharSet = Set Of Char;
  
Const
  Version      = '1.0.0';  
  FmtChars : CharSet = ['!', '.', ',', ' ',')',';','-'];
  
Var
  ds          : TSQLite3Dataset;
  database    : String;
  StartDir    : String;
  Systems     : TStringList;
  Console     : String;
  i           : Integer;
  Res         : Integer;
  DescText    : TStringList;
  DescTop,
  DescBot      : Integer;
  Mode         : Byte = 0;
  GRes         : Integer;
  Total        : Integer;
  SelGame      : Integer;
  OuttaHere    : Boolean = False;
  
Procedure SortBox(x,y:byte); Forward;
Procedure FindGame(x,y:byte); Forward;

procedure listdir(dir:string; var dirs:tstringlist);
var
  Info : SearchRec;
begin
  // if we have found a file...
  FindFirst (AddSlash(dir)+'*',AnyFile ,Info);
  While DosError = 0 Do Begin
    
        If (Info.Attr and Directory) = Directory then begin
         if (Info.name<>'') and (Info.name<>'..') and (Info.name<>'.') then
         dirs.add(Info.name);
         
        end;
     FindNext(info);
   end;
   // we are done with file list
  FindClose(Info);
end;

function LevenshteinDistance(const s1 : string; s2 : string) : integer;
var
  length1, length2, i, j ,
  value1, value2, value3 : integer;
  matrix : array of array of integer;
begin
  length1 := Length( s1 );
  length2 := Length( s2 );
  SetLength (matrix, length1 + 1, length2 + 1);
  for i := 0 to length1 do matrix [i, 0] := i;
  for j := 0 to length2 do matrix [0, j] := j;
  for i := 1 to length1 do
    for j := 1 to length2 do
      begin
        if Copy( s1, i, 1) = Copy( s2, j, 1 )
          then matrix[i,j] := matrix[i-1,j-1]
          else  begin
            value1 := matrix [i-1, j] + 1;
            value2 := matrix [i, j-1] + 1;
            value3 := matrix[i-1, j-1] + 1;
            matrix [i, j] := min( value1, min( value2, value3 ));
          end;
      end;
  result := matrix [length1, length2];
end;

function CompareText(const s1, s2: string): integer;
var
  s1lower, s2lower: string;
begin
  s1lower := Lower( s1 );
  s2lower := Lower( s2 );
  result := LevenshteinDistance( s1lower, s2lower );
end;

function removespchar(str:string):string;
var
  tmp:string;
begin
  tmp:=str;
  tmp:=Replace(tmp,'''',' ');
  tmp:=Replace(tmp,'/','-');
  tmp:=Replace(tmp,'\','-');
  tmp:=Replace(tmp,';','');
  tmp:=Replace(tmp,'#','');
  tmp:=Replace(tmp,'*','');
  tmp:=Replace(tmp,'.','');
  tmp:=Replace(tmp,':','');
  tmp:=Replace(tmp,'&amp','and');
  tmp:=Replace(tmp,',','');
  tmp:=Replace(tmp,'-','');
  tmp:=Replace(tmp,' ','');
  result:=tmp;
end;

function removebrackets(str:string):string;
 var a,b,i:integer;
   found:boolean;
   s:string;
 begin
 s:=str;
   found:=true;
   repeat
     if pos('(',s)>0 then begin
        a:=pos('(',s);
        b:=pos(')',s);
        delete(s,a,b-a+1);
        result := s;
     end else found:=false;
   until found=false;
      found:=true;
   repeat
     if pos('[',s)>0 then begin
        a:=pos('[',s);
        b:=pos(']',s);
        delete(s,a,b-a+1);
        result := StrStripB(s,' ');
     end else found:=false;
   until found=false;
   a:=pos('GBA',s);
   if a>0 then delete(s,a,3);
   a:=pos('#',s);
   if a>0 then delete(s,a,1);
   result:=s;
 end;
 
function findromfile(romname:string; rompath:string):string;
Var
  i,q:integer;
  Info : SearchRec;
  rom,ff:string;
 Begin
  i:=100;
  q:=0;
  findromfile:='';
  FindFirst (rompath+'*',AnyFile,Info);
  While DosError = 0 Do Begin
    If (Info.Attr and archive) = 0 then
      begin
        ff:=Lower(removespchar(removebrackets(JustFile(Info.name))));
        if ff<>'' then begin
          q:=CompareText(ff,romname);
          if i>q then begin
            i:=q;
            rom:=Info.name;
          end;
        end;
      end;
    FindNext(info);
  end;
  FindClose(Info);
   if i>10 then findromfile:='none' else findromfile:=rom;
   if pos('''',rom)>0 then findromfile:='none' else findromfile:=rom;
end;

Procedure About;
  Var
    x : Byte = 28;
    y : Byte = 5;
    d : Byte = 0;
Begin
  TextAttr:=7*16;
  GotoXY(x,y);           Write('RETROROMS is a DOOR Program for BBSes.');
  d:=d+1; GotoXY(x,y+d); Write('');
  d:=d+1; GotoXY(x,y+d); Write('Its not 100% finished and it has some bugs. But');
  d:=d+1; GotoXY(x,y+d); Write('the main functionality is there.');
  d:=d+1; GotoXY(x,y+d); Write('');
  d:=d+1; GotoXY(x,y+d); Write('For the time beeing you cannot download ROMs,');
  d:=d+1; GotoXY(x,y+d); Write(' except from the MasterSystem area. ;)');
  TextAttr:=7;
End;

procedure WriteHelp;
begin
  WriteLn('');
  TextAttr := 14;
  WriteLn(' ____  _____ _____ ____   ___   ____    _    __  __ _____ ____  ');
  WriteLn('|  _ \| ____|_   _|  _ \ / _ \ / ___|  / \  |  \/  | ____/ ___| ');
  WriteLn('| |_) |  _|   | | | |_) | | | | |  _  / _ \ | |\/| |  _| \___ \ ');
  WriteLn('|  _ <| |___  | | |  _ <| |_| | |_| |/ ___ \| |  | | |___ ___) |');
  WriteLn('|_| \_\_____| |_| |_| \_\\___/ \____/_/   \_\_|  |_|_____|____/ ');
  WriteLn('                                        Version '+version);
  WriteLn('');
  TextAttr := 7;
  WriteLn(' Thousands of retro games inside your BBS');
  WriteLn(' Usage:');
  WriteLn('    retrogames <door/32 filename>');
  WriteLn('');
  WriteLn(' Example:');
  WriteLn('    retrogames /bbs/node1/door.sys');
  WriteLn('');
end;

Procedure ShadowBox(x1,y1,x2,y2,at:byte);
Var
  i  : Byte;
  l  : Char;
Begin

    For i := y1+3 to y2 Do Begin
      l := GetCharAt(x2+1,i);
      WriteXY(x2+1,i,at,l);
      l := GetCharAt(x2+2,i);
      WriteXY(x2+2,i,at,l);
    End;
      For i := x1+5 to x2 Do Begin
      l := GetCharAt(i,y2+3);
      WriteXY(i,y2+3,at,l);
    End;
End;

Procedure ClearArea(x1,y1,x2,y2:Byte;C:Char);
Var
  i,d:Byte;
Begin
  For i := y1 to y2 Do
    WriteXY(x1,i,TextAttr,StrRep(c,x2-x1));
End;

Procedure HelpLine(S:String);
Var
  d : Byte;
Begin
  d:= 40 - (strMCILen(S) Div 2);
  GotoXY(1,25);
  Write(StrRep(' ',79));
  GotoXY(d,25);
  WritePipe(S);
End;

Procedure BackGround;
Var
  d     : Byte = 0;
  
Begin

    TextAttr:=0;
    GotoXY(1,1);           Write('[1C[1;37m‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹[2C‹€ﬂﬂ[0;37;40mﬂ[1mﬂ[0;37;40mﬂ≤ﬂﬂﬂﬂ[1;30mﬂ[0;37;40mﬂ[1;30mﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ[0;37;40mﬂ[1;30mﬂﬂﬂﬂ ﬂﬂﬂ±±ﬂﬂﬂﬂﬂ€‹[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;47m€ﬂ    ﬂ  ﬂ  [33m [30m  [33m [30mﬂ ﬂﬂﬂ≤[1C[0;37;40m≤[1C‹€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€‹[1C[1;30m€[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;47m€[30m [37m                  [30m ∞[1C[0;37;40m€[1C€[30;47m∞∞[37;40m€[1;30;47m∞[0;30;47m                                             [37;40m€[1C[1;30m€[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;47m∞  [30m                  ≤[1C[37mﬂ[1C[0;30;47m                                                   [1C[1;40m€[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;47m [0;37;40mﬂ∞ﬂ[1;30mﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ€[1C[47m‹[0;30;47m‹                                                   [1C[1;40m€[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m€[0;37;40m [18C [1m[1C[30;47m∞[1C[0;30;47m                                                   [1C[1;40m€[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m≤[19C[0;37;40m [1;30m∞[1C[47m‹[1C[0;30;47m                                                   [1C[1;40mﬂ[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m±[19C[0;37;40m [1;30m∞[1C[47m€[1C[0;30;47m                                                   [1C[1;40m€[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m±[19C[0;37;40m [1;30m∞[1C[47m€[1C[0;30;47m                                                   [1C[1;40m‹[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m±[0;37;40m [18C [1;30m∞[1C[47m∞[1C[0;30;47m                                                   [1C[1;40m‹[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m±[0;37;40m [18C [1;30m∞[1C[47m€[1C[0;30;47m                                                   [1C[1;40mﬂ[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m±[0;37;40m [18C €[1C[1;30;47m€[1C[0;30;47m                                                  [37;40m€[1C[1;30m€[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m∞[0;37;40m [18C [1;30m∞[1C[47m€[1C[0;30;47m                                                  [37;40m€[1C[1;30m€[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m∞[0;37;40m [18C [1;30m∞[1C[47m€[1C[0;30;47m                                                   [1C[1;40m≤[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m [0;37;40m [18C [1;30m∞[1C[47m€[1C[0;30;47m                                                   [1C[1;40m€[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m [0;37;40m [18C [1;30m∞[1Cﬂ[1C[0;30;47m                                                   [1C[1;40m€[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m [0;37;40m [18C [1;30m∞[1C€[1C[0;30;47m                                                   ‹[1m±[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m [0;37;40m [18C [1;30m∞[1C [1C[0;30;47m                                                   [1C[1m‹[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m∞[0;37;40m [18C [1;30m∞[1C€[1C[0;30;47m                                                   [1C[37;40m±');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m∞[0;37;40m [18C [1;30m∞ ≤[1C[0;30;47m                                                   [1C[37;40m≤');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m±[0;37;40m [18C [1;30m∞[1Cﬂ[1C[0;30;47m                                                  [37;40m€[1C€');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m≤[0;37;40m [18C [1;30m∞[1C€[1C[0;30;47m                                              [1m∞[0;37;40m€[30;47m∞∞[37;40m€[1C[1;47mﬂ[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m€[0;37;40m [18C [1m[1C[30m€[1C[0;37;40mﬂ€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€ﬂ[1C[1m€[0m');
    d:=d+1; GotoXY(1,1+d); Write('[1C[1;30m€€‹‹ ‹‹ ‹‹[6C‹ ‹[0;37;40m‹‹[1;30;47mﬂ[1C[40mﬂ€‹‹‹‹ ‹≤≤‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹[0;37;40m‹[1;30m‹‹[0;37;40m‹[1;30m‹[0;37;40m‹[30;47m∞∞[37;40m‹‹[1m‹‹[0;37;40m‹[1m‹‹[0;30;47m∞[1;37;40mﬂ');

End;

Procedure SmallBox(x,y:Byte);
Var
  d     : Byte = 0;
Begin

  TextAttr:=0;
  GotoXY(x,y);           WritePipe('|23|07‹|00‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹');
  d:=d+1; GotoXY(x,y+d); WritePipe('|16 |15‹€ﬂﬂ|07ﬂ|15ﬂ|07ﬂ≤ﬂﬂ|08 ﬂﬂﬂ±±ﬂﬂﬂﬂﬂ€‹ ');
  d:=d+1; GotoXY(x,y+d); WritePipe('|16 |07≤|00 |23ﬂ                 ﬂ|16 |08€ ');
  d:=d+1; GotoXY(x,y+d); WritePipe(' |07€|00 |23 ∞                 |16 |08€|16 ');
  d:=d+1; GotoXY(x,y+d); WritePipe(' |15|23ﬂ|00|16 |23                   |16 |08€|16 ');
  d:=d+1; GotoXY(x,y+d); WritePipe(' |23‹|00‹                   |16 |08€|16 ');
  d:=d+1; GotoXY(x,y+d); WritePipe(' |23∞|00|16 |23                   |16 |08€|16 ');
  d:=d+1; GotoXY(x,y+d); WritePipe(' |23‹|00|16 |23                   |16 |08€|16 ');
  d:=d+1; GotoXY(x,y+d); WritePipe(' ≤|00 |23                   |16 |07≤|16 ');
  d:=d+1; GotoXY(x,y+d); WritePipe(' |08ﬂ|00 |23                   |16 |07€|16 ');
  d:=d+1; GotoXY(x,y+d); WritePipe(' |08€|00 |23                 ∞ |16 |15|23ﬂ|16 ');
  d:=d+1; GotoXY(x,y+d); WritePipe(' |08|16€|00 |23‹                 ‹|16 |15€|16 ');
  d:=d+1; GotoXY(x,y+d); WritePipe(' |08ﬂ€‹‹‹‹ ‹≤≤‹‹|00|23∞∞|07|16‹‹|15‹‹|07‹|15‹‹|00|23∞|15|16ﬂ ');
  d:=d+1; GotoXY(x,y+d); WritePipe('|23|07‹|16‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹');

End;

Procedure WideBox(x,y:Byte);
Var
  d     : Byte = 0;
Begin

    GotoXY(x,y);
    Write('[1;37m‹€ﬂﬂ[0;37;40mﬂ[1mﬂ[0;37;40mﬂ≤ﬂﬂﬂﬂ[1;30mﬂ[0;37;40mﬂ[1;30mﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ[0;37;40mﬂ[1;30mﬂﬂﬂﬂ ﬂﬂﬂ±±ﬂﬂﬂﬂﬂ€‹[0m');
    d:=d+1; GotoXY(x,y+d); Write('≤[1C‹€€€€€€€€€€€€€[30;47m    Search Title[37;40m€€€€€€€€€€€€€€€€€€€€‹[1C[1;30m€[0m');
    d:=d+1; GotoXY(x,y+d); Write('[1;30m€[1C[0;30;47m                                                  [37;40m€[1C[1;47mﬂ[0m');
    d:=d+1; GotoXY(x,y+d); Write('[1;30m€[1C[0;37;40mﬂ€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€ﬂ[1C[1m€[0m');
    d:=d+1; GotoXY(x,y+d); Write('[1;30mﬂ€‹‹‹‹ ‹≤≤‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹[0;37;40m‹[1;30m‹‹[0;37;40m‹[1;30m‹[0;37;40m‹[30;47m∞∞[37;40m‹‹[1m‹‹[0;37;40m‹[1m‹‹[0;30;47m∞[1;37;40mﬂ[0m');

End;

Function YesNo(Title,Prompt:String):Boolean;
Var
  Image : TScreenBuf;
  Res : Boolean = False;
  x     : Byte = 12;
  y     : Byte = 10;
Begin

    SaveScreen (Image);
    ClearArea(x+1,y+1,x+57,y+5,' ');
    WideBox(x,y);
    WriteXY(x+5,y+1,7*16,'                            ');
    HelpLine('|07Use |15LEFT|07/|15RIGHT |07Cursor to Select');
  
    WriteXY(x+3,y+2,7*16,StrPadC(Prompt,49,' '));
    WriteXY(x+3,y+1,7*16,Title);
    Res := GetYN(x+25,y+3,15+7*16,False);
    
    RestoreScreen (Image);
  Result:=Res;
End;

procedure rowid(d:integer);
var i:integer;
begin
  case d of
    0: ds.first;
    1: ds.first;
    else begin
       ds.first;
       for i:=1 to d-1 do ds.next;
       end;
  end;
end;

Procedure DownloadGame;
Var
  S,Z : String;
  dir : String;
  sz  : String = 'sz -bf ';
  
  Procedure GetFile;
  Var
    Img : TScreenBuf;
  Begin
    SaveScreen(Img);
    fpsystem(sz+'"'+Dir+s+'"');
    ClrScr;
    BackGround;
    RestoreScreen(Img);
    HelpLine('|07Press |15[|07/|15] |07to scroll text |00|23›Rﬁ|07|16edraw |00|23›Sﬁ|07|16ort |00|23›Fﬁ|07|16ind |00|23›Dﬁ|07|16ownload ROM');
  End;
  
Begin
  RowID(SelGame+1);
  dir:=StartDir+'system'+PathChar+Console+PathChar+'roms'+PathChar;
  S:=JustFileName(JustFile(ds.fields.fieldbyname('rom_filename').asstring));
  Z:=Lower(removespchar(removebrackets(ds.fields.fieldbyname('title').asstring)));
  //WriteXY(1,1,7,dir+'#####');
  //WriteXY(1,2,7,JustFileName(JustFile(ds.fields.fieldbyname('rom_filename').asstring))+'####');
  If FileExist(Dir+S) Then Begin
    If YesNo('                   Download File?',S+' ')=True Then GetFile;
  End Else Begin
    S:=findromfile(Z,dir);
    If s<>'none' Then Begin
      If YesNo('                   Download File?',S+' ') Then GetFile;
    End Else Begin
      YesNo('Error','File Not Found... Canceling.');
    End;
  End;
  HelpLine('|07Press |15[|07/|15] |07to scroll text |00|23›Rﬁ|07|16edraw |00|23›Sﬁ|07|16ort |00|23›Fﬁ|07|16ind |00|23›Dﬁ|07|16ownload ROM');
End;

Procedure CheckNormalKeys(Ch:Char);
Var
  p:Byte;
Begin
If Ch='[' Then Begin
        DescTop:=DescTop-1;
        If Desctop<=0 Then Desctop:=0;
      End Else 
      If Ch=']' Then Begin
        DescTop:=DescTop+1;
        If DescTop>=DescText.Count-1 Then DescTop:=DescText.Count-1;
      End;
      If DescText.Count>0 Then Begin
        p:=0;
        While (p<=12) Do Begin
          If (Desctop+p<=DescText.Count-1) Then
            WriteXY(28,10+p,7*16,DescText[p+DescTop])
          Else
            WriteXY(28,10+p,7*16,StrRep(' ',49));
          p:=p+1;
        End;
      End;
  If (LoCase(Ch)='s') And (Mode=1) Then SortBox(40,7);
  If (LoCase(Ch)='f') And (Mode=1) Then FindGame(5,10);
  If (LoCase(Ch)='d') And (Mode=1) Then DownloadGame;
End;

Function SmallMenu(COnst MenuList:Tstringlist; x,y,w,h:Byte;Bar:Integer;BarOnc,BarOffc:String;MoreX,MoreY:Byte):Integer;
Var
  Ch : Char;
  Ch2: Char;
  TopPage   :Integer;
  BarPos    :Integer;
  More      :Integer;
  LastMore  :Integer;
  Temp      :Integer;
  Temp2     :Integer;
  Done      : Boolean;
  morecol   : String = '|08|16';
  p         : Byte;
  
  
Procedure BarON;
Begin
  If Systems.Count=0 Then Exit;
  WriteXYPipe(x, y + BarPos - TopPage,7,baronc+StrPadR(menulist[BarPos], w, ' '))
end;

Procedure BarOFF;
begin
  If Systems.Count=0 Then Exit;
  WriteXYPipe(x, y + BarPos - TopPage,7,baroffc+StrPadR(MenuList[BarPos], w, ' '))
end;
  
Procedure DrawPage;
Var
  tmp: Integer;
  h1 : Integer;
begin
  If Systems.Count=0 Then Exit;
  Temp2 := BarPos;
  For tmp := 0 to h - 1 do begin 
    If Toppage+tmp<=Total Then Begin
      BarPos := TopPage + tmp;
      BarOFF;
    End;
  end;
  BarPos := Temp2;
  BarON;
end;
  
Begin
  
  If Bar > Total Then Begin
    TopPage  := 0;
    BarPos   := 0;
  End Else
  If Bar > Total - h Then Begin
    TopPage  := Total - h + 1;
    if TopPage<0 Then TopPage:=0;
    BarPos   := Bar;
  End Else Begin
    TopPage  := Bar;
    BarPos   := Bar;
  End;
  
  Done     := False;
  More     := 0;
  LastMore := 0;
  SmallMenu := -1;
  
  
      
  DrawPage;
  If (MoreX=0) and (MoreY=0) Then Exit;
  
  Repeat
    More := 0;
    Ch   := ' ';
    Ch2  := ' ';
    

    If TopPage > 1 Then begin
      More := 1;
      Ch   := Chr(244);
    End;

    If TopPage + h-1 < Total Then begin
      Ch2  := Chr(245);
      More := More + 2;
    End;

    If More <> LastMore Then begin
      LastMore := More;
      GotoXY (MoreX, MoreY);
      WritePipe (morecol+' (' + Ch + Ch2 + ' more) ');
    End;    
    
    Ch := ReadKey;
    If Ch=#0 Then begin
      Ch := ReadKey;
      
  //HOME key
      if ch = chr(71) then begin

        TopPage := 0;
        BarPos  := 0;
        drawpage;
        end;
  //END Key
      if ch = chr(79) then begin

        if Total > h then begin
          TopPage := Total - h +1;
          BarPos  := Total;
        end else begin
          BarPos  := Total ;
        end;
        drawpage;
        end;
  
      If Ch = Chr(72) Then begin

        If BarPos > TopPage Then begin
          BarOFF;
          BarPos := BarPos - 1;
          BarON;
          end
        Else
        If TopPage > 0 Then begin
          TopPage := TopPage - 1;
          BarPos  := BarPos  - 1;
          DrawPage;
        End;
      end;
  
      If Ch = Chr(73) Then begin

        If TopPage - h >= 0 Then begin
          TopPage := TopPage - h;
          BarPos  := BarPos  - h;
          DrawPage;
          end
        Else begin
          TopPage := 0;
          BarPos  := 0;
          DrawPage;
        End;
      end;
  
    If Ch = Chr(80) Then begin

      If BarPos < Total Then
        If BarPos < TopPage + h - 1 Then begin
          BarOFF;
          BarPos := BarPos + 1;
          BarON;
          end
        Else
        If BarPos < Total Then begin
          TopPage := TopPage + 1;
          BarPos  := BarPos  + 1;
          DrawPage;
        End;
      End;
      
      If Ch = Chr(81) Then begin //PGDN
        If Total > h Then
          If TopPage + h < Total - h +1 Then begin
            TopPage := TopPage + h;
            BarPos  := BarPos  + h;
            DrawPage;
            end
          Else
          begin
            TopPage := Total - h +1;
            BarPos  := Total;
            DrawPage;
          End
        Else
        begin
          BarOFF;
          BarPos := Total;
          BarON;
        End;
     End;

  //ch:=#0
  End Else
    If (Ch = Chr(27)) Or (Ch = BackSpace) Then Begin
        SmallMenu := -255;
        Done := True;
      End
      Else
        If Ch = Chr(13) Then Begin
            SmallMenu := BarPos;
            Done := True;
          End
      Else
      If LoCase(Ch) = 'a' then Begin
        BackGround;
        DrawPage;
        About;
      End Else
      If LoCase(Ch) = 'r' then Begin
      BackGround;
      DrawPage;
      If Mode=1 Then Begin
        WriteXY(4,3,15+7*16,StrPadC(Console,20,' '));
        WriteXY(28,4,7*16,'Title:');
        WriteXY(28,6,7*16,'Release:');
        WriteXY(28,7,7*16,'Genre  :');
        WriteXY(28,8,7*16,'Dev.   :');
        WriteXY(53,6,7*16,'Rate:');
        WriteXY(53,7,7*16,'ESRB:');
        WriteXY(53,8,7*16,'Pub.:');
        HelpLine('|07Press |15[|07/|15] |07to scroll text |00|23›Rﬁ|07|16edraw |00|23›Sﬁ|07|16ort |00|23›Fﬁ|07|16ind |00|23›Dﬁ|07|16ownload ROM');
      End;
    End Else
      If Ch = Chr(45) THen Begin
        SmallMenu := -253;
        Done := True;
      End Else CheckNormalKeys(ch);
      
  //WriteXY(64,23,15+7*16,StrPadL(StrI2S(Barpos+1)+' / '+StrI2S(Systems.Count),14,' '));
  //WriteXY(1,1,15+7*16,'Desctop: '+StrI2S(Desctop)+' Count: '+Stri2s(desctext.count));
  Until Done;
End;

Procedure SQLExec(S:String);
Begin
  if ds.active=true then ds.close;
  with ds do
    begin
     Sql := s;
     Open;
  end;
  Systems.Clear;
  DS.First;
  While Not DS.EOF Do Begin
    Systems.Add(ds.fields.fieldbyname('title').asstring);
    DS.Next;
  End;
  
End;

Procedure FindGame(x,y:byte);
Var
  Image : TScreenBuf;
  FStr  : String = '';
  Def   : String = '';
Begin
  SaveScreen (Image);
  ClearArea(x+1,y+1,x+57,y+5,' ');
  WideBox(x,y);
  GotoXY(x+3,y+ 2);
  FStr := Input(Def,CHARS_ALL,#0,49,100,7);
  SQLExec('select * from games where title like ''%'+FStr+'%''');
  RestoreScreen (Image);
  ClearArea(3,6,22,23,' ');
  GRes:=0;
  Total:=Systems.Count-1;
  SmallMenu(Systems, 4,6,18,18,GRes,'|23|15','|07|16',0,0); 
End;

Procedure ExitDoor;
Begin
  If YesNo('                     Exit','Are you sure? ') Then Begin
    Systems.Free;
    DescText.Free;
    ds.Free;
    ClrScr;
    OuttaHere:=True;
  ENd;
End;

Procedure SortBox(x,y:byte);
Var
  Image : TScreenBuf;
  Ch    : Char;
  Sel   : Integer = 0;
  Menu   : Array[0..6] Of String[15];

  Procedure DrawPage;
  Var d : Byte;
  Begin
      For d:=0 To 6 Do
        WriteXY(x+4,y+3+d,7*16,StrPadR(Menu[d],17,' '));
      WriteXY(x+4,y+3+Sel,15+16,StrPadR(Menu[Sel],17,' '));
  End;

Begin
  Menu[0]:='by Title Asc';
  Menu[1]:='by Title Desc';
  Menu[2]:='by Rate';
  Menu[3]:='by Release';
  Menu[4]:='by ESRB';
  Menu[5]:='by Publisher';
  Menu[6]:='Cancel';
  
  SaveScreen (Image);
  SmallBox(x,y);
  
  Repeat
    DrawPage;
    Ch:=Readkey;
    If Ch=#0 Then Ch:=Readkey;
    Case Ch Of
      CursorUp :  Begin
              Sel:=Sel-1;
              If Sel < 0 Then Sel:=0;
            End;
      CursorDown: Begin
              Sel:=Sel+1;
              If Sel > 6 Then Sel:=6;
            End;
    End;
  Until (Ch=#13) or (Ch=#27);
  If Ch=#13 Then Begin
    Case Sel Of
      0: SQLExec('select * from games order by title asc');
      1: SQLExec('select * from games order by title desc');
      2: SQLExec('select * from games order by rating asc');
      3: SQLExec('select * from games order by release asc');
      4: SQLExec('select * from games order by esrb asc');
      5: SQLExec('select * from games order by publisher asc');
    End;
    Total:=Systems.Count-1;
    SmallMenu(Systems, 4,6,18,18,GRes,'|23|15','|07|16',0,0); 
  End;
  RestoreScreen (Image);

End;

Procedure OpenDatabase(s:string);
Var
  ss:string;
Begin
  if ds.active=true then ds.close;
  ss:=StartDir+'system'+PathChar+Replace(s,' ','_')+PathChar+'games.db';
  //writexy(1,25,15,ss);
  if FileExist(ss)=false then begin
    helpline('[e101] Database does not exist. Press any key to continue...');
    readkey;
  end else begin
  try
  with ds do
    begin
     FileName := ss;
     database:= 'games';
     TableName := 'games';

     PrimaryKey := 'gid';
     sql:='PRAGMA encoding = "el.utf8"';
     execsql;
     //sql:='SET names utf8';
     //execsql;
     Sql := 'select * from games order by title asc';
     Open;
     end;
 except
     helpline('Error opening database. Press any key to continue...');
     readkey;
 end;
 end;
end;



Procedure DisplayGame(D:Integer);
Begin
  RowID(D+1);
  WriteXY(28,5,15+7*16,StrPadR(ds.fields.fieldbyname('title').asstring,48,' '));
  WriteXY(37,6,15+7*16,StrPadR(ds.fields.fieldbyname('release').asstring,16,' '));
  WriteXY(37,7,15+7*16,StrPadR(ds.fields.fieldbyname('genre').asstring,16,' '));
  WriteXY(37,8,15+7*16,StrPadR(ds.fields.fieldbyname('developer').asstring,16,' '));
  
  WriteXY(59,6,15+7*16,StrPadR(ds.fields.fieldbyname('rating').asstring,16,' '));
  WriteXY(59,7,15+7*16,StrPadR(ds.fields.fieldbyname('esrb').asstring,16,' '));
  WriteXY(59,8,15+7*16,StrPadR(ds.fields.fieldbyname('publisher').asstring,16,' '));
  
End;

Procedure LoadDesc(F:String);
Var
  Fn:Text;
  S :String;
Begin
  DescText.Clear;
  DescTop:=0;
  If Not FileExist(f) Then Exit;
  Assign(Fn,F);
  Reset(Fn);
  While Not EOF(fn) Do Begin
    ReadLn(fn,s);
    DescText.Add(StrPadR(s,49,' '));
  End;
  CloseFile(Fn);
End;

Procedure LoadDesc2(F:String);
Var
  Fn    : File;
  S     : String;
  Dat   : Array[1..50] Of Char;
  i     : Integer;
  n,d,x : Byte;
  NumRead:Word;
Begin
  DescText.Clear;
  DescTop:=0;
  If Not FileExist(f) Then Exit;
  Assign(Fn,F);
  Reset(Fn,1);
  i:=0;
  d:=0;
  While Not EOF(fn) Do Begin
    i:=i+d;
    Seek(Fn,i);
    BlockRead(fn,Dat,50,NumRead);
    n:=NumRead;
    While n>=1 Do Begin
      If Dat[n] In FmtChars Then Begin
        d:=n;
        S:='';
        For x:=1 to d Do S:=S+Dat[x];
        DescText.Add(StrPadR(s,50,' '));
        n:=1;
      End;   
      n:=n-1;
    End;
  End;
  CloseFile(Fn);
End;

Procedure ListGames(Title:String);
Var
  p    : Byte;
  Ch   : Char;
Begin
  Systems.Clear;
  DS.First;
  Console:=Replace(Title,' ','_');
  While Not DS.EOF Do Begin
    Systems.Add(ds.fields.fieldbyname('title').asstring);
    DS.Next;
  End;
  GRes:=0;
  BackGround;
  WriteXY(4,3,15+7*16,StrPadC(Title,20,' '));
  WriteXY(28,4,7*16,'Title:');
  WriteXY(28,6,7*16,'Release:');
  WriteXY(28,7,7*16,'Genre  :');
  WriteXY(28,8,7*16,'Dev.   :');
  WriteXY(53,6,7*16,'Rate:');
  WriteXY(53,7,7*16,'ESRB:');
  WriteXY(53,8,7*16,'Pub.:');
  HelpLine('|07Press |15[|07/|15] |07to scroll text |00|23›Rﬁ|07|16edraw |00|23›Sﬁ|07|16ort |00|23›Fﬁ|07|16ind |00|23›Dﬁ|07|16ownload ROM');
  Repeat
    If (GRes<Systems.Count) And (GRes>=0) Then Begin
      SelGame:=Gres;
      DisplayGame(GRes);
      TextAttr:=7*16;
      ClearArea(28,10,78,22,' ');
      TextAttr:=7;
      LoadDesc2(StartDir+'system'+PathChar+Replace(Title,' ','_')+PathChar+ds.fields.fieldbyname('title').asstring+'.txt');
      If DescText.Count>0 Then Begin
        If DescTop+12<DescText.Count Then 
          For p:=0 To 12 Do WriteXY(28,10+p,7*16,DescText[p+DescTop])
        Else 
          For p:=0 To DescText.Count-1 Do WriteXY(28,10+p,7*16,DescText[p]);
      End;
      Total:=Systems.Count-1;
      GRes:=SmallMenu(Systems, 4,6,18,18,GRes,'|23|15','|07|16',10,24);  
    End;
  Until GRes = -255;
  BackGround;
  ClearArea(3,6,22,23,' ');
End;

Procedure DisplaySystems;
Begin
  BackGround;
  WriteXY(4,3,15+7*16,StrPadC('Systems',20,' '));
  Repeat
    HelpLine('|16|07Press |15ENTER |07to select. |15UP/DOWN |07Keys to move |00|23›Aﬁ|07|16bout');
    Total:=Systems.Count-1;
    Res:=SmallMenu(Systems, 4,6,18,18,0,'|23|15','|07|16',10,24);
    If (Res<Systems.Count) And (Res>=0) Then Begin
        OpenDatabase(Systems[Res]);
        Mode:=1;
        ClearArea(3,6,22,23,' ');
        ListGames(Systems[Res]);
        BackGround;
        Systems.Clear;
        TextAttr:=7*16;
        ClearArea(28,4,78,22,' ');
        TextAttr:=0;
        ClearArea(3,6,22,23,' ');
        ListDir(StartDir+'system',Systems);
        WriteXY(4,3,15+7*16,StrPadC('Systems',20,' '));
        DescText.Clear;
        Mode:=0;
        For i:=0 To Systems.Count -1 Do Systems[i]:=Replace(Systems[i],'_',' ');  
    End;
    If Res=-255 THen ExitDoor;
  Until OuttaHere;
End;

procedure enable_ansi_unix;
begin
  Write(#27 + '(U' + #27 + '[0m');
end; 

Begin
  StartDir := AppPath;
  
  enable_ansi_unix;

  If ParamCount < 1 Then Begin
    WriteHelp;
    //ClrScr;
    Halt;
  End;  
  ReadDoor(ParamStr(1));
  TextAttr := 7;
  ClrScr;
  ds := TSqlite3Dataset.Create(nil);
  Systems := TStringList.Create;
  DescText:= TStringList.Create;
  ListDir(StartDir+'system',Systems);
  For i:=0 To Systems.Count -1 Do Systems[i]:=Replace(Systems[i],'_',' ');
  DisplaySystems;
  
End.
