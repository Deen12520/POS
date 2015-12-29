unit C_MD_Return;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Buttons, DB, DBAccess, Uni, MemDS,
  DBClient, Mask, DBCtrls,DateUtils;

type
  TW_MD_ReturnForm = class(TForm)
    edtRetrn: TEdit;
    btnRetrn_Esc: TBitBtn;
    uniqueryTH: TUniQuery;
    dsFinProRetrn_Detail: TUniDataSource;
    lblTranNum: TLabel;
    lblPOSID: TLabel;
    lblCashID: TLabel;
    lblTranTime: TLabel;
    dbgrdTH: TDBGrid;
    btnRetrn: TButton;
    lblTotal: TLabel;
    lblCash: TLabel;
    unqrySelect: TUniQuery;
    intgrfldTHField: TIntegerField;
    lblCommId: TLabel;
    grp1: TGroupBox;
    grp2: TGroupBox;
    dbgrdJY: TDBGrid;
    lbl1: TLabel;
    edtSPMC: TEdit;
    lbl2: TLabel;
    edtTHSL: TEdit;
    uniqueryJY: TUniQuery;
    dsJY: TUniDataSource;
    intgrflduniquery2HH: TIntegerField;
    strngflduniquery2commodity_id: TStringField;
    strngflduniquery2commodity_name: TStringField;
    fltflduniquery2sale_price: TFloatField;
    fltflduniquery2sale_count: TFloatField;
    fltflduniquery2sale_total: TFloatField;
    strngfldRetrn_Detailcommodity_id: TStringField;
    strngfldRetrn_Detailcommodity_name: TStringField;
    fltfldRetrn_Detailsale_price: TFloatField;
    fltfldRetrn_Detailsale_count: TFloatField;
    fltfldRetrn_Detailsale_total: TFloatField;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    uniqueryTJ: TUniQuery;
    edtDH: TEdit;
    edtPOS: TEdit;
    edtSYY: TEdit;
    edtXJ: TEdit;
    edtZJ: TEdit;
    edtJYSJ: TEdit;
    lbl7: TLabel;
    lbl8: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnRetrn_EscClick(Sender: TObject);
    procedure intgrfldTHFieldGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure btnRetrnClick(Sender: TObject);
    procedure intgrflduniquery2HHGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtRetrnKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgrdJYDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
    procedure dsJYDataChange(Sender: TObject; Field: TField);
    procedure edtTHSLKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtRetrnChange(Sender: TObject);
  private
    { Private declarations }
  public

    { Public declarations }
  end;

var
  W_MD_ReturnForm: TW_MD_ReturnForm;
  temp_THCount:string;
  seq_num:Integer;
  comm_id:String;
  spid_temp : array[ 0..20] of string;        //��ȡ��ǰѡ���е���Ʒid
  spmc_temp : array[ 0..20] of string;       //��ȡ��ǰ���ݺŵ���Ʒ����
  scount_temp : array[ 0..20] of string;      //��ȡ��ǰ��Ʒ����������
 // j : Integer;    //����ѭ�����۽��׵���Ӧ�����۽����굥������
  k : Integer;    //����ѭ�����۽����굥��Ӧ�Ĳ�ͬ��Ʒ������

implementation
  uses C_ZB_DataModule,UnitAutoComplete;
{$R *.dfm}
var
  i:Integer=1;   //ͬһ�˻���ˮ���µ���Ʒ���
  liushuihao:string;  //��ǰ��ˮ��
  THshuihaohao:string;  //�˻���ˮ��
  LStrings: TStringList;    //�洢���ݵ�����
//��ʼʱҳ�治��ʾ
procedure TW_MD_ReturnForm.FormShow(Sender: TObject);
var
  temp,s_time,e_time : string;
  
