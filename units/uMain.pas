unit uMain;

interface

uses
  uSharedStructs,
  uGlobalFuncs,
  uResourceStrings,
  advApiHook,
  SyncObjs,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComCtrls, Menus, XPMan, JvExComCtrls, JvComCtrls, JvExControls, JvLabel,
  ExtCtrls, AppEvnts, Dialogs, JvComponentBase, JvTrayIcon, siComp,
  ActnList;

type
  TL2PacketHackMain = class(TForm)
    StatusBar1: TStatusBar;
    XPManifest1: TXPManifest;
    MainMenu1: TMainMenu;
    nFile: TMenuItem;
    nSettings: TMenuItem;
    N11: TMenuItem;
    nExitApp: TMenuItem;
    nHelp: TMenuItem;
    nAboutDlgShow: TMenuItem;
    nAdditional: TMenuItem;
    nProcessesShow: TMenuItem;
    nConvertorShow: TMenuItem;
    pcClientsConnection: TJvPageControl;
    nPscketFilterShow: TMenuItem;
    Splash: TJvLabel;
    UnUsedObjectsDestroyer: TTimer;
    nReloadPacketsIni: TMenuItem;
    N2: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    nUserFormShow: TMenuItem;
    N6: TMenuItem;
    nOpenPlog: TMenuItem;
    dlgOpenLog: TOpenDialog;
    nOpenRawLog: TMenuItem;
    nAutomation: TMenuItem;
    nScriptsShow: TMenuItem;
    nPluginsShow: TMenuItem;
    trayMenu: TPopupMenu;
    nScripts: TMenuItem;
    MenuItem1: TMenuItem;
    nPlugins: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem4: TMenuItem;
    nExit: TMenuItem;
    JvTrayIcon1: TJvTrayIcon;
    nShowHide: TMenuItem;
    N14: TMenuItem;
    nLanguage: TMenuItem;
    lang: TsiLang;
    RusLang: TMenuItem;
    EngLang: TMenuItem;
    ActionList1: TActionList;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    Action5: TAction;
    Action6: TAction;
    Action7: TAction;
    Action8: TAction;
    Action9: TAction;
    Action10: TAction;
    l2ph1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure nSettingsClick(Sender: TObject);
    procedure nProcessesShowClick(Sender: TObject);
    procedure nConvertorShowClick(Sender: TObject);
    procedure nPscketFilterShowClick(Sender: TObject);
    procedure nAboutDlgShowClick(Sender: TObject);
    procedure UnUsedObjectsDestroyerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure nExitAppClick(Sender: TObject);
    procedure nReloadPacketsIniClick(Sender: TObject);
    procedure ApplicationEvents1Hint(Sender: TObject);
    procedure nUserFormShowClick(Sender: TObject);
    procedure nOpenPlogClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure nOpenRawLogClick(Sender: TObject);
    procedure nPluginsShowClick(Sender: TObject);
    procedure nScriptsShowClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure JvTrayIcon1Click(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure nShowHideClick(Sender: TObject);
    procedure nExitClick(Sender: TObject);
    procedure RusLangClick(Sender: TObject);
    procedure EngLangClick(Sender: TObject);
    procedure Action9Execute(Sender: TObject);
    procedure l2ph1Click(Sender: TObject);
  protected
    procedure CreateParams (var Params : TCreateParams); override;
  private
    { Private declarations }
    procedure NewPacket(var msg: TMessage); Message WM_NewPacket;
    procedure ProcessPacket(var msg: TMessage); Message WM_ProcessPacket;
    procedure NewAction(var msg: TMessage); Message WM_NewAction;
    procedure ReadMsg(var msg: TMessage); Message WM_Dll_Log;
  public
    { Public declarations }
    Procedure init;

  end;
  pstr = ^string;

var
  L2PacketHackMain: TL2PacketHackMain;
  c_s : TCriticalSection;

implementation
uses uPlugins, uPluginData, usocketengine, winsock, uEncDec, uVisualContainer,
  uSettingsDialog, uLogForm, uConvertForm, uFilterForm, uProcesses,
  uAboutDialog, uData, uUserForm, uProcessRawLog, uScripts, Math;
 

{$R *.dfm}

{ TfMain }

procedure TL2PacketHackMain.init;
var
  ver : string;
begin
  //������ �����
  Top :=Options.ReadInteger('General','Top',0);
  Left :=Options.ReadInteger('General','Left',600);
  Width :=Options.ReadInteger('General','Widht',700);
  Height :=Options.ReadInteger('General','Heigth',960);

  ver := uGlobalFuncs.getversion;
  Splash.Caption := 'L2PacketHack v'+ ver + 'a'+#10#13#10#13+'[No Connections]';
  Caption := 'L2PacketHack v' + ver + ' by CoderX.ru Team';
  fAbout.Memo1.Lines.Insert(0, lang.GetTextOrDefault('IDS_6' (* '���������� ������:' *) ));
  fAbout.Memo1.Lines.Insert(0,'');
  fAbout.Memo1.Lines.Insert(0, ' by CoderX.ru Team');
  fAbout.Memo1.Lines.Insert(0,'L2PacketHack v' + ver);




  AddToLog(lang.GetTextOrDefault('IDS_9' (* '�������� L2ph v' *) ) + ver);
  sockEngine := TSocketEngine.create;
  sockEngine.ServerPort := htons(LocalPort);
  sockEngine.StartServer;
  sockEngine.isSocks5 := false;//����� ������ � �������� ������, �� ������� ���� ����� �� �����
end;



procedure TL2PacketHackMain.FormCreate(Sender: TObject);
begin

  HookCode(@ShowMessage,@ShowMessageNew,@ShowMessageOld);
  c_s := TCriticalSection.Create;
  DoubleBuffered := true;
  FillVersion_a;
  SysMsgIdList := TStringList.Create;
  ItemsList := TStringList.Create;
  NpcIdList := TStringList.Create;
  ClassIdList := TStringList.Create;
  SkillList := TStringList.Create;
  Reload;

end;

procedure TL2PacketHackMain.nSettingsClick(Sender: TObject);
begin
  if GetForegroundWindow = fSettings.Handle then
    fSettings.Hide
  else
    fSettings.Show;
end;

procedure TL2PacketHackMain.nProcessesShowClick(Sender: TObject);
begin
fProcesses.Show;
end;

procedure TL2PacketHackMain.nConvertorShowClick(Sender: TObject);
begin
  if GetForegroundWindow = fConvert.Handle then
    fConvert.Hide
  else
    fConvert.Show;
end;

procedure TL2PacketHackMain.nPscketFilterShowClick(Sender: TObject);
begin
  if GetForegroundWindow = fPacketFilter.Handle then
    fPacketFilter.Hide
  else
    fPacketFilter.Show;
end;

procedure TL2PacketHackMain.nAboutDlgShowClick(Sender: TObject);
begin
fAbout.show;
end;

procedure TL2PacketHackMain.UnUsedObjectsDestroyerTimer(Sender: TObject);
begin
  if Assigned(sockEngine) then sockEngine.destroyDeadTunels;
  if Assigned(dmData) then dmData.destroyDeadLSPConnections;
  if Assigned(dmData) then dmData.destroyDeadLogWievs;
end;

procedure TL2PacketHackMain.ReadMsg(var msg: TMessage);
var
  NewReddirectIP: Integer;
  IPb:array[0..3] of Byte absolute NewReddirectIP;
begin
c_s.Enter;
  msg.ResultHi := LocalPort;
  NewReddirectIP := msg.WParam;
  sockEngine.RedirrectIP := NewReddirectIP;
  sockEngine.RedirrectPort := msg.LParamLo;

  if Pos(IntToStr(ntohs(msg.LParamLo))+';',sIgnorePorts+';')=0 then begin
    if fSettings.ChkIntercept.Checked then
    begin
      msg.ResultLo:=1;
      AddToLog (Format(rsInjectConnectIntercepted, [IPb[0],IPb[1],IPb[2],IPb[3],ntohs(msg.LParamLo)]));
    end else
    begin
      msg.ResultLo:=0;
      AddToLog (Format(rsInjectConnectInterceptOff, [IPb[0],IPb[1],IPb[2],IPb[3],ntohs(msg.LParamLo)]));
    end;
  end else
  begin
    msg.ResultLo:=0;
    AddToLog (Format(rsInjectConnectInterceptedIgnoder, [IPb[0],IPb[1],IPb[2],IPb[3],ntohs(msg.LParamLo)]));
  end;
c_s.Leave;
end;


procedure TL2PacketHackMain.NewPacket(var msg: TMessage);
var
  temp : SendMessageParam;
begin
c_s.Enter;
{ TODO : ������� }
temp := SendMessageParam(pointer(msg.WParam)^);
fScript.ScryptProcessPacket(temp.packet, temp.FromServer, temp.Id);
if temp.Packet.Size > 2 then //������� ���� ������� ����� ��������
Ttunel(temp.tunel).Visual.AddPacketToAcum(temp.Packet, temp.FromServer, Ttunel(temp.tunel).EncDec);

{ TODO : here }
PostMessage(Handle,WM_ProcessPacket,integer(@Ttunel(temp.tunel).Visual), 0);
c_s.Leave;
end;

procedure TL2PacketHackMain.NewAction(var msg: TMessage);
var
  Tunel : Ttunel;
  EncDec : TencDec;
  SocketEngine : TSocketEngine;
  action : byte;
  i:integer;

begin
c_s.Enter;
action := byte(msg.wparam);

case action of
  TencDec_Action_LOG: //������ � sLastPacket;  ������ �����
  begin
    //TencDec(Caller).sLastPacket
  end;
  TencDec_Action_MSG: //�a���� � sLastMessage; ���������� - Log
    begin
      EncDec := TencDec(msg.LParam);
      AddToLog(encdec.sLastMessage);
    end;
  TencDec_Action_GotName:
    begin
      EncDec := TencDec(msg.LParam);
      if assigned(EncDec.ParentTtunel) then
        begin
          Tunel := Ttunel(EncDec.ParentTtunel);
          if assigned(tunel) then
            begin
              AddToLog(Format(rsConnectionName, [integer(pointer(Tunel)), encdec.CharName]));
              Tunel.AssignedTabSheet.Caption := EncDec.CharName;
              Tunel.CharName := EncDec.CharName;
            end;
        end;




    end; //������ � name; ���������� - UpdateComboBox1 (������� �������������)
  TencDec_Action_ClearPacketLog:; //������ ���. ������ �����; ���������� ClearPacketsLog
  //TSocketEngine �������� ���
  TSocketEngine_Action_MSG: //������ � sLastMessage; ���������� - Log
    begin
      SocketEngine := TSocketEngine(msg.LParam);
      AddToLog(SocketEngine.sLastMessage);
    end;
  Ttunel_Action_connect_server:
  begin
    Tunel := Ttunel(msg.LParam);
    for i:=0 to Plugins.Count - 1 do with TPlugin(Plugins.Items[i]) do
      if Loaded and Assigned(OnConnect) then OnConnect(Tunel.serversocket, true);
  end; //
  Ttunel_Action_disconnect_server:
  begin
    Tunel := Ttunel(msg.LParam);
    Tunel.active := false;
    for i:=0 to Plugins.Count - 1 do with TPlugin(Plugins.Items[i]) do
      if Loaded and Assigned(OnDisconnect) then OnDisconnect(Tunel.serversocket, true);
  end; //
  Ttunel_Action_connect_client:
    begin ////��������� ����� ���� � ���� ������.. � ��� ��� �����...
      Tunel := Ttunel(msg.LParam);
      Tunel.AssignedTabSheet := TTabSheet.Create(pcClientsConnection);
      Tunel.Visual := TfVisual.Create(Tunel.AssignedTabSheet);
      Tunel.Visual.setNofreeBtns(GlobalNoFreeAfterDisconnect);
      Tunel.Visual.Parent := Tunel.AssignedTabSheet;
      Tunel.AssignedTabSheet.PageControl := pcClientsConnection;
      Tunel.AssignedTabSheet.Caption := Tunel.CharName;
      Tunel.Visual.currentLSP := nil;
      Tunel.Visual.CurrentTpacketLog := nil;
      Tunel.Visual.currenttunel := Tunel;
      tunel.Visual.init;
      Tunel.active := true;
      if not pcClientsConnection.Visible then pcClientsConnection.Visible  := true;
      
      for i:=0 to Plugins.Count - 1 do with TPlugin(Plugins.Items[i]) do
        if Loaded and Assigned(OnConnect) then OnConnect(Tunel.serversocket, false);
    end; //
  Ttunel_Action_disconnect_client:
    begin
      Tunel := Ttunel(msg.LParam);
      Tunel.active := false;
      for i:=0 to Plugins.Count - 1 do with TPlugin(Plugins.Items[i]) do
        if Loaded and Assigned(OnDisconnect) then OnDisconnect(Tunel.serversocket, false);
    end;

  Ttulel_action_tunel_created:
    begin

    end;
  Ttulel_action_tunel_destroyed:
    begin
      Tunel := Ttunel(msg.LParam);
      tunel.Visual.deinit;
      if Assigned(Tunel.Visual) then Tunel.Visual.Destroy;
      if Assigned(Tunel.AssignedTabSheet) then Tunel.AssignedTabSheet.Destroy;
    end; 

  end;
c_s.Leave;
end;

procedure TL2PacketHackMain.FormDestroy(Sender: TObject);
begin
  isGlobalDestroying := true;
  UnhookCode(@ShowMessageOld);
  c_s.Destroy;
  if Assigned(sockEngine) then
    sockEngine.destroy;
    
  SysMsgIdList.Destroy;
  ItemsList.Destroy;
  NpcIdList.Destroy;
  ClassIdList.Destroy;
  SkillList.Destroy;

end;

procedure TL2PacketHackMain.nExitAppClick(Sender: TObject);
begin
  Close;
end;

procedure TL2PacketHackMain.nReloadPacketsIniClick(Sender: TObject);
begin
  Reload;
end;

procedure TL2PacketHackMain.ApplicationEvents1Hint(Sender: TObject);
begin
  StatusBar1.SimpleText := Application.Hint;
end;

procedure TL2PacketHackMain.nUserFormShowClick(Sender: TObject);
begin
if (GetForegroundWindow = UserForm.Handle) or not nUserFormShow.Enabled then
  UserForm.Hide
else
  UserForm.show;
end;

procedure TL2PacketHackMain.nOpenPlogClick(Sender: TObject);
var
  NewPacketLogWiev : TpacketLogWiev;
begin
  if dlgOpenLog.Execute then
  if FileExists(dlgOpenLog.FileName) then
  begin
    NewPacketLogWiev := TpacketLogWiev.create;
    NewPacketLogWiev.INIT(dlgOpenLog.FileName);
  end;
end;

procedure TL2PacketHackMain.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if AllowExit then Application.Terminate;
  if MessageDlg(pchar(
                lang.GetTextOrDefault('IDS_18' (* '�� ������� ��� ������ ����� �� ���������?' *) ) + #10#13+
                lang.GetTextOrDefault('IDS_19' (* '��� ���������� ���������!' *) )),
                mtConfirmation,[mbYes, mbNo],0)=mrYes then Application.Terminate;
  CanClose:=False;
end;

procedure TL2PacketHackMain.nOpenRawLogClick(Sender: TObject);
begin
  if GetForegroundWindow = fProcessRawLog.Handle then
    fProcessRawLog.Hide
  else
    fProcessRawLog.Show;
end;

procedure TL2PacketHackMain.nPluginsShowClick(Sender: TObject);
begin
  if GetForegroundWindow = fPlugins.Handle then
    fPlugins.Hide
  else
    fPlugins.Show;

end;

procedure TL2PacketHackMain.nScriptsShowClick(Sender: TObject);
begin
  if GetForegroundWindow = fScript.Handle then
    fScript.Hide
  else
    fScript.Show;
//ShowMessage('���������� ������� ��� ���� �� ������� ������.. ������� ���������� ����. ��� ����� �� ��������. �����.');
end;

procedure TL2PacketHackMain.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
    ExStyle := ExStyle OR WS_EX_APPWINDOW;
end;

procedure TL2PacketHackMain.FormActivate(Sender: TObject);
begin
{ TODO : ��� ������������ � ������� ���������� �� �� - � �������� �� ������������ ������. }
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TL2PacketHackMain.JvTrayIcon1Click(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
{if Button = mbLeft then
if L2PacketHackMain.Visible then SetForegroundWindow(L2PacketHackMain.Handle);}
end;

procedure TL2PacketHackMain.nShowHideClick(Sender: TObject);
begin
  if JvTrayIcon1.ApplicationVisible then
    JvTrayIcon1.HideApplication
  else
    begin
    JvTrayIcon1.ShowApplication;
    SetForegroundWindow(L2PacketHackMain.Handle);
    end;
end;

procedure TL2PacketHackMain.nExitClick(Sender: TObject);
begin
close;
end;

procedure TL2PacketHackMain.RusLangClick(Sender: TObject);
begin
EngLang.Checked := false;
RusLang.Checked := true;
lang.Language := 'Rus';
fSettings.lang.Language := 'Rus';
end;

procedure TL2PacketHackMain.EngLangClick(Sender: TObject);
begin
EngLang.Checked := true;
RusLang.Checked := false;
lang.Language := 'Eng';
fSettings.lang.Language := 'Eng';
end;

procedure TL2PacketHackMain.Action9Execute(Sender: TObject);
begin
  if Visible then BringToFront; 
end;

procedure TL2PacketHackMain.l2ph1Click(Sender: TObject);
begin
if GetForegroundWindow = fLog.Handle then
  fLog.Hide
else
  fLog.Show;
end;

procedure TL2PacketHackMain.ProcessPacket(var msg: TMessage);
var
visual:tfvisual;
begin
  visual := TfVisual(pointer(msg.WParam)^);
  visual.processpacketfromacum;
end;

end.