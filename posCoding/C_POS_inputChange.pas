unit C_POS_inputChange;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TW_POS_inputChangeForm = class(TForm)
    edt1: TEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    edt2: TEdit;
    btn1: TBitBtn;
    btn2: TBitBtn;
    lbl3: TLabel;
    lbl4: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure edt2KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  W_POS_inputChangeForm: TW_POS_inputChangeForm;
  useChange:Double;  //使用零钱数

implementation
uses C_POS_Vip,C_POS_UserChange;
{$R *.dfm}

procedure TW_POS_inputChangeForm.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #68) or (Key = #100) then
      btn1.Click;
end;

procedure TW_POS_inputChangeForm.FormShow(Sender: TObject);
begin
   KeyPreview:=True;
   edt1.Text:=FloatToStr(formal_rest);
   edt1.ReadOnly:=True;
   lbl4.Caption:='请输入取出零钱金额！';
   edt2.SetFocus;
end;

procedure TW_POS_inputChangeForm.btn1Click(Sender: TObject);
var
  QC_money:Double;  //输入金额
begin
   if edt2.Text<>'' then
   begin
     QC_money:=StrToFloat(edt2.Text);
     //判断输入的是正负、（存零、取零）
     //存零
     if QC_money<0 then
     begin

        if (formal_rest-QC_money)>4 then
        begin
          lbl4.Caption:='存零超过限额！';
          //edt2.SetFocus;
          btn2.SetFocus;
        end
        else
        begin
           useChange:=QC_money;
           lbl4.Caption:='进行存零！';
           Close;
        end;

     end
     else
     begin

        if QC_money>formal_rest then
        begin
          lbl4.Caption:='取出零钱数不能大于零钱总额，请核对！';
          edt2.SetFocus;
        end
        else
        begin

          Application.CreateForm(TW_POS_UserChangeForm,W_POS_UserChangeForm);
          W_POS_UserChangeForm.ShowModal;
          if useLQ_flag then
          begin
            useChange:=QC_money;
          end
          else
          begin
            useChange:=0.00;
          end;
          lbl4.Caption:='取出零钱';
          W_POS_UserChangeForm.Free;
          Close;

        end;
     end;
   end
   else
   begin
     lbl4.Caption:='输入为空，请输入';
   end;


end;

procedure TW_POS_inputChangeForm.btn2Click(Sender: TObject);
begin
  close;
  useLQ_flag:=False;
end;

procedure TW_POS_inputChangeForm.edt2KeyPress(Sender: TObject;
  var Key: Char);
begin
    if not (key in ['0'..'9',#13,#8,'.','-']) then
        key:=#0;

    if ((key='.')and (pos('.',edt2.Text)>0)) then
        key:=#0;
end;

end.
