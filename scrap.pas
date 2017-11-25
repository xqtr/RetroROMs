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

program hello;

{$GOTO ON}  

{$mode objfpc}{$H+}
{$IFDEF Linux}
  {$DEFINE Unix}
  {$ENDIF}

uses
  baseunix,fphttpclient,sysutils,regexpr,db,sqlite3ds,crt,math,strutils,fileutil,classes;

const Table: Array[0..255] of DWord =
     ($00000000, $77073096, $EE0E612C, $990951BA,
      $076DC419, $706AF48F, $E963A535, $9E6495A3,
      $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988,
      $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91,
      $1DB71064, $6AB020F2, $F3B97148, $84BE41DE,
      $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
      $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC,
      $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
      $3B6E20C8, $4C69105E, $D56041E4, $A2677172,
      $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
      $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940,
      $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
      $26D930AC, $51DE003A, $C8D75180, $BFD06116,
      $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
      $2802B89E, $5F058808, $C60CD9B2, $B10BE924,
      $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,
      $76DC4190, $01DB7106, $98D220BC, $EFD5102A,
      $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433,
      $7807C9A2, $0F00F934, $9609A88E, $E10E9818,
      $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01,
      $6B6B51F4, $1C6C6162, $856530D8, $F262004E,
      $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
      $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C,
      $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
      $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2,
      $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
      $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
      $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
      $5005713C, $270241AA, $BE0B1010, $C90C2086,
      $5768B525, $206F85B3, $B966D409, $CE61E49F,
      $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4,
      $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,
      $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A,
      $EAD54739, $9DD277AF, $04DB2615, $73DC1683,
      $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8,
      $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1,
      $F00F9344, $8708A3D2, $1E01F268, $6906C2FE,
      $F762575D, $806567CB, $196C3671, $6E6B06E7,
      $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC,
      $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
      $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252,
      $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
      $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60,
      $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
      $CB61B38C, $BC66831A, $256FD2A0, $5268E236,
      $CC0C7795, $BB0B4703, $220216B9, $5505262F,
      $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04,
      $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
      $9B64C2B0, $EC63F226, $756AA39C, $026D930A,
      $9C0906A9, $EB0E363F, $72076785, $05005713,
      $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38,
      $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21,
      $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E,
      $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
      $88085AE6, $FF0F6A70, $66063BCA, $11010B5C,
      $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
      $A00AE278, $D70DD2EE, $4E048354, $3903B3C2,
      $A7672661, $D06016F7, $4969474D, $3E6E77DB,
      $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0,
      $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
      $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6,
      $BAD03605, $CDD70693, $54DE5729, $23D967BF,
      $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94,
      $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D);



  type
    tgame=record
      id, name, rdate, plat, overview,
      esrb,genre,youtube,publisher,developer,rating,
      banner,boxart_f,boxart_b,screenshot,logo :string;
    end;
    

var
  t:string;
  platforms: array of string;
  pids,gids: array of string;
  gnames:array of string;
  games:array of tgame;
  game:tgame;
	CRC		: Dword;
	ds		: TSqlite3Dataset;
	pl,roms,images,tmp:string;
	i, gid: integer;
	getimages:boolean;
	fullfile,fieldd,dbfile,dir:string;
	ss:tstringlist;

  Label retryget;  

procedure log(str:string);
begin
	writeln(str);
end;
  
procedure CalcCRC32(FileName: String; var CRC32: dword);
var F: file;
    BytesRead: dword;
    Buffer: Array[1..65521] of byte;
    i: Word;
begin
    FileMode := 0;
    CRC32 := $ffffffff;
    {$I-}
    AssignFile(F, FileName);
    Reset(F, 1);
    if IOResult = 0 then
    begin
      repeat
        BlockRead(F, Buffer, SizeOf(Buffer), BytesRead);
        for i := 1 to BytesRead do CRC32 := (CRC32 shr 8) xor Table[Buffer[i] xor (CRC32 and $000000FF)];
      until BytesRead = 0;
    end;
    CloseFile(F);
    {$I+}
    CRC32 := not CRC32;
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

