unit uGlobalFuncs;

interface

uses
  uResourceStrings,
  uSharedStructs,
  sysutils,
  windows,
  Classes,
  TlHelp32,
  PSAPI,
  advApiHook,
  inifiles,
  Messages,
  uencdec;

  const
  WM_Dll_Log = $04F0;               //�������� ��������� �� inject.dll
  WM_NewAction = WM_APP + 107; //
  WM_AddLog = WM_APP + 108; //
  WM_NewPacket = WM_APP + 109; //
  WM_ProcessPacket = WM_APP + 110; //  
  //TencDec �������� �����
  TencDec_Action_LOG = 1; //������ � sLastPacket;  ���������� - PacketSend
  TencDec_Action_MSG = 2; //�a���� � sLastMessage; ���������� - Log
  TencDec_Action_GotName = 3; //������ � name; ���������� - UpdateComboBox1 (������� �������������)
  TencDec_Action_ClearPacketLog = 4; //������ ���. ������ �����; ���������� ClearPacketsLog
  //TSocketEngine �������� ���
  TSocketEngine_Action_MSG = 5; //������ � sLastMessage; ���������� - Log
  Ttunel_Action_connect_server = 6; //
  Ttunel_Action_disconnect_server = 7; //
  Ttunel_Action_connect_client = 8; //
  Ttunel_Action_disconnect_client = 9; //
  Ttulel_action_tunel_created = 10; //
  Ttulel_action_tunel_destroyed = 11; //  
  type
  SendMessageParam = class
  packet:tpacket;
  FromServer:boolean;
  Id:integer;
  tunel:Tobject;
  end;
  //�����������//
  function SymbolEntersCount(s: string): string;
  function HexToString(Hex:String):String;
  function ByteArrayToHex(str1:array of Byte; size: Word):String;
  function WideStringToString(const ws: WideString; codePage: Word): AnsiString;
  function StringToHex(str1,Separator:String):String;
  function StringToWideString(const s: AnsiString; codePage: Word): WideString;
  procedure FillVersion_a;
  //�����������//

  function getversion:string;

  function AddDateTime : string; //������� "11.12.2009 02.03.06"
  function AddDateTimeNormal : string; //������� "11.12.2009 02:03:06"
  function TimeStepByteStr:string;

  //��������� ���������
  Function LoadLibraryXor(const name: string): boolean; //��������� ������.��� ������������ � SettingsDialog
  Function LoadLibraryInject (const name: string) : boolean; //��������� ������.��� ������������ SettingsDialog

  procedure GetProcessList(var sl: TStrings); //�������� ������ ��������� ������������ � dmData.timerSearchProcesses

  procedure Reload;

  function GetNamePacket(s:string):string; // �������� �������� ������ �� ������
  var
  isGlobalDestroying : boolean;
  hXorLib:THandle; //����� ���������� ������. ��������������� � SettingsDialog
  pInjectDll : Pointer; //������ � ������.��� ��������������� � SettingsDialog
  CreateXorIn: Function(Value:PCodingClass):HRESULT; stdcall; //���� ���������� ������ (������)
  CreateXorOut: Function(Value:PCodingClass):HRESULT; stdcall; //��� ��������������� � ��������������� � SettingsDialog (������)

  sClientsList, //������ ��������� ���������� ��������� ��������������� � SettingsDialog
  sIgnorePorts, //�������� ������ ���������� �� ������� ������������ ��������������� � SettingsDialog
  sNewxor, //���� � ������.��� ��������������� � SettingsDialog
  sInject, //���� � ������.��� ��������������� � SettingsDialog
  sLSP : string; //���� � ��� ������. ��������������� � SettingsDialog
  LocalPort : word; //������� ����. ��������������� � SettingsDialog.
  AllowExit: boolean; //��������� �����. ��������������� � SettingsDialog

  GlobalSettings : TEncDecSettings; //������� ��������� ��� ������ ��������������� � SettingsDialog
  GlobalProtocolVersion : integer = -1;
  filterS, filterC: string; //������ ��������

  procedure AddToLog (msg: String); //��������� ������ � frmLogForm.log
  procedure ShowMessageNew(const Msg: string);

  function DataPckToStrPck(var pck): string; stdcall;
 var
  l2pxversion_array: array[0..3] of Byte; //������ ����������� ������� FillVersion_a
  l2pxversion: Integer  absolute l2pxversion_array;

  ShowMessageOld: procedure (const Msg: string);
  MaxLinesInLog : Integer; //������������ ���������� ����� � ���� ����� �������� ���� ������� � ���� � �������� ���
  MaxLinesInPktLog : Integer; //������������ ���������� ����� � ���� ������� ����� �������� ���� ������� � ���� � �������� ���
  isDestroying : boolean = false;
  PacketsNames, PacketsFromS, PacketsFromC : TStringList;

  SysMsgIdList,  //�� ����
  ItemsList,
  NpcIdList,
  ClassIdList,
  SkillList : TStringList; //� �� ���� - ������������ fPacketFilter
  
  GlobalRawAllowed, GlobalNoFreeAfterDisconnect : boolean; //���������� ��������� �� ����������� ���������� ������ ��� ������ ����������
  Options, PacketsINI : TMemIniFile;
  
