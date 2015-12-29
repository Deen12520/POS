unit C_POS_Bank;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TW_POS_BankForm = class(TForm)
    lblFKFS: TLabel;
    edt1: TEdit;
    lblYSJE: TLabel;
    edt2: TEdit;
    lblSFJE: TLabel;
    edt3: TEdit;
    lblBZ: TLabel;
    edt4: TEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    btnQD: TBitBtn;
    btnTC: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edt3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edt3KeyPress(Sender: TObject; var Key: Char);
    procedure btnTCClick(Sender: TObject);
    procedure btnQDClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
     // PayName:string;  //支付名称
   // moneyPay:Double;  //付款金额
  end;

var
  W_POS_BankForm: TW_POS_BankForm;
   // PayName:string;  //支付名称
   // moneyPay:Double;  //付款金额

   //Test:string='dancy';   //测试全局变量
    PayName:string;  //支付名称
    moneyPay:Double;  //付款金额
   bankflag:Boolean=False;  //银行卡支付成功的标志


implementation
uses C_POS_Settlement;

{$R *.dfm}

procedure TW_POS_BankForm.FormShow(Sender: TObject);
begin
  edt2.Text:=FloatToStr(C_POS_Settlement.moneyYS);
  edt3.Text:=FloatToStr(C_POS_Settlement.moneyYS);
  edt2.ReadOnly:=True;
  edt3.SetFocus;
  edt4.Visible:=False;
end;

procedure TW_POS_BankForm.FormCreate(Sender: TObject);
begin
  edt3.Text:='';
  edt4.Text:='';
  KeyPreview := true;
end;


procedure TW_POS_BankForm.edt3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

//edit输入合法性检查
procedure TW_POS_BankForm.edt3KeyPress(Sender: TObject; var Key: Char);
begin
  {
  if (pos('.',TEdit(Sender).Text))<>0  then
  begin
    if (Length(edt3.Text)-Pos('.',TEdit(Sender).Text))=2 then
      Key:=#0;
      exit;
  end;
   }
  if not (key in ['0'..'9',#46,#8,'.'])then
    key:= #0
  else
  begin
    if   key = '.' then
    begin
        if pos('.',TEdit(Sender).Text)> 0 then key:=#0;   //只能输入一个小数点
        if (length(TEdit(Sender).Text) = 0)   then       //如果第一次输入'.'则自动加'0';
        begin
            Tedit(Sender).SelText:='0.';
            key:=#0;
        end;
    end
    else
    if key = '0' then
      begin
          if   (length(TEdit(Sender).Text)= 1) and (TEdit(Sender).Text='0') then
              key   :=   #0;
      end
    else
      begin
          if   (length(TEdit(Sender).Text)=1) and (TEdit(Sender).Text='0') then
               TEdit(Sender).Text:='';
      end;
  end;
end;

procedure TW_POS_BankForm.btnTCClick(Sender: TObject);
begin
  close;
end;

procedure TW_POS_BankForm.btnQDClick(Sender: TObject);
begin
    moneyPay:=StrToFloat(edt3.Text);
    PayName:='银行卡';
    lbl2.Caption:='付款金额为'+edt3.Text;
    bankflag:=True;
    close;
end;

procedure TW_POS_BankForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #68) or (Key = #100) then
      btnQD.Click;
end;

end.
