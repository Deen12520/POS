unit C_POS_OtherPayWay;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TW_POS_OtherPayWayForm = class(TForm)
    lbl1: TLabel;
    cbb1: TComboBox;
    btn1: TBitBtn;
    btn2: TBitBtn;
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  W_POS_OtherPayWayForm: TW_POS_OtherPayWayForm;
  PayName:string;  //支付名称
implementation

{$R *.dfm}

//取消
procedure TW_POS_OtherPayWayForm.btn2Click(Sender: TObject);
begin
  close;
end;

//获取选择的值
procedure TW_POS_OtherPayWayForm.btn1Click(Sender: TObject);
begin
  PayName:=cbb1.Text;
  ShowMessage(PayName);
  close;
end;

end.