implementation
uses udata, usocketengine, ulogform;

function DataPckToStrPck(var pck): string; stdcall;
var
  tpck: packed record
    size: Word;
    id: Byte;
  end absolute pck;
begin
  SetLength(Result,tpck.size-2);
  Move(tpck.id,Result[1],Length(Result));
end;


procedure ShowMessageNew(const Msg: string);
begin
  if Msg<>'Unregistered version of FastScript.' then
    ShowMessageOld(Msg);
end;

Procedure Reload;
begin
  //��������� systemmsg.ini
  SysMsgIdList.LoadFromFile(ExtractFilePath(ParamStr(0))+'sysmsgid.ini');
  //��������� itemname.ini
  ItemsList.LoadFromFile(ExtractFilePath(ParamStr(0))+'itemsid.ini');
  //��������� npcname.ini
  NpcIdList.LoadFromFile(ExtractFilePath(ParamStr(0))+'npcsid.ini');
  //��������� ClassId.ini
  ClassIdList.LoadFromFile(ExtractFilePath(ParamStr(0))+'classid.ini');
  //��������� skillname.ini
  SkillList.LoadFromFile(ExtractFilePath(ParamStr(0))+'skillsid.ini');
end;

function TimeStepByteStr:string;
var
  TimeStep: TDateTime;
  TimeStepB: array [0..7] of Byte;
begin
  TimeStep:=Time;
  Move(TimeStep,TimeStepB,8);
  result := ByteArrayToHex(TimeStepB,8);
end;

function GetNamePacket(s:string):string;
var
  ik: Word;
begin
  Result:='';
  ik:=1;
  // ���� ����� ����� ������
  while (s[ik]<>':') and (ik<Length(s)) do begin
    Result:=Result+s[ik];
    Inc(ik);
  end;
  if (ik=Length(s))and(s[ik]<>':') then Result:=Result+s[ik];
end;


function StringToWideString(const s: AnsiString; codePage: Word): WideString;
var
  l: integer;
begin
  if s = '' then
    Result := ''
else
  begin
    l := MultiByteToWideChar(codePage, MB_PRECOMPOSED, PChar(@s[1]), -1, nil,
      0);
    SetLength(Result, l - 1);
    if l > 1 then
      MultiByteToWideChar(CodePage, MB_PRECOMPOSED, PChar(@s[1]),
        -1, PWideChar(@Result[1]), l - 1);
  end;
end;



function StringToHex(str1,Separator:String):String;
var
  buf:String;
  i:Integer;
begin
  buf:='';
  for i:=1 to Length(str1) do begin
    buf:=buf+IntToHex(Byte(str1[i]),2)+Separator;
  end;
  Result:=buf;
end;

