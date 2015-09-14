unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, RichMemo, lNetComponents, Forms, Controls,
  Graphics, Dialogs, Menus, turseriale, ExtCtrls, StdCtrls, ComCtrls,
  PairSplitter, Buttons, registry, writedata, strutils, lNet;

type

  Visible = (txt, hex, txthex, nothing);
  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox10: TComboBox;
    ComboBox11: TComboBox;
    ComboBox12: TComboBox;
    ComboBox13: TComboBox;
    ComboBox14: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    ComboBox9: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    lNetServer: TLTCPComponent;
    lnetclient: TLTCPComponent;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PairSplitter1: TPairSplitter;
    PairSplitter2: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    PairSplitterSide3: TPairSplitterSide;
    PairSplitterSide4: TPairSplitterSide;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    RichMemo1: TRichMemo;
    RichMemo2: TRichMemo;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    StatusBar1: TStatusBar;



    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);

    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox14Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lnetclientAccept(aSocket: TLSocket);
    procedure lnetclientCanSend(aSocket: TLSocket);
    procedure lnetclientConnect(aSocket: TLSocket);
    procedure lnetclientDisconnect(aSocket: TLSocket);
    procedure lnetclientError(const msg: string; aSocket: TLSocket);
    procedure lnetclientReceive(aSocket: TLSocket);
    procedure lNetServerConnect(aSocket: TLSocket);
    procedure lNetServerDisconnect(aSocket: TLSocket);
    procedure lNetServerReceive(aSocket: TLSocket);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);

    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure PairSplitter1ChangeBounds(Sender: TObject);

    procedure Panel1Click(Sender: TObject);
    procedure RichMemo1EditingDone(Sender: TObject);
    procedure RichMemo1KeyPress(Sender: TObject; var Key: char);


  private
    { private declarations }
    serialeserveropened: boolean;
    serialeclientopened: boolean;

    serialeserver: TSeriale;
    serialeclient: TSeriale;
    procedure redraw;
    procedure serialeserverrecv(Data: string);
    procedure serialeserveropen(Sender: TObject);
    procedure serialeserverclose(Sender: TObject);
    procedure serialeclientrecv(Data: string);
    procedure serialeclientopen(Sender: TObject);
    procedure serialeclientclose(Sender: TObject);
    function GetSerialPortNames: TStringList;
    procedure writedatatomemo(Data: string; Source: TSourceData);
    procedure routedata(Data: string; Source: TSourceData);
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  visibled: Visible = txthex;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Panel1Click(Sender: TObject);
begin

end;

procedure TForm1.RichMemo1EditingDone(Sender: TObject);
begin
  //send terminal string to server or client according to setting

end;

procedure TForm1.RichMemo1KeyPress(Sender: TObject; var Key: char);
var
  tmpstr:string;
