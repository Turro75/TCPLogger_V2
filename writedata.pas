unit writeData;
{
 this unit prepare the attributes for each string in order to write down to the
 string in the right format i.e. color for identifying the source.
 ther are two functions which accept a string as argument and return the string
 well formatted as txt or hex.
 another function generates the html string in order to write down the log file
}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, graphics, strutils, lazutf8;

const
  coloreterm = clBlack;
  coloreserver = clRed;
  coloreclient = clGreen;
  coloremsg19 = clPurple;
type

  TSourceData = (fromServer, fromClient, fromTerm);

  ToutputStr = record
    color : TColor;
    headerstr : string;
    data : widestring;
  end;

  function writeHEX (data : string; source : TSourceData): TOutputStr;
  function writeTXT (data : widestring; source : TSourceData): TOutputStr;
  function writeHTML(data : widestring; source : TSourceData): string;
  function convertiUTF8(const str: string): string;
  procedure createHtml;
  var
  logdir: String;
  htmlfile : Textfile;
  htmlfilename : string;

implementation

function writeHEX(data: string; source: TSourceData): TOutputStr;
var
  i : longint;
begin
   case source of
   fromServer: begin
     result.headerstr:='From SERV: ';
      result.color:=coloreserver;
      if ansistartsstr('MSG 19', data) then  //useful only on dynamark protocol
         result.color:=coloremsg19;
    end;
    fromClient : begin
      result.color:=coloreclient;
      result.headerstr:='From CLNT: ';
    end;
    fromTerm   : begin
      result.color:=coloreterm;
      result.headerstr:='From TERM: ';
    end;
   end;
    for i:=1 to length(data) do
   begin
     result.data:=result.data+' '+data[i]+convertiUTF8(data[i]);
   end;
end;

function writeTXT(data: widestring; source: TSourceData): TOutputStr;
begin
  case source of
    fromServer : begin
      result.headerstr:='From SERV: ';
      result.color:=coloreserver;
      if ansistartsstr('MSG 19', data) then  //useful only on dynamark protocol
         result.color:=coloremsg19;
    end;
    fromClient : begin
      result.color:=coloreclient;
      result.headerstr:='From CLNT: ';
    end;
    fromTerm   : begin
      result.color:=coloreterm;
      result.headerstr:='From TERM: ';
    end;
   end;
  result.data:=data;
end;

function writeHTML(data: widestring; source: TSourceData): string;
begin
   result:=data;
end;


function convertiUTF8(const str: string): string;
var
  p: PChar;
  unicode: Cardinal;
  CharLen: integer;
  c,i:integer;
  tmp,utf8:string;
begin
  p:=PChar(str);
  c:=1;
  repeat
    unicode:=UTF8CharacterToUnicode(p,CharLen);
    utf8:=unicodetoutf8(unicode);
    for i:=1 to  length(utf8) do
        begin
          result:=result+'[0x'+inttohex(word(utf8[i]),2)+']';
        end;
    inc(p,CharLen);
    inc(c);
  until (CharLen=0) or (unicode=0);
end;

procedure createHtml;
begin
  try
    closefile(htmlfile);
  except

  end;

  htmlfilename:=logdir+'\'+formatdatetime('LOGV2_dd-MM-YY_hhmmss',now)+'.html';
  assignfile(htmlfile,htmlfilename);
  rewrite(htmlfile);
end;

end.

