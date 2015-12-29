unit C_POS_SaleCheck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DB, DBAccess, Uni, MemDS, Grids, DBGrids;

type
  TW_POS_SaleCheckForm = class(TForm)
    lblCashier: TLabel;
    lblCashierId: TLabel;
    lblSTime: TLabel;
    lblSDate: TLabel;
    btnOK: TButton;
    lblRMB: TLabel;
    lblBank: TLabel;
    lblCZK: TLabel;
    lblGWQ: TLabel;
    lblTotal: TLabel;
    edtRMB: TEdit;
    edtBank: TEdit;
    edtCZK: TEdit;
    edtGWQ: TEdit;
    edtTotal: TEdit;
    unqrySaleCheck: TUniQuery;
    dsSaleCheck: TUniDataSource;
    pnlPMoney: TPanel;
    dbgrdPMoney: TDBGrid;
    lblPTotal: TLabel;
    lbl_PTotal: TLabel;
    unqrySelect: TUniQuery;
    btnESC: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtRMBKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtBankKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtCZKKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtGWQKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    function generateLSH(var Currency_time:TDateTime):string;
    procedure btnESCClick(Sender: TObject); //��ˮ������
    procedure check_right(Sender: TObject; var Key: Char);
    procedure edtRMBKeyPress(Sender: TObject; var Key: Char);
    procedure edtBankKeyPress(Sender: TObject; var Key: Char);
    procedure edtCZKKeyPress(Sender: TObject; var Key: Char);
    procedure edtGWQKeyPress(Sender: TObject; var Key: Char);//�༭��Ϸ����ж�
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  W_POS_SaleCheckForm: TW_POS_SaleCheckForm;

implementation
   uses C_ZB_DataModule;
{$R *.dfm}
var
  liushuihao:string;//��ˮ��
  
procedure TW_POS_SaleCheckForm.FormShow(Sender: TObject);
var
  Currency_time:TDateTime;
begin
    if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
      DM_ZB_Common.SetupConnection;
   //unqrySaleCheck.Active:=True;

   //���ܴ������洫��������ԱID
   lblCashierId.Caption:= DM_ZB_Common.vg_str_CashierID;
   //lblCashierId.Caption:= '012';  

   //���ɽ���ʱ��
   Currency_time:=DM_ZB_Common.GetDBDatetime;
   lblSDate.Caption:= DateTimeToStr(Currency_time);

   //������ˮ��
   liushuihao:=generateLSH(Currency_time);

   //�����ƶ����ֽ�༭�򣬲����ܼƵı༭������Ϊֻ��
   edtRMB.SetFocus;
   edtTotal.ReadOnly := True;

end;

//��ˮ������
function TW_POS_SaleCheckForm.generateLSH(var Currency_time:TDateTime):string;
var
  penal_num:string;  //��ˮ�ű��
  str_date:string;
  m,s:string;
  mdstr,posstr,datestr:string;
  i:Integer;
  l_sql:string;  //��ˮ�Ų�ѯ���
begin
    //����һ���µ���ˮ��

    //to do ���ܲ���ȡ����     -----done!
    posstr:=DM_ZB_Common.vg_str_PosID;       //��ȡPOS���
    mdstr:=DM_ZB_Common.vg_str_DepartmentID;    //��ȡ�ŵ���
    str_date:=SysUtils.FormatDateTime('yyyymmdd',Currency_time);//��ȡ������
    penal_num:='DZ'+mdstr+posstr+str_date;

    //to do ����ʱ�䡢�ŵ��š�pos�Ų�ѯ    -----done!
    // ȡ��ͬһ���е������ˮ��
    l_sql:='select max(penalty_id) as ss from t_bi_penitydetail'+
      ' where penalty_id like '''+ trim(penal_num)+'%''';
    with unqrySelect do
    begin
      Close;
      SQL.Clear;
      SQL.Add(l_sql);
      Open;
    end;

     if (unqrySelect.FieldByName('ss').Value='') then
      penal_num:=penal_num+'0000'
    else
     begin
      unqrySelect.Last;
      m:=Trim(unqrySelect.Fields.Fields[0].Value);
      i:=StrToInt(Trim(Copy(m,17,4)));
      if i<9 then
        penal_num:=penal_num+'000'+IntToStr(i+1)
      else if i<99 then
        penal_num:=penal_num+'00'+IntToStr(i+1)
      else if i<999 then
        penal_num:=penal_num+'0'+IntToStr(i+1)
      else
        penal_num:=penal_num+IntToStr(i+1);
     end;
     result:=penal_num;           //����ֵֻ�ܴ���result
end;

