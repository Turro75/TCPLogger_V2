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
  Classes, SysUtils, graphics;

type

  TSourceData = (fromServer, fromClient, fromTerm);

  ToutputStr = record
    color : TColor;
    data : widestring;
  end;

  function writeHEX (data : widestring; source : TSourceData): TOutputStr;
  function writeTXT (data : widestring; source : TSourceData): TOutputStr;
  function writeHTML(data : widestring; source : TSourceData): string;

implementation

function writeHEX(data: widestring; source: TSourceData): TOutputStr;
begin
   case source of
    fromServer : begin
      result.color:=clRed;
    end;
    fromClient : begin
      result.color:=clGreen;
    end;
    fromTerm   : begin
      result.color:=clBlack;
    end;
   end;
   result.data:=data;
end;

function writeTXT(data: widestring; source: TSourceData): TOutputStr;
begin
  case source of
    fromServer : begin
      result.color:=clRed;
    end;
    fromClient : begin
      result.color:=clGreen;
    end;
    fromTerm   : begin
      result.color:=clBlack;
    end;
   end;
   result.data:=data;
end;

function writeHTML(data: widestring; source: TSourceData): string;
begin
   result:=data;
end;

end.

