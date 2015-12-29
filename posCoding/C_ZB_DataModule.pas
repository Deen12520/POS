unit C_ZB_DataModule;

interface

uses
  SysUtils, Classes, DB, ADODB, IniFiles,QDialogs, DBAccess,
  Uni, UniProvider, PostgreSQLUniProvider;

type
  TDM_ZB_Common = class(TDataModule)
    VG_ZB_ADOConnection: TUniConnection;
    PostgreSQLUniProvider1: TPostgreSQLUniProvider;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
     vl_str_key:string;
  public
    { Public declarations }
     vg_str_PosID:string;            //pos机号
     vg_str_CashierID:string;        //收银员ID
     vg_str_onworktime:TDateTime;    //上班时间
     PrintPort:string;  //打印机接口

     vg_str_CompanyName:string;     //  公司名称  (用于报表头打印或其它，从参数表取来）
     vg_str_DepartmentID:string;    //  门店编码
     
     vg_str_DepartmentName:string;  // 门店名称（用于报表头打印或其它，从参数表取来）
     vg_str_EmployeeId:string;      //     操作员编码
     vg_str_EmployeeName:string;
     vg_str_EmployeeRoleID:string;
     vg_str_CurrentWindow:string;   //  当前主窗口中显示的功能界面的编码
     vg_str_functions:string;       //  当前操作员能操作当前窗口的功能按钮集合，如"提交，审核"等
     vg_str_ZCDAuditedbyZB:string;         //  转仓单的审核是否由总部控制（1）或调入门店控制（0）;
                                    //  总部控制，则在菜单生成时出现，否则，禁止相应菜单生成
     vg_b_debug:boolean;            // 调试模式，1：开启，密码使用原始密码；0：关闭，密码使用加密密码
    { =========================================================================
      函数名             |  返回类型  |    参数表        |      功能简述
      *************************************************************************
      GetDBDatetime      Tdatetime      无               获取数据库当前时间
      WriteError           Boolean        ErrorStr:string  将错误写入日志
                                        错误描述字符串
      *************************************************************************}
     function GetDBDatetime():Tdatetime;
     function WriteError(ErrorStr:string):Boolean;
     procedure DisplayMsgInStatus(DisplayMsg:string);
     function EncryptString(Source:string): string;
     function UnEncryptString(Source:string): string;
     function SetupConnection():Boolean;    // 测试数据库连接情况，未连接在建立连接
                                            //  若无参数则配置数据库参数，连接建立后
                                            //  返回true、false
  end;

var
  DM_ZB_Common: TDM_ZB_Common;

implementation

uses C_ZB_DBConfig;

{$R *.dfm}

function TDM_ZB_Common.SetupConnection():Boolean;
var
  Myinifile:Tinifile;
  temp:string;
  flag:boolean;
  result_Val:integer;
begin
  flag:=true;
  if VG_ZB_ADOConnection.Connected  then
      SetupConnection:=true
  else
    begin
      Myinifile:=Tinifile.create('Store.ini');
      if   Myinifile=nil then
         begin
            showmessage('配置文件打开失败，请与管理员联系');
            SetupConnection:=false;
            exit;
         end
      else
        begin
          temp:=myinifile.ReadString('System','IP','');
          if temp<>'' then
               VG_ZB_ADOConnection.server:=UnEncryptString (temp)
          else flag:=false;
          temp:=myinifile.ReadString('System','Port','');
          if temp<>'' then
               VG_ZB_ADOConnection.Port :=strtoint(DM_ZB_common.UnEncryptString (temp))
          else flag:=false;
          temp:=myinifile.ReadString('System','DataBase','');
          if temp<>'' then
               VG_ZB_ADOConnection.Database :=DM_ZB_common.UnEncryptString (temp)
          else flag:=false;
          temp:=myinifile.ReadString('System','UserName','');
          if temp<>'' then
               VG_ZB_ADOConnection.UserName:=DM_ZB_common.UnEncryptString (temp)
          else flag:=false;
          temp:=myinifile.ReadString('System','password','');
          if temp<>'' then
               VG_ZB_ADOConnection.Password:=DM_ZB_common.UnEncryptString (temp)
          else flag:=false;
          VG_ZB_ADOConnection.providerName := 'postgresql';
          myinifile.Destroy;
          if flag then
             begin
                DM_ZB_Common.VG_ZB_ADOConnection.AutoCommit:=true;
                DM_ZB_Common.VG_ZB_ADOConnection.LoginPrompt :=false;
                DM_ZB_Common.VG_ZB_ADOConnection.Connect;
             end;
          if DM_ZB_Common.VG_ZB_ADOConnection.Connected=false then
          begin
              result_Val:=MessageDlg('不能连接数据库，是否重新配置数据库连接文件？',mtConfirmation, [mbYes, mbNo], 0);
              if  result_Val = 3  then
                 //W_ZB_DB_CFG.ShowModal
              begin
                    if W_ZB_DB_CFG=nil then W_ZB_DB_CFG:=TW_ZB_DB_CFG.Create(nil);
                    W_ZB_DB_CFG.ShowModal;
                    W_ZB_DB_CFG.Release ;
              end
              else
                begin
                  SetupConnection:=false;
                  exit;
                end;
           end;     
          if DM_ZB_Common.VG_ZB_ADOConnection.Connected then
               SetupConnection:=true
           else
             SetupConnection:=false;
        end;
     end;
