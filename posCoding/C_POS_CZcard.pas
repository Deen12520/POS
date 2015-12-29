unit C_POS_CZcard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, MemDS, DBAccess, Uni, UniProvider,
  PostgreSQLUniProvider;

type
  TW_POS_CZcardForm = class(TForm)
    lbl1: TLabel;
    edtCZK: TEdit;
    edtYSJE: TEdit;
    lbl2: TLabel;
    edtCZKH: TEdit;
    lbl3: TLabel;
    edtSFJE: TEdit;
    lbl4: TLabel;
    btnQD: TBitBtn;
    btnTC: TBitBtn;
    lbl5: TLabel;
    lbl6: TLabel;
    uniqueryCZK: TUniQuery;
    pstgrsqlnprvdr1: TPostgreSQLUniProvider;
    edtYE: TEdit;
    lbl7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtSFJEKeyPress(Sender: TObject;var Key: Char);
    procedure edtCZKHKeyPress(Sender: TObject;
  var Key: Char);
    //procedure edtSFJEKeyDown(Sender: TObject; var Key: Word;
      //Shift: TShiftState);
    //procedure edtCZKHKeyDown(Sender: TObject; var Key: Word;
      //Shift: TShiftState);
    procedure btnTCClick(Sender: TObject);
    procedure btnQDClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtCZKHExit(Sender: TObject);
    procedure edtSFJEExit(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  W_POS_CZcardForm: TW_POS_CZcardForm;
  PayName:string;  //支付名称
  moneyPay:Double;  //付款金额
  CZcardID:string;  //储值卡号
  CZflag:Boolean=False; //储值卡支付成功的标志
  
implementation
uses C_POS_Settlement;
//,C_ZB_DataModule
var
  Restmoney:Double;   //储值卡余额
{$R *.dfm}


procedure TW_POS_CZcardForm.FormCreate(Sender: TObject);
begin

  KeyPreview := true;
end;

procedure TW_POS_CZcardForm.FormShow(Sender: TObject);
begin
  {
  //uniquery连接数据库：1、加上这一句；2、use C_ZB_DataModule
  if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
     DM_ZB_Common.SetupConnection; }
     
  edtYSJE.Text:=FloatToStr(moneyYS);
  edtSFJE.Text:='';
  edtCZKH.Text:='';
  edtYE.Text:='';
  edtYSJE.ReadOnly:=True;
  edtCZK.ReadOnly:=True;
  edtCZKH.SetFocus;
end;

//输入金额合法性
procedure TW_POS_CZcardForm.edtSFJEKeyPress(Sender: TObject;
  var Key: Char);
begin
  //TO DO 控制只能输入两个小数点
  
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

//储值卡只能输入数字
procedure TW_POS_CZcardForm.edtCZKHKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#13,#8])then
    key:= #0

end;


procedure TW_POS_CZcardForm.btnTCClick(Sender: TObject);
begin
  CZflag:=False;
  close;
end;

procedure TW_POS_CZcardForm.btnQDClick(Sender: TObject);
var
  x:Integer;
begin

  if StrToFloat(edtSFJE.Text)>Restmoney then
  begin
    lbl6.Caption:='储值卡余额不足！请重新输入！';
    edtSFJE.SetFocus;
  end
  else
  begin
     x:=MessageBox(Handle,Pansichar('您输入的金额为'+#13#10 +edtSFJE.Text),'提示',MB_OKCANCEL);
     if x=1 then
     begin
        CZflag:=True;
        PayName:='储值卡';
        moneyPay:=StrToFloat(edtSFJE.Text);
        //储值卡内扣除当前零钱
        with uniqueryCZK do
        begin
          Close;
          sql.Clear;
          SQL.Add('UPDATE t_mem_valuecard SET valuecard_balance=:a WHERE valuecard_id=:b');
          ParamByName('a').Value:=Restmoney-moneyPay;
          ParamByName('b').Value:=edtCZKH.Text;
          ExecSQL;
        end;
        lbl6.Caption:='付款金额为'+edtSFJE.Text;
        Close;
     end
     else
     begin
       edtSFJE.SetFocus;
     end;


  end;
end;

//输入金额不能为空
procedure TW_POS_CZcardForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #68) or (Key = #100) then
      btnQD.Click;
end;

//判断储值卡号是否有效
procedure TW_POS_CZcardForm.edtCZKHExit(Sender: TObject);
begin
      CZcardID:=edtCZKH.Text;
     //TO DO 输入不能为空    储值卡号是否存在,卡余额是否足以支付当前账单
     if edtCZKH.Text<>'' then
     begin
       with uniqueryCZK do
       begin
         Close;
         SQL.Clear;
         SQL.Add('SELECT * from t_mem_valuecard where valuecard_id=:a and valuecard_state=''1''');
         ParamByName('a').Value:=Trim(CZcardID);
         Open;
       end;

       if uniqueryCZK.RecordCount<1 then
       begin
         lbl6.Caption:='该卡号不存在，请核对输入！';
         edtCZKH.SetFocus;
       end
       else
       begin
          Restmoney:=uniqueryCZK.FieldByName('valuecard_balance').AsFloat;
          edtYE.Text:=FloatToStr(Restmoney);
          //余额大于应收金额时，直接用储值卡付款
          if Restmoney>=C_POS_Settlement.moneyYS  then
          begin
            lbl6.Caption:='可用储值卡付款'+FloatToStr(C_POS_Settlement.moneyYS);
            edtSFJE.Text:=FloatToStr(moneyYS);
            edtSFJE.SetFocus;
          end
          else
          begin
            lbl6.Caption:='余额为'+ FloatToStr(Restmoney);
            //ShowMessage('是否全部使用？');
            edtSFJE.Text:=FloatToStr(Restmoney);
            edtSFJE.SetFocus;
          end;

       end;
    end
    else
    begin
       lbl6.Caption:='请输入卡号！';
       edtCZKH.SetFocus;
    end;
end;

//实付金额格式限制
procedure TW_POS_CZcardForm.edtSFJEExit(Sender: TObject);
begin
    if edtSFJE.Text='' then
    begin
      lbl6.Caption:='请输入应付金额！';
      edtSFJE.SetFocus;
    end
    else  if StrToFloat(edtSFJE.Text)<=0.00 then
    begin
      btnQD.SetFocus;
      lbl6.Caption:='请输入大于0的金额！';
    end;
end;

end.
