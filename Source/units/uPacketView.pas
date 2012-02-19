unit uPacketView;

interface

uses
  ComCtrls,
  SysUtils,
  StrUtils,
  uGlobalFuncs,
  uJavaParser,
  Windows,
  Messages, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RVScroll, RichView, RVStyle, ExtCtrls, siComp, StdCtrls, Menus;

type
  TfPacketView = class(TFrame)
    Splitter1: TSplitter;
    rvHEX: TRichView;
    lang: TsiLang;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    RVStyle1: TRVStyle;
    N2: TMenuItem;
    Panel1: TPanel;
    rvFuncs: TRichView;
    Label2: TLabel;
    rvDescryption: TRichView;
    Splitter2: TSplitter;
    procedure rvHEXMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure rvDescryptionMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure rvDescryptionRVMouseUp(Sender: TCustomRichView;
      Button: TMouseButton; Shift: TShiftState; ItemNo, X, Y: Integer);
    procedure rvHEXRVMouseUp(Sender: TCustomRichView; Button: TMouseButton;
      Shift: TShiftState; ItemNo, X, Y: Integer);
    procedure rvHEXSelect(Sender: TObject);
    procedure rvDescryptionSelect(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure rvFuncsSelect(Sender: TObject);

  private
    { Private declarations }
    procedure fParse;
    procedure fGet;
    procedure fSwitch;
    procedure fLoop;
    procedure fFor;
    procedure fLoopM;
    function GetName(s: string): string;
    function GetTyp(s: string): string;
    function GetType(const s: string; var i: Integer): string;
    function GetFunc(s: string): string;
    function GetParam(s: string): string;
    function GetParam2(s: string): string;
    function GetFunc01(const ar1: integer): string;
    function GetFunc01Aion(const ar1: integer): string;
    function GetFuncStrAion(const ar1: integer): string;
    function GetFunc02(const ar1: integer): string;
    function GetFunc09(id: byte; ar1: integer): string;
    function GetSkill(const ar1: integer): string;
    function GetSkillAion(const ar1: integer): string;
    function GetAugment(const ar1: integer): string;
    function GetMsgID(const ar1: integer): string;
    function GetMsgIDA(const ar1: integer): string;
    function GetClassID(const ar1: integer): string;
    function GetClassIDAion(const ar1: integer): string;
    function GetFSup(const ar1: integer): string;
    function prnoffset(offset: integer): string;
    function AllowedName(Name: string): boolean;
    function GetValue(var typ:string; name_, PktStr: string; var PosInPkt: integer): string;
    function GetNpcID(const ar1 : cardinal) : string;
    procedure addtoHex(Str:string);
    procedure selectitemwithtag (Itemtag:integer);
    function get(param1:string;id: byte; var value:string):boolean;
    procedure addToDescr(offset: integer; typ, name_, value: string);
    function GetFuncParams(FuncParamNames, FuncParamTypes :TStringList): string;
    procedure PrintFuncsParams(sFuncName :string);
    //��� ������������� � WPF 669f
    function GetFSay2(const ar1: integer): string;
    function GetF0(const ar1: integer): string;
    function GetF1(const ar1: integer): string;
    function GetF9(ar1: integer): string;
    function GetF3(const ar1: integer): string;
    //yet another parser
    procedure fParseJ;
  public
    { Public declarations }
    currentpacket: string;
    hexvalue: string; //��� ������ HEX � ����������� �������
    HexViewOffset : boolean;
    itemTag, templateindex:integer;
    //yet another parser
    procedure ParsePacket(PacketName, Packet:string; size : word = 0);
    procedure InterpretatorJava(PacketName, Packet: string; size: word = 0);
    procedure InterpretJava(PacketJava : TJavaParser; SkipID: boolean; PktStr: string; var PosInPkt: integer; var typ, name_, value, hexvalue: string; size: word);
  end;

implementation

uses umain;

{$R *.dfm}
  var
    cID: Byte;
    wSubID, wSize, wSub2ID : word;
    blockmask, PktStr, StrIni, Param0: String;
    oldpos, ii, PosInIni, PosInPkt, offset: Integer;
    ptime: TDateTime;
    isshow: Boolean;
    FuncNames, FuncParamNames, FuncParamTypes, FuncParamNumbers: TStringList;
    value, tmp_value, typ, name_, func, tmp_param, param1, param2,
    tmp_param1, tmp_param2, tmp_param12: String;

procedure TfPacketView.addtoHex(Str: string);
begin
  inc(itemTag);
  rvHEX.AddNLTag(copy(str,1,length(str)-1),templateindex,-1,itemTag);
  rvHEX.AddNL(' ', 0, -1);
end;

function TfPacketView.GetNpcID(const ar1: cardinal): string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.NpcID - ���������� ����� �� ��� ID �� �������� ���������
var
 _ar1: cardinal;
begin
  _ar1:=ar1-kNpcID;
  result:='0'; if ar1=0 then exit;
  result:=NpcIdList.Values[inttostr(_ar1)];
  if length(result)>0 then result:=result+' ID:'+inttostr(ar1)+' (0x'+inttohex(ar1,4)+')' else result:='Unknown Npc ID:'+inttostr(ar1)+'('+inttohex(ar1,4)+')';
end;

function TfPacketView.GetValue(var typ:string; name_, PktStr: string; var PosInPkt: integer): string;
var
  value: string;
  d:integer;
  pch: WideString;
begin
  templateindex := 0;
  hexvalue:='';
  case typ[1] of
    'd':
    begin
      value:=IntToStr(PInteger(@PktStr[PosInPkt])^);
      hexvalue:=' (0x'+inttohex(Strtoint(value),8)+')';
      templateindex := 10;
      Inc(PosInPkt,4);
    end;  //integer (������ 4 �����)           d, h-hex
    'c':
    begin
      value:=IntToStr(PByte(@PktStr[PosInPkt])^);
      hexvalue:=' (0x'+inttohex(Strtoint(value),2)+')';
      templateindex := 11;
      Inc(PosInPkt);
    end;  //byte / char (������ 1 ����)        b
    'f':
    begin
      value:=FloatToStr(PDouble(@PktStr[PosInPkt])^);
      templateindex := 12;
      Inc(PosInPkt,8);
    end;  //double (������ 8 ����, float)      f
    'n':
    begin
      value:=FloatToStr(PSingle(@PktStr[PosInPkt])^);
      templateindex := 12;
      Inc(PosInPkt,4);
    end;  //Single (������ 4 ����, float)      n
    'h':
    begin
      value:=IntToStr(PWord(@PktStr[PosInPkt])^);
      hexvalue:=' (0x'+inttohex(Strtoint(value),4)+')';
      templateindex := 13;
      Inc(PosInPkt,2);
    end;  //word (������ 2 �����)              w
    'q':
    begin
      value:=IntToStr(PInt64(@PktStr[PosInPkt])^);
      templateindex := 14;
      Inc(PosInPkt,8);
    end;  //int64 (������ 8 �����)
    '-','z':
    begin
      templateindex := 15;
      if Length(name_)>4 then
      begin
        if name_[1]<>'S' then
        begin
          d:=strtoint(copy(name_,1,4));
          Inc(PosInPkt,d);
          value:=lang.GetTextOrDefault('skip' (* '���������� ' *) )+inttostr(d)+lang.GetTextOrDefault('byte' (* ' ����(�)' *) );
        end else
          value:=lang.GetTextOrDefault('skip script' (* '���������� ������' *) );
      end else
      begin
        d:=strtoint(name_);
        Inc(PosInPkt,d);
        value:=lang.GetTextOrDefault('skip' (* '���������� ' *) )+inttostr(d)+lang.GetTextOrDefault('byte' (* ' ����(�)' *) );
      end;
    end;
    's':begin
      templateindex := 16;
      d := PosEx(#0#0, PktStr ,PosInPkt)-PosInPkt;
      if (d mod 2)=1 then Inc(d);
      SetLength(pch, d div 2);
      if d>=2 then Move(PktStr[PosInPkt],pch[1],d) else d:=0;
      value:=pch; //����������� ���������

     Inc(PosInPkt,d+2);
    end;
    '_':begin //(�������) ������ �� ������, ����� ��� switch
      templateindex := 17;
      value:='0';
    end;
    else value:= lang.GetTextOrDefault('unknownid' (* '����������� ������������� -> ?(name_)!' *) );
  end;
  Result:=value;
  if PosInPkt>wSize+10 then
    result:='range error';
end;

{ TfPacketView }
//-------------
function TfPacketView.GetType(const s:string; var i: Integer):string;
begin
  Result:='';
  while (s[i]<>')')and(i<Length(s)) do begin
    Result:=Result+s[i];
    Inc(i);
  end;
  Result:=Result+s[i];
end;
//-------------
function TfPacketView.GetTyp(s:string):string;
begin
  //d(Count:For.0001)
  //d(Count:Get.Func01)
  //-(40)
  Result:=s[1];
end;
function TfPacketView.GetName(s:string):string;
var
 k : integer;
begin
  Result:='';
  k:=Pos('(',s);
  if k=0 then exit;
  inc(k);
  while (s[k]<>':')and(k<Length(s)) do begin
    Result:=Result+s[k];
    Inc(k);
  end;
end;
function TfPacketView.GetFunc(s:string):string;
var
 k : integer;
begin
  Result:='';
  k:=Pos(':',s);
  if k=0 then exit;
  inc(k);
  while (s[k]<>'.')and(k<Length(s)) do begin
    Result:=Result+s[k];
    Inc(k);
  end;
end;
//-------------
function TfPacketView.GetParam(s:string):string;
var
 k : integer;
begin
  Result:='';
  k:=Pos('.',s);
  //�� ����� �����
  if k=0 then exit;
  inc(k);
  while (s[k]<>'.') and (k<Length(s)) do begin //or(s[k]<>')')
    Result:=Result+s[k];
    Inc(k);
  end;
end;
//-------------
function TfPacketView.GetParam2(s:string):string;
var
 k, l : integer;
 s2: string;
begin
  Result:='';
  k:=Pos('.',s);
  //�� ����� �����
  if k=0 then exit;
  //�� ��������� �� ������ ������
  inc(k);
  l:=length(s);
  s2:=copy(s,k, l-k+1);
  //���� ������ �����
  k:=Pos('.',s2);
  //�� ����� �����
  if k=0 then exit;
  inc(k);
  while (s2[k]<>')')and(k<Length(s2)) do begin
    Result:=Result+s2[k];
    Inc(k);
  end;
end;
//��� ������������� � WPF 669f
function TfPacketView.GetF0(const ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.F0 - ���������� �������� Item'� �� ��� ID �� �������� ���������
begin
  result:=GetFunc01(ar1);
end;
function TfPacketView.GetF3(const ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.F3 - ���������� �������� ������� �� ��� ID �� �������� ���������
begin
  result:=GetFunc01(ar1);
end;
//-------------
function TfPacketView.GetFunc01(const ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.Func01 - ���������� �������� Item'� �� ��� ID �� �������� ���������
begin
  result:='0'; if ar1=0 then exit;
  result:=ItemsList.Values[IntTostr(ar1)];
  if length(result)>0 then result:=result+' ID:'+inttostr(ar1)+' (0x'+inttohex(ar1,4)+')' else result:='Unknown Items ID:'+inttostr(ar1)+'('+inttohex(ar1,4)+')';
end;
//AION -------------
function TfPacketView.GetFunc01Aion(const ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.Func01A - ���������� �������� Item'� �� ��� ID �� �������� ���������
begin
  result:='0'; if ar1=0 then exit;
  result:=ItemsListAion.Values[IntTostr(ar1)];
  if length(result)>0 then result:=result+' ID:'+inttostr(ar1)+' (0x'+inttohex(ar1,4)+')' else result:='Unknown Items ID:'+inttostr(ar1)+'('+inttohex(ar1,4)+')';
end;
//-------------
function TfPacketView.GetFuncStrAion(const ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.StringA - ���������� ������ �� ��� ID �� �������� ���������
begin
  result:='0'; if ar1=0 then exit;
  result:=ClientStringsAion.Values[IntTostr(ar1)];
  if length(result)>0 then result:=result+' ID:'+inttostr(ar1)+' (0x'+inttohex(ar1,4)+')' else result:='Unknown msgID:'+inttostr(ar1)+'('+inttohex(ar1,4)+')';
end;
//��� ������������� � WPF 669f
function TfPacketView.GetFSay2(const ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.FSay2 - ���������� ��� Say2
begin
  result:=GetFunc02(ar1);
end;

function TfPacketView.GetFunc02(const ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.Func02 - ���������� ��� Say2
begin
  case ar1 of
    0: result := 'ALL';
    1: result := '! SHOUT';
    2: result := '" TELL';
    3: result := '# PARTY';
    4: result := '@ CLAN';
    5: result := 'GM';
    6: result := 'PETITION_PLAYER';
    7: result := 'PETITION_GM';
    8: result := '+ TRADE';
    9: result := '$ ALLIANCE';
    10: result := 'ANNOUNCEMENT';
    11: result := 'BOAT (WILLCRASHCLIENT?)';
    12: result := 'L2FRIEND';
    13: result := 'MSNCHAT';
    14: result := 'PARTYMATCH_ROOM';
    15: result := 'PARTYROOM_COMMANDER (yellow)';
    16: result := 'PARTYROOM_ALL (red)';
    17: result := 'HERO_VOICE';
    18: result := 'CRITICAL_ANNOUNCE';
    19: result := 'SCREEN_ANNOUNCE';
    20: result := 'BATTLEFIELD';
    21: result := 'MPCC_ROOM';
    else result := '?';
  end;
  result:=result+' ID:'+inttostr(ar1)+' (0x'+inttohex(ar1,4)+')';
end;
//-------------
function TfPacketView.GetF9(ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.F9 - SocialAction
begin
  result := '';
  case ar1 of // [C] 1B - RequestSocialAction,  [S] 2D - SocialAction
              // CT1: [S] 27 - SocialAction
     02: result := 'Greeting';
     03: result := 'Victory';
     04: result := 'Advance';
     05: result := 'No';
     06: result := 'Yes';
     07: result := 'Bow';
     08: result := 'Unaware';
     09: result := 'Social Waiting';
    $0A: result := 'Laugh';
    $0B: result := 'Applaud';
    $0C: result := 'Dance';
    $0D: result := 'Sorrow';
    $0E: result := 'Charm';
    $0F: result := 'Shyness';
    $10: result := 'Hero light';
    $084A: result := 'LVL-UP';
    else result := '?';
  end;
  result:=result+' ID:'+inttostr(ar1)+' (0x'+inttohex(ar1,4)+')';
end;
//-------------
function TfPacketView.GetFunc09(id: byte; ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.Func09 - ������.
begin
  result := '';
  if (id in [$1B,$2D,$27]) then begin
    case ar1 of // [C] 1B - RequestSocialAction,  [S] 2D - SocialAction
                // CT1: [S] 27 - SocialAction
       02: result := 'Greeting';
       03: result := 'Victory';
       04: result := 'Advance';
       05: result := 'No';
       06: result := 'Yes';
       07: result := 'Bow';
       08: result := 'Unaware';
       09: result := 'Social Waiting';
      $0A: result := 'Laugh';
      $0B: result := 'Applaud';
      $0C: result := 'Dance';
      $0D: result := 'Sorrow';
      $0E: result := 'Charm';
      $0F: result := 'Shyness';
      $10: result := 'Hero light';
      $084A: result := 'LVL-UP';
      else result := '?';
    end;
  end else if (id=$6D) then begin
    case ar1 of //  [C] 6D - RequestRestartPoint.
      0: result := 'res to town';
      1: result := 'res to clanhall';
      2: result := 'res to castle';
      3: result := 'res to siege HQ';
      4: result := 'res here and now :)';
      else result := '?';
    end;
  end;
  if (id=$6E) then begin
    case ar1 of // [C] 6E - RequestGMCommand.
      1: result := 'player status';
      2: result := 'player clan';
      3: result := 'player skills';
      4: result := 'player quests';
      5: result := 'player inventory';
      6: result := 'player warehouse';
      else result := '?';
    end;
  end;
  if (id=$A0) then begin
    case ar1 of // [C] A0 -RequestBlock
      0: result := 'block name';
      1: result := 'unblock name';
      2: result := 'list blocked names';
      3: result := 'block all';
      4: result := 'unblock all';
      else result := '?';
    end;
  end;
  result:=result+' ID:'+inttostr(ar1)+' (0x'+inttohex(ar1,4)+')';
end;
//-------------
function TfPacketView.GetSkill(const ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.Skill - ���������� �������� ����� �� ��� ID �� �������� ���������
begin
  result:='0'; if ar1=0 then exit;
  result:=SkillList.Values[inttostr(ar1)];
  if length(result)>0 then result:=result+' ID:'+inttostr(ar1)+' (0x'+inttohex(ar1,4)+')' else result:='Unknown Skill ID:'+inttostr(ar1)+'('+inttohex(ar1,4)+')';
end;
//AION -------------
function TfPacketView.GetSkillAion(const ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.SkillA - ���������� �������� ����� �� ��� ID �� �������� ���������
begin
  result:='0'; if ar1=0 then exit;
  result:=SkillListAion.Values[inttostr(ar1)];
  if length(result)>0 then result:=result+' ID:'+inttostr(ar1)+' (0x'+inttohex(ar1,4)+')' else result:='Unknown Skill ID:'+inttostr(ar1)+'('+inttohex(ar1,4)+')';
end;
//��� ������������� � WPF 669f
function TfPacketView.GetF1(const ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.F1 - ���������� �������� ����� �� ��� ID �� �������� ���������
begin
  result:=GetAugment(ar1);
end;
//-------------
function TfPacketView.GetAugment(const ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.AugmentID - ���������� �������� ����� �� ��� ID �� �������� ���������
begin
  result:='0'; if ar1=0 then exit;
  result := AugmentList.Values[inttostr(ar1)];
  if length(result)>0 then result:=result+' ID:'+inttostr(ar1)+' (0x'+inttohex(ar1,4)+')' else result:='Unknown Augment ID:'+inttostr(ar1)+'('+inttohex(ar1,4)+')';
end;
//-------------
function TfPacketView.GetMsgID(const ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.MsgID - ���������� ����� �� ��� ID �� �������� ���������
begin
  result:='0'; if ar1=0 then exit;
  result:=SysMsgidList.Values[inttostr(ar1)];
  if length(result)>0 then result:=result+' ID:'+inttostr(ar1)+' (0x'+inttohex(ar1,4)+')' else result:='Unknown SysMsg ID:'+inttostr(ar1)+'('+inttohex(ar1,4)+')';
end;
//AION -------------
function TfPacketView.GetMsgIDA(const ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.MsgIDA - ���������� ����� �� ��� ID �� �������� ���������
begin
  result:='0'; if ar1=0 then exit;
  result:=SysMsgidListAion.Values[inttostr(ar1)];
  if length(result)>0 then result:=result+' ID:'+inttostr(ar1)+' (0x'+inttohex(ar1,4)+')' else result:='Unknown SysMsg ID:'+inttostr(ar1)+'('+inttohex(ar1,4)+')';
end;
//-------------
function TfPacketView.GetClassID(const ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.ClassID - �����
begin
  result:=ClassIdList.Values[inttostr(ar1)];
  if length(result)>0 then result:=result+' ID:'+inttostr(ar1)+' (0x'+inttohex(ar1,4)+')' else result:='Unknown Class ID:'+inttostr(ar1)+'('+inttohex(ar1,4)+')';
end;
//AION -------------
function TfPacketView.GetClassIDAion(const ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.ClassIDA - �����
begin
  result:=ClassIdListAion.Values[inttostr(ar1)];
  if length(result)>0 then result:=result+' ID:'+inttostr(ar1)+' (0x'+inttohex(ar1,4)+')' else result:='Unknown Class ID:'+inttostr(ar1)+'('+inttohex(ar1,4)+')';
end;
//-------------
function TfPacketView.GetFSup(const ar1 : integer) : string;
// ������� �-���, ���������� �� �� �������, � �� ���������
// :Get.FSup - Status Update ID
begin
  case ar1 of
    01: result := 'Level';      02: result := 'EXP';         03: result := 'STR';
    04: result := 'DEX';        05: result := 'CON';         06: result := 'INT';
    07: result := 'WIT';        08: result := 'MEN';         09: result := 'cur_HP';
    $0A: result := 'max_HP';   $0B: result := 'cur_MP';     $0C: result := 'max_MP';
    $0D: result := 'SP';       $0E: result := 'cur_Load';   $0F: result := 'max_Load';
    $11: result := 'P_ATK';    $12: result := 'ATK_SPD';    $13: result := 'P_DEF';
    $14: result := 'Evasion';  $15: result := 'Accuracy';   $16: result := 'Critical';
    $17: result := 'M_ATK';    $18: result := 'CAST_SPD';   $19: result := 'M_DEF';
    $1A: result := 'PVP_FLAG'; $1B: result := 'KARMA';      $21: result := 'cur_CP';
    $22: result := 'max_CP';
    else result := '?'
  end;
  result:=result+' ID:'+inttostr(ar1)+' (0x'+inttohex(ar1,4)+')';
end;

function TfPacketView.prnoffset(offset:integer):string;
begin
  result:=inttostr(offset);
  case Length(result) of
    1: result:='000'+result;
    2: result:='00'+result;
    3: result:='0'+result;
  end;
end;
//�������� �� ��, ��� ������ ������ �� ��������
function TfPacketView.AllowedName(Name:string):boolean;
var
i:integer;
begin
  result := true;
  i := 1;
  while i <= length(Name) do
  begin
    if not (lowercase(Name[i])[1] in ['a'..'z']) then
      begin
        result := false;
        exit;
      end;
    inc(i);
  end;
end;
//=======================================================================
// �������� ��������� �������
//=======================================================================
//  procedure addToDescr(offset:integer; typ, name_, value:string);
//  procedure PrintFuncsParams(sFuncName:string);
//  procedure fGet();
//  procedure fFor();
//  procedure fLoop();
//  procedure fParse();
//  procedure fSwitch();
//=======================================================================
procedure TfPacketView.addToDescr(offset :integer; typ, name_, value :string);
var
  another :string;
begin
  another := ' ' + typ + ' ';
  if HexViewOffset
    then
      rvDescryption.AddNLTag(inttohex(offset, 4)+another, templateindex, 0, itemTag)
    else
      rvDescryption.AddNLTag(prnoffset(offset)+another, templateindex, 0, itemTag);

  rvDescryption.GetItem(rvDescryption.ItemCount-1).Tag := itemTag;
  rvDescryption.AddNL(' ', 0, -1);
  rvDescryption.AddNL(name_, 1, -1);
  rvDescryption.AddNL(': ', 0, -1);
  rvDescryption.AddNL(value, 0, -1);
end;
//=======================================================================
function TfPacketView.GetFuncParams(FuncParamNames, FuncParamTypes :TStringList) :string;
var
  i :integer;
begin
  result := '';
  i := 0;
  while i < funcparamnames.Count do
  begin
    if (i < funcparamnames.Count - 1) and (FuncParamTypes.Strings[i] = FuncParamTypes.Strings[i+1]) then
      result := format('%s%s, ',[result, FuncParamNames.Strings[i]])
    else
    begin
    case FuncParamTypes.Strings[i][1] of
      'd':
          begin
            result := format('%s%s:%s',[result, FuncParamNames.Strings[i],'Integer']);
          end;  //dword (������ 4 �����)           d, h-hex
      'c':
          begin
            result := format('%s%s:%s',[result, FuncParamNames.Strings[i],'Byte']);
          end;  //byte / char (������ 1 ����)        b
      'f':
          begin
            result := format('%s%s:%s',[result, FuncParamNames.Strings[i],'Real']);
          end;  //double (������ 8 ����, float)      f
      'h':
          begin
            result := format('%s%s:%s',[result, FuncParamNames.Strings[i],'Word']);
          end;  //word (������ 2 �����)              w
      'q':
          begin
            result := format('%s%s:%s',[result, FuncParamNames.Strings[i],'Int64']);
          end;  //int64 (������ 8 �����)
      's':begin
            result := format('%s%s:%s',[result, FuncParamNames.Strings[i],'String']);
          end;
    end;
    if i < funcparamnames.Count-1 then
      result := result + '; ';
    end;
    inc(i);
  end;
end;
//=======================================================================
procedure TfPacketView.PrintFuncsParams(sFuncName :string);
var
  i :integer;
  values :string;
begin
  if FuncNames.IndexOf(sFuncName) < 0 then
  begin
    i := 0;
    values := '';
    while i < FuncParamNumbers.count do
    begin
      if (i < FuncParamNumbers.Count - 1) then
        values := format('%sValues[%s], ', [values, FuncParamNumbers.Strings[i]])
      else
        values := format('%sValues[%s]', [values, FuncParamNumbers.Strings[i]]);

      inc(i);
    end;
    rvFuncs.AddNL(format('Declaration : %s(%s);', [sFuncName, GetFuncParams(FuncParamNames, FuncParamTypes)]), 0, 0);
    rvFuncs.AddNL(format('Calling : %s(%s);', [sFuncName, values]), 0, 0);

    FuncNames.Add(sFuncName);
    rvFuncs.AddNL('Mask : ', 0, 0);
    rvFuncs.AddNL(blockmask, 0, -1);
    rvFuncs.AddNL('', 0, 0);
    blockmask := '';
  end;
  FuncParamNumbers.clear;
  FuncParamNames.Clear;
  FuncParamTypes.Clear;
end;
//=======================================================================
  procedure TfPacketView.fParse();
  begin
      //������� ������ ���� typ(name_:func.param1.param2)
      Param0:=GetType (StrIni, PosInIni);
      inc(PosInIni); //���������� �� ��������� ��������
      typ:=GetTyp(Param0); //��������� ��� ��������
      name_:=GetName(Param0); //��������� ��� �������� � ������� typ(name_:func.param1.param2)
      func:=uppercase(GetFunc(Param0)); //��������� ��� ������� � ������� typ(name_:func.param1.param2)
      param1:=uppercase(GetParam(Param0)); //��������� ��� �������� � ������� typ(name_:func.param1.param2)
      param2:=GetParam2(Param0); //��������� ��� �������� � ������� typ(name_:func.param1.param2)
      offset:=PosinPkt-11;
      oldpos := PosInPkt;
      //��� �� ��� ���������
      // if (PosInIni<Length(StrIni))and(PosInPkt<sizze+10)

      //��������� �������� �� ������, �������� ��������� � ������������ � ����� ��������
      value:=GetValue(typ, name_, PktStr, PosInPkt);
      //���������� �������
      if typ<>'_' then
      begin
        if AllowedName(name_) then
        begin
          FuncParamNames.Add(name_);
          FuncParamTypes.Add(typ);
          FuncParamNumbers.Add(inttostr(length(blockmask)));
        end;
        blockmask := blockmask + typ;
      end;
      if PosInPkt - oldpos > 0 then
        addtoHex(StringToHex(copy(pktstr, oldpos, PosInPkt - oldpos),' '));
  end;
//=======================================================================
  procedure TfPacketView.fGet();
  begin
    if not get(param1, cID, value) then
      exit
    else
      addToDescr(offset, typ, name_, value);        //�������������
  end;
//=======================================================================
//�������� ������ switch � java ����� ��������� ���:
//���:
//switch (���������) { case
//��������1:
//// ������������������ ����������
//break;
//case ��������2:
//// ������������������ ����������
//break;
//...
//case ��������N:
//// ������������������ ����������
//break;
//default:
//// ������������������ ����������, ����������� �� ���������
//� ��� �������� ������ �������� ���, ������:
//���:
//17=SM_MESSAGE:h(id2)c(chatType:switch.0002.0003)c(RaceId)d(ObjectId)_(id:case.0.2)h(unk)s(message)_(id:case.1.3)h(unk)d(unk)s(message)_(id:case.2.4)h(unk)d(unk)d(unk)s(message)s(Name)s(message)
//���:
//����� � ����� c(chatType:switch.0002.0003)
//chatType  - ���������, ��� ���� (1 ����)
// switch  - �������� ����� ��������� ������
//0002 - ������� ��������� ����� switch ����������, �.�. �������� c(RaceId)d(ObjectId) ������ ��������� � ����������� �� �����
//0003 - ������� ��������� _(id:case ������������ � switch
//
//� ����� _(id:case.0000.0002)h(unk)s(message)
//_ - ������������
//id - ������������, ���� ����� ������� ��� ��������������
//case - �������� ����� ��� �������� ������ �� ��������� 0000
//0002 � ���������� ��������� � ����� case, �.�. �������� h(unk)s(message)
//��������� �������� s(Name)s(message) �������� ��� ����� default, �.�. ���� chatType �� ������������� �� ������ case, �� � ����������� �������� �������� s(Name)s(message).
//�� �������� ���� ����� ����� ��������, �.�. ������ 0001 ����� 1.
//=======================================================================
  procedure TfPacketView.fSwitch();
  var
    i, j :integer;
    end_block :string;
  begin
      //�������������
      addToDescr(offset, typ, name_, value+hexvalue);
      tmp_param1:=param1;
      tmp_param2:=param2;
      tmp_value:=value;
      end_block:=value;
      if value = 'range error' then exit;
      //��������, ��� param1 > 0
      if strtoint(param1)>0 then
      begin
        //������������� �������� ���� ������������ ������
        for i:=1 to StrToInt(tmp_param1) do
        begin
          fParse();
          if Func='LOOPM' then  fLoopM()
          else
          if Func='LOOP' then  fLoop()
          else
          if Func='FOR' then  fFor()
          else
          if Func='SWITCH' then  fSwitch()
          else
          if Func='GET' then  fGet() //get(param1, id, value);
          //�������������
          else addToDescr(offset, typ, name_, value+hexvalue);
        end;
      end;
      for i:=1 to StrToInt(tmp_param2) do  //��������� �� ���� case
      begin
          fParse();
          tmp_param12:=param2;
          if Func='CASE' then
          begin
            if tmp_value=param1 then  //id �������
            begin
              //������������� ��������
              for j:=1 to StrToInt(tmp_param12) do
              begin
                fParse();
                if Func='LOOPM' then  fLoopM()
                else
                if Func='LOOP' then  fLoop()
                else
                if Func='FOR' then  fFor()
                else
                if Func='SWITCH' then  fSwitch()
                else
                if Func='GET' then  fGet() //get(param1, id, value);
                //�������������
                else addToDescr(offset, typ, name_, value+hexvalue);
              end;
            end else
              //���������� ��������
              for j:=1 to StrToInt(tmp_param12) do
              begin
                Param0:=GetType(StrIni, PosInIni);
                inc(PosInIni);
              end;
          end;
      end;
  end;
//=======================================================================
  procedure TfPacketView.fLoop();
  var
    i, j, val :integer;
    end_block :string;
  begin
      //�������������
      addToDescr(offset, typ, name_, value+hexvalue);
      tmp_param:=param2;
      tmp_value:=value;
      //end_block:=value;
      if value='range error' then exit;
      if StrToInt(value)=0 then
      begin
        //���������� ������ �������� � Loop
        for i:=1 to StrToInt(param2) do
        begin
          Param0:=GetType(StrIni, PosInIni);
          inc(PosInIni);
        end;
      end else
      begin
        //��������, ��� param1 > 1
        if strtoint(param1)>1 then
        begin
          //������������� ��������
          for i:=1 to StrToInt(param1)-1 do
          begin
            fParse();
            if Func='GET' then  fGet() //get(param1, id, value);
            //�������������
            else addToDescr(offset, typ, name_, value+hexvalue);
          end;
        end;
        ii:=PosInIni;
        if tmp_value = 'range error' then exit;
        //PrintFuncsParams('Pck'+PacketName);
        if StrToInt(tmp_value)>32767
        then val:=(StrToInt(tmp_value) XOR $FFFF)+1
        else val:=StrToInt(tmp_value);
        end_block:=inttostr(val);
//        for i:=1 to StrToInt(tmp_value) do
        for i:=1 to val do
        begin
          rvDescryption.AddNL('              '+lang.GetTextOrDefault('startb' (* '[������ �������������� ����� ' *) ), 0, 0);
          rvDescryption.AddNL(inttostr(i)+'/'+end_block, 1, -1);
          rvDescryption.AddNL(']', 0, -1);
          PosInIni:=ii;
          for j:=1 to StrToInt(tmp_param) do
          begin
            fParse();
            //����� ����� ���� SWITCH
            if Func='LOOPM' then  fLoopM()
            else
            if Func='LOOP' then  fLoop()
            else
            if Func='FOR' then  fFor()
            else
            if Func='SWITCH' then  fSwitch()
            else
            if Func='GET' then  fGet() //get(param1, id, value);
            //�������������
            else addToDescr(offset, typ, name_, value+hexvalue);
          end;
          //if value = 'range error' then break;
          rvDescryption.AddNL('              '+lang.GetTextOrDefault('endb' (* '[����� �������������� ����� ' *) ), 0, 0);
          rvDescryption.AddNL(inttostr(i)+'/'+end_block, 1, -1);
          rvDescryption.AddNL(']', 0, -1);
          //PrintFuncsParams('Item'+PacketName);
        end;
      end;
  end;
//=======================================================================
//���� Loop ��� ���� � ���������� � ���� �����
  procedure TfPacketView.fLoopM();
  var
    i, j, val, k :integer;
    end_block :string;
  begin
      //�������������
      addToDescr(offset, typ, name_, value+hexvalue);
      tmp_param:=param2;
      tmp_value:=value;
      //end_block:=value;
      if value='range error' then exit;
      if StrToInt(value)=0 then
      begin
        //���������� ������ �������� � Loop
        for i:=1 to StrToInt(param2) do
        begin
          Param0:=GetType(StrIni, PosInIni);
          inc(PosInIni);
        end;
      end else
      begin
        //��������, ��� param1 > 1
        if strtoint(param1)>1 then
        begin
          //������������� ��������
          for i:=1 to StrToInt(param1)-1 do
          begin
            fParse();
            if Func='GET' then  fGet() //get(param1, id, value);
            //�������������
            else addToDescr(offset, typ, name_, value+hexvalue);
          end;
        end;
        ii:=PosInIni;
        if tmp_value = 'range error' then exit;
        //����������� �������� ����� � �����
        k:=StrToInt(tmp_value); // EquipmentMask
        val:=0;
        for i:=0 to 15 do val:=val+((k shr i)and 1);
        end_block:=inttostr(val);
        for i:=1 to val do
        begin
          rvDescryption.AddNL('              '+lang.GetTextOrDefault('startb' (* '[������ �������������� ����� ' *) ), 0, 0);
          rvDescryption.AddNL(inttostr(i)+'/'+end_block, 1, -1);
          rvDescryption.AddNL(']', 0, -1);
          PosInIni:=ii;
          for j:=1 to StrToInt(tmp_param) do
          begin
            fParse();
            if Func='LOOPM' then  fLoopM()
            else
            if Func='LOOP' then  fLoop()
            else
            if Func='FOR' then  fFor()
            else
            if Func='SWITCH' then  fSwitch()
            else
            if Func='GET' then  fGet() //get(param1, id, value);
            //�������������
            else addToDescr(offset, typ, name_, value+hexvalue);
          end;
          //if value = 'range error' then break;
          rvDescryption.AddNL('              '+lang.GetTextOrDefault('endb' (* '[����� �������������� ����� ' *) ), 0, 0);
          rvDescryption.AddNL(inttostr(i)+'/'+end_block, 1, -1);
          rvDescryption.AddNL(']', 0, -1);
          //PrintFuncsParams('Item'+PacketName);
        end;
      end;
  end;
//=======================================================================
  procedure TfPacketView.fFor();
  var
    i, j :integer;
  begin
      //�������������
      addToDescr(offset, typ, name_, value+hexvalue);
      tmp_param:=param1;
      tmp_value:=value;
      ii:=PosInIni;
      if value='range error' then exit;
      if StrToInt(value)=0 then
      begin
        //���������� ������ ��������
        for i:=1 to StrToInt(param1) do
        begin
      //��� �� ��� ���������
      // if (PosInIni<Length(StrIni))and(PosInPkt<sizze+10)

          Param0:=GetType(StrIni, PosInIni);
          inc(PosInIni);
        end;
      end else begin
        //rvDescryption.AddNL('Mask : ', 0, 0);
        //rvDescryption.AddNL(blockmask, 4, -1);
        //blockmask := '';
        for i:=1 to StrToInt(tmp_value) do
        begin
          rvDescryption.AddNL('              '+lang.GetTextOrDefault('startb' (* '[������ �������������� ����� ' *) ), 0, 0);
          rvDescryption.AddNL(inttostr(i)+'/'+tmp_value, 1, -1);
          rvDescryption.AddNL(']', 0, -1);
          PosInIni:=ii;
          for j:=1 to StrToInt(tmp_param) do
          begin
            fParse();
            //����� ����� ���� SWITCH
            if Func='LOOP' then  fLoop()
            else
            if Func='FOR' then  fFor()
            else
            if Func='SWITCH' then  fSwitch()
            else
            if Func='GET' then  fGet() //get(param1, id, value);
            //�������������
            else addToDescr(offset, typ, name_, value+hexvalue);
          end;
          rvDescryption.AddNL('              '+lang.GetTextOrDefault('endb' (* '[����� �������������� ����� ' *) ), 0, 0);
          rvDescryption.AddNL(inttostr(i)+'/'+tmp_value, 1, -1);
          rvDescryption.AddNL(']', 0, -1);
        end;
      end;
  end;
//******************************************************************************
//******************************************************************************
//******************************************************************************
 //=======================================================================
procedure TfPacketView.fParseJ();
begin
  offset:=PosinPkt-11;
  oldpos := PosInPkt;
  //��������� �������� �� ������, �������� ��������� � ������������ � ����� ��������
  value:=GetValue(typ, name_, PktStr, PosInPkt);
//���������� �������
  if AllowedName(name_) then
  begin
    FuncParamNames.Add(name_);
    FuncParamTypes.Add(typ);
    FuncParamNumbers.Add(inttostr(length(blockmask)));
  end;
  blockmask := blockmask + typ;
  if PosInPkt - oldpos > 0 then
    addtoHex(StringToHex(copy(pktstr, oldpos, PosInPkt - oldpos),' '));
end;
//=======================================================================
procedure TfPacketView.InterpretJava(PacketJava : TJavaParser; SkipID: boolean; PktStr: string; var PosInPkt: integer; var typ, name_, value, hexvalue: string; size: word);
var
  strIndex, tmp : integer;
  brkLeft, brkRigth, count, index, depth : integer;
//  text: string;
  i: integer;
  isFind, isEnd: boolean;
  s, ss: string;
begin
  PacketJava.fFindProc();    //���� ��������� � ��������� �������
  isFind:=false;
  isEnd:=false;
  strIndex:=PacketJava.GetStrIndex;
  brkLeft:=0;
  brkRigth:=0;
  count:=0;
  index:=0;
  depth:=0; //������� FOR, Switch, IF
  s:='body=0';
  //���������� �� ����
  PacketJava.fPush(brkLeft, brkRigth, count, index);
  PacketJava.fPush1(s);
  //������� ���� ����������
  while (PacketJava.GetStrIndex < PacketJava.Count) and (PosInPkt<size+11) do
  begin
    strIndex:=PacketJava.GetStrIndex;
//    text:=PacketJava.GetString(PacketJava.GetStrIndex);
    PacketJava.ParseString;
    if PacketJava.CountToken()>0 then
    begin
      s:=PacketJava.GetString(strIndex);
      //������������ byte[]
      if PacketJava.FindToken('byte') <> -1 then
        PacketJava.fByte()
      else
      //������������ ���������� � �������
      if (Pos('=',s)>0) then
      begin
        PacketJava.fMove();
      end else
      //���� ����� ��� ����������� ����������� ������
      if (PacketJava.FindToken('writeimpl') <> -1) OR
         (PacketJava.FindToken('readimpl') <> -1) then
      begin
        s:='impl=0';
        //���������� �� ����
        PacketJava.fPush(brkLeft, brkRigth, count, index);
        PacketJava.fPush1(s);
        while (PacketJava.GetStrIndex < PacketJava.Count) and (not isEnd) do // and (PosInPkt<size+10) do
        begin
          s:=PacketJava.GetString(strIndex);
          brkLeft:=0;
          brkRigth:=0;
          count:=0;
          index:=0;
          depth:=0; //������� FOR, Switch, IF
          if PacketJava.CountToken()>0 then
          begin
            typ:='';
            tmp:=PosInPkt;
            //������������ runImpl - �����
            if PacketJava.FindToken('runimpl') <> -1 then
                isEnd:=true
            else
            //������������ byte[]
            if PacketJava.FindToken('byte') <> -1 then
              PacketJava.fByte()
            else

            //==============================================================
            //������������ WRITE
            if (Pos('write', s)>0) then
            begin
              //WRITEQ
              if PacketJava.FindToken('writeq') <> -1 then
              begin
                typ:='q';
                PacketJava.fWriteD(PktStr, PosInPkt, typ, name_, value, hexvalue);
              end else
              //WRITED
              if PacketJava.FindToken('writed') <> -1 then
              begin
                typ:='d';
                PacketJava.fWriteD(PktStr, PosInPkt, typ, name_, value, hexvalue);
              end else
              //WRITEH
              if PacketJava.FindToken('writeh') <> -1 then
              begin
                typ:='h';
                PacketJava.fWriteD(PktStr, PosInPkt, typ, name_, value, hexvalue);
              end else
              //WRITED
              if PacketJava.FindToken('writes') <> -1 then
              begin
                typ:='s';
                PacketJava.fWriteD(PktStr, PosInPkt, typ, name_, value, hexvalue);
              end else
              //WRITEC
              if PacketJava.FindToken('writec') <> -1 then
              begin
                //��������� WriteC
                if SkipID then
                begin
                  SkipID:=false;
                end
                else
                begin
                  typ:='c';
                  PacketJava.fWriteD(PktStr, PosInPkt, typ, name_, value, hexvalue);
                end;
              end else
              //WRITEB
              if PacketJava.FindToken('writeb') <> -1 then
              begin
                typ:='-';
                PacketJava.fWriteB(PktStr, PosInPkt, typ, name_, value, hexvalue);
              end else
              //WRITEF
              if PacketJava.FindToken('writef') <> -1 then
              begin
                if ((GlobalProtocolVersion<CHRONICLE4))then // ��� ����
                  typ:='n'
                else
                  typ:='f';
                PacketJava.fWriteD(PktStr, PosInPkt, typ, name_, value, hexvalue);
              end;
//            end;
            end else

            //==============================================================
            //������������ READ
            if (Pos('read', s)>0) then
            begin
              //READQ
              if PacketJava.FindToken('readq') <> -1 then
              begin
                typ:='q';
                PacketJava.fReadD(PktStr, PosInPkt, typ, name_, value, hexvalue);
              end else
              //READD
              if PacketJava.FindToken('readd') <> -1 then
              begin
                typ:='d';
                PacketJava.fReadD(PktStr, PosInPkt, typ, name_, value, hexvalue);
              end else
              //READH
              if PacketJava.FindToken('readh') <> -1 then
              begin
                typ:='h';
                PacketJava.fReadD(PktStr, PosInPkt, typ, name_, value, hexvalue);
              end else
              //READC
              if PacketJava.FindToken('readc') <> -1 then
              begin
                typ:='c';
                PacketJava.fReadD(PktStr, PosInPkt, typ, name_, value, hexvalue);
              end else
              //READS
              if PacketJava.FindToken('reads') <> -1 then
              begin
                typ:='s';
                PacketJava.fReadD(PktStr, PosInPkt, typ, name_, value, hexvalue);
              end else
              //READB
              if PacketJava.FindToken('readb') <> -1 then
              begin
                typ:='-';
                PacketJava.fReadB(PktStr, PosInPkt, typ, name_, value, hexvalue);
              end else
              //READF
              if PacketJava.FindToken('readf') <> -1 then
              begin
                if ((GlobalProtocolVersion<CHRONICLE4))then // ��� ����
                  typ:='n'
                else
                  typ:='f';
                PacketJava.fReadD(PktStr, PosInPkt, typ, name_, value, hexvalue);
              end;
//            end;
            end else
//-->
            //IF
            if PacketJava.FindToken('if') <> -1 then
            begin
              brkLeft:=PacketJava.GetStrIndex; //������ ����
              brkRigth:=brkLeft;           //����� ����
              if PacketJava.fIf(brkLeft, brkRigth, count) then   //��� �� ���� ������
              begin
                PacketJava.SetStrIndex(brkLeft); //������ � ������
                strIndex:=PacketJava.GetStrIndex;
//                text:=PacketJava.GetString(strIndex);
                //������ IF
                inc(depth);
                s:='if='+inttostr(depth);
                //���������� �� ����
                PacketJava.fPush(brkLeft, brkRigth, count, index);
                PacketJava.fPush1(s);
              end
              else //������ �� ������
              begin
                PacketJava.SetStrIndex(brkRigth); //����������
                strIndex:=PacketJava.GetStrIndex;
//                text:=PacketJava.GetString(strIndex);
              end;
            end else
//-->
            //���� ����� ����� ELSE, �� ���������� ��� �����
            if PacketJava.FindToken('else') <> -1 then
            begin
              brkLeft:=PacketJava.GetStrIndex; //������ ����
              brkRigth:=brkLeft;           //����� ����
//              isIf:=PacketJava.fElse(brkLeft, brkRigth, count);
              PacketJava.SetStrIndex(brkRigth); //����������
              strIndex:=PacketJava.GetStrIndex;
//              text:=PacketJava.GetString(strIndex);
            end else
//-->
            //SWITCH
            if PacketJava.FindToken('switch') <> -1 then
            begin
              brkLeft:=PacketJava.GetStrIndex; //������ ����
              brkRigth:=brkLeft;           //����� ����
              PacketJava.fSwitch(brkLeft, brkRigth, count);
              PacketJava.SetStrIndex(brkLeft); //������ � ������
              strIndex:=PacketJava.GetStrIndex;
//              text:=PacketJava.GetString(strIndex);
              //������ switch
              inc(depth);
              s:='switch='+inttostr(depth);
              //���������� �� ����
              PacketJava.fPush(brkLeft, brkRigth, count, index);
              PacketJava.fPush1(s);
            end else
            //CASE
            if PacketJava.FindToken('case') <> -1 then
            begin
              //����� �� �����
              PacketJava.fPop1(s);
              PacketJava.fPop(brkLeft, brkRigth, count, index);
              PacketJava.fCase(brkLeft, brkRigth, count);
              //���������� �� ����
              PacketJava.fPush(brkLeft, brkRigth, count, index);
              PacketJava.fPush1(s);
            end else
            //break
            if PacketJava.FindToken('break') <> -1 then
            begin
              //����� �� �����
              PacketJava.fPop1(s);
              PacketJava.fPop(brkLeft, brkRigth, count, index);
              PacketJava.SetStrIndex(brkRigth); //� ����� switch
            end else
//-->
            //FOR
            if PacketJava.FindToken('for') <> -1 then
            begin
              brkLeft:=PacketJava.GetStrIndex; //������ ����
              brkRigth:=brkLeft;           //����� ����
              PacketJava.fFor(brkLeft, brkRigth, count);
              //mask
              if count>32767 then
//                count:=(count XOR $FFFF)+1;
                count:=(-1*count) AND $FFFF;

              if (count>0) and (not PacketJava.fEmptyFor(brkLeft, brkRigth)) then
              begin
                PacketJava.SetStrIndex(brkLeft); //������ ���� � ������
                //������ �����
                inc(depth);
                s:='for='+inttostr(depth);
                index:=1;
                //���������� �� ����
                PacketJava.fPush(brkLeft, brkRigth, count, index);
                PacketJava.fPush1(s);

                rvDescryption.AddNL('              '+lang.GetTextOrDefault('startb' (* '[������ �������������� ����� ' *) ), 0, 0);
                rvDescryption.AddNL(inttostr(index)+'/'+inttostr(count), 1, -1);
                rvDescryption.AddNL(']', 0, -1);
              end;
              strIndex:=PacketJava.GetStrIndex;
//              text:=PacketJava.GetString(strIndex);
              //����� ��������� ����� �����
              //PacketJava.ClearKeywords; //��������
            end else
            //{
            if PacketJava.FindToken('{') <> -1 then
            begin
              //����� �� �����
              PacketJava.fPop1(s);
              //����� �� �����
              PacketJava.fPop(brkLeft, brkRigth, count, index);
//              if (Pos('for',s)>0) then
//              begin
//                rvDescryption.AddNL('              '+lang.GetTextOrDefault('startb' (* '[������ �������������� ����� ' *) ), 0, 0);
//                rvDescryption.AddNL(inttostr(index)+'/'+inttostr(count), 1, -1);
//                rvDescryption.AddNL(']', 0, -1);
//              end;
///              if (Pos('if',s)>0) then
///              if (Pos('switch', s)>0) then
              //���������� �� ����
              PacketJava.fPush(brkLeft, brkRigth, count, index);
              PacketJava.fPush1(s);
            end else
            //}
            if PacketJava.FindToken('}') <> -1 then
            begin
              //����� �� �����
              PacketJava.fPop1(s);
              i:=Pos('=',s)+1;
              ss:=copy(s,i,length(s)-Pos('=',s));
              depth:=strtoint(ss);
              //����� �� �����
              PacketJava.fPop(brkLeft, brkRigth, count, index);
              //============
              //FOR
              if (Pos('for',s)>0) then
              begin
                rvDescryption.AddNL('              '+lang.GetTextOrDefault('endb' (* '[����� �������������� ����� ' *) ), 0, 0);
                rvDescryption.AddNL(inttostr(index)+'/'+inttostr(count), 1, -1);
                rvDescryption.AddNL(']', 0, -1);
                if index<count then
                begin
                  inc(index); //:=index+1;
                  PacketJava.SetStrIndex(brkLeft); //������ ���� � ������

                  rvDescryption.AddNL('              '+lang.GetTextOrDefault('startb' (* '[������ �������������� ����� ' *) ), 0, 0);
                  rvDescryption.AddNL(inttostr(index)+'/'+inttostr(count), 1, -1);
                  rvDescryption.AddNL(']', 0, -1);

                end else
                  dec(depth);
                s:='for='+inttostr(depth);
                if depth>0 then
                begin
                  //���������� �� ����
                  PacketJava.fPush(brkLeft, brkRigth, count, index);
                  PacketJava.fPush1(s);
                end;
              end else
              //============
              //IF
              if (Pos('if',s)>0) then
              begin
                dec(depth);
                s:='if='+inttostr(depth);
                if depth>0 then
                begin
                  //���������� �� ����
                  PacketJava.fPush(brkLeft, brkRigth, count, index);
                  PacketJava.fPush1(s);
                end;
              end else
              //============
              //SWITCH
              if (Pos('switch',s)>0) then
              begin
                dec(depth);
                s:='switch='+inttostr(depth);
                if depth>0 then
                begin
                  //���������� �� ����
                  PacketJava.fPush(brkLeft, brkRigth, count, index);
                  PacketJava.fPush1(s);
                end;
              end else
              //============
              //Proc
              if (Pos('proc',s)>0) then
              begin
                PacketJava.SetStrIndex(brkRigth); //RETURN
              end;
            end else
            begin
//-->
              //�������� �� ���������
              brkLeft:=PacketJava.GetStrIndex; //������ ����
              brkRigth:=brkLeft;           //����� ����
              isFind:=PacketJava.fProcExec(brkLeft, brkRigth);
              if isFind then   //��� �� ���� ������
              begin
                PacketJava.SetStrIndex(brkLeft); //������ � ������
                strIndex:=PacketJava.GetStrIndex;
//                text:=PacketJava.GetString(strIndex);
                s:='proc=0';
                //���������� �� ����
                PacketJava.fPush(brkLeft, brkRigth, count, index);
                PacketJava.fPush1(s);
              end;
//-->
              //������� ����������
              s:=PacketJava.GetString(strIndex);
              if (Pos('=',s)>0) then
              begin
                PacketJava.fMove();
              end;
            end;
//-->
            if typ<>'' then
            begin
//              if (tmp>size+10) then //�������� �� ����� �� ����� ������
//              begin
//                PosInPkt:=size; //�������� �� ����� ������ � �� �����
//                fParseJ();
//                isEnd:=true;
//                PosInPkt:=tmp;
//              end else
              begin
                PosInPkt:=tmp; //�������� � ������� �������
                fParseJ();
              end;
              //����� �������� Get.ItemID  � �.�. value:=GetSkill(strtoint(value))
              //...
              if (PacketJava.FindToken('skillid') <> -1)
                  OR (PacketJava.FindToken('spellid') <> -1)
                  then
              begin
                if ((GlobalProtocolVersion<CHRONICLE4))then // ��� ����
                  value:=GetSkillAion(strtoint(value))
                else
                  value:=GetSkill(strtoint(value));
              end else
              if (PacketJava.FindToken('msgid') <> -1)
                  OR (PacketJava.FindToken('messageid') <> -1)
                  then
              begin
                if ((GlobalProtocolVersion<CHRONICLE4))then // ��� ����
                begin
                  s:=GetMsgIDA(strtoint(value));
                  if (Pos('Unkn', s)>0) then
                    s:=GetFuncStrAion(strtoint(value));
                  value:=s;
                end
                else
                  value:=GetMsgID(strtoint(value));
              end else
              if (PacketJava.FindToken('classid') <> -1)
                  OR (PacketJava.FindToken('racesex') <> -1)
                  OR (PacketJava.FindToken('mapid') <> -1)
                  then
              begin
                if ((GlobalProtocolVersion<CHRONICLE4))then // ��� ����
                  value:=GetClassIDAion(strtoint(value))
                else
                  value:=GetClassID(strtoint(value));
              end else
              if (PacketJava.FindToken('templateid') <> -1)
                  OR (PacketJava.FindToken('recipeid') <> -1)
                  OR (PacketJava.FindToken('itemid') <> -1)
                  then
              begin
                if ((GlobalProtocolVersion<CHRONICLE4))then // ��� ����
                  value:=GetFunc01Aion(strtoint(value))
                else
                  value:=GetFunc01(strtoint(value));
              end else
              if (PacketJava.FindToken('npcid') <> -1)
                  //OR (PacketJava.FindToken('_npcid') <> -1)
                  then
              begin
                if ((GlobalProtocolVersion<CHRONICLE4))then // ��� ����
                  //value:=GetNpcIDA(strtoint(value))
                else
                  value:=GetNpcID(strtoint(value))
              end else
              if (PacketJava.FindToken('actionid') <> -1)
                  //OR (PacketJava.FindToken('actionid') <> -1)
                  //OR (PacketJava.FindToken('getactionid') <> -1)
                  then
              begin
                if ((GlobalProtocolVersion<CHRONICLE4))then // ��� ����
                  //value:=GetF9(strtoint(value))
                else
                  value:=GetF9(strtoint(value))
              end else
              if (PacketJava.FindToken('attrid') <> -1)
                  //OR (PacketJava.FindToken('_attrid') <> -1)
                  //OR (PacketJava.FindToken('getattrid') <> -1)
                  then
              begin
                if ((GlobalProtocolVersion<CHRONICLE4))then // ��� ����
                  //value:=GetFsup(strtoint(value))
                else
                  value:=GetFsup(strtoint(value))
              end;
              //
//              if (PosInPkt<size+10) then
                addToDescr(offset, typ, name_, value+hexvalue);
            end;
          end;
          strIndex:=PacketJava.GetStrIndex;
          text:=PacketJava.GetString(PacketJava.GetStrIndex);
          PacketJava.ParseString;
          if (PosInPkt>size+11) then
            isEnd:=true;
        end;
      end;
    end;
  end;
end;
//=======================================================================
procedure TfPacketView.InterpretatorJava(PacketName, Packet: string; size: word = 0);
var
  PacketJava : TJavaParser;
  FromServer, SkipID: boolean;
begin
  //��������� packets.ini
  //�� opcode ������� PacketName
  PacketJava := TJavaParser.Create;

  FuncParamNames := TStringList.Create;
  FuncParamTypes := TStringList.Create;
  FuncParamNumbers := TStringList.Create;
  FuncNames := TStringList.Create;
  SkipId:=false; //ID �� ����������
  try
    //������ ������
    PktStr := HexToString(Packet);
    if Length(PktStr)<12 then Exit;
    FromServer:=(PktStr[1] = #03);

    Move(PktStr[2],ptime,8);
    if size = 0 then
      Size:=Word(Byte(PktStr[11]) shl 8)+Byte(PktStr[10])
    else
      ptime := now;
    //������ ������� �� ������� ��������
    wSize:=size;
    if (GlobalProtocolVersion=AION)then // ��� ���� 2.1 - 2.6
    begin
      cID:=Byte(PktStr[12]); //����������� ������ ������, ID
      wSubID:=0;   //�� ���������
      wSub2ID:=0;   //�� ���������
    end
    else
    if (GlobalProtocolVersion=AION27)then // ��� ���� 2.7 ����������� ID
    begin
      cID:=Byte(PktStr[12]);                    //� cID - ID ������ ��� ����������� ID
      wSubID:=Word(Byte(PktStr[13]) shl 8 + cID); //� wSubId - ID ������ ��� ����������� ID
      wSub2ID:=0;   //�� ���������
    end
    else //��� Lineage II
    begin
      if wSize=3 then
      begin
        cID:=Byte(PktStr[12]); //����������� ������ ������, ID
        wSubID:=0;    //����� ����������, ����� � subid 0
        wSub2ID:=0;   //�� ���������
      end
      else
      begin
        if FromServer {PktStr[1]=#04} then
        begin      //client  04,
          cID:=Byte(PktStr[13]); //��������� ���� ������� ID � wSub2ID
          wSub2ID:=Word(cID shl 8+Byte(PktStr[14]));
          cID:=Byte(PktStr[12]); //����������� ������ ������, ID
          wSubID:=Word(cID shl 8+Byte(PktStr[13])); //��������� ���� ������� ID � wSubID
        end
        else  //������  03, ��������� ���� � ������� ������� ID
        begin
          cID:=Byte(PktStr[12]); //����������� ������ ������, ID
          if wSize=3 then
          begin
              wSubID:=0;    //����� ����������, ����� � subid 0
              wSub2ID:=0;    //����� ����������, ����� � subid 0
          end
          else
          begin
            cID:=Byte(PktStr[14]); //����������� ������ SUB2ID
            wSub2ID:=Word(cID shl 8+Byte(PktStr[15])); //��������� Sub2Id
            cID:=Byte(PktStr[12]);                   //����������� ������ ������, ID
            wSubID:=Word(cID shl 8+Byte(PktStr[13])); //��������� SubId
          end;
        end;
      end;
    end;

    currentpacket := StringToHex(copy(PktStr, 12, length(PktStr)-11),' ');

    rvHEX.Clear;
    rvDescryption.Clear;
    rvFuncs.Clear;

    GetPacketName(cID, wSubID, wSub2ID, (PktStr[1]=#03), PacketName, isshow);
    //��������� �������� ������
    if (GlobalProtocolVersion=AION) then // ��� ���� 2.1 - 2.6
    begin
      if PktStr[1]=#03 then //server
        PacketJava.LoadFromFile(AppPath+'settings\packets.ini\aion21\serverpackets\'+LowerCase(PacketName)+'.java')
      else    //client
        PacketJava.LoadFromFile(AppPath+'settings\packets.ini\aion21\clientpackets\'+LowerCase(PacketName)+'.java');
    end else
    if (GlobalProtocolVersion=AION27) then // ��� ���� 2.7
    begin
      if PktStr[1]=#03 then //server
        PacketJava.LoadFromFile(AppPath+'settings\packets.ini\aion27\serverpackets\'+LowerCase(PacketName)+'.java')
      else    //client
        PacketJava.LoadFromFile(AppPath+'settings\packets.ini\aion27\clientpackets\'+LowerCase(PacketName)+'.java');
    end else
    if (GlobalProtocolVersion>Aion27) AND  (GlobalProtocolVersion<interlude) then // ��� C4, C5
    begin
      if PktStr[1]=#03 then   //server
        PacketJava.LoadFromFile(AppPath+'.\settings\packets.ini\c4\serverpackets\'+LowerCase(PacketName)+'.java')
      else   //client
        PacketJava.LoadFromFile(AppPath+'.\settings\packets.ini\c4\clientpackets\'+LowerCase(PacketName)+'.java');
    end else
    if (GlobalProtocolVersion=interlude) then // ��� Interlude
    begin
      if PktStr[1]=#03 then   //server
        PacketJava.LoadFromFile(AppPath+'.\settings\packets.ini\interlude\serverpackets\'+LowerCase(PacketName)+'.java')
      else   //client
        PacketJava.LoadFromFile(AppPath+'.\settings\packets.ini\interlude\clientpackets\'+LowerCase(PacketName)+'.java');
    end else
    if (GlobalProtocolVersion=Gracia) then // ��� Gracia
    begin
      if PktStr[1]=#03 then   //server
        PacketJava.LoadFromFile(AppPath+'.\settings\packets.ini\gracia\serverpackets\'+LowerCase(PacketName)+'.java')
      else   //client
        PacketJava.LoadFromFile(AppPath+'.\settings\packets.ini\gracia\clientpackets\'+LowerCase(PacketName)+'.java');
    end else
    if (GlobalProtocolVersion=GraciaFinal) then // ��� GraciaFinal
    begin
      if PktStr[1]=#03 then   //server
        PacketJava.LoadFromFile(AppPath+'.\settings\packets.ini\graciafinal\serverpackets\'+LowerCase(PacketName)+'.java')
      else   //client
        PacketJava.LoadFromFile(AppPath+'.\settings\packets.ini\graciafinal\clientpackets\'+LowerCase(PacketName)+'.java');
    end else
    if (GlobalProtocolVersion=GraciaEpilogue) then // ��� GraciaEpilogue
    begin
      if PktStr[1]=#03 then   //server
        PacketJava.LoadFromFile(AppPath+'.\settings\packets.ini\graciaepilogue\serverpackets\'+LowerCase(PacketName)+'.java')
      else   //client
        PacketJava.LoadFromFile(AppPath+'.\settings\packets.ini\graciaepilogue\clientpackets\'+LowerCase(PacketName)+'.java');
    end else
    if (GlobalProtocolVersion=HighFive) then // ��� HighFive
    begin
      if PktStr[1]=#03 then   //server
        PacketJava.LoadFromFile(AppPath+'.\settings\packets.ini\HighFive\serverpackets\'+LowerCase(PacketName)+'.java')
      else   //client
        PacketJava.LoadFromFile(AppPath+'.\settings\packets.ini\HighFive\clientpackets\'+LowerCase(PacketName)+'.java');
    end else
    if (GlobalProtocolVersion=GoD) then // ��� GoD
    begin
      if PktStr[1]=#03 then   //server
        PacketJava.LoadFromFile(AppPath+'.\settings\packets.ini\god\serverpackets\'+LowerCase(PacketName)+'.java')
      else   //client
        PacketJava.LoadFromFile(AppPath+'.\settings\packets.ini\god\clientpackets\'+LowerCase(PacketName)+'.java');
    end;

    Label1.Caption:=lang.GetTextOrDefault('IDS_109' (* '���������� �����: ��� - 0x' *) )+IntToHex(cID, 2)+', '+PacketName+lang.GetTextOrDefault('size' (* ', ������ - ' *) )+IntToStr(wSize);
    //�������� � pkt
    PosInPkt:=13;
    //�������� ��������� ����� �� ��������� � packets.ini �������
    //��������� ���
    rvDescryption.AddNL(lang.GetTextOrDefault('IDS_121' (* 'T��: ' *) ), 11, 0);
    if ((GlobalProtocolVersion=AION27) and (wSubId<>0))then // ��� ���� 2.7 ����������� ID
      rvDescryption.AddNLTag('0x'+IntToHex(wSubId, 4), 0, -1, 1)
    else
      rvDescryption.AddNLTag('0x'+IntToHex(cID, 2), 0, -1, 1);
    rvDescryption.AddNL(' (', 0, -1);
    rvDescryption.AddNL(PacketName, 1, -1);
    rvDescryption.AddNL(')', 0, -1);
    //��������� ������ � �����
    rvDescryption.AddNL(lang.GetTextOrDefault('size2' (* 'P�����: ' *) ), 0, 0);
    rvDescryption.AddNL(IntToStr(wSize-2), 1, -1);
    rvDescryption.AddNL('+2', 2, -1);

    rvDescryption.AddNL(lang.GetTextOrDefault('IDS_126' (* '����� �������: ' *) ), 0, 0);
    rvDescryption.AddNL(FormatDateTime('hh:nn:ss:zzz',ptime), 1, -1);

    itemTag := 0;
    templateindex := 11;
    if ((GlobalProtocolVersion=AION27) and (wSubId<>0))then // ��� ���� 2.7 ����������� ID
    begin
      addtoHex(StringToHex(copy(pktstr, 12, 2),' '));
      inc(PosInPkt);
    end
    else
      addtoHex(StringToHex(copy(pktstr, 12, 1),' '));
    itemTag := 1;

    //PktStr - �����
    //PosInPkt - �������� � ������
    try
      blockmask := '';
      //� ����� �� ���� ������� ���� h(id2), �������� � ���������� ���, ������� ������� ��� ����
//      if ((GlobalProtocolVersion<CHRONICLE4))then // ��� ����
      if (GlobalProtocolVersion<CHRONICLE4) then // ��� ���� � ����������� ID
      begin
        if (wSubID=0) then // ��� ���� � ����������� ID
        begin
          typ:='h';
          name_:='id2';
          fParseJ();  //�������� HEX ������
          addToDescr(offset, typ, name_, value+hexvalue); //��������� �����������
          typ:='';
          name_:='';
        end
        else // ����������� ID
        begin
          typ:='c';
          name_:='static';
          fParseJ();  //�������� HEX ������
          addToDescr(offset, typ, name_, value+hexvalue); //��������� �����������
          typ:='h';
          name_:='id2';
          fParseJ();  //�������� HEX ������
          addToDescr(offset, typ, name_, value+hexvalue); //��������� �����������
          typ:='';
          name_:='';
        end;
      end;
      //LineageII � ��������� ������� � ��������� ���� �������� �� c(ID) ��� ���� ������������
      if (GlobalProtocolVersion>Aion27) and FromServer then // ��� LineageII
      begin
        //�������� � pkt
        SkipID:=true;
      end;
//-->>
      InterpretJava(PacketJava, SkipID, PktStr, PosInPkt, typ, name_, value, hexvalue, size);
//-->>
      oldpos := PosInPkt;
      PosInPkt := wSize + 10;
      if PosInPkt - oldpos > 0 then    //������������ ������� �� ������������ ����
        addtoHex(StringToHex(copy(pktstr, oldpos, PosInPkt - oldpos),' '));

      if blockmask <> '' then
        PrintFuncsParams('Pck'+PacketName);

      rvHEX.FormatTail;
      rvFuncs.FormatTail;
      rvDescryption.FormatTail;
    except
        //������ ��� ����������� ������
    end;
  finally
    FuncParamNames.Destroy;
    FuncParamTypes.Destroy;
    FuncParamNumbers.Destroy;
    FuncNames.Destroy;
    ////////////////////////////////////////////////////////
    PacketJava.Destroy;
  end;
end;
//******************************************************************************
//******************************************************************************
//=======================================================================
procedure TfPacketView.ParsePacket(PacketName, Packet: string; size: word = 0);
begin
  FuncParamNames := TStringList.Create;
  FuncParamTypes := TStringList.Create;
  FuncParamNumbers := TStringList.Create;
  FuncNames := TStringList.Create;
  //HexViewOffset := GlobalSettings.HexViewOffset;
  try
    //������ ������, sid - ����� ������, cid - ����� ����������
    PktStr := HexToString(packet);
    if Length(PktStr)<12 then Exit;
    Move(PktStr[2],ptime,8);
    if size = 0 then
      Size:=Word(Byte(PktStr[11]) shl 8)+Byte(PktStr[10])
    else
      ptime := now;
    //������ ������� �� ������� ��������
    wSize:=size;
    if (GlobalProtocolVersion=AION)then // ��� ���� 2.1 - 2.6
    begin
      cID:=Byte(PktStr[12]); //����������� ������ ������, ID
      wSubID:=0;   //�� ���������
      wSub2ID:=0;   //�� ���������
    end
    else
    if (GlobalProtocolVersion=AION27)then // ��� ���� 2.7 ����������� ID
    begin
      cID:=Byte(PktStr[12]);                    //� cID - ID ������ ��� ����������� ID
      wSubID:=Word(Byte(PktStr[13]) shl 8 + cID); //� wSubId - ID ������ ��� ����������� ID
      wSub2ID:=0;   //�� ���������
    end
    else //��� Lineage II
    begin
      if wSize=3 then
      begin
        cID:=Byte(PktStr[12]); //����������� ������ ������, ID
        wSubID:=0;    //����� ����������, ����� � subid 0
        wSub2ID:=0;   //�� ���������
      end
      else
      begin
        if PktStr[1]=#04 then
        begin      //client  04,
          cID:=Byte(PktStr[13]); //��������� ���� ������� ID � wSub2ID
          wSub2ID:=Word(cID shl 8+Byte(PktStr[14]));
          cID:=Byte(PktStr[12]); //����������� ������ ������, ID
          wSubID:=Word(cID shl 8+Byte(PktStr[13])); //��������� ���� ������� ID � wSubID
        end
        else  //������  03, ��������� ���� � ������� ������� ID
        begin
          cID:=Byte(PktStr[12]); //����������� ������ ������, ID
          if wSize=3 then
          begin
              wSubID:=0;    //����� ����������, ����� � subid 0
              wSub2ID:=0;    //����� ����������, ����� � subid 0
          end
          else
          begin
            cID:=Byte(PktStr[14]); //����������� ������ SUB2ID
            wSub2ID:=Word(cID shl 8+Byte(PktStr[15])); //��������� Sub2Id
            cID:=Byte(PktStr[12]);                   //����������� ������ ������, ID
            wSubID:=Word(cID shl 8+Byte(PktStr[13])); //��������� SubId
          end;
        end;
      end;
    end;

    currentpacket := StringToHex(copy(PktStr, 12, length(PktStr)-11),' ');

    rvHEX.Clear;
    rvDescryption.Clear;
    rvFuncs.Clear;

    if PacketName = '' then
      GetPacketName(cID, wSubID, wSub2ID, (PktStr[1]=#03), PacketName, isshow);
    //��������� ������ �� packets.ini ��� ��������
    if PktStr[1]=#04 then
    begin
      //client  04
      if (GlobalProtocolVersion=AION)then // ��� ���� 2.1 - 2.6
      begin
        StrIni:=PacketsINI.ReadString('client', IntToHex(cID, 2), 'Unknown:');
      end
      else
      begin
        if (GlobalProtocolVersion=AION27)then // ��� ���� 2.7 ����������� ID
        begin
          //0081=cm_time_check:c(static)h(id2)d(nanoTime)
          //32=cm_group_response:h(id2)d(unk1)c(unk2)
          StrIni:=PacketsINI.ReadString('client', IntToHex(wSubId, 4), 'Unknown:');
          //���� �� ����� ����������� ID, ������ � ��� ID �����������
          if (StrIni = 'Unknown:') then
          begin
            StrIni:=PacketsINI.ReadString('client', IntToHex(cID, 2), 'Unknown:');   //���� � ������ �� �����, �� ��� ������ - Unknown:
            wSubId:=0;   //������, ��� ����������� ID
          end;
        end
        else
        begin
          if (GlobalProtocolVersion<GRACIA) then
          begin
            //������ ����� 39 ��� ������ C4-C5-Interlude
            if (cID in [$39, $D0]) and (wSize>3) then
              //C4, C5, T0
              StrIni:=PacketsINI.ReadString('client', IntToHex(wSubID, 4), 'Unknown:h(subID)')
            else
              StrIni:=PacketsINI.ReadString('client', IntToHex(cID, 2), 'Unknown:');
          end
          else
          begin
            //��� ������ Kamael - Hellbound - Gracia - Freya
           //client three ID packets: c(ID)h(sub2ID)
           if (cID=$D0) and (((wsub2id>=$5100) and (wsub2id<=$5105)) or (wsub2id=$5A00)) and (wSize>3) then
              StrIni:=PacketsINI.ReadString('server', IntToHex(cID, 2)+IntToHex(wSub2ID, 4), 'Unknown:c(ID)h(subID)')
            else
            begin
              if (cID=$D0) and (wSize>3) then
                StrIni:=PacketsINI.ReadString('client',IntToHex(wSubID, 4), 'Unknown:h(subID)')
              else
                StrIni:=PacketsINI.ReadString('client', IntToHex(cID, 2), 'Unknown:');
            end;
          end;
        end;
      end;
    end
    else
    begin
      //server  03
      if (GlobalProtocolVersion=AION)then // ��� ���� 2.1 - 2.6
      begin
        StrIni:=PacketsINI.ReadString('server', IntToHex(cID, 2), 'Unknown:');
      end
      else
      begin
        if (GlobalProtocolVersion=AION27)then // ��� ���� 2.7 ����������� ID
        begin
          //0081=cm_time_check:c(static)h(id2)d(nanoTime)
          //32=cm_group_response:h(id2)d(unk1)c(unk2)
          StrIni:=PacketsINI.ReadString('server', IntToHex(wSubId, 4), 'Unknown:');
          //���� �� ����� ����������� ID, ������ � ��� ID �����������
          if (StrIni = 'Unknown:') then
          begin
            StrIni:=PacketsINI.ReadString('server', IntToHex(cID, 2), 'Unknown:');   //���� � ������ �� �����, �� ��� ������ - Unknown:
            wSubId:=0;   //������, ��� ����������� ID
          end;
        end
        else
        begin
          //server four ID packets: c(ID)h(subID)h(sub2ID)
          if ((wsubid=$FE97) or (wsubid=$FE98) or (wsubid=$FEB7)) and (wSize>3) then
              StrIni:=PacketsINI.ReadString('server', IntToHex(wSubID, 4)+IntToHex(wSub2ID, 4), 'Unknown:h(subID)h(sub2ID)')
          else
          begin
            if (cID=$FE) and (wSize>3) then
              StrIni:=PacketsINI.ReadString('server', IntToHex(wSubID, 4), 'Unknown:h(subID)')
            else
              StrIni:=PacketsINI.ReadString('server', IntToHex(cID, 2), 'Unknown:');
          end;
        end;
      end;
    end;

    if ((GlobalProtocolVersion=AION27) and (wSubId<>0))then // ��� ���� 2.7 ����������� ID
      Label1.Caption:=lang.GetTextOrDefault('IDS_109' (* '���������� �����: ��� - 0x' *) )+IntToHex(wSubId, 4)+', '+PacketName+lang.GetTextOrDefault('size' (* ', ������ - ' *) )+IntToStr(wSize)
    else
      Label1.Caption:=lang.GetTextOrDefault('IDS_109' (* '���������� �����: ��� - 0x' *) )+IntToHex(cID, 2)+', '+PacketName+lang.GetTextOrDefault('size' (* ', ������ - ' *) )+IntToStr(wSize);
    //�������� ��������� ����� �� ��������� � packets.ini �������
    //�������� � ini
    PosInIni:=Pos(':',StrIni);
    //�������� � pkt
    PosInPkt:=13;
    Inc(PosInIni);
    //��������� ���
    rvDescryption.AddNL(lang.GetTextOrDefault('IDS_121' (* 'T��: ' *) ), 11, 0);
    if ((GlobalProtocolVersion=AION27) and (wSubId<>0))then // ��� ���� 2.7 ����������� ID
      rvDescryption.AddNLTag('0x'+IntToHex(wSubId, 4), 0, -1, 1)
    else
      rvDescryption.AddNLTag('0x'+IntToHex(cID, 2), 0, -1, 1);
    rvDescryption.AddNL(' (', 0, -1);
    rvDescryption.AddNL(PacketName, 1, -1);
    rvDescryption.AddNL(')', 0, -1);
    //��������� ������ � �����
    rvDescryption.AddNL(lang.GetTextOrDefault('size2' (* 'P�����: ' *) ), 0, 0);
    rvDescryption.AddNL(IntToStr(wSize-2), 1, -1);
    rvDescryption.AddNL('+2', 2, -1);

    rvDescryption.AddNL(lang.GetTextOrDefault('IDS_126' (* '����� �������: ' *) ), 0, 0);
    rvDescryption.AddNL(FormatDateTime('hh:nn:ss:zzz',ptime), 1, -1);

    itemTag := 0;
    templateindex := 11;

    if ((GlobalProtocolVersion=AION27) and (wSubId<>0))then // ��� ���� 2.7 ����������� ID
    begin
      addtoHex(StringToHex(copy(pktstr, 12, 2),' '));
      inc(PosInPkt);
    end
    else
      addtoHex(StringToHex(copy(pktstr, 12, 1),' '));

    itemTag := 1;

    //GetType - ���������� ������� ���� d(Count:For.0001) �� packets.ini
    //StrIni - ������� �� packets.ini �� ID �� ������
    //PktStr - �����
    //Param0 - ������ d(Count:For.0001)
    //PosInIni - �������� � ������� �� packets.ini �� ID �� ������
    //PosInPkt - �������� � ������
    try
      blockmask := '';
      while (PosInIni>1)and(PosInIni<Length(StrIni))and(PosInPkt<wSize+10) do
      begin
        fParse();
        if Func='GET' then fGet()
        else
        //��� �4, �5 � �0-����������
        if Func='FOR' then fFor()
        else
        //��� �1 - �������-��������-������
        (*� ������� LOOP ������ �������� ����� ���� ������ 1,
        ������ ��� ������ �������, � ���������
        � ����� �� �������� 2*)
        if (Func='LOOP') {and (StrToInt(value)>0)} then fLoop()
        else
        if (Func='LOOPM') {and (StrToInt(value)>0)} then fLoopM()
        else
        //========================================================================
        //��� ������, ����� � AION
        (*� ������� SWITCH ������ �������� ����� ���� ������ 0,
        ������ �������� ������ �������, � ���������
        � ����� �� �������� 2*)
        //d(id:switch.skip.count)
        // _(id:case.param1.param2)
        //d(number)
        // _(id:case.param1.param2)
        //d(number)
        if Func='SWITCH' then fSwitch()
        else
          //�������������
          addToDescr(offset, typ, name_, value+hexvalue);
      end;
    except
      //������ ��� ����������� ������
    end;
    oldpos := PosInPkt;
    PosInPkt := wSize + 10;
    if PosInPkt - oldpos > 0 then
      addtoHex(StringToHex(copy(pktstr, oldpos, PosInPkt - oldpos),' '));

    if blockmask <> '' then
      PrintFuncsParams('Pck'+PacketName);

    rvHEX.FormatTail;
    rvFuncs.FormatTail;
    rvDescryption.FormatTail;
  finally
    FuncParamNames.Destroy;
    FuncParamTypes.Destroy;
    FuncParamNumbers.Destroy;
    FuncNames.Destroy;
  end;
end;
//==============================================================================
procedure TfPacketView.rvHEXMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  rvHEX.SetFocusSilent;
end;

procedure TfPacketView.rvDescryptionMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  rvDescryption.SetFocusSilent;
end;

procedure TfPacketView.rvDescryptionRVMouseUp(Sender: TCustomRichView;
  Button: TMouseButton; Shift: TShiftState; ItemNo, X, Y: Integer);
begin
if ItemNo >= 0 then
  selectitemwithtag(rvDescryption.GetItemTag(ItemNo));
end;

procedure TfPacketView.selectitemwithtag(Itemtag: integer);
var
  i:integer;
begin
  i := 0;
  while (i < rvhex.ItemCount) do
    begin
      if rvHEX.GetItemStyle(i) >= 20 then
        dec(rvHEX.GetItem(i).StyleNo,10);

      inc(i);
    end;

  i := 0;
  while (i < rvDescryption.ItemCount) do
    begin
      if rvDescryption.GetItemStyle(i) >= 20 then
        dec(rvDescryption.GetItem(i).StyleNo,10);

      inc(i);
    end;

  if Itemtag < 1 then exit;
  i := 0;
  while (i < rvHEX.ItemCount) and (rvHEX.GetItemTag(i)<>ItemTag) do inc(i);
  if i < rvHEX.ItemCount then
  begin
    Inc(rvHEX.GetItem(i).StyleNo,10);
    rvHEX.Format;
  end;

  i := 0;
  while (i < rvDescryption.ItemCount) and (rvDescryption.GetItemTag(i)<>ItemTag) do inc(i);
  if i < rvDescryption.ItemCount then
  begin
    Inc(rvDescryption.GetItem(i).StyleNo,10);
    rvDescryption.Format;
  end;

end;

procedure TfPacketView.rvHEXRVMouseUp(Sender: TCustomRichView;
  Button: TMouseButton; Shift: TShiftState; ItemNo, X, Y: Integer);
begin
if ItemNo >= 0 then
  selectitemwithtag(rvHEX.GetItemTag(ItemNo));
end;

procedure TfPacketView.rvHEXSelect(Sender: TObject);
begin
  if rvHEX.SelectionExists then begin
    rvHEX.CopyDef;
    rvHEX.Deselect;
    rvHEX.Invalidate;
    rvHEX.SetFocus;
  end;
end;

procedure TfPacketView.rvDescryptionSelect(Sender: TObject);
begin
  if rvDescryption.SelectionExists then begin
    rvDescryption.CopyDef;
    rvDescryption.Deselect;
    rvDescryption.Invalidate;
    rvDescryption.SetFocus;
  end;
end;

Function TfPacketView.get(param1: string; id: byte; var value: string):boolean;
begin
  result := false;
  if StrToIntDef(value, 0) <> StrToIntDef(value, 1) then exit;
  if param1='FUNC01' then    value:=GetFunc01(strtoint(value)) else
  if param1='FUNC01A' then   value:=GetFunc01Aion(strtoint(value)) else
  if param1='FUNC02' then    value:=GetFunc02(strtoint(value)) else
  if param1='FUNC09' then    value:=GetFunc09(id, strtoint(value)) else
  if param1='CLASSID' then   value:=GetClassID(strtoint(value)) else
  if param1='CLASSIDA' then  value:=GetClassIDAion(strtoint(value)) else
  if param1='FSUP' then      value:=GetFsup(strtoint(value)) else
  if param1='NPCID' then     value:=GetNpcID(strtoint(value)) else
  if param1='MSGID' then     value:=GetMsgID(strtoint(value)) else
  if param1='MSGIDA' then    value:=GetMsgIDA(strtoint(value)) else
  if param1='SKILL' then     value:=GetSkill(strtoint(value)) else
  if param1='SKILLA' then    value:=GetSkillAion(strtoint(value)) else
  if param1='STRINGA' then   value:=GetFuncStrAion(strtoint(value)) else
  if param1='F0' then        value:=GetF0(strtoint(value)) else
  if param1='F1' then        value:=GetF1(strtoint(value)) else
  if param1='F3' then        value:=GetF3(strtoint(value)) else
  if param1='F9' then        value:=GetF9(strtoint(value)) else
  if param1='FSAY2' then     value:=GetFSay2(strtoint(value)) else
  if param1='AUGMENTID' then value:=GetAugment(strtoint(value));
  result := true;
end;

procedure TfPacketView.N1Click(Sender: TObject);
begin
  N1.Checked := not N1.Checked;
  rvDescryption.WordWrap := N1.Checked;
  rvDescryption.Format;
end;

procedure TfPacketView.N2Click(Sender: TObject);
begin
  N2.Checked := not n2.Checked;
  rvFuncs.Visible := n2.Checked;
  Splitter2.Visible := N2.Checked;
  //Splitter2.Top := 1;
end;

procedure TfPacketView.rvFuncsSelect(Sender: TObject);
begin
  if rvFuncs.SelectionExists then
  begin
    rvFuncs.CopyDef;
    rvFuncs.Deselect;
    rvFuncs.Invalidate;
    rvFuncs.SetFocus;
  end;
end;

end.