end;
function TDM_ZB_Common.GetDBDatetime():Tdatetime;
begin
   GetDBDatetime:= now();
end;
function TDM_ZB_Common.WriteError(ErrorStr:string):Boolean;
begin
end;
procedure TDM_ZB_Common.DisplayMsgInStatus(DisplayMsg:string);
begin
   //W_zb_mainwindow.StatusBar1.Panels[2].Text := DisplayMsg;
end;

function TDM_ZB_Common.EncryptString(Source:string): string;
// 对字符串加密(Source:源 Key:密匙)
var
  Key:string;
  KeyLen: integer;
  KeyPos: integer;
  Offset: integer;
  Dest: string;
  SrcPos: integer;
  SrcAsc: integer;
  Range: integer;
begin
  if Source='' then
      begin
         EncryptString:='';
         exit;
      end;
  Key:=vl_str_key;
  KeyLen := Length(Key);
  if KeyLen = 0 then
      Key := 'delphi';
  KeyPos := 0;
  Range := 256;
  randomize;
  Offset := random(Range);
  Dest := format('%1.2x', [Offset]);
  for SrcPos := 1 to Length(Source) do
  begin
    SrcAsc := (Ord(Source[SrcPos]) + Offset) mod 255;
    if KeyPos < KeyLen then
      KeyPos := KeyPos + 1
    else
      KeyPos := 1;
    SrcAsc := SrcAsc xor Ord(Key[KeyPos]);
    Dest := Dest + format('%1.2x', [SrcAsc]);
    Offset := SrcAsc;
  end;
  result := Dest;
end;

function TDM_ZB_Common.UnEncryptString(Source:string): string;
// 对字符串解密(Src:源 Key:密匙)
var
  Key:string;
  KeyLen: integer;
  KeyPos: integer;
  Offset: integer;
  Dest: string;
  SrcPos: integer;
  SrcAsc: integer;
  TmpSrcAsc: integer;
begin
  if Source='' then
      begin
         UnEncryptString:='';
         exit;
      end;
  Key:=vl_str_key;
  KeyLen := Length(Key);
  if KeyLen = 0 then
      Key := 'delphi';
  KeyPos := 0;
  Offset := strtoint('$' + copy(Source, 1, 2));
  SrcPos := 3;
  repeat
    SrcAsc := strtoint('$' + copy(Source, SrcPos, 2));
    if KeyPos < KeyLen then
        KeyPos := KeyPos + 1
    else
        KeyPos := 1;
    TmpSrcAsc := SrcAsc xor Ord(Key[KeyPos]);
    if TmpSrcAsc <= Offset then
      TmpSrcAsc := 255 + TmpSrcAsc - Offset
    else
      TmpSrcAsc := TmpSrcAsc - Offset;
    Dest := Dest + chr(TmpSrcAsc);
    Offset := SrcAsc;
    SrcPos := SrcPos + 2;
  until SrcPos >= Length(Source);
  result := Dest;
end;

procedure TDM_ZB_Common.DataModuleCreate(Sender: TObject);
begin
  vl_str_key:='Delphi';
  vg_b_debug:=true;


  //给定POS机号、门店编号，测试
  vg_str_PosID:='01';;
  vg_str_DepartmentID:='1001';
  //vg_str_CashierID:='0001';
  vg_str_CompanyName:='HoLo连锁便利店';
  vg_str_onworktime:=Now();
  PrintPort:='lpt';
end;

end.
