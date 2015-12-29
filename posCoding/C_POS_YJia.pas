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
  Yjia:Double;  //��ۺ�Ӧ��
  payName:string;  //֧����ʽ
  YJflag:Boolean=False;  //�ж��Ƿ���۳ɹ���һ����־

implementation
uses C_POS_Settlement;
{$R *.dfm}

procedure TW_POS_YJiaForm.edtYJKeyPress(Sender: TObject; var Key: Char);
begin
  //����Ϸ���
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

procedure TW_POS_YJiaForm.FormShow(Sender: TObject);
begin
    //��ʾӦ��
    edtYS.Text:=FloatToStr(moneyYS);    //C_POS_Settlement.moneyYS
    edtYJ.Text:=FloatToStr(moneyYS);

    edtYJ.SetFocus;
end;

procedure TW_POS_YJiaForm.btn1Click(Sender: TObject);
var
  x:Integer;
begin
  //����ǰ��绰��ѯ���
  x:=MessageBox(Handle,Pansichar('��ۺ�Ӧ�գ���˶ԣ�'+#13#10 +edtYJ.Text),'��ʾ',MB_OKCANCEL);
  if x=1 then
  begin
    Yjia:=StrToFloat(Trim(edtYJ.Text));
    payName:='���';
    lbl4.Caption:='��۳ɹ���';
    YJflag:=True;
    close;
  end
  else
  begin
    edtYJ.SetFocus;
  end;

   //ShowMessage('��ۺ�Ӧ��'+edtYJ.Text+',��˶ԣ�');

   //btn2.SetFocus;
end;

procedure TW_POS_YJiaForm.btn2Click(Sender: TObject);
begin
  close;
end;

end.
