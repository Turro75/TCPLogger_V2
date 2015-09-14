program TCPLogger_V2;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, richmemopackage, LazSerialPort, lnetvisual, sdposeriallaz, Unit1,
  dynprotocol, TurSeriale, writeData
  { you can add units after this };

{$R *.res}

begin
  Application.Title:='TCPLogger_V2';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

