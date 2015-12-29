unit C_POS_CashBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, DBAccess, Uni, MemDS;

type
  TW_POS_CashBox = class(TForm)
    unqryPass: TUniQuery;
    dsPass: TUniDataSource;
    lblWarn: TLabel;
    edtPass: TEdit;
    btnOK: TButton;
    btnESC: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnESCClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    //procedure edtPassKeyPress(Sender: TObject; var Key: Char);
    
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  W_POS_CashBox: TW_POS_CashBox;

implementation
 uses C_ZB_DataModule;
{$R *.dfm}

procedure TW_POS_CashBox.FormShow(Sender: TObject);
begin
  if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
   DM_ZB_Common.SetupConnection;
   //unqryPass.Active:=True;
end;

//确认提交密码
procedure TW_POS_CashBox.btnOKClick(Sender: TObject);
var
  s_sql:string;
  cashierID:string;
  F:TextFile;   
  PDStr:string;
begin
  cashierID :=DM_ZB_Common.vg_str_CashierID;  //（！收银员ID从主界面传入！）
  s_sql := 'select employee_password from t_cmp_employee'+
            ' where employee_id = '''+cashierID+'''';
  with unqryPass do
  begin
    SQL.Clear;
    SQL.Add(s_sql);
    Open;
  end;

  if edtPass.Text = unqryPass.FieldByName('employee_password').AsString then
  begin
    //弹出钱箱功能
    PDStr:= #27+#112+#0+#100+#100;  // 开钱箱指令
    AssignFile(F, 'LPT1');   //关联文件
    Rewrite(F);              //打开文件
    Write(F, PDStr);         //写入一行
    CloseFile(F);            //关闭文件
    close;
  end
  else
    ShowMessage('密码输入错误！');
end;

//取消，退出当前窗口
procedure TW_POS_CashBox.btnESCClick(Sender: TObject);
begin
  if Application.MessageBox('是否取消打开钱箱！', '询问', MB_ICONQUESTION + MB_YESNO) = ID_YES then
    close;
end;

//设置快捷键
procedure TW_POS_CashBox.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  btnOK.Click;
  if Key = #27 then
  btnESC.Click;
end;

end.