function SymbolEntersCount(s: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(s) do
    if not(s[i] in [' ',#10,#13]) then
      Result:=Result+s[i];
end;

function HexToString(Hex:String):String;
var
  buf:String;
  bt:Byte;
  i:Integer;
begin
  buf:='';
  Hex:=SymbolEntersCount(UpperCase(Hex));
  for i:=0 to (Length(Hex) div 2)-1 do begin
    bt:=0;
    if (Byte(hex[i*2+1])>$2F)and(Byte(hex[i*2+1])<$3A)then bt:=Byte(hex[i*2+1])-$30;
    if (Byte(hex[i*2+1])>$40)and(Byte(hex[i*2+1])<$47)then bt:=Byte(hex[i*2+1])-$37;
    if (Byte(hex[i*2+2])>$2F)and(Byte(hex[i*2+2])<$3A)then bt:=bt*16+Byte(hex[i*2+2])-$30;
    if (Byte(hex[i*2+2])>$40)and(Byte(hex[i*2+2])<$47)then bt:=bt*16+Byte(hex[i*2+2])-$37;
    buf:=buf+char(bt);
  end;
  HexToString:=buf;
end;

procedure GetProcessList(var sl: TStrings);
var
  pe: TProcessEntry32;
  ph, snap: THandle; //����������� �������� � ������
  mh: hmodule; //���������� ������
  procs: array[0..$FFF] of dword; //������ ��� �������� ������������ ���������
  count, cm: cardinal; //���������� ���������
  i: integer;
  ModName: array[0..max_path] of char; //��� ������
  tmp: string;
begin
  sl.Clear;
  if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then
  begin //���� ��� Win9x
    snap := CreateToolhelp32Snapshot(th32cs_snapprocess, 0);
    if integer(snap)=-1 then
    begin
      exit;
    end
    else
    begin
      pe.dwSize:=sizeof(pe);
      if Process32First(snap, pe) then
        repeat
          sl.Add(string(pe.szExeFile));
        until not Process32Next(snap, pe);
    end;
  end else begin //���� WinNT/2000/XP
    if not EnumProcesses(@procs, sizeof(procs), count) then
    begin
      exit;
    end;
    try
    for i:=0 to (count div 4) - 1 do if procs[i] <> 4 then
    begin
      EnablePrivilegeEx(INVALID_HANDLE_VALUE,'SeDebugPrivilege');
      ph := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, false, procs[i]);
      if ph > 0 then
      begin
        EnumProcessModules(ph, @mh, 4, cm);
        GetModuleFileNameEx(ph, mh, ModName, sizeof(ModName));
        tmp:=LowerCase(ExtractFileName(string(ModName)));
        sl.Add(IntToStr(procs[i])+'='+tmp);
        CloseHandle(ph);
      end;
    end;
    except
    end;
  end;
end;


procedure AddToLog (msg: String);
begin
  if isDestroying then exit;
  SendMessage(fLog.Handle,WM_AddLog,integer(msg),0);
end;

Function LoadLibraryInject(const name: string):boolean;
var sFile, Size:THandle;
    ee:OFSTRUCT;
    tmp:PChar;
begin
  if pInjectDll <> nil then
  begin
    FreeMem(pInjectDll);
    AddToLog(format(rsUnLoadDllSuccessfully,[name]));
  end;
  
  tmp:=PChar(ExtractFilePath(paramstr(0))+name);
  if fileExists (tmp) then begin
    sFile := OpenFile(tmp,ee,OF_READ);
    Result := true;
    AddToLog(format(rsLoadDllSuccessfully,[name]));
    Size := GetFileSize(sFile, nil);
    GetMem(pInjectDll, Size);
    ReadFile(sFile, pInjectDll^, Size, Size, nil);
    CloseHandle(sFile);
  end else
    begin
     result := false;
     AddToLog(format(rsLoadDllUnSuccessful,[name]));
    end;
end;


Function LoadLibraryXor(const name: string): boolean;
begin
// ��������� XOR dll
  if hXorLib <> 0 then
    begin
      FreeLibrary(hXorLib);
      AddToLog(format(rsUnLoadDllSuccessfully,[name]));
    end;
  hXorLib := LoadLibrary(PChar(ExtractFilePath(paramstr(0))+name));
  if hXorLib > 0 then
  begin
    AddToLog(format(rsLoadDllSuccessfully,[name]));
    result := true;
    @CreateXorIn := GetProcAddress(hXorLib,'CreateCoding');
    @CreateXorOut := GetProcAddress(hXorLib,'CreateCodingOut');
    if @CreateXorOut=nil then CreateXorOut:=CreateXorIn;
  end
 else
  begin
    Result := false;
    AddToLog(format(rsLoadDllUnSuccessful,[name]));
  end;
end;



function WideStringToString(const ws: WideString; codePage: Word): AnsiString;
var
  l: integer;
begin
  if ws = '' then
    Result := ''
else
  begin
    l := WideCharToMultiByte(codePage,
      WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
      @ws[1], -1, nil, 0, nil, nil);
    SetLength(Result, l - 1);
    if l > 1 then
      WideCharToMultiByte(codePage,
        WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
        @ws[1], -1, @Result[1], l - 1, nil, nil);
  end;
end;

function AddDateTime : string;
begin
  result := FormatDateTime('dd.mm.yyy hh.nn.ss' , now);
end;

function AddDateTimeNormal : string;
begin
  result := FormatDateTime('dd.mm.yyy hh:nn:ss' , now);
end;

function ByteArrayToHex(str1:array of Byte; size: Word):String;
var
  buf:String;
  i:Integer;
begin
  buf:='';
  for i:=0 to size-1 do begin
    buf:=buf+IntToHex(str1[i],2);
  end;
  Result:=buf;
end;

procedure FillVersion_a; //���������� ������������ ? ... � ����!
var
  ver:string;
begin
  ver := getversion;
  l2pxversion_array[0] := StrToIntDef(copy(ver,1,pos('.',ver)-1),0);
  delete(ver,1, pos('.', ver));
  l2pxversion_array[1] := StrToIntDef(copy(ver,1,pos('.',ver)-1),0);
  delete(ver,1, pos('.', ver));
  l2pxversion_array[2] := StrToIntDef(copy(ver,1,pos('.',ver)-1),0);
  delete(ver,1, pos('.', ver));
  l2pxversion_array[3] := StrToIntDef(ver,0);
end;

function getversion:string;
type
 LANGANDCODEPAGE = record
  wLanguage: word;
  wCodePage:word;
end;

var
  dwHandle, cbTranslate, lenBuf: cardinal;
  sizeVers: DWord;
  lpData, langData: Pointer;
  lpTranslate: ^LANGANDCODEPAGE;
  i: Integer;
  s: string;
  buf:PChar;
begin
 result := '';
 sizeVers := GetFileVersionInfoSize(pchar(ExtractFileName(ParamStr(0))), dwHandle);
 If sizeVers = 0 then
 exit;
 GetMem(lpData, sizeVers);
 try
  ZeroMemory(lpData, sizeVers);
  GetFileVersionInfo (pchar(ExtractFileName(ParamStr(0))), 0, sizeVers, lpData);
  If not VerQueryValue (lpData, '\VarFileInfo\Translation', langData, cbTranslate) then
  exit;
  For i := 0 to (cbTranslate div sizeof(LANGANDCODEPAGE)) do
  begin
   lpTranslate := Pointer(Integer(langData) + sizeof(LANGANDCODEPAGE) * i);
   s := Format('\StringFileInfo\%.4x%.4x\FileVersion', [lpTranslate^.wLanguage,
                  lpTranslate^.wCodePage]);
   If VerQueryValue (lpData, PChar(s), Pointer(buf), lenBuf) then
   begin
    Result := buf;

    break;
   end;
  end;
 finally
  FreeMem(lpData);
 end;
end;
end.