begin
    s_time := DateTimeToStr(Now);
    e_time := DateTimeToStr(incday(Now,-7));//��ǰ����ǰ����

   //�ٶ���������ʵ��
    LStrings := TStringList.Create;
    //���������ֶ�  (��7��ļ�¼)
    with unqrySelect do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT trade_turnover_num from t_bi_saledeal where store_id=:p');
      SQL.Add(' and trade_time BETWEEN '''+e_time+'''  AND '''+s_time+''' limit 7');
      ParamByName('p').Value:=DM_ZB_Common.vg_str_DepartmentID;
      //ParamByName('a').Value:=e_time;
      //ParamByName('b').Value:=s_time;
      Open;
      if RecordCount<>0 then
        while not Eof do
        begin
           LStrings.Add(FieldByName('trade_turnover_num').AsString);
           Next;  //ָ������
        end;
    end;
    TAutoComplete.EnableAutoComplete(edtRetrn, LStrings, ACO_AUTOSUGGEST + ACO_UPDOWNKEYDROPSLIST);
    
   temp := 'select * from t_bi_saledeal'
    +' LEFT JOIN t_bi_saledealdetail on t_bi_saledeal.trade_turnover_num=t_bi_saledealdetail.tran_seri_num'
    +' where 1=2';
   if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
   DM_ZB_Common.SetupConnection;
   {��ʼ��ʱ��ʾ�ձ�}
   with uniqueryJY do
   begin
     SQL.Clear;
     SQL.Add(temp);
     Open;
   end;
   KeyPreview:=True;
end;

//�˳���ǰ����
procedure TW_MD_ReturnForm.btnRetrn_EscClick(Sender: TObject);
begin
  if Application.MessageBox(PChar('��ȷ��Ҫ�˳���'), 'ѯ��', MB_ICONQUESTION + MB_YESNO) = ID_YES then
      Self.Close;
end;

//�кŵ���
procedure TW_MD_ReturnForm.intgrfldTHFieldGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := IntToStr(unqrySelect.RecNo);
end;

//���ױ���������
procedure TW_MD_ReturnForm.intgrflduniquery2HHGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := IntToStr(uniqueryJY.RecNo);
end;

//����˻���ť��ת���˻�ҳ�棬����ѡ����Ʒ�����˻�ҳ��
// �˻��ɹ�����Ҫ��Ǯ��  TO Do
procedure TW_MD_ReturnForm.btnRetrnClick(Sender: TObject);
begin
    i:=1;
    //���˻���¼д�뵽���۽��ױ��У��Ƿ�����ֽ��Ƿ�����״̬���˻�����������
    if StrToFloat(edtXJ.Text)<-StrToFloat(lbl6.Caption) then
    begin
      lbl8.Caption:='�˿���ô����ֽ��޷��˻���';// �ԣϡ��ģ���Ҫɾ���˻�����
      //uniqueryTH.Delete;
    end
    else
    begin
       with uniqueryTJ do
       begin
          Close;
          SQL.Clear;
          SQL.Add('insert into t_bi_saledeal values(:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k)');
          ParamByName('a').Value:=Trim(DM_ZB_Common.vg_str_DepartmentID);     //�ŵ���
          ParamByName('b').Value:=Now();                                      //�˻�ʱ��
          ParamByName('c').Value:=Trim(THshuihaohao);                          //�˻���ˮ��
          ParamByName('d').Value:=Trim(DM_ZB_Common.vg_str_PosID);          //POS����
          ParamByName('e').Value:=StrToFloat(lbl6.Caption);                 //����Ӧ���ܶ�
          ParamByName('f').Value:=StrToFloat(lbl6.Caption);                //����ʵ���ܶ�

          ParamByName('g').Value:='';                        //��Ȩ��
          ParamByName('h').Value:='2';                                     //״̬
          ParamByName('i').Value:='';                  //��ԱID

          ParamByName('j').Value:=0;        //��Ա����
          ParamByName('k').Value:=Trim(DM_ZB_Common.vg_str_CashierID);      //����ԱID
          ExecSQL;

          //�˻���Ϣд��֧����Ϣ��
          Close;
          SQL.Clear;
          SQL.Add('insert into t_dealpaydetail values(:a,:b,:c,:d,:e,:f)');
          ParamByName('a').Value:=DM_ZB_Common.vg_str_DepartmentID;  //�ŵ����
          ParamByName('b').Value:=Now;       //����ʱ��
          ParamByName('c').Value:=THshuihaohao;       //�˻���ˮ��
          ParamByName('d').Value:='0';       //֧����ʽID ��Ĭ���ֽ��˿�
          ParamByName('e').Value:=StrToFloat(lbl6.Caption); //֧�����

          //*******To do �����ֵ���Ż��Ա����******
          ParamByName('f').Value:='';       //����
          ExecSQL;

       end;
       lbl8.Caption:='�˻��ɹ���';
       btnRetrn_Esc.SetFocus;
    end;

end;

//�������� �Լ� ��ݼ�����
procedure TW_MD_ReturnForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if(Key=#84) then   //T�������˻�
      btnRetrn.Click;

    if(Key=#27) then    //ESC���˳�
      btnRetrn_Esc.Click;
end;

//СƱ��ѯ
procedure TW_MD_ReturnForm.edtRetrnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  danjuhao : string;     //�����СƱ����
begin
    danjuhao:=Trim(edtRetrn.Text);
    if (Key=VK_RETURN) then
    begin
      //�����۽��ױ��л�ȡ�õ���pos���ţ�����Աid������ʱ��
      with  unqrySelect do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT a.trade_turnover_num,a.sale_pose_id,a.trade_time,a.cashier_id,a.sale_real_total,a.sale_real_total,b.pay_money ');
        SQL.Add(' from t_bi_saledeal  as a LEFT JOIN t_dealpaydetail as b ');
        SQL.Add(' on a.trade_turnover_num=b.tran_seri_num');
        SQL.Add(' WHERE a.trade_turnover_num=:a and b.pay_way_id=''0''');
        ParamByName('a').Value:=danjuhao;
        Open;

      end;
      if unqrySelect.RecordCount = 0 then
      begin
         showmessage('�޲�ѯ�����');
         btnRetrn.Enabled:=False;
         edtRetrn.SetFocus;
      end
      else
      begin
        btnRetrn.Enabled:=True;
        liushuihao:=danjuhao;    //��ǰ������ˮ��
         //����
         edtDH.Text:=liushuihao;
        // POS����
        edtPOS.Text:=unqrySelect.FieldValues['sale_pose_id'];
        //����ԱID
        edtSYY.Text:=unqrySelect.FieldValues['cashier_id'];
        //����ʱ��
        edtJYSJ.Text:=unqrySelect.FieldValues['trade_time'];
        //�ܼ�
        edtZJ.Text:=unqrySelect.FieldValues['sale_real_total'];
        //�ֽ�
        edtXJ.Text:=unqrySelect.FieldValues['pay_money'];

        //��Ʒ�б���Ϣ��ʾ
        with uniqueryJY do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM t_bi_saledealdetail where tran_seri_num=:a');
          ParamByName('a').Value:=danjuhao;
          Open;
        end;

        //Ĭ�Ͻ��������һ�У������ƶ� (���������DBgrid�вſ���)
        dbgrdJY.SetFocus;
        //uniqueryJY.Last;
        if key=vk_up then
            if uniqueryJY.Bof =false then
              uniqueryJY.Prior;
        if key=vk_down then
            if uniqueryJY.eof =false then
              uniqueryJY.next;


      end;
     
    end;

