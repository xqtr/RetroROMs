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
  baseunix,sysutils,regexpr,crt,strutils,fileutil,classes;

var
  t:string;

	ss:tstringlist;

procedure log(str:string);
begin
	writeln(str);
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
 
procedure help;
begin
writeln('Retroid List Tool...');
writeln;
writeln('Usage:');
writeln('  '+ExtractFileName(paramstr(0))+' <path> <file_masks> <command> <listfile> <options>');
writeln;
writeln(' <path>       : Path to search for files and write to list');
writeln(' <file_masks> : Mask for files to search for ex. *.pas;*.pp;*.p;*.inc');
writeln('                Multiple masks supported, seperate with semicolon');
writeln(' <command>    : The command to execute when list item is selected');
writeln(' <listfile>   : File to save the list');
writeln;
writeln(' Options:');
writeln(' -r           : Search in subdirs also');
writeln;
end;

var
  files:tstringlist;
	i:integer;
	recursive:boolean;
	tmp:string;
	
 begin
    if paramcount<4 then begin
		help;
		exit;
    end;
    recursive:=false;
    for i:=1 to paramcount do
		if lowercase(paramstr(i))='-r' then recursive:=true;
	Files := FindAllFiles(paramstr(1), paramstr(2), recursive);
	for i:=0 to files.count-1 do begin
		tmp:=files[i];
		tmp:=removeext(ExtractFilename(tmp));
		files[i]:=tmp+'%!update%|'+paramstr(3)+' '+'"'+files[i]+'"';
	end;
	files.savetofile(paramstr(4));
	files.free;
	
  end.
