unit dynprotocol;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
function prepare_dyncommand(const command :string):string;
function dyn_markstart : string;
function dyn_markstop : string;
function dyn_setdate : string;
function dyn_setmsg(msgid:integer; active:boolean):string;



implementation

function prepare_dyncommand(const command : string):string  ;
begin
    prepare_dyncommand:=command+#13#10;
end;

function dyn_markstart: string;
begin
   dyn_markstart:=prepare_dyncommand('MARK START');
end;

function dyn_markstop: string;
begin
   dyn_markstop:=prepare_dyncommand('MARK STOP');
end;

function dyn_setdate: string;
begin
  dyn_setdate:=prepare_dyncommand('SETDATE '+formatdatetime('hh nn ss YYYY MM DD',now));
end;

function dyn_setmsg(msgid: integer; active: boolean): string;
begin
  if active then
     dyn_setmsg:='SETMSG '+inttostr(msgid)+' 1'
     else
     dyn_setmsg:='SETMSG '+inttostr(msgid)+' 0'
end;

end.

