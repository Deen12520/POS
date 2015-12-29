unit C_POS_Vip;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DB, MemDS, DBAccess, Uni;

type
  TW_POS_VipForm = class(TForm)
    lbl1: TLabel;
    edtvip: TEdit;
    grp1: TGroupBox;
    btn1: TBitBtn;
    lbl2: TLabel;
    lbl3: TLabel;
    uniqueryVIP: TUniQuery;
    btn2: TBitBtn;
    procedure edtvipKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  W_POS_VipForm: TW_POS_VipForm;
  vipKH:string;      //��Ա����
  formalScore:Integer; //ԭ�ۼƻ���
  formal_rest:Double;  //ԭ��Ǯ
  vip_flag:Boolean;  //��Ա�Ƿ�����ɹ���һ����־
  cardType1:string;  //������
  formal_totalXF:Double; //ԭ���ۼ����Ѷ�

implementation
uses C_ZB_DataModule;

{$R *.dfm}

procedure TW_POS_VipForm.edtvipKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
//var
  //cardType:string;  //������
begin
  if (Key=VK_RETURN)  then
  begin
    edtvip.SetFocus;
    vipKH:=edtvip.Text;
    with uniqueryVIP do
    begin
      Close;
      sql.Clear;
      SQL.Add('select * from t_mem_membaseinfo where mem_card_id=:a and card_status=''1''');
      ParamByName('a').Value:=vipKH;
      Open;
    end;
    if uniqueryVIP.RecordCount<1 then
    begin
      ShowMessage('δ������Ч��Ա���ţ����������룡����Ļ�Ա����Ϊ��'+vipKH);
      edtvip.SetFocus;
    end
    else
    begin
      vip_flag:=True;
      cardType1:=uniqueryVIP.FieldByName('card_type').AsString;
      //���ֿ�
      if cardType1='0' then
      begin
         formalScore:=uniqueryVIP.FieldByName('mem_add_point').AsInteger;
         formal_rest:=uniqueryVIP.FieldByName('change_total').AsFloat;
      end
      else
      //�ۿۿ�
      begin
         formalScore:=0;
         formal_rest:=0;
      end;
      formal_totalXF:=uniqueryVIP.FieldByName('mem_sum_sale_acco').AsFloat;
      close;
    end;


  end;
end;

procedure TW_POS_VipForm.FormShow(Sender: TObject);
begin
  if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
     DM_ZB_Common.SetupConnection;
  vip_flag:=False;
end;

procedure TW_POS_VipForm.btn2Click(Sender: TObject);
begin
  close;
end;

end.
