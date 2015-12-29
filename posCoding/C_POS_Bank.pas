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
     // PayName:string;  //֧������
   // moneyPay:Double;  //������
  end;

var
  W_POS_BankForm: TW_POS_BankForm;
   // PayName:string;  //֧������
   // moneyPay:Double;  //������

   //Test:string='dancy';   //����ȫ�ֱ���
    PayName:string;  //֧������
    moneyPay:Double;  //������
   bankflag:Boolean=False;  //���п�֧���ɹ��ı�־


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

//edit����Ϸ��Լ��
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
        if pos('.',TEdit(Sender).Text)> 0 then key:=#0;   //ֻ������һ��С����
        if (length(TEdit(Sender).Text) = 0)   then       //�����һ������'.'���Զ���'0';
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
    PayName:='���п�';
    lbl2.Caption:='������Ϊ'+edt3.Text;
    bankflag:=True;
    close;
end;

procedure TW_POS_BankForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #68) or (Key = #100) then
      btnQD.Click;
end;

end.
