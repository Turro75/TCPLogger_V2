unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, RichMemo,   Forms, Controls, Graphics,
  Dialogs, Menus, turseriale, ExtCtrls, StdCtrls, ComCtrls, PairSplitter,
  Buttons, registry;

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
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
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
    StatusBar1: TStatusBar;



    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);

    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox8Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);

    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure PairSplitter1ChangeBounds(Sender: TObject);

    procedure Panel1Click(Sender: TObject);


  private
    { private declarations }
    serial1: TSeriale;
    procedure redraw;
    procedure serial1recv(Data: string);
    procedure serial1open(Sender: TObject);
    procedure serial1close(Sender: TObject);
    function GetSerialPortNames: TStringList;

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



procedure TForm1.serial1recv(Data: string);
begin
  richmemo1.Append('RECV: '+Data);
end;

procedure TForm1.serial1open(Sender: TObject);
begin
  button1.Caption := 'STOP';
  statusbar1.Panels.Items[0].Text := 'Connected to ' + serial1.Port;
  panel2.Enabled := False;
  combobox1.Enabled := False;
  bitbtn1.Enabled := False;
end;

procedure TForm1.serial1close(Sender: TObject);
begin
  button1.Caption := 'START';
  statusbar1.Panels.Items[0].Text := serial1.Port + ' disconnected';
  panel2.Enabled := True;
  combobox1.Enabled := True;
  bitbtn1.Enabled := True;
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


procedure TForm1.FormResize(Sender: TObject);
begin
  redraw;
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
begin
  statusbar1.Panels.Items[3].Text:='MODE: Terminal to Server';
end;

procedure TForm1.MenuItem11Click(Sender: TObject);
begin
  statusbar1.Panels.Items[3].Text:='MODE: Sniffer Only';
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
begin
   statusbar1.Panels.Items[3].Text:='MODE: Terminal to Client';
end;

procedure TForm1.MenuItem13Click(Sender: TObject);
begin
  if menuitem13.Checked then
  begin
     statusbar1.Panels.Items[2].Text:='Timestamp ON';
  end
     else
  begin
     statusbar1.Panels.Items[2].Text:='Timestamp OFF';
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
  combobox8.Items := combobox1.Items;
  ComboBox1Change(nil);
  Combobox8Change(nil);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  tmpterm: string;
begin
  if button1.Caption = 'START' then
  begin
    // button1.Caption := 'STOP';

    if combobox1.Text = 'TCP/IP' then
    begin
      //start lnet connection to server
    end
    else
    begin
      //setup and open serial port
    //  if assigned(Serial1) then
    //     serial1.Free;
      serial1 := Tseriale.Create(nil);
      serial1.OnPortOpen := @serial1open;
      serial1.OnPortClose := @serial1close;
      serial1.ReceiveCallBack := @serial1recv;
      serial1.Baud := StrToInt(combobox2.Text);
      serial1.DataBits := StrToInt(combobox3.Text);
      serial1.Parity := serial1.StrToParity(combobox4.Text);
      serial1.StopBits := serial1.StrToStopb(combobox5.Text);

      if combobox7.Text = 'TERM' then
      begin
        serial1.ReceiveMode := rmTERM;
        tmpterm := '';
        if checkbox1.Checked then
          tmpterm := '#13';
        if checkbox2.Checked then
          tmpterm := tmpterm + '#10';
        serial1.Terminator := tmpterm;
        serial1.Terminator:='#13#10';
      end
      else
      begin
        serial1.ReceiveMode := rmRaw;
      end;
      serial1.Port := '\\.\' + combobox1.Text;
      serial1.Open;

    end;
  end
  else
  begin
    // button1.Caption := 'START';
    if combobox1.Text = 'TCP/IP' then
    begin
      //start lnet connection to server
    end
    else
    begin
      if assigned(serial1) then
      begin
        serial1.Close;
        serial1.Free;
      end;
    end;
  end;
end;


procedure TForm1.ComboBox4Change(Sender: TObject);
begin

end;

procedure TForm1.ComboBox8Change(Sender: TObject);
begin
  if combobox8.Text = 'TCP/IP' then
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

procedure TForm1.MenuItem7Click(Sender: TObject);
begin
  menuitem7.Checked := not menuitem7.Checked;
  redraw;
end;

procedure TForm1.PairSplitter1ChangeBounds(Sender: TObject);
begin

end;




end.
