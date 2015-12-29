unit C_POS_YJia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DB, MemDS, DBAccess, Uni;

type
  TW_POS_YJiaForm = class(TForm)
    pnl1: TPanel;
    lbl1: TLabel;
    edtYS: TEdit;
    lbl2: TLabel;
    edtYJ: TEdit;
    btn1: TBitBtn;
    btn2: TBitBtn;
    lbl3: TLabel;
    lbl4: TLabel;
    procedure edtYJKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  W_POS_YJiaForm: TW_POS_YJiaForm;
  Yjia:Double;  //议价后应收
  payName:string;  //支付方式
  YJflag:Boolean=False;  //判断是否议价成功的一个标志

implementation
uses C_POS_Settlement;
{$R *.dfm}

procedure TW_POS_YJiaForm.edtYJKeyPress(Sender: TObject; var Key: Char);
begin
  //输入合法性
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

procedure TW_POS_YJiaForm.FormShow(Sender: TObject);
begin
    //显示应收
    edtYS.Text:=FloatToStr(moneyYS);    //C_POS_Settlement.moneyYS
    edtYJ.Text:=FloatToStr(moneyYS);

    edtYJ.SetFocus;
end;

procedure TW_POS_YJiaForm.btn1Click(Sender: TObject);
var
  x:Integer;
begin
  //收银前打电话咨询议价
  x:=MessageBox(Handle,Pansichar('议价后应收，请核对！'+#13#10 +edtYJ.Text),'提示',MB_OKCANCEL);
  if x=1 then
  begin
    Yjia:=StrToFloat(Trim(edtYJ.Text));
    payName:='议价';
    lbl4.Caption:='议价成功！';
    YJflag:=True;
    close;
  end
  else
  begin
    edtYJ.SetFocus;
  end;

   //ShowMessage('议价后应收'+edtYJ.Text+',请核对！');

   //btn2.SetFocus;
end;

procedure TW_POS_YJiaForm.btn2Click(Sender: TObject);
begin
  close;
end;

end.
