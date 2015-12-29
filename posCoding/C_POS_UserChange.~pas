unit C_POS_UserChange;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, MemDS, DBAccess, Uni, StdCtrls, Buttons;

type
  TW_POS_UserChangeForm = class(TForm)
    edt1: TEdit;
    btn1: TBitBtn;
    btn2: TBitBtn;
    lbl1: TLabel;
    lbl2: TLabel;
    uniqueryLQ: TUniQuery;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btn1Click(Sender: TObject);
    procedure edt1KeyPress(Sender: TObject; var Key: Char);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  W_POS_UserChangeForm: TW_POS_UserChangeForm;
  useLQ_flag:Boolean;   //取零成功的标志

implementation
uses C_ZB_DataModule,C_POS_Vip;

{$R *.dfm}

procedure TW_POS_UserChangeForm.FormShow(Sender: TObject);
begin
  if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
      DM_ZB_Common.SetupConnection;

  KeyPreview:=True;
  useLQ_flag:=False;
  lbl2.Caption:='请输入取零密码！';
  edt1.SetFocus;
end;

procedure TW_POS_UserChangeForm.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #68) or (Key = #100) then
      btn1.Click;
end;

procedure TW_POS_UserChangeForm.btn1Click(Sender: TObject);
var
  input:string;  //输入的字符
begin
  if edt1.Text<>'' then
  begin
      input:=UpperCase(Trim(edt1.Text));
      //判断输入的取零密码是否正确
      with uniqueryLQ do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM t_mem_membaseinfo where mem_card_id=:a and change_password=:b and card_type=''0'' and card_status=''1''');
        ParamByName('a').Value:=vipKH;
        ParamByName('b').Value:=input;
        Open;
      end;
      if uniqueryLQ.RecordCount<1 then
      begin
         lbl2.Caption:='取零密码错误！请先核对！';
         edt1.SetFocus;
      end
      else
      begin
        lbl2.Caption:='密码正确！';
        //sqma:=input;
        useLQ_flag:=True;
        Close;

      end;
  end
  else
  begin
    lbl2.Caption:='输入为空，请输入！';
  end;

end;

procedure TW_POS_UserChangeForm.edt1KeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#13,#8]) then
        key:=#0;
end;

procedure TW_POS_UserChangeForm.btn2Click(Sender: TObject);
begin
  close;
end;

end.