begin
  if ((Key=#13) and (not richmemo1.ReadOnly)) then
  begin
    tmpstr:=richmemo1.Lines.Strings[richmemo1.Lines.Count-1];
    richmemo1.Lines.Delete(richmemo1.Lines.Count-1);
    // richmemo1.Append('enter pressed');
    writedatatomemo(tmpstr+#13#10, fromTerm);

  end;
end;



procedure TForm1.serialeserverrecv(Data: string);
begin
  if length(Data)>0 then
 // if trim(Data) <> '' then
  begin
    writedatatomemo(Data, fromserver);
  end;

end;

procedure TForm1.serialeserveropen(Sender: TObject);
begin
  button1.Caption := 'STOP';
  statusbar1.Panels.Items[0].Text := 'Connected to ' + serialeserver.Port;
  panel2.Enabled := False;
  combobox1.Enabled := False;
  bitbtn1.Enabled := False;
  serialeserveropened := True;
end;

procedure TForm1.serialeserverclose(Sender: TObject);
begin
  button1.Caption := 'START';
  statusbar1.Panels.Items[0].Text := serialeserver.Port + ' disconnected';
  panel2.Enabled := True;
  combobox1.Enabled := True;
  bitbtn1.Enabled := True;
  serialeserveropened := False;
end;

procedure TForm1.serialeclientrecv(Data: string);
begin
  if length(Data)>0 then
  begin
    writedatatomemo(Data, fromclient);
  end;
end;

procedure TForm1.serialeclientopen(Sender: TObject);
begin
  button2.Caption := 'STOP';
  statusbar1.Panels.Items[1].Text := 'Connected to ' + serialeclient.Port;
  panel4.Enabled := False;
  combobox14.Enabled := False;
  serialeclientopened := True;
end;

procedure TForm1.serialeclientclose(Sender: TObject);
begin
  button2.Caption := 'START';
  statusbar1.Panels.Items[1].Text := serialeclient.Port + ' disconnected';
  panel4.Enabled := True;
  combobox14.Enabled := True;
  serialeclientopened := False;
end;

procedure TForm1.redraw;
begin
  PairSplitter1.Visible := True;
  case visibled of
    txt:
    begin
      PairSplitter1.Position := PairSplitterSide3.Height;
    end;
    hex:
    begin
      PairSplitter1.Position := 0;
    end;
    txthex:
    begin
      PairSplitter1.Position := PairSplitterSide3.Height div 2;
    end;
    nothing:
    begin
      PairSplitter1.Visible := False;
    end;
  end;
  if menuitem7.Checked then
  begin
    pairsplitter2.Position := form1.Width - 130;
  end
  else
  begin
    pairsplitter2.Position := form1.Width;
  end;
  groupbox1.Height := pairsplitter2.Height div 2;

end;


function TForm1.GetSerialPortNames: TStringList;
var
  reg: TRegistry;
  l, v: TStringList;
  n: integer;
begin
  v := TStringList.Create;
  l := TStringList.Create;
  reg := TRegistry.Create;

  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM') then
    begin
      reg.GetValueNames(l);
      for n := 0 to l.Count - 1 do
      begin
        v.Append(reg.ReadString(l[n]));
      end;
    end;

  finally
    reg.Free;
    l.Free;
  end;
  Result := v;
end;

procedure TForm1.writedatatomemo(Data: string; Source: TSourceData);
var
  timestr: string;
  fp: Tfontparams;
  tmpstr: TOutputStr;
  time: TDateTime;

begin
  routedata(Data,Source);
  if menuitem13.Checked then  //timestamp active?
  begin
    timestr := formatdatetime('c.zzz ', now);
  end
  else
  begin
    timestr := '';
  end;
  //Here always write to html log
  writehtml(Data,Source);
  if (not menuitem16.Checked) then
  begin
    //write to richmemo only if not log only (for performances issues)
  RichMemo1.GetTextAttributes(RichMemo1.SelStart, fp);
  tmpstr := writetxt(Data, Source);
  fp.Color := tmpstr.color;
  richmemo1.SetTextAttributes(richmemo1.SelStart, 0, fp);
  richmemo2.SetTextAttributes(richmemo2.SelStart, 0, fp);
  tmpstr.Data := ansireplacestr(tmpstr.Data, #13, '<CR>');
  richmemo1.Append(timestr + tmpstr.headerstr +
  ansireplacestr(tmpstr.Data, #10, '<LF>'));
  tmpstr := writehex(Data, Source);
  tmpstr.Data := ansireplacestr(tmpstr.Data, #13, '');
  richmemo2.Append(timestr + tmpstr.headerstr + ansireplacestr(tmpstr.Data, #10, ''));

  end;
end;

procedure TForm1.routedata(Data: string; Source: TSourceData);
begin
  if Source = fromServer then
  begin
    //send data to client if flag active

    //check if client is serial or tcp and if it is active
    if menuitem14.Checked then
    begin
      //send data to client
      //check if serial or tcp and if it is active
      if lnetclient.Connected then
        lnetclient.SendMessage(Data);
      if serialeclientopened then
        serialeclient.Send(Data);
    end;
  end;

  if Source = fromClient then
  begin
    //send data to server if flag active
    //according to mode send data to server or client
    if menuitem15.Checked then
    begin
      //send data to client
      //check if serial or tcp and if it is active
      if lnetserver.Connected then
        lnetserver.SendMessage(Data);
      if serialeserveropened then
        serialeserver.Send(Data);
    end;

  end;
  if Source = fromTerm then
  begin
    //according to mode send data to server or client
    if menuitem10.Checked then
    begin
      //send data to server
      //check if serial or tcp and if it is active
      if lnetserver.Connected then
        lnetserver.SendMessage(Data);
      if serialeserveropened then
        serialeserver.Send(Data);
    end;
    if menuitem12.Checked then
    begin
      //send data to client
      //check if serial or tcp and if it is active
      if lnetclient.Connected then
        lnetclient.SendMessage(Data);
      if serialeclientopened then
        serialeclient.Send(Data);
    end;

  end;

end;



procedure TForm1.FormResize(Sender: TObject);
begin
  redraw;
end;

procedure TForm1.lnetclientAccept(aSocket: TLSocket);
begin
  statusbar1.Panels.Items[1].Text := 'Connected to Client';
end;

procedure TForm1.lnetclientCanSend(aSocket: TLSocket);
begin

end;

procedure TForm1.lnetclientConnect(aSocket: TLSocket);
begin

end;



procedure TForm1.lnetclientDisconnect(aSocket: TLSocket);
begin
  // richmemo1.Append('lnetclientDisconnect');
  statusbar1.Panels.Items[1].Text := 'Not connected to Client';
end;

procedure TForm1.lnetclientError(const msg: string; aSocket: TLSocket);
begin
  richmemo1.Append('lnetclientError ' + msg);
end;

procedure TForm1.lnetclientReceive(aSocket: TLSocket);
var
  Data: string;
begin
  if lnetclient.GetMessage(Data) > 0 then
  begin

    writedatatomemo(Data, fromclient);
    //writehtml

  end;

end;

procedure TForm1.lNetServerConnect(aSocket: TLSocket);
begin
  button1.Caption := 'STOP';
  statusbar1.Panels.Items[0].Text := 'Connected to Server';
  panel1.Enabled := False;
  combobox1.Enabled := False;
  bitbtn1.Enabled := False;
end;

procedure TForm1.lNetServerDisconnect(aSocket: TLSocket);
begin
  button1.Caption := 'START';
  statusbar1.Panels.Items[0].Text := 'Not connected to Server';
  panel1.Enabled := True;
  combobox1.Enabled := True;
  bitbtn1.Enabled := True;
end;

procedure TForm1.lNetServerReceive(aSocket: TLSocket);
var
  Data: string;
begin
  if lnetserver.GetMessage(Data)>0 then
  begin
    writedatatomemo(Data, fromserver);
  end;
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
begin
  statusbar1.Panels.Items[3].Text := 'MODE: Terminal to Server';
  richmemo1.ReadOnly := False;
end;

procedure TForm1.MenuItem11Click(Sender: TObject);
begin
  statusbar1.Panels.Items[3].Text := 'MODE: PassThrough Only';
  richmemo1.ReadOnly := True;
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
begin
  statusbar1.Panels.Items[3].Text := 'MODE: Terminal to Client';
  richmemo1.ReadOnly := False;
end;

procedure TForm1.MenuItem13Click(Sender: TObject);
begin
  if menuitem13.Checked then
  begin
    statusbar1.Panels.Items[2].Text := 'Timestamp ON';
  end
  else
  begin
    statusbar1.Panels.Items[2].Text := 'Timestamp OFF';
  end;
end;

procedure TForm1.MenuItem14Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem15Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem16Click(Sender: TObject);
begin
  statusbar1.Panels.Items[3].Text := 'MODE: Log Only';
  richmemo1.ReadOnly := True;
end;

procedure TForm1.MenuItem17Click(Sender: TObject);
begin
  //close current html file and create a new one
  //filename has to include date and time in order to better get it
  //probably writedata is the right unit where to write down this action
  if logdir<>'' then
     createhtml
  else
     begin
          if selectdirectorydialog1.Execute then
          begin
             logdir:=selectdirectorydialog1.FileName;
             createhtml;
          end;

     end;

end;


procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  if combobox1.Text = 'TCP/IP' then
  begin
    panel1.Visible := True;
    panel2.Visible := False;
  end
  else
  begin
    panel1.Visible := False;
    panel2.Visible := True;
  end;
end;



procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  Combobox1.Items := GetSerialPortNames;
  Combobox1.Items.Insert(0, 'TCP/IP');
  combobox1.ItemIndex := 0;
  combobox14.Items := combobox1.Items;
  combobox14.ItemIndex := 0;
  ComboBox1Change(nil);
  ComboBox14Change(nil);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  tmpterm: string;
begin
  if button1.Caption = 'START' then
  begin
    if combobox1.Text = 'TCP/IP' then
    begin
      //start lnet connection to server
      lnetserver.Connect(labelededit1.Text, StrToInt(labelededit2.Text));
    end
    else
    begin
      //setup and open serial port
      //  if assigned(serialeserver) then
      //     serialeserver.Free;
      serialeserver := Tseriale.Create(nil);
      serialeserver.OnPortOpen := @serialeserveropen;
      serialeserver.OnPortClose := @serialeserverclose;
      serialeserver.ReceiveCallBack := @serialeserverrecv;
      serialeserver.Baud := StrToInt(combobox2.Text);
      serialeserver.DataBits := StrToInt(combobox3.Text);
      serialeserver.Parity := serialeserver.StrToParity(combobox4.Text);
      serialeserver.StopBits := serialeserver.StrToStopb(combobox5.Text);

      if combobox7.Text = 'TERM' then
      begin
        serialeserver.ReceiveMode := rmTERM;
        tmpterm := '';
        if checkbox1.Checked then
          tmpterm := '#13';
        if checkbox2.Checked then
          tmpterm := tmpterm + '#10';
        serialeserver.Terminator := tmpterm;
        serialeserver.Terminator := '#13#10';
      end
      else
      begin
        serialeserver.ReceiveMode := rmRaw;
      end;
      serialeserver.Port := '\\.\' + combobox1.Text;
      serialeserver.Open;

    end;
  end
  else
  begin
    // button1.Caption := 'START';
    if combobox1.Text = 'TCP/IP' then
    begin
      //stop lnet connection to server
      if lnetserver.Connected then
        lnetserver.Disconnect;
    end
    else
    begin
      if assigned(serialeserver) then
      begin
        serialeserver.Close;
        serialeserver.Free;
      end;
    end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  tmpterm: string;
begin
  if button2.Caption = 'START' then
  begin
    if combobox14.Text = 'TCP/IP' then
    begin
      //start lnet connection to server
      lnetclient.Listen(StrToInt(labelededit4.Text));
      button2.Caption := 'STOP';
      panel3.Enabled := False;
      combobox14.Enabled := False;
    end
    else
    begin
      //setup and open serial port
      //  if assigned(serialeserver) then
      //     serialeserver.Free;
      serialeclient := Tseriale.Create(nil);
      serialeclient.OnPortOpen := @serialeclientopen;
      serialeclient.OnPortClose := @serialeclientclose;
      serialeclient.ReceiveCallBack := @serialeclientrecv;
      serialeclient.Baud := StrToInt(combobox8.Text);
      serialeclient.DataBits := StrToInt(combobox9.Text);
      serialeclient.Parity := serialeclient.StrToParity(combobox10.Text);
      serialeclient.StopBits := serialeclient.StrToStopb(combobox11.Text);

      if combobox13.Text = 'TERM' then
      begin
        serialeclient.ReceiveMode := rmTERM;
        tmpterm := '';
        if checkbox1.Checked then
          tmpterm := '#13';
        if checkbox2.Checked then
          tmpterm := tmpterm + '#10';
        serialeclient.Terminator := tmpterm;
        serialeclient.Terminator := '#13#10';
      end
      else
      begin
        serialeclient.ReceiveMode := rmRaw;
      end;
      serialeclient.Port := '\\.\' + combobox14.Text;
      serialeclient.Open;

    end;
  end
  else
  begin

    if combobox14.Text = 'TCP/IP' then
    begin
      //stop lnet connection to client
      button2.Caption := 'START';
      panel3.Enabled := True;
      combobox14.Enabled := True;
      lnetclient.Disconnect(True);
      button2.Caption := 'START';
      statusbar1.Panels.Items[1].Text := 'Not connected to Client';
    end
    else
    begin
      if assigned(serialeclient) then
      begin
        serialeclient.Close;
        serialeclient.Free;
      end;
    end;
  end;

end;


procedure TForm1.ComboBox4Change(Sender: TObject);
begin

end;

procedure TForm1.ComboBox14Change(Sender: TObject);
begin
  if combobox14.Text = 'TCP/IP' then
  begin
    panel3.Visible := True;
    panel4.Visible := False;
  end
  else
  begin
    panel3.Visible := False;
    panel4.Visible := True;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  BitBtn1Click(nil);
  serialeclientopened := False;
  serialeserveropened := False;

end;



procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  //TXT view
  menuitem3.Checked := not menuitem3.Checked;
  case visibled of
    txt: visibled := nothing;
    hex: visibled := txthex;
    txthex: visibled := hex;
    nothing: visibled := txt;
  end;
  redraw;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  //HEX view
  menuitem4.Checked := not menuitem4.Checked;
  case visibled of
    txt: visibled := txthex;
    hex: visibled := nothing;
    txthex: visibled := txt;
    nothing: visibled := hex;
  end;
  redraw;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  selectdirectorydialog1.FileName:=logdir;
  if selectdirectorydialog1.Execute then
     logdir:=selectdirectorydialog1.FileName;
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
begin
  menuitem7.Checked := not menuitem7.Checked;
  redraw;
end;

procedure TForm1.PairSplitter1ChangeBounds(Sender: TObject);
begin

end;




end.