{------------------------------------------------------------------------------
  Name:    LevenshteinDistanceText
  Params: s1, s2 - UTF8 encoded strings
  Returns: Minimum number of single-character edits.
  Compare 2 UTF8 encoded strings, case insensitive.
------------------------------------------------------------------------------}
function cText(const s1, s2: string): integer;
var
  s1lower, s2lower: string;
begin
  s1lower := LowerCase( s1 );
  s2lower := LowerCase( s2 );
  result := LevenshteinDistance( s1lower, s2lower );
end;


function removespchar(str:string):string;
var
  tmp:string;
begin
	tmp:=str;
	tmp:=StringReplace(tmp,'''',' ',[rfReplaceAll,rfIgnoreCase]);
	tmp:=StringReplace(tmp,'/','-',[rfReplaceAll,rfIgnoreCase]);
	tmp:=StringReplace(tmp,'\','-',[rfReplaceAll,rfIgnoreCase]);
	tmp:=StringReplace(tmp,';','',[rfReplaceAll,rfIgnoreCase]);
	tmp:=StringReplace(tmp,'#','',[rfReplaceAll,rfIgnoreCase]);
	tmp:=StringReplace(tmp,'*','',[rfReplaceAll,rfIgnoreCase]);
	tmp:=StringReplace(tmp,'.','',[rfReplaceAll,rfIgnoreCase]);
	tmp:=StringReplace(tmp,':','',[rfReplaceAll,rfIgnoreCase]);
	tmp:=StringReplace(tmp,'&amp','and',[rfReplaceAll,rfIgnoreCase]);
	tmp:=StringReplace(tmp,',','',[rfReplaceAll,rfIgnoreCase]);
	tmp:=StringReplace(tmp,'-','',[rfReplaceAll,rfIgnoreCase]);
	tmp:=StringReplace(tmp,' ','',[rfReplaceAll,rfIgnoreCase]);
	result:=tmp;
end;


  procedure savestringtofile(s,f:string);
  var
    filevar:textfile;
  begin
    assignfile(filevar,f);
    {$I+}
    try
      rewrite(filevar);
      writeln(filevar,s);
      closefile(filevar);
    except
      on E: EInOutError do
        begin
          writeln('File error');
        end;
      end;
  end;

   function isodate(s:string):string;
   begin
     result:=copy(s,7,4)+copy(s,4,2)+copy(s,1,2);
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
        result := trim(s);
     end else found:=false;
   until found=false;
   a:=pos('GBA',s);
   if a>0 then delete(s,a,3);
   a:=pos('#',s);
   if a>0 then delete(s,a,1);
   result:=s;
 end;

 function removeext(ffile:string):string;
 var s:string;
   i:integer;
 begin
   s:=ffile;

   for i:=length(s) downto 1 do if s[i]='.' then
     begin
       delete(s,i,length(s)-i+1);
       break;
     end;
        //delete(s,pos('.',s),length(s)-pos('.',s)+1);
   result:=s;
 end;

procedure reptext(var str:string; f,t:string);
  var
    i:integer;
  begin
    for i:=length(str) downto 1 do
      //if str[i]=f then str[i]=t;
  end;


 function findromfile(romname:string; rompath:string):string;
 Var
     i,q:integer;
     Info : TSearchRec;
     Count : Longint;
     rom,ff:string;
 Begin
   Count:=0;
   i:=100;
   q:=0;
   result:='';
   if rompath<>'' then begin
   rompath:=IncludeTrailingPathDelimiter(rompath);
   //writeln(format('%4s - %30s - %30s',['Pro.','Title','File']));
   If FindFirst (rompath+'*',faAnyFile and not faDirectory,Info)=0 then
   begin
     Repeat
       Inc(Count);
       With Info do
       begin
         If (Attr and faarchive) = faarchive then
           begin
//             writeln(removeext(name));
//             writeln(ExtractFilename(name));
//             writeln(ExtractFileext(name));
				//ff:=removebrackets(removeext(name));
				ff:=lowercase(removespchar(removebrackets(ExtractFileName(name))));
				if trim(ff)<>'' then begin
					q:=ctext(ff,romname);
					//writeln(format('%4s - %30s - %30s',[inttostr(q),romname,ff]));
	//              writeln(q,' - ',romname,' - ',removebrackets(extractfilename(name)));
					if i>q then begin
						i:=q;
						rom:=name;
					end;
				end;
           end;
        // Writeln (Name:40,'Match:',q:5);
        end;

     Until FindNext(info)<>0;
   end;
   FindClose(Info);
//   Writeln ('Finished search. Found ',Count,' matches');
//   writeln(rom,'  Match: ',i);
   if i>10 then result:='none' else result:=rom;
   if pos('''',rom)>0 then result:='Reject' else result:=rom;
   //log('Best match for '+romname+' is: '+rom);
   write('.');
   //log('Result: '+rom);
   end;
 end;
 
 procedure savetexttofile(txt:string; filename:string);
 var 
   ff:textfile;
 begin
	assignfile(ff,filename);
	{$I+}
    try
      rewrite(ff);
      writeln(ff,txt);
      closefile(ff);
    except
		writeln('Could not save textfile');
	end;
  end;
 
procedure opendatabase(s:utf8string);
begin
  if ds.active=true then ds.close;
  if fileexists(s)=false then begin
    log('[e101] Database does not exist. Press any key to continue...');
  end else begin
  try
  with ds do
    begin
     FileName := s;
     //PrimaryKey := 'title';
     ds.tablename:='games';
     sql:='PRAGMA encoding = "el.utf8"';
     execsql;
     //sql:='SET names utf8';
     //execsql;
     Sql := 'select * from games';
     Open;
     end;
 except
     log('Error opening database. Press any key to continue...');
 end;
 end;
end; 

procedure help;
begin
writeln('Retroid Scraper Tool...');
writeln;
writeln('Usage:');
writeln('  '+ExtractFileName(paramstr(0))+' <database_filename> <field> <path>');
writeln;
writeln('  <database_filename> : Full path to filename of Sqlite3 database file');
writeln(' Fields:');
writeln(' box      : Box art');
writeln(' rom      : Rom file');
writeln(' pdf      : PDF file/manual');
writeln(' video    : Video file');
writeln(' music    : Music file');
writeln(' screen   : Screenshot');
writeln(' text     : Game Overview File');
end;

function idexist(id:string):boolean;
begin
	if ds.active=true then ds.close;
	ds.sql:='select * from games where gid='+id;
	ds.open;
	if ds.recordcount<>0 then result:=true else result:=false;
end;

var
  ii:integer;

 begin
    //getpage('http://thegamesdb.net/api/GetPlatformsList.php');
//    writeln('Compare: '+inttostr(ctext(removebrackets('Choplifter III (UE) [!]'),'Choplifter III')));
//    findromfile('Disney''s Mulan','/home/x/pmht/system/gb/roms');
//    readln;
	dir:='';
	if paramcount<3 then begin
		help;
		exit;
	end;
	if not fileexists(paramstr(1)) then begin
		log('Database file: '+paramstr(1)+' does not exist!');
		ds.free;
	end;
	tmp:=paramstr(2);
	case lowercase(tmp) of
	'box': fieldd:='box_filename';   
	'rom'   : fieldd:='rom_filename';  
	'pdf' : fieldd:='pdf_filename';
	'video' : fieldd:='video_filename'; 
	'music': fieldd:='music_filename';
	'screen': fieldd:='screenshot_filename'; 
	'text'	: fieldd:='overview_filename';
	else begin
		log('Second parameter is not correct');
		writeln;
		help;
		exit;
		end;
	end;
	if directoryexists(paramstr(3))=false then begin
		log('Directory/folder, does not exist. Check your permissions or maybe you mistyped');
		writeln;
		help;
		exit;
	end;
	ds := TSqlite3Dataset.Create(nil);
	
	opendatabase(paramstr(1));
	ds.open;
	//if ds.active then ds.close;
	ds.first;
	while not ds.eof do begin
		tmp:=lowercase(removespchar(removebrackets(ds.fields[0].asstring)));
		//log(tmp);
		if tmp<>'' then begin
			ds.execsql('update games set '+fieldd+'='''+IncludeTrailingPathDelimiter(paramstr(3))+findromfile(tmp,paramstr(3))+
			''' where gid='+ds.fields[1].asstring);
			//ds.fields[field].asstring:=IncludeTrailingPathDelimiter(paramstr(3))+findromfile(tmp,paramstr(3));
			//ds.post;
		end;
		ds.next;
	end;
	ds.applyupdates;
	ds.free;
	
  end.
