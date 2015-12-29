unit C_ZB_DBConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Mask, jpeg,inifiles;

type
  TW_ZB_DB_CFG = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    BitBtn_test: TBitBtn;
    BitBtn_ok: TBitBtn;
    BitBtn_exit: TBitBtn;
    Panel1: TPanel;
    Label6: TLabel;
    Edit_IP: TEdit;
    Edit_Port: TEdit;
    Edit_UserName: TEdit;
    Edit_Pass: TMaskEdit;
    Image1: TImage;
    Edit_DBName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn_okClick(Sender: TObject);
    procedure BitBtn_exitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn_testClick(Sender: TObject);
  private
    { Private declarations }
  public
     HasTest:boolean;
    { Public declarations }
  end;

var
  W_ZB_DB_CFG: TW_ZB_DB_CFG;

implementation

uses C_ZB_DataModule;

{$R *.dfm}

procedure TW_ZB_DB_CFG.FormCreate(Sender: TObject);
var
  x,y:integer;
begin
  HasTest:=false;
  x:=getsystemmetrics(sm_cxscreen);
  y:=getsystemmetrics(sm_cyscreen);
  top:= (y-height) div 2;
  left:= (x-width) div 2;
end;

procedure TW_ZB_DB_CFG.BitBtn_okClick(Sender: TObject);
var
  Myinifile:TiniFile;
begin
  if HasTest=false then
      if messagebox(W_ZB_DB_CFG.Handle,'参数没有测试，是否继续保存？','提示信息',MB_YESNO)=IDNO then exit;
  Myinifile:=Tinifile.create('Store.ini');
  myinifile.WriteString('System','IP',DM_ZB_Common.EncryptString(trim(edit_ip.Text)) );
  myinifile.WriteString('System','Port',DM_ZB_Common.EncryptString(trim(edit_port.Text)));
  myinifile.WriteString('System','DataBase',DM_ZB_Common.EncryptString(trim(Edit_DBName.Text)));
  myinifile.WriteString('System','UserName',DM_ZB_Common.EncryptString(trim(edit_Username.Text)));
  myinifile.WriteString('System','password',DM_ZB_Common.EncryptString(trim(edit_pass.Text)));
  myinifile.Destroy;

end;

procedure TW_ZB_DB_CFG.BitBtn_exitClick(Sender: TObject);
begin
  W_ZB_DB_CFG.close;
end;

procedure TW_ZB_DB_CFG.FormShow(Sender: TObject);
var
  Myinifile:TiniFile;
  temp:string;
begin
  Myinifile:=Tinifile.create('Store.ini');
  if   Myinifile=nil then exit;
  temp:=myinifile.ReadString('System','IP','');
  edit_ip.Text:=DM_ZB_common.UnEncryptString (temp);
  temp:=myinifile.ReadString('System','Port','');
  if temp='' then
      edit_port.text:='5432'
   else
      edit_port.Text:=DM_ZB_common.UnEncryptString (temp);
  temp:=myinifile.ReadString('System','DataBase','');
  Edit_DBName.Text:=DM_ZB_common.UnEncryptString (temp);
  temp:=myinifile.ReadString('System','UserName','');
  edit_Username.Text:=DM_ZB_common.UnEncryptString (temp);
  temp:=myinifile.ReadString('System','password','');
  edit_pass.Text:=DM_ZB_common.UnEncryptString (temp);
  myinifile.Destroy;
  edit_ip.SetFocus ;
end;

procedure TW_ZB_DB_CFG.BitBtn_testClick(Sender: TObject);
begin
   hastest:=false;
   DM_ZB_Common.VG_ZB_ADOConnection.Connected:=false;
   DM_ZB_Common.VG_ZB_ADOConnection.UserName := trim(edit_Username.Text);
   DM_ZB_Common.VG_ZB_ADOConnection.Password := trim(edit_pass.Text);
   DM_ZB_Common.VG_ZB_ADOConnection.ProviderName := 'postgresql'; //注意此项不设置会出现错误Requested database driver was not found.
   DM_ZB_Common.VG_ZB_ADOConnection.server := trim(edit_ip.Text);
   DM_ZB_Common.VG_ZB_ADOConnection.Port := strtoint(edit_port.text); //可以不设置使用默认的值
   DM_ZB_Common.VG_ZB_ADOConnection.Database:= trim(Edit_DBName.Text);
   DM_ZB_Common.VG_ZB_ADOConnection.AutoCommit:=true;
   DM_ZB_Common.VG_ZB_ADOConnection.LoginPrompt :=false;
   try
     DM_ZB_Common.VG_ZB_ADOConnection.Connect;
   finally
   end;
   if DM_ZB_Common.VG_ZB_ADOConnection.Connected then
   begin
     //DM_ZB_Common.VG_ZB_ADOConnection.ExecuteDirect('set CLIENT_ENCODING TO ''GB18030''');
     hastest:=true;
     showmessage('测试成功');
   end
   else
     showmessage('测试失败');
end;

end.