//ȷ���ύǮ��Ľ��
procedure TW_POS_SaleCheckForm.btnOKClick(Sender: TObject);
var
  i:Integer;
  Currency_time:TDateTime;
  c_sql:string;//Ӧ�ɽ���ѯ
  sum : Double;//�ܼƽ��
  a : array[0..3]  of Double;//���������ѯ���ĸ�֧����ʽ��Ӧ���
  b : array[0..3] of Double;//������������ĸ�֧����ʽ��Ӧ���
begin
  // ȡ��������Ա�ϰ�ʱ���ڵĸ�֧����ʽ��Ӧ�ս��
   c_sql:='select c.pay_way_name as name,sum(b.pay_money) as sum from t_dealpaydetail as b'+
           ' left JOIN  t_bi_storeturnwork as stw on b.store_id = stw.store_id'+
           ' left JOIN t_bi_payway  as c on  b.pay_way_id=c.pay_way_id'+
           '  where (stw.employee_id ='''+lblCashierId.Caption+''' and'+
           '  (b.trade_date >= stw.onwork_time'+
           ' and b.trade_date <= stw.offwork_time))'+
           ' GROUP BY name';

           {���������� ��ѯ������Ա���һ�ε��ϰ�ʱ�䲢�Ը�ʱ����ڵĽ�������ܣ�����֧������ӱ���
            select c.pay_way_name as name,sum(b.pay_money) as sum from t_dealpaydetail as b
            left JOIN  t_bi_storeturnwork as stw on b.store_id = stw.store_id
            left JOIN t_bi_payway  as c on  b.pay_way_id=c.pay_way_id
             where b.trade_date BETWEEN 
						(select max(onwork_time) from t_bi_storeturnwork WHERE employee_id ='012')
            AND (SELECT max(offwork_time) from t_bi_storeturnwork WHERE employee_id ='012')
           GROUP BY name;
           }

    with unqrySaleCheck do
    begin
      SQL.Clear;
      SQL.Add(c_sql);
      Open;
    end;

    //����Ӧ���ܶ�
    sum := 0;
    dbgrdPMoney.Columns[0].Title.Caption := '֧����ʽ';
    dbgrdPMoney.Columns[0].Width := 80;
    dbgrdPMoney.Columns[1].Title.Caption := '���';
    dbgrdPMoney.Columns[1].Width := 60;
    //unqrySaleCheck.RecNo := 1;//�����ָ���һ��
    unqrySaleCheck.First;
    //�ۼӸ�֧����ʽ�����ܶ�
    while not unqrySaleCheck.Eof do
    begin
      sum := sum+dbgrdPMoney.DataSource.DataSet.FieldByName('sum').AsFloat;
      if dbgrdPMoney.DataSource.DataSet.FieldByName('name').AsString = '�ֽ�' then
      begin
        //����Ӧ���ֽ��ܶ�
        a[0] := dbgrdPMoney.DataSource.DataSet.FieldByName('sum').AsFloat;
        b[0] :=  StrToFloat(edtRMB.Text);
      end
      else if dbgrdPMoney.DataSource.DataSet.FieldByName('name').AsString = '���п�' then
      begin
      //����Ӧ�����п��ܶ�
        a[1] := dbgrdPMoney.DataSource.DataSet.FieldByName('sum').AsFloat;
        b[1] :=  StrToFloat(edtBank.Text);
      end
      else if dbgrdPMoney.DataSource.DataSet.FieldByName('name').AsString = '��ֵ��' then
      begin
      //����Ӧ�մ�ֵ���ܶ�
        a[2] := dbgrdPMoney.DataSource.DataSet.FieldByName('sum').AsFloat;
        b[2] :=  StrToFloat(edtCZK.Text);
      end
      else if dbgrdPMoney.DataSource.DataSet.FieldByName('name').AsString = '����ȯ' then
      begin
      //����Ӧ�չ���ȯ�ܶ�
        a[3] := dbgrdPMoney.DataSource.DataSet.FieldByName('sum').AsFloat;
        b[3] :=  StrToFloat(edtGWQ.Text);
      end;
      unqrySaleCheck.Next;
    end;
     lbl_PTotal.Caption := FloatToStr(sum);
     edtTotal.ReadOnly := False;
     edtTotal.Text := FloatToStr(StrToFloat(edtRMB.Text)+ StrToFloat(edtBank.Text)+ StrToFloat(edtCZK.Text)+ StrToFloat(edtGWQ.Text));
     pnlPMoney.Visible := True;

     //�����б༭�����������Ϊֻ��
     edtRMB.ReadOnly := True;
     edtBank.ReadOnly := True;
     edtCZK.ReadOnly := True;
     edtGWQ.ReadOnly :=True;
     edtTotal.ReadOnly := True;

    //�½�һ���ɿ���ϸ���¼
    for i:=0 to 3  do
    begin
       with unqrySelect do
       begin
          Close;
          SQL.Clear;
          SQL.Add('insert into t_bi_penitydetail values(:a,:b,:c,:d,:e,:f)');
          ParamByName('a').Value:=Trim(DM_ZB_Common.vg_str_DepartmentID);     //�ŵ���
          ParamByName('b').Value:=StrToDateTime(lblSDate.Caption);           //����ʱ��
          ParamByName('c').Value:=Trim(liushuihao);                          //�ɿ���ˮ��
          ParamByName('d').Value:=IntToStr(i);                             //֧����ʽid
          ParamByName('e').Value:=a[i];                                   //Ӧ�ս��
          ParamByName('f').Value:=b[i];                                  //ʵ�ս��
          ExecSQL;
        end;
    end;

    //�½�һ���ɿ��¼
     with unqrySelect do
       begin
         // Close;
          SQL.Clear;
          SQL.Add('insert into t_bi_penalty values(:a,:b,:c,:d,:e,:f,:g)');
          ParamByName('a').Value:=Trim(DM_ZB_Common.vg_str_DepartmentID);     //�ŵ���
          ParamByName('b').Value:=StrToDateTime(lblSDate.Caption);           //����ʱ��
          ParamByName('c').Value:=Trim(liushuihao);                         //�ɿ���ˮ��
          ParamByName('d').Value:=Trim(lblCashierId.Caption);              //����ԱID
          ParamByName('e').Value:=Now;                                   //�ɿ�ʱ��
          ParamByName('f').Value:=StrToFloat(lbl_PTotal.Caption);        //ʵ���ܽ��
          ParamByName('g').Value:=StrToFloat(edtTotal.Text);            //Ӧ���ܽ��
          ExecSQL;
        end;
     Currency_time:=DM_ZB_Common.GetDBDatetime;//��ȡ���ݿ�ʱ��
     liushuihao:=generateLSH(Currency_time);    //������ˮ��
end;

//�༭��Ϸ����ж�
procedure TW_POS_SaleCheckForm.check_right(Sender: TObject; var Key: Char);
begin
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

//���¼���ת�����п��༭�� �����ϼ���ת������ȯ�༭��
procedure TW_POS_SaleCheckForm.edtRMBKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DOWN then
    edtBank.SetFocus
  else if Key = VK_UP then
    edtGWQ.SetFocus
  else if Key = VK_RETURN then
    edtBank.SetFocus;
end;

//���¼���ת����ֵ���༭�򣬰��ϼ���ת���ֽ�༭��
procedure TW_POS_SaleCheckForm.edtBankKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DOWN then
    edtCZK.SetFocus
  else if Key = VK_UP then
    edtRMB.SetFocus
  else if Key = VK_RETURN then
    edtCZK.SetFocus;
end;

//���¼���ת������ȯ���༭�򣬰��ϼ���ת�����п��༭��
procedure TW_POS_SaleCheckForm.edtCZKKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if Key = VK_DOWN then
    edtGWQ.SetFocus
   else if Key = VK_UP then
    edtBank.SetFocus
   else if Key = VK_RETURN then
    edtGWQ.SetFocus;
end;

//���¼���ת���ֽ�༭�򣬰��ϼ���ת����ֵ���༭��
procedure TW_POS_SaleCheckForm.edtGWQKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DOWN then
    edtRMB.SetFocus
  else if Key = VK_UP then
    edtCZK.SetFocus
  else if Key = VK_RETURN then
    //edtRMB.SetFocus;
    btnOK.SetFocus;
end;

//�˳���ǰ����
procedure TW_POS_SaleCheckForm.btnESCClick(Sender: TObject);
begin
  if Application.MessageBox('�Ƿ��˳��������˽��棡', 'ѯ��', MB_ICONQUESTION + MB_YESNO) = ID_YES then
    close;
end;

//�ֽ������ж�
procedure TW_POS_SaleCheckForm.edtRMBKeyPress(Sender: TObject;
  var Key: Char);
begin
 check_right(Sender,Key);
end;

//���п������ж�
procedure TW_POS_SaleCheckForm.edtBankKeyPress(Sender: TObject;
  var Key: Char);
begin
 check_right(Sender,Key);
end;

//��ֵ�������ж�
procedure TW_POS_SaleCheckForm.edtCZKKeyPress(Sender: TObject;
  var Key: Char);
begin
  check_right(Sender,Key);
end;

//����ȯ�����ж�
procedure TW_POS_SaleCheckForm.edtGWQKeyPress(Sender: TObject;
  var Key: Char);
begin
  check_right(Sender,Key);
end;

end.
