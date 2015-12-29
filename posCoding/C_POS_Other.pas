unit C_POS_Other;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DB, MemDS, DBAccess, Uni;

type
  TW_POS_OtherForm = class(TForm)
    pnl1: TPanel;
    btn1: TBitBtn;
    btn2: TBitBtn;
    btn3: TBitBtn;
    btn4: TBitBtn;
    btn5: TBitBtn;
    btn6: TBitBtn;
    btn7: TBitBtn;
    btn8: TBitBtn;
    btn9: TBitBtn;
    btn10: TBitBtn;
    uniqueryother: TUniQuery;
    procedure btn5Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure btn10Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    //procedure OpenMoneyBox;   //弹出钱箱
  private
    { Private declarations }
  public
    { Public declarations }
    //SYSP_flag:Boolean;   //收银锁屏的标志
  end;

var
  W_POS_OtherForm: TW_POS_OtherForm;


implementation
uses C_MD_Return,C_POS_Promotion,C_MD_SPFin,C_POS_CashBox,C_POS_SaleCheck,
  C_POS_Login,C_ZB_DataModule;

{$R *.dfm}

//交班处理
procedure TW_POS_OtherForm.btn5Click(Sender: TObject);
var
  JBflag:Integer;  //是否交班的标志
begin
   JBflag:=application.messagebox('是否交班？','注意：',MB_ICONINFORMATION+MB_OkCancel);
   If JBflag=2 then//不交班
   Begin
      Exit;
   end
   else
   Begin
     //交班成功后，更新下班时间，然后进入登陆界面
     with uniqueryother do
     begin
       Close;
       SQL.Clear;
       SQL.Add('INSERT INTO t_bi_storeturnwork VALUES(:a,:b,:c,:d)');
       ParamByName('a').Value:=DM_ZB_Common.vg_str_CashierID;
       ParamByName('b').Value:=DM_ZB_Common.vg_str_DepartmentID;
       ParamByName('c').Value:=DM_ZB_Common.vg_str_onworktime;
       ParamByName('d').Value:=Now();
       ExecSQL;
     end;
     Application.Terminate;     //交班并写入数据
   End;

end;

//退换货
procedure TW_POS_OtherForm.btn7Click(Sender: TObject);
begin
    W_POS_OtherForm.Hide;
    Application.CreateForm(TW_MD_ReturnForm,W_MD_ReturnForm);
    W_MD_ReturnForm.ShowModal;

    W_MD_ReturnForm.Free;
    W_POS_OtherForm.Close;
    //W_POS_OtherForm.Free;

   // W_MD_ReturnForm.ShowModal;
    //Self.close;
end;

//促销查询
procedure TW_POS_OtherForm.btn1Click(Sender: TObject);
begin
    Application.CreateForm(TW_POS_PromotionForm,W_POS_PromotionForm);
    W_POS_PromotionForm.ShowModal;
    W_POS_PromotionForm.Free;
    //W_POS_PromotionForm.ShowModal;
    Self.close;
end;

//商品查询
procedure TW_POS_OtherForm.btn4Click(Sender: TObject);
begin
    Self.Hide;
    Application.CreateForm(TW_MD_SPFinForm,W_MD_SPFinForm);
    W_MD_SPFinForm.ShowModal;
    W_MD_SPFinForm.Free;
    //W_MD_SPFinForm.ShowModal;
    Self.Close;
end;

//收银对账
procedure TW_POS_OtherForm.btn2Click(Sender: TObject);
begin
   Application.CreateForm(TW_POS_SaleCheckForm,W_POS_SaleCheckForm);

   W_POS_SaleCheckForm.ShowModal;
   W_POS_SaleCheckForm.Free;
   W_POS_OtherForm.Close;
   //W_POS_SaleCheckForm.ShowModal;

end;

//开钱箱
procedure TW_POS_OtherForm.btn8Click(Sender: TObject);
//var
  //sMoneyBoxOpenCommand:String=CHR(27)+Chr(112)+CHR(0)+CHR(60)+CHR(255);
begin
   Application.CreateForm(TW_POS_CashBox,W_POS_CashBox);
   W_POS_CashBox.ShowModal;
   W_POS_CashBox.Free;
   W_POS_CashBox.ShowModal;
   Self.Close;
   //OpenMoneyBox;
end;


//钱箱设置
procedure TW_POS_OtherForm.btn10Click(Sender: TObject);
begin
   ShowMessage('钱箱设置');
   Self.Close;
end;

//打印机设置
procedure TW_POS_OtherForm.btn3Click(Sender: TObject);
begin
  ShowMessage('打印机设置');
  Self.Close;
end;

//收银锁屏
procedure TW_POS_OtherForm.btn9Click(Sender: TObject);
begin
  ShowMessage('收银锁屏');
  //W_POS_OtherForm.Hide;
  Application.CreateForm(TW_POS_LoginForm,W_POS_LoginForm);
  W_POS_OtherForm.Close;
  W_POS_LoginForm.ShowModal;
  W_POS_LoginForm.Free;



  //SYSP_flag:=True;
  //W_POS_LoginForm.edt1.Text:= DM_ZB_Common.vg_str_CashierID;
  //W_POS_LoginForm.edt1.ReadOnly:=True;
  //self.Close;
end;

procedure TW_POS_OtherForm.FormCreate(Sender: TObject);
begin
  if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
    DM_ZB_Common.SetupConnection;
end;

end.