end;

//dbgrd1������ѡȡ����ɫ����
procedure TW_MD_ReturnForm.dbgrdJYDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  // dbgrid��options�������dgrowselect=true
  if gdselected in state then
     dbgrdJY.Canvas.Brush.Color:=clgradientinactivecaption
   else
     dbgrdJY.Canvas.Brush.Color := clwindow;
   dbgrdJY.DefaultDrawColumnCell(rect,datacol,column,state);
end;

//��ʾѡ���еļ�¼��Ϣ
procedure TW_MD_ReturnForm.dsJYDataChange(Sender: TObject; Field: TField);
begin

     if uniqueryJY.Eof and uniqueryJY.Bof then
        Exit
     else
     begin
       
        edtSPMC.Text:=uniqueryJY.FieldByName('commodity_name').AsString;
        edtTHSL.Text:=uniqueryJY.FieldByName('sale_count').AsString;
        edtTHSL.SetFocus;
        
     end;
end;

//���˻��б��м����˻���¼
procedure TW_MD_ReturnForm.edtTHSLKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  numTH:Double;   //�˻�����
  spbh,spmc:string;   //��Ʒ��š���Ʒ����
  spjg,spsl:double;     //��Ʒ�۸�

begin
   if (Key=VK_RETURN) then
    begin
      //1����ȡ��ǰСƱ�������ۻ�����Ϣ
      if uniqueryJY.Eof and uniqueryJY.Bof then
            Exit
      else
      begin
        spbh:=uniqueryJY.FieldByName('commodity_id').AsString;
        spmc:=uniqueryJY.FieldByName('commodity_name').AsString;
        spjg:=uniqueryJY.FieldByName('sale_price').AsFloat;
        spsl:=uniqueryJY.FieldByName('sale_count').AsFloat;
      end;

      //2�������µ��˻���ˮ��
      THshuihaohao:='R'+copy(liushuihao,2,Length(liushuihao));
      //ShowMessage(THshuihaohao);

      //3�������˻���¼

      numTH:=StrToFloat(edtTHSL.Text);
      //�˻��������ܴ��ڹ�������
      if numTH>spsl then
         lbl8.Caption:='�˻��������ܴ��ڹ�����������˶ԣ�'
      else if  -StrToFloat(lbl6.Caption)> StrToFloat(edtXJ.Text)  then
      begin
        lbl8.Caption:='�˻������ֽ��޷��˻�'
      end
      else
      begin
         with uniqueryTJ do
        begin
          Close;
          sql.Clear;
          SQL.Add('insert into t_bi_saledealdetail values(:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k,:l,:m)');
          ParamByName('a').Value:=IntToStr(i);                          //��ˮ�ŵ����
          ParamByName('b').Value:=DM_ZB_Common.vg_str_DepartmentID;         // �ŵ����
          ParamByName('c').Value:=Trim(THshuihaohao);                          //�˻���ˮ��
          ParamByName('d').Value:=Trim(spbh);                               //��Ʒ����
          ParamByName('e').Value:=Trim(spmc);                             //��Ʒ����
          ParamByName('f').Value:=spjg;                       //���۵���
          ParamByName('g').Value:=spjg;                        //���ۼ۸�
          ParamByName('h').Value:=spjg;                       //�ɱ�����
          ParamByName('i').Value:=-numTH;                  // �˻�����
          ParamByName('j').Value:=0.00;                                  //��������
          ParamByName('k').Value:=0.00;                                 //�����۸�
          ParamByName('l').Value:=-spjg*numTH;           //�˻��ܶ� (С��)
          ParamByName('m').Value:=0;                               //��Ա����
          ExecSQL;
        end;
        with uniqueryTH do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select * from t_bi_saledealdetail where tran_seri_num=:o');
          ParamByName('o').Value:=THshuihaohao;
          Open;
        end;
          i:=i+1;
    

        //4�������˻��������˻����
        with uniqueryTJ do
        begin
          Close;
          sql.Clear;
          sql.Add('SELECT SUM(sale_count) as THS,SUM(sale_total) THJE');
          SQL.Add(' FROM t_bi_saledealdetail where tran_seri_num =:a');
          ParamByName('a').Value:=THshuihaohao;
          Open;
          lbl4.Caption:=uniqueryTJ.FieldByName('THS').AsString;
          lbl6.Caption:=uniqueryTJ.FieldByName('THJE').AsString;
        end;
      end;

    end;

    //dbgrdJY.SetFocus;
