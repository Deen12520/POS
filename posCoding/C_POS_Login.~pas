unit C_POS_Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DB, MemDS, DBAccess, Uni;

type
  TW_POS_LoginForm = class(TForm)
    pnl1: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    edt1: TEdit;
    edt2: TEdit;
    btnQD: TBitBtn;
    btnQX: TBitBtn;
    uniqueryP_login: TUniQuery;
    function jiemi(mima:string):string;
    procedure btnQDClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnQXClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    vl_input_count:integer;
  public
    { Public declarations }
   // loginStatus:boolean;
  end;

var
  W_POS_LoginForm: TW_POS_LoginForm;

implementation
uses C_ZB_DataModule;

{$R *.dfm}
function TW_POS_LoginForm.jiemi(mima:string):string;
begin
   if dm_zb_common.vg_b_debug =false then jiemi:=DM_ZB_COmmon.UnEncryptString(mima)
   else   jiemi:=mima;
end;


procedure TW_POS_LoginForm.btnQDClick(Sender: TObject);
var
  vl_sql:string;
  vl_pass:string;
begin
   //只有符合相应权限的才能登陆进去
   //uniqueryP_login.Connection:=DM_ZB_Common.VG_ZB_ADOConnection;

    vl_sql:='select * from t_cmp_employee'
     +' where employee_id='''+trim(edt1.Text)
     +''' and employee_status=''0'                    // employee_status=0 为任职状态
     +''' and role_id=''2''';                          //
    uniqueryP_login.SQL.Clear;
    uniqueryP_login.SQL.Add(vl_sql);
    uniqueryP_login.Open;
    if uniqueryP_login.eof then
    begin
       showmessage('用户ID不存在');
       vl_input_count:=vl_input_count+1;
       if vl_input_count>=3 then self.Close ;
       exit;
    end;
    uniqueryP_login.First ;
    vl_pass:=uniqueryP_login.FieldValues['employee_password'];

   if jiemi(vl_pass)<>trim(edt2.Text) then
   begin
       showmessage('密码错误!请重新输入');
       vl_input_count:=vl_input_count+1;
       if vl_input_count>=3 then self.Close ;
       exit;
   end;         
   // success login
  DM_ZB_Common.vg_str_CashierID:=uniqueryP_login.FieldValues['employee_id'];
   if uniqueryP_login.FieldByName('employee_name').IsNull then
     DM_ZB_Common.vg_str_EmployeeName:=''
  else
     DM_ZB_Common.vg_str_EmployeeName:=uniqueryP_login.FieldValues['employee_name'];
  if uniqueryP_login.FieldByName('dept_id').IsNull then
     DM_ZB_Common.vg_str_DepartmentID:=''
  else
     DM_ZB_Common.vg_str_DepartmentID:=uniqueryP_login.FieldValues['dept_id'];
  if uniqueryP_login.FieldByName('role_id').IsNull then
     DM_ZB_Common.vg_str_EmployeeRoleID:=''
  else
     DM_ZB_Common.vg_str_EmployeeRoleID:=uniqueryP_login.FieldValues['role_id'];

  //记录上班时间
  DM_ZB_Common.vg_str_onworktime:=Now();
  //loginStatus:=True;
  self.ModalResult:=mrOk;
  //self.Close;

  //登陆成功进入主界面
  {
  //W_POS_LoginForm.Hide;
  if edt1.ReadOnly then
  begin
    W_POS_MainWindow.Show;
  end
  else
  begin
     Application.CreateForm(TW_POS_MainWindow,W_POS_MainWindow);
     W_POS_LoginForm.close;
     W_POS_MainWindow.ShowModal;
     W_POS_MainWindow.free;
     W_POS_MainWindow:=nil;
  end;
 }

end;

procedure TW_POS_LoginForm.FormCreate(Sender: TObject);
var
  x,y:integer;
begin
  if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
     DM_ZB_Common.SetupConnection;
  //loginStatus:=false;
  x:=getsystemmetrics(sm_cxscreen);
  y:=getsystemmetrics(sm_cyscreen);
  top:= (y-height) div 2;
  left:= (x-width) div 2;
  vl_input_count:=0;
end;

procedure TW_POS_LoginForm.btnQXClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TW_POS_LoginForm.FormShow(Sender: TObject);
begin
  //从收银锁屏界面返回
   if DM_ZB_Common.vg_str_CashierID<>'' then
   begin
      //W_POS_MainWindow.Hide;
      //W_POS_MainWindow.close;
      edt1.Text:=DM_ZB_Common.vg_str_CashierID;
      edt1.ReadOnly:=True;
      edt2.SetFocus;
   end;
end;

end.
