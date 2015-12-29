unit C_ZB_Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Mask, Buttons,inifiles, DB, MemDS,
  DBAccess, Uni;

type
  Tw_ZB_login = class(TForm)
    Label4: TLabel;
    Label5: TLabel;
    Bevel2: TBevel;
    BitBtn_login: TBitBtn;
    BitBtn_exit: TBitBtn;
    Panel1: TPanel;
    Label6: TLabel;
    Edit_UserName: TEdit;
    Edit_Pass: TMaskEdit;
    Image1: TImage;
    CheckBox1: TCheckBox;
    GroupBox1: TGroupBox;
    ZQuery1: TUniQuery;
    procedure BitBtn_loginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn_exitClick(Sender: TObject);
  private
    { Private declarations }
    vl_input_count:integer;
    function jiemi(mima:string):string;
  public
    vl_str_CenterOrStore:string;
     loginStatus:boolean;
    { Public declarations }
  end;

var
  w_ZB_login: Tw_ZB_login;

implementation

uses C_ZB_DataModule,C_POS_MainWindow;

{$R *.dfm}

function Tw_ZB_login.jiemi(mima:string):string;
begin
   if dm_zb_common.vg_b_debug =false then jiemi:=DM_ZB_COmmon.UnEncryptString(mima)
   else   jiemi:=mima;
end;
procedure Tw_ZB_login.BitBtn_loginClick(Sender: TObject);
var
  Myinifile:TiniFile;
  vl_sql:string;
  vl_pass:string;
begin
   ZQuery1.Connection :=DM_ZB_Common.VG_ZB_ADOConnection ;
   vl_sql:='select * from t_cmp_employee'
       +' where employee_id='''+trim(edit_username.Text)
       +''' and employee_status=''1''';                    // employee_status=1 为正常状态
   ZQuery1.SQL.Clear;
   ZQuery1.SQL.Add(vl_sql);
   ZQuery1.Open;
   if ZQuery1.eof then
   begin
       showmessage('用户ID不存在，或密码错误');
       vl_input_count:=vl_input_count+1;
       if vl_input_count>=3 then self.Close ;
       exit;
   end;
   ZQuery1.First ;
   vl_pass:=ZQuery1.FieldValues['employee_password'];
   if jiemi(vl_pass)<>trim(edit_pass.Text) then
   begin
       showmessage('用户ID不存在，或密码错误');
       vl_input_count:=vl_input_count+1;
       if vl_input_count>=3 then self.Close ;
       exit;
   end;
  // success login
  DM_ZB_Common.vg_str_EmployeeId:=ZQuery1.FieldValues['employee_id'];
  if ZQuery1.FieldByName('employee_name').IsNull then
     DM_ZB_Common.vg_str_EmployeeName:=''
  else
     DM_ZB_Common.vg_str_EmployeeName:=ZQuery1.FieldValues['employee_name'];
  if ZQuery1.FieldByName('dept_id').IsNull then
     DM_ZB_Common.vg_str_DepartmentID:=''
  else
     DM_ZB_Common.vg_str_DepartmentID:=ZQuery1.FieldValues['dept_id'];
  if ZQuery1.FieldByName('role_id').IsNull then
     DM_ZB_Common.vg_str_EmployeeRoleID:=''
  else
     DM_ZB_Common.vg_str_EmployeeRoleID:=ZQuery1.FieldValues['role_id'];
  showmessage('添加其他全局变量初始化代码');
  //  vg_str_DepartmentName
  loginStatus:=true;
  Myinifile:=Tinifile.create('Store.ini');
  if checkbox1.Checked then
      begin
         myinifile.WriteString('user','remember','1');
         myinifile.WriteString('user','username',trim(edit_username.text));
      end
  else
     begin
       myinifile.WriteString('user','remember','0');
       myinifile.WriteString('user','username','');
     end;
  myinifile.Destroy;
  showmessage('需要加入操作日志表的代码');
  Application.CreateForm(TW_POS_MainWindow,W_POS_MainWindow);
  W_POS_MainWindow.ShowModal;
  W_ZB_Login.Free;
  W_POS_MainWindow.Free;
  //W_POS_MainWindow.ShowModal;    //主界面出现
  //self.close;
end;

procedure Tw_ZB_login.FormShow(Sender: TObject);
var
  Myinifile:TiniFile;
begin
  loginStatus:=false;
  edit_pass.Text :='';
  // success login
  Myinifile:=Tinifile.create('Store.ini');
  if Myinifile=nil then exit;
  if myinifile.ReadString('user','remember','1')='1' then
       checkbox1.Checked:=true
       else checkbox1.Checked:=false;
   edit_username.text:=myinifile.ReadString('user','username','');
  myinifile.destroy;
end;

procedure Tw_ZB_login.FormCreate(Sender: TObject);
var
  x,y:integer;
begin
  loginStatus:=false;
  x:=getsystemmetrics(sm_cxscreen);
  y:=getsystemmetrics(sm_cyscreen);
  top:= (y-height) div 2;
  left:= (x-width) div 2;
  vl_input_count:=0;
end;

procedure Tw_ZB_login.BitBtn_exitClick(Sender: TObject);
begin
  self.close;
end;

end.