end;

//�����б�ʵʱ����
procedure TW_MD_ReturnForm.edtRetrnChange(Sender: TObject);
var
  temp1,temp2:string;
begin
  temp1:=UpperCase(Trim(edtRetrn.Text));
  temp2:='SELECT trade_turnover_num from t_bi_saledeal where store_id=''1001'''+
     ' and (trade_turnover_num like '''+temp1+'%'')' +
     ' limit 5';
     {
   //�ٶ���������ʵ��
    //LStrings.Clear;  //�������
    //LStrings.Free;   //�ͷ�
    LStrings := TStringList.Create;
    //���������ֶ�
    with unqrySelect do
    begin
      Close;
      SQL.Clear;
      SQL.Add(temp2);
      //SQL.Add('SELECT trade_turnover_num from t_bi_saledeal');
      //SQL.Add(' where trade_turnover_num like ' +temp+'%');
      //SQL.Add(' and store_id=:p');
      //sql.Add(' limit 5');
      //ParamByName('p').Value:=DM_ZB_Common.vg_str_DepartmentID;
      //ParamByName('ID').Value:=quotedstr(temp+'%');
      //ParamByName('q').value:='%';
      Open;
      if RecordCount<>0 then
        while not Eof do
        begin
           LStrings.Add(FieldByName('trade_turnover_num').AsString);
           Next;  //ָ������
        end;
    end;
    TAutoComplete.EnableAutoComplete(edtRetrn, LStrings, ACO_AUTOSUGGEST + ACO_UPDOWNKEYDROPSLIST);
     }
end;

end.
