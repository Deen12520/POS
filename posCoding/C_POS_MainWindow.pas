unit C_POS_MainWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, DB, DBAccess, Uni, MemDS,
  OleCtrls, MSCommLib_TLB, Mask,strUtils,Math;

type
  TW_POS_MainWindow = class(TForm)
    pnl7: TPanel;
    pnl1: TPanel;
    lbl1: TLabel;
    pnl2: TPanel;
    pnl3: TPanel;
    pnl4: TPanel;
    lbl2: TLabel;
    pnl5: TPanel;
    pnl6: TPanel;
    pnl8: TPanel;
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    btn4: TButton;
    btn5: TButton;
    btn6: TButton;
    btn7: TButton;
    lbl3: TLabel;
    UniDataSource1: TUniDataSource;
    UniQuery1: TUniQuery;
    dbgrd1: TDBGrid;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    mscmIC1: TMSComm;
    intgrfldUniQuery1Xuhao: TIntegerField;
    unqryedit1: TUniQuery;
    strngfldUniQuery1commodity_id: TStringField;
    fltfldUniQuery1sale_price: TFloatField;
    fltfldUniQuery1sale_count: TFloatField;
    strngfldUniQuery1commodity_name: TStringField;
    fltfldUniQuery1sale_total: TFloatField;
    edt1: TEdit;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    unqryeditCX: TUniQuery;
    unqryeditTJ: TUniQuery;
    unqryeditVip: TUniQuery;
    lbl11: TLabel;
    lbl12: TLabel;
    lbl13: TLabel;
    lbl14: TLabel;
    lblHYH: TLabel;
    lblHYJF: TLabel;
    lblLQZE: TLabel;
    strngfldUniQuery1tran_seri_num: TStringField;
    lbl15: TLabel;
    intgrfldUniQuery1row_id: TIntegerField;
    dbgrdYSSP: TDBGrid;
    uniqueryYSSP: TUniQuery;
    ds1: TUniDataSource;
    strngfldYSSPshort_code: TStringField;
    strngfldYSSPcommodity_id: TStringField;
    intgrfldYSSP_XH: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btn2Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure intgrfldUniQuery1XuhaoGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    function generateLSH(var Currency_time:TDateTime):string;
    procedure dbgrd1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btn6Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edt1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn3Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure TotalNumAndFee(Sender: TObject;var liushuihao:string);
    procedure edt1KeyPress(Sender: TObject; var Key: Char);
    procedure intgrfldYSSP_XHGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  W_POS_MainWindow: TW_POS_MainWindow;
  //flag:Boolean=True;   //״̬λ���ж���ˮ���Ƿ�����
  //no:Integer=1;    //��ˮ��ĩβ5λ
  //quality:Double=1.0;    //����
  //spbh:string='S123456';   //��Ʒ���
  liushuihao:string;     //��ˮ��
  flag:Integer=0;  //�ж��ǵ�һ�ε�����ǵڶ��ε��
  spbm:string;            //��Ʒ����,��Ʒ��ѯ��ʹ��
  //TotalAmount:string='0.00';  //�ϼƽ��



implementation

{$R *.dfm}
uses C_ZB_DataModule, C_POS_quantity,C_POS_Vip, C_POS_Other, C_POS_guadan,
  C_POS_Settlement,C_POS_SQMa,C_MD_SPFin,C_POS_Login;
//�˿ڳ�ʼ��
var
  i:Integer=1;   //ͬһ��ˮ���µ���Ʒ���
procedure TW_POS_MainWindow.FormCreate(Sender: TObject);

begin
  //Ӧ�ó�����������壬�����崴��ʱ���õ�¼
  try
    W_POS_LoginForm := TW_POS_LoginForm.Create(nil);
    W_POS_LoginForm.Showmodal;
    if W_POS_LoginForm.ModalResult<>mrOk then
    begin
      Application.Terminate;
      Exit;
    end;
  finally
    W_POS_LoginForm.Free;
  end;
   KeyPreview := true;
end;

procedure TW_POS_MainWindow.FormShow(Sender: TObject);
var
  Currency_time:TDateTime;   //��ǰʱ��
begin
  if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
     DM_ZB_Common.SetupConnection;

     lbl6.Caption:=DM_ZB_Common.vg_str_CashierID;
     lbl15.Caption:='��ӭ�����������棡';

     //Ԥ����Ʒ������ʾ
     with uniqueryYSSP do
     begin
       Close;
       SQL.Clear;
       SQL.Add('SELECT * from t_bi_shortcode where store_id=:a');
       ParamByName('a').Value:=DM_ZB_Common.vg_str_DepartmentID;
       Open;
     end; 

    //UniQuery1.Active:=True;
    //��Ʒ�б���ʾ
    with UniQuery1 do
    begin
      Close;
      sql.Clear;
      SQL.Add('select * from t_bi_saledealdetail where 1=2');
      Open;
    end;
    Currency_time:=DM_ZB_Common.GetDBDatetime;//��ȡ���ݿ�ʱ��
    liushuihao:=generateLSH(Currency_time);    //������ˮ��
    lbl4.Caption:=DateTimeToStr(Now);
    edt1.SetFocus;
    //edt1.Clear;
    lbl8.Caption:='0.00';
    lbl10.Caption:='0.00';
end;

//��ݼ�����
procedure TW_POS_MainWindow.FormKeyPress(Sender: TObject; var Key: Char);
begin
    //�����µ���*ʱ�͵���button1
    if (Key = #42) then
       btn1.Click;  
    if (Key = #68) or (Key = #100) then
       btn2.Click;
    if (Key = #90) or (Key = #122) then
       btn3.Click;
    if (Key = #86) or (Key = #118) then
       btn4.Click;
    if (Key = #71) or (Key = #103) then
       btn5.Click;
    if (Key = #81) or (Key = #113) then
       btn6.Click;
    if (Key = #43) then
       btn7.Click;
end;

//ɾ�����ܵ�ʵ��
procedure TW_POS_MainWindow.btn2Click(Sender: TObject);
begin
  {
  with UniQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from t_bi_saledealdetail where tran_seri_num='''+liushuihao+'''');
    Open;
  end;
  if UniQuery1.RecordCount>=1 then
  begin
     //UniQuery1.Last;
     //UniQuery1.Delete;
     //dbgrd1.Update;
     dbgrd1.SelectedRows.Delete;

     TotalNumAndFee(Sender,liushuihao);    //�����ͽ��ͳ��
  end
  else
  begin
      lbl15.Caption:='��ǰ����Ʒ���޷�ɾ��';
      lbl8.Caption:='0.00';
      lbl10.Caption:='0.00';
  end;
  }
  if dbgrd1.DataSource.DataSet.IsEmpty then
  begin
      lbl15.Caption:='��ǰ����Ʒ���޷�ɾ��';
      lbl8.Caption:='0.00';
      lbl10.Caption:='0.00';
  end
  else
  begin
    UniQuery1.Delete;
  end;
  edt1.SelectAll;     //������ѡ���ı��������ı�
end;

//��Ա
procedure TW_POS_MainWindow.btn4Click(Sender: TObject);
var
 // t_sql:string;
  KJ_jf:Integer;   //�ۼ�����
begin
  //��̬����������ͷŴ���
  Application.CreateForm(TW_POS_VipForm,W_POS_VipForm);
  W_POS_VipForm.ShowModal;
  W_POS_VipForm.Free;

  //vipKH:=C_POS_Vip.vipKH;   //��ȡ��Ա����
  //t_sql:='select * from t_mem_membaseinfo where mem_card_id='''+vipKH+'''';
  with unqryeditVip do      //��ѯ��Ա��Ϣ
  begin
     SQL.Clear;
     SQL.Add('select * from t_mem_membaseinfo where mem_card_id=:a and card_status=''1''');
     ParamByName('a').Value:=vipKH;
     Open;
  end;
  //��ǰ����=�ۼ����ӻ���-�ۼ����ѻ���
  KJ_jf:=formalScore-unqryeditVip.FieldByName('mem_sub_point').AsInteger;
  //ShowMessage(IntToStr(jf));
  if vip_flag then
  begin
    lblHYH.Caption:=vipKH;
    lblHYJF.Caption:= IntToStr(KJ_jf);
    lblLQZE.Caption:=FloatToStr(formal_rest);   //numric ���Ϳ�ֱ��ʹ��asstring
    lbl15.Caption:='��Ա���룡';
  end
  else
  begin
     lblHYH.Caption:='';
     lblHYJF.Caption:= '';
     lblLQZE.Caption:='';   //numric ���Ϳ�ֱ��ʹ��asstring
  end;

  //lblLQZE.Caption:=unqryeditVip.FieldValues['change_total'];
  //ShowMessage('button4....');
  //���»�ԱID�����۽��ױ���  TO DO
 { with unqryeditVip do
  begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE t_bi_saledeal SET men_id=:a where trade_turnover_num=:b');
    ParamByName('a').Value:=lblHYH.Caption;
    ParamByName('b').Value:=liushuihao;
    ExecSQL;
  end; }

  edt1.SelectAll;     //������ѡ���ı��������ı�
end;

//**********����*********
procedure TW_POS_MainWindow.btn7Click(Sender: TObject);
var
  //Currency_time:TDateTime;   //��ǰʱ��
  onsaleLSH:string;      //��ǰ������ˮ��
  moneySS:Double;    //ʵ�ս��
begin

  //��ǰ���״����Ƿ�Ϊ��
   DM_ZB_Common.VG_ZB_ADOConnection.StartTransaction;  //��ʼһ������
  try   //�쳣��׽
     onsaleLSH:=UniQuery1.FieldByName('tran_seri_num').AsString;
     //��ǰ���۽��治Ϊ��
     if  onsaleLSH<>'' then
     begin
       //�ж���ֱ�����ۻ��Ǵӹҵ���������
       with unqryeditCX do
       begin
         Close;
         SQL.Clear;
         SQL.Add('select * from t_bi_saledeal where trade_turnover_num=:a');
         ParamByName('a').Value:=onsaleLSH;
         Open;
       end;
       //ֱ������
       if unqryeditCX.RecordCount<1 then
         with UniQuery1 do
         begin
            Close;
            SQL.Clear;
            SQL.Add('insert into t_bi_saledeal values(:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k)');
            ParamByName('a').Value:=Trim(DM_ZB_Common.vg_str_DepartmentID);     //�ŵ���
            ParamByName('b').Value:=Now();                                      //����ʱ��
            ParamByName('c').Value:=Trim(liushuihao);                          //������ˮ��
            ParamByName('d').Value:=Trim(DM_ZB_Common.vg_str_PosID);          //POS����
            ParamByName('e').Value:=StrToFloat(lbl10.Caption);                 //����Ӧ���ܶ�
            ParamByName('f').Value:=StrToFloat(lbl10.Caption);                //����ʵ���ܶ�
            //******To do ��Ȩ��ֵ���뽻�ױ���,��Ȩ����ڴ˴�������******

            ParamByName('g').Value:='';                        //��Ȩ��
            ParamByName('h').Value:='0';                                     //״̬
            ParamByName('i').Value:='';                  //��ԱID

            //TO do ��Ա����
            if lblHYJF.Caption<>'' then
                 ParamByName('j').Value:=StrToInt(lblHYJF.Caption)
            else
                 ParamByName('j').Value:=0;
            ParamByName('k').Value:=Trim(DM_ZB_Common.vg_str_CashierID);      //����ԱID
            ExecSQL;                         
          end;
       //�ӹҵ���������    TO do

        //��̬����������ͷŴ���
        Application.CreateForm(TW_POS_SettlementForm,W_POS_SettlementForm);
        W_POS_SettlementForm.ShowModal;
        W_POS_SettlementForm.Free;
        //�ж��Ƿ����ɹ�,����ɹ��޸Ľ���״̬
        //TO do
        if setflag then
        begin
           //����ʵ�ս��
           with unqryeditCX do
           begin
              Close;
              sql.Clear;
              sql.Add('select SUM(pay_money) as ss  from t_dealpaydetail where tran_seri_num=:a and store_id=:b');
              ParamByName('a').Value:=liushuihao;
              ParamByName('b').Value:=DM_ZB_Common.vg_str_DepartmentID;
              Open;
           end;
           moneySS:=unqryeditCX.FieldByName('ss').AsFloat;
           with unqryeditCX do
           begin
              Close;
              SQL.Clear;
              SQL.Add('UPDATE t_bi_saledeal SET status=''2'',author_code=:a,sale_real_total=:b where trade_turnover_num=:c');
              ParamByName('a').Value:=C_POS_SQMa.sqma;
              ParamByName('b').Value:=moneySS;
              ParamByName('c').Value:=onsaleLSH;
              ExecSQL;
           end;

       

           //���׳ɹ������ǻ�Ա��������Ա����
           //*******TO DO  Ӧ��ȥ�������*******
           if HY_flag then
           begin
              with unqryeditVip do
              begin
                Close;
                sql.Clear;
                SQL.Add('INSERT into t_mem_pointchangeinfo VALUES(:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k,:l,:m,:n,:o)');
                ParamByName('a').Value:=HY_ID;       //��ԱID
                ParamByName('b').Value:=vipKH;       //��Ա����
                ParamByName('c').Value:=Now;       //����ʱ��
                ParamByName('d').Value:=DM_ZB_Common.vg_str_DepartmentID;       //�����ŵ���
                ParamByName('e').Value:=DM_ZB_Common.vg_str_PosID;       //POS����
                ParamByName('f').Value:=DM_ZB_Common.vg_str_CashierID;       //����ԱID
                ParamByName('g').Value:=liushuihao;       //������ˮ��
                ParamByName('h').Value:=moneySS;       //�������
                ParamByName('i').Value:=formalScore;      //ԭ�ۼƻ��֣���������
                ParamByName('j').Value:=Floor(moneySS);       //���ֱ仯��
                ParamByName('k').Value:=formalScore+Floor(moneySS);       //���ۼƻ���
                ParamByName('l').Value:=formal_rest;      //ԭ��Ǯ
                ParamByName('m').Value:=0;       //��Ǯ�仯��
                ParamByName('n').Value:=formal_rest;       //����Ǯ
                ParamByName('o').Value:='';       //��ע
                ExecSQL;
              end;

              //���»�Ա�ۼƻ��֡��ۼ����Ѷ��Ǯ�������޸�ʱ�䡢�޸���
              with unqryeditVip do
              begin
                Close;
                sql.Clear;
                SQL.Add('UPDATE t_mem_membaseinfo SET mem_add_point=:a,mem_sum_sale_acco=:b,change_total=:c,modify_date=:d,modify_oper=:e');
                SQL.Add(' WHERE mem_card_id=:f');
                ParamByName('a').Value:=formalScore+Floor(moneySS);    //�ۼƻ���
                ParamByName('b').Value:=formal_totalXF+moneySS;    //�ۼ����Ѷ�
                ParamByName('c').Value:=formal_rest;    //��Ǯ�ܶ�   ???
                ParamByName('d').Value:=Now;    //�޸�ʱ��
                ParamByName('e').Value:=DM_ZB_Common.vg_str_CashierID;    //�޸���
                ParamByName('f').Value:=vipKH;
                ExecSQL;
              end;
              
              

           end;
           vipKH:='';   //��Ա����Ϊ��
           lblHYH.Caption:='';
           lblHYJF.Caption:='';
           lblLQZE.Caption:='';
           lbl8.Caption:='0.00';
           lbl10.Caption:='0.00';
           UniQuery1.Close;
          // Currency_time:=DM_ZB_Common.GetDBDatetime;//��ȡ���ݿ�ʱ��
           //liushuihao:=generateLSH(Currency_time);    //������ˮ��
           // W_POS_SettlementForm.ShowModal;
           i:=1;
        end
        else         //�ϵ�����
        begin
           with unqryeditCX do
           begin
              Close;
              SQL.Clear;
              SQL.Add('UPDATE t_bi_saledeal SET status=''3'' where trade_turnover_num=:a');
              ParamByName('a').Value:=liushuihao;
              ExecSQL;
           end;
           //Currency_time:=DM_ZB_Common.GetDBDatetime;//��ȡ���ݿ�ʱ��
           //liushuihao:=generateLSH(Currency_time);    //������ˮ��
           // W_POS_SettlementForm.ShowModal;
           i:=1;
        end;

      
     end
     else
     begin
       lbl15.Caption:='��ǰ����Ʒ���ۣ��޷����㣡';
     end;

     DM_ZB_Common.VG_ZB_ADOConnection.Commit;
  except
     DM_ZB_Common.VG_ZB_ADOConnection.Rollback;  //�¼��ع�
     ShowMessage('Error!');
     close;
  end;
  //UniQuery1.SQL.Clear;

end;

//�޸�����       //TO DO .....ҳ��ϸ��
procedure TW_POS_MainWindow.btn1Click(Sender: TObject);
//var
  //v_sql:='update t_bi_saledealdetail set sale_count=a''
begin
  //��̬����������ͷŴ���
  Application.CreateForm(TW_POS_quantityForm,W_POS_quantityForm);
  W_POS_quantityForm.ShowModal;
  W_POS_quantityForm.Free;
  quality:=C_POS_quantity.quality;
  with UniQuery1 do//uniquery1ֻ����ʾ����������sql����
  begin
    //UniQuery1.Locate('row_id',UniQuery1.FieldByName('row_id').value,[loPartialKey]);
    Edit;   //����༭״̬
    dbgrd1.DataSource.DataSet.FieldByName('sale_count').AsFloat:=quality;
    dbgrd1.DataSource.DataSet.FieldByName('sale_total').AsFloat:=quality*UniQuery1.FieldByName('sale_price').AsFloat;
    //UniQuery1.FieldByName('sale_count').AsFloat:=quality;
    //UniQuery1.FieldByName('sale_total').AsFloat:=quality*UniQuery1.FieldByName('sale_price').AsFloat;
    Post ;   //�ύ����
  end;
  TotalNumAndFee(Sender,liushuihao);    //�����ͽ��ͳ��
  //ShowMessage('******...');
  edt1.SelectAll;     //������ѡ���ı��������ı�
end;

procedure TW_POS_MainWindow.intgrfldUniQuery1XuhaoGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := IntToStr(UniQuery1.RecNo);  //�ڱ������ʾ�к�
end;

//��ˮ�����ɣ�20λ
function TW_POS_MainWindow.generateLSH(var Currency_time:TDateTime):string;
var
    m,s:string;
    mdstr,posstr,datestr:string;
    j:Integer;
    l_sql:string;
begin

    //to do ���ܲ���ȡ����     -----done!
    posstr:=DM_ZB_Common.vg_str_PosID;       //��ȡPOS���
    mdstr:=DM_ZB_Common.vg_str_DepartmentID;    //��ȡ�ŵ���
    //z_len:=4;   //   ��ˮ����5λ
    datestr:=FormatDateTime('yyyymmdd',Currency_time); //ʱ��תSting
    //endstring:=LeftStr(datestr,8);    //��ȡ���8λ
    s:='S'+mdstr+posstr+datestr;

    //to do ����ʱ�䡢�ŵ��š�pos�Ų�ѯ    -----done!
    // ȡ��ͬһ���е������ˮ��
    l_sql:='select max(trade_turnover_num) as ss from t_bi_saledeal'+
      ' where trade_turnover_num like '''+ trim(s)+'%''';
    with unqryeditCX do
    begin
      Close;
      SQL.Clear;
      SQL.Add(l_sql);
      Open;
    end;
    //ShowMessage(unqryeditCX.FieldByName('ss').Value);
    if (unqryeditCX.FieldByName('ss').Value='') then
      s:=s+'00000'
    else
    begin
      unqryeditCX.Last;
      m:=Trim(unqryeditCX.Fields.Fields[0].Value);
      j:=StrToInt(Trim(Copy(m,16,5)));
      //ShowMessage(IntToStr(i));
      if j<9 then
        s:=s+'0000'+IntToStr(j+1)
      else if j<99 then
        s:=s+'000'+IntToStr(j+1)
      else if j<999 then
        s:=s+'00'+IntToStr(j+1)
      else if j<9999 then
        s:=s+'0'+IntToStr(j+1)
      else
        s:=s+IntToStr(j+1);
    end;
    Result:=s;
    //ShowMessage(Result);      //Test
end;

//�˳�
procedure TW_POS_MainWindow.btn6Click(Sender: TObject);
var
  ExitFlag:Integer;
begin
   ExitFlag:=Application.MessageBox('�Ƿ�ȷ���˳�?','��ʾ',MB_ICONINFORMATION+MB_OkCancel);
  If ExitFlag=2 then//���˳�
    Begin
      Exit;
    end
  else
    Begin
      Application.Terminate;     //�˳�
    End;
end;

//�˳�ϵͳ
procedure TW_POS_MainWindow.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  ExitFlag:Integer;//�˳���־
begin
  ExitFlag:=Application.MessageBox('�Ƿ�ȷ���˳�?','��ʾ',MB_ICONINFORMATION+MB_OkCancel);
  If ExitFlag=2 then//���˳�
    Begin
    //TCloseAction = (caNone, caHide, caFree, caMinimize);
      Action:=caNone;
      Exit;
    end
  else
    Begin
      Application.Terminate;     //�˳�
    End;
end;

//dbgrd1������ѡȡ����ɫ����
procedure TW_POS_MainWindow.dbgrd1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  // dbgrid��options�������dgrowselect=true
  if gdselected in state then
     dbgrd1.Canvas.Brush.Color:=clgradientinactivecaption
   else
     dbgrd1.Canvas.Brush.Color := clwindow;
   dbgrd1.DefaultDrawColumnCell(rect,datacol,column,state);
end;

//ͨ����Ʒ�����ѯ�����鲻��������������������������ѡ���
procedure TW_POS_MainWindow.edt1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var

  //spbm:string;            //��Ʒ����
  v_sql1,v_sql3:string;
  rows:Integer;          //�к�
  spbh,spmc,splx_id,gys_id:string;   //��Ʒ��š���Ʒ����  ��Ʒ����ID ��Ӧ��ID
  spjg:double;     //��Ʒ�۸�
  //Currency_time:TDateTime;   //��ǰʱ��
  edtLengh:Integer;   //�ַ�����
  comId:string;  //ͨ�������ѯ������Ʒ�Ա���
  Currency_time:TDateTime;   //��ǰʱ��

begin

  if (Key=VK_RETURN)  then
  begin
    //�жϵ�ǰ�����б��Ƿ�Ϊ��*****To  Do
   if dbgrd1.DataSource.DataSet.IsEmpty then
   begin
      //vipKH:='';   //��Ա����Ϊ��
      //lblHYH.Caption:='';
      //lblHYJF.Caption:='';
     // lblLQZE.Caption:='';
      Currency_time:=DM_ZB_Common.GetDBDatetime;//��ȡ���ݿ�ʱ��
      liushuihao:=generateLSH(Currency_time);    //������ˮ��
   end;
  
  //To DO ***����2λ����Ʒ��������3λģ����ѯ****

  spbm:=Trim(edt1.Text);
  edtLengh:=Length(spbm);    //������ַ�����
  if edtLengh<2 then
  begin
     lbl15.Caption:='��������ַ�����2λ,���������룡';
     edt1.SetFocus;
  end
  //�����ѯ
  else if edtLengh=2 then
  begin
     with uniqueryYSSP do
     begin
       Close;
       sql.Clear;
       SQL.Add('SELECT * FROM t_bi_shortcode WHERE short_code=:a and store_id=:b');
       ParamByName('a').Value:=spbm;
       ParamByName('b').Value:=DM_ZB_Common.vg_str_DepartmentID;
       Open;
     end;
     //ͨ������δ�鵽��¼
     if uniqueryYSSP.RecordCount<1 then
     begin
       lbl15.Caption:='δ�ҵ���¼����˶Ժ����룡';
       edt1.SetFocus;
     end
     else
     //TO Do ���뾫ȷ��ѯ���鵽֮���Զ�������Ʒ���б���? ���Ա������뵽edit��
     begin
        comId:=uniqueryYSSP.FieldByName('commodity_id').AsString;
        //edt1.Text:=comId;
        //�ҵ�����Ʒ����ֱ�Ӽ��뵽��Ʒ�����б���
        v_sql1:='select * from t_bi_commbaseinfo'+
         ' where commodity_id = '''+comID+''' and status=''1''';                       //whereǰ���һ���ո�
        with unqryedit1 do
        begin
           close;
           SQL.Clear;
           SQL.Add(v_sql1);
           Open;
        end;
        //���ܳ��ֶ����ϵı�Ź����������ͨ�������Ҳ�����Ʒ
        if unqryedit1.RecordCount<1 then
        begin
           lbl15.Caption:='δ�ҵ���¼����˶Ըö����Ƿ���ڣ�';
        end
        else
        begin

          //spbh:=unqryedit1.Fields.Fields[0].Value;       //��Ʒ���
          //spmc:=unqryedit1.Fields.Fields[1].Value;       //��Ʒ����
         // spjg:=unqryedit1.Fields.Fields[2].Value;       //��Ʒ�۸�
          spbh:=unqryedit1.FieldByName('commodity_id').AsString;       //��Ʒ���
          spmc:=unqryedit1.FieldByName('commodity_name').AsString;       //��Ʒ����
          spjg:=unqryedit1.FieldByName('retail_price').AsFloat;      //��Ʒ�۸�
          //splx_id:=unqryedit1.FieldByName('comm_type_id').AsString;  //��Ʒ����ID
          //gys_id:=unqryedit1.FieldByName('main_supplier').AsString;  // ��Ӧ��ID

          quality:=1.0;  //����Ĭ��Ϊ1

          {//����---����ṹ��
          sd[i].commodity_id:=spbh;
          sd[i].Sale_num:=quality;
          sd[i].SalePrice:=spjg;
          sd[i].CommType:=splx_id;
          sd[i].SupplierID:=gys_id;}


           with UniQuery1 do
           begin
               //�����ݲ�����Ʒ������Ϣ��
               begin
                  Close;
                  SQL.Clear;
                  //SQL.Add(v_sql2);
                  SQL.Add('insert into t_bi_saledealdetail values(:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k,:l,:m)');
                  ParamByName('a').Value:=IntToStr(i);                     //��ˮ�ŵ����
                  ParamByName('b').Value:=DM_ZB_Common.vg_str_DepartmentID;         // �ŵ����
                  ParamByName('c').Value:=Trim(liushuihao);                          //������ˮ��
                  ParamByName('d').Value:=Trim(spbh);                               //��Ʒ����
                  ParamByName('e').Value:=Trim(spmc);                             //��Ʒ����
                  ParamByName('f').Value:=FloatToStr(spjg);                       //���۵���
                  ParamByName('g').Value:=FloatToStr(spjg);                        //���ۼ۸�
                  ParamByName('h').Value:=FloatToStr(spjg);                       //�ɱ�����
                  ParamByName('i').Value:=FloatToStr(quality);                  // ��������
                  ParamByName('j').Value:=0.00;                                  //��������
                  ParamByName('k').Value:=0.00;                                 //�����۸�
                  ParamByName('l').Value:=FloatToStr(spjg*quality);           //�����ܶ� (С��)
                  ParamByName('m').Value:=0;                               //��Ա����
                  ExecSQL;
               end;
               begin
                  Close;
                  SQL.Clear;
                  SQL.Add('select * from t_bi_saledealdetail where tran_seri_num=:a');
                  ParamByName('a').Value:=liushuihao;
                  Open;
               end;
               i:=i+1;
           end;
           TotalNumAndFee(Sender,liushuihao);    //�����ͽ��ͳ��
        end;
     end;
  end
  else
  //3λ����ģ����ѯ
  begin
     v_sql1:='select commodity_id,commodity_name,retail_price from t_bi_commbaseinfo'+
     ' where status=''1'' and commodity_id like '''+spbm+'%''';             //whereǰ���һ���ո�
      with unqryedit1 do
      begin
         close;
         SQL.Clear;
         SQL.Add(v_sql1);
         Open;
      end;
     //Currency_time:=DM_ZB_Common.GetDBDatetime;
     rows:=unqryedit1.RecordCount;     //��ѯ���ļ�¼��

     if  rows<1 then
        ShowMessage('û�в�ѯ����¼�����������룡')
     else if rows>1 then
     begin
        //ShowMessage('����һ����Ʒ��ѯ��')
        Application.CreateForm(TW_MD_SPFinForm,W_MD_SPFinForm);
        W_MD_SPFinForm.ShowModal;
        W_MD_SPFinForm.Free;
        //W_MD_SPFinForm.ShowModal;
        //�ж��Ƿ��ѯ�ɹ�
        if CX_flag then
        begin
            with unqryeditCX do
            begin
              Close;
              sql.Clear;
              SQL.Add('select * from t_bi_commbaseinfo where status=''1'' and commodity_id=:a');
              ParamByName('a').Value:=CX_spmb;
              Open;
            end;
            spbh:=unqryeditCX.FieldByName('commodity_id').AsString;       //��Ʒ���
            spmc:=unqryeditCX.FieldByName('commodity_name').AsString;       //��Ʒ����
            spjg:=unqryeditCX.FieldByName('retail_price').AsFloat;      //��Ʒ�۸�

            //splx_id:=unqryeditCX.FieldByName('comm_type_id').AsString;  //��Ʒ����ID
            //gys_id:=unqryeditCX.FieldByName('main_supplier').AsString;  // ��Ӧ��ID

            quality:=1.0;  //����Ĭ��Ϊ1

            {//����---����ṹ��
            sd[i].commodity_id:=spbh;
            sd[i].Sale_num:=quality;
            sd[i].SalePrice:=spjg;
            sd[i].CommType:=splx_id;
            sd[i].SupplierID:=gys_id;    }

            with UniQuery1 do
            begin
               //�����ݲ�����Ʒ������Ϣ��
               begin
                  Close;
                  SQL.Clear;
                  //SQL.Add(v_sql2);
                  SQL.Add('insert into t_bi_saledealdetail values(:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k,:l,:m)');
                  ParamByName('a').Value:=IntToStr(i);                      //��ˮ�ŵ����
                  ParamByName('b').Value:=DM_ZB_Common.vg_str_DepartmentID;         // �ŵ����
                  ParamByName('c').Value:=Trim(liushuihao);                          //������ˮ��
                  ParamByName('d').Value:=Trim(spbh);                               //��Ʒ����
                  ParamByName('e').Value:=Trim(spmc);                             //��Ʒ����
                  ParamByName('f').Value:=FloatToStr(spjg);                       //���۵���
                  ParamByName('g').Value:=FloatToStr(spjg);                        //���ۼ۸�
                  ParamByName('h').Value:=FloatToStr(spjg);                       //�ɱ�����
                  ParamByName('i').Value:=FloatToStr(quality);                  // ��������
                  ParamByName('j').Value:=0.00;                                  //��������
                  ParamByName('k').Value:=0.00;                                 //�����۸�
                  ParamByName('l').Value:=FloatToStr(spjg*quality);           //�����ܶ� (С��)
                  ParamByName('m').Value:=0;                                  //��Ա����
                  ExecSQL;
               end;
               begin
                  Close;
                  SQL.Clear;
                  SQL.Add('select * from t_bi_saledealdetail where tran_seri_num=:a');
                  ParamByName('a').Value:=liushuihao;
                  Open;
               end;
               i:=i+1;
           end;
           TotalNumAndFee(Sender,liushuihao);    //�����ͽ��ͳ��

        end;
     end
     else
     begin
       //spbh:=unqryedit1.Fields.Fields[0].Value;       //��Ʒ���
       //spmc:=unqryedit1.Fields.Fields[1].Value;       //��Ʒ����
       //spjg:=unqryedit1.Fields.Fields[2].Value;       //��Ʒ�۸�
       spbh:=unqryedit1.FieldByName('commodity_id').AsString;       //��Ʒ���
       spmc:=unqryedit1.FieldByName('commodity_name').AsString;       //��Ʒ����
       spjg:=unqryedit1.FieldByName('retail_price').AsFloat;      //��Ʒ�۸�
       //splx_id:=unqryedit1.FieldByName('comm_type_id').AsString;  //��Ʒ����ID
       //gys_id:=unqryedit1.FieldByName('main_supplier').AsString;  // ��Ӧ��ID

        quality:=1.0;  //����Ĭ��Ϊ1
       begin

        {//����---����ṹ��
        sd[i].commodity_id:=spbh;
        sd[i].Sale_num:=quality;
        sd[i].SalePrice:=spjg;
        sd[i].CommType:=splx_id;
        sd[i].SupplierID:=gys_id; }
        {
        v_sql2:='insert into t_bi_saledealdetail(tran_seri_num,commodity_id,commodity_name,sale_price,sale_count,sale_total)'+
           ' values('''+liushuihao+''','''+spbh+''','''+spmc+''','+FloatToStr(spjg)+','+FloatToStr(quality)+','+FloatToStr(spjg*quality)+')';
        }
        v_sql3:='select * from t_bi_saledealdetail where tran_seri_num='''+liushuihao+'''';
        //v_sql4:='select * from t_bi_saledealdetail where tran_seri_num='''+liushuihao+''''+
                   // ' and commodity_id='''+trim(spbh)+'''';


        //to do ��ͬɨ���¼���ظ�����  -------done!
       with UniQuery1 do
       begin
           //�����ݲ�����Ʒ������Ϣ��
           begin
              Close;
              SQL.Clear;
              //SQL.Add(v_sql2);
              SQL.Add('insert into t_bi_saledealdetail values(:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k,:l,:m)');
              ParamByName('a').Value:=IntToStr(i);                     //��ˮ�ŵ����
              ParamByName('b').Value:=DM_ZB_Common.vg_str_DepartmentID;         // �ŵ����
              ParamByName('c').Value:=Trim(liushuihao);                          //������ˮ��
              ParamByName('d').Value:=Trim(spbh);                               //��Ʒ����
              ParamByName('e').Value:=Trim(spmc);                             //��Ʒ����
              ParamByName('f').Value:=FloatToStr(spjg);                       //���۵���
              ParamByName('g').Value:=FloatToStr(spjg);                        //���ۼ۸�
              ParamByName('h').Value:=FloatToStr(spjg);                       //�ɱ�����
              ParamByName('i').Value:=FloatToStr(quality);                  // ��������
              ParamByName('j').Value:=0.00;                                  //��������
              ParamByName('k').Value:=0.00;                                 //�����۸�
              ParamByName('l').Value:=FloatToStr(spjg*quality);           //�����ܶ� (С��)
              ParamByName('m').Value:=0;                               //��Ա����
              ExecSQL;
           end;
           begin
              Close;
              SQL.Clear;
              SQL.Add(v_sql3);
              Open;
           end;
           i:=i+1;
       end;
       TotalNumAndFee(Sender,liushuihao);    //�����ͽ��ͳ��

     end;
    end;
  end;




  // spjg:=1.0;


       //Ĭ�Ͻ��������һ�У������ƶ� (���������DBgrid�вſ���)
      UniQuery1.Last;
      if key=vk_up then
          if uniquery1.Bof =false then
            uniquery1.Prior;
      if key=vk_down then
          if uniquery1.eof =false then
            uniquery1.next;
     edt1.SelectAll;     //������ѡ���ı��������ı�
  end;
end;

//�����ͽ��ͳ��
procedure TW_POS_MainWindow.TotalNumAndFee(Sender: TObject;var liushuihao:string);

begin
   with  unqryeditTJ do
     begin                              
       SQL.Clear;
       SQL.Add('select sum(sale_count),sum(sale_total) from t_bi_saledealdetail');
       SQL.Add('where tran_seri_num='''+liushuihao+'''');
       Open;
     end;
    // ShowMessage(unqryeditTJ.Fields.Fields[0].AsString);
    //TotalAmount:=unqryeditTJ.Fields.Fields[1].AsString;
    lbl8.Caption:=unqryeditTJ.Fields.Fields[0].AsString;
    lbl10.Caption:=unqryeditTJ.Fields.Fields[1].AsString;

end;

//����
procedure TW_POS_MainWindow.btn3Click(Sender: TObject);
begin
  //��̬����������ͷŴ���
  Application.CreateForm(TW_POS_OtherForm,W_POS_OtherForm);
  W_POS_OtherForm.ShowModal;
  W_POS_OtherForm.Free;
  W_POS_OtherForm:=nil;
//ShowMessage('112234');
end;

//�ҵ�
procedure TW_POS_MainWindow.btn5Click(Sender: TObject);
var
  gd_sql1,onsaleLSH:string;    //��ǰ��ˮ��
  //Currency_time:TDateTime;   //��ǰʱ��
begin
  //****1���������ۣ��ҵ�����ǰ�Ľ��׼�¼��ӵ��ҵ���Ϣ����***
  //****3�����ж����ҵ���¼��ѡ����Ӧ�Ĺҵ��ţ���������**

   DM_ZB_Common.VG_ZB_ADOConnection.StartTransaction;  //��ʼһ������
   try   //�쳣��׽
     onsaleLSH:=UniQuery1.FieldByName('tran_seri_num').AsString;

     //��ǰ���۽��治Ϊ��
     if  onsaleLSH<>'' then
     begin
        //��ѯ��ǰ��ˮ���Ƿ�����ڹҵ�����
       with unqryeditCX do
       begin
          Close;
          sql.Clear;
          SQL.Add('select * from t_bi_saledeal where trade_turnover_num=:a and status=''0''');
          ParamByName('a').Value:=Trim(onsaleLSH);
          Open;
       end;
       if (unqryeditCX.RecordCount<1) then
       begin
          //����ˮ�Ų����ڹҵ���Ϣ����
          with UniQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('insert into t_bi_saledeal values(:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k)');
            ParamByName('a').Value:=Trim(DM_ZB_Common.vg_str_DepartmentID);     //�ŵ���
            ParamByName('b').Value:=Now();                                      //����ʱ��
            ParamByName('c').Value:=Trim(liushuihao);                          //������ˮ��
            ParamByName('d').Value:=Trim(DM_ZB_Common.vg_str_PosID);          //POS����
            ParamByName('e').Value:=StrToFloat(lbl10.Caption);                //����Ӧ���ܶ�
            ParamByName('f').Value:=StrToFloat(lbl10.Caption);                //����ʵ���ܶ�
            ParamByName('g').Value:='';                                         //��Ȩ��
            ParamByName('h').Value:='1';                                     //״̬

            ParamByName('i').Value:='';                                         //��ԱID
            //TO do ��Ա����
            if lblHYJF.Caption<>'' then
               ParamByName('j').Value:=StrToInt(lblHYJF.Caption)
            else
               ParamByName('j').Value:=0;
            ParamByName('k').Value:=Trim(DM_ZB_Common.vg_str_CashierID);      //����ԱID
            ExecSQL;
          end;

          //*******TO do,  �������������������ͬ��Ʒ��������ˮ��******
          //Currency_time:=DM_ZB_Common.GetDBDatetime;//��ȡ���ݿ�ʱ��
          //liushuihao:=generateLSH(Currency_time);    //������ˮ��
       end
       else
       //����ˮ�Ŵ��ڹҵ���Ϣ����
       begin
          unqryeditCX.Edit;
          unqryeditCX.FieldByName('status').AsString:='1';
          unqryeditCX.Post;
          UniQuery1.Close;
          
       end;
       //�ҵ��ɹ��������µ���ˮ��,�����µĽ���
        lbl15.Caption:='�ҵ��ɹ���';
        //Currency_time:=DM_ZB_Common.GetDBDatetime;//��ȡ���ݿ�ʱ��
        //liushuihao:=generateLSH(Currency_time);    //������ˮ��
     end
     //��ǰ���۽���Ϊ��
     else
     begin
       //�ж��Ƿ��йҵ���Ϣ
        with unqryeditCX do
        begin
          Close;
          sql.Clear;
          SQL.Add('select * from t_bi_saledeal where status=''1''');
          Open;
        end;
        if unqryeditCX.RecordCount<1 then
        begin
           lbl15.Caption:='��ǰ����Ʒ���ۣ����ܹҵ���';
        end
        //ֻ��һ���ҵ���Ϣ��ֱ�ӷ������۽���
        else  if unqryeditCX.RecordCount=1 then
        begin
            gd_sql1:='SELECT * FROM t_bi_saledealdetail'+
            ' where tran_seri_num='+
            '(SELECT trade_turnover_num from t_bi_saledeal'+
            ' WHERE status=''1'')';


            with UniQuery1 do
            begin
              Close;
              SQL.Clear;
              SQL.Add(gd_sql1);
              Open;
            end;
            onsaleLSH:=UniQuery1.FieldByName('tran_seri_num').AsString;
            TotalNumAndFee(Sender,onsaleLSH);    //�����ͽ��ͳ��

            //�������۽��棬�޸�״̬Ϊ0
            with  unqryeditCX do
            begin
              Close;
              SQL.Clear;
              SQL.Add('update t_bi_saledeal set status=''0'' where trade_turnover_num=:a');
              ParamByName('a').Value:=onsaleLSH;
              ExecSQL;
            end;
            lbl15.Caption:='�����ҵ��ɹ���';
        end
        //�ж����ҵ���Ϣ�������ҵ�����
        else
        begin
            //��̬����������ͷŴ���
            Application.CreateForm(TW_POS_guadanForm,W_POS_guadanForm);
            W_POS_guadanForm.ShowModal;
            W_POS_guadanForm.Free;
            gd_sql1:='SELECT * FROM t_bi_saledealdetail'+
            ' where tran_seri_num='+
            '(SELECT trade_turnover_num from t_bi_saledeal'+
            ' WHERE status=''0'')';
            with UniQuery1 do
            begin
              SQL.Clear;
              SQL.Add(gd_sql1);
              Open;
            end;
            onsaleLSH:=UniQuery1.FieldByName('tran_seri_num').AsString;
            TotalNumAndFee(Sender,onsaleLSH);    //�����ͽ��ͳ��

            //�������۽��棬�޸�״̬Ϊ0
            with  unqryeditCX do
            begin
              Close;
              SQL.Clear;
              SQL.Add('update t_bi_saledeal set status=''0'' where trade_turnover_num=:a');
              ParamByName('a').Value:=onsaleLSH;
              ExecSQL;
            end;
            lbl15.Caption:='�����ҵ��ɹ���';
        end;

     end;

     DM_ZB_Common.VG_ZB_ADOConnection.Commit;
  except
     DM_ZB_Common.VG_ZB_ADOConnection.Rollback;  //�¼��ع�
     ShowMessage('Error!');
     close;
  end;
 end;

 //�༭����������
procedure TW_POS_MainWindow.edt1KeyPress(Sender: TObject; var Key: Char);
begin
    if not (Key in ['0'..'9',#13,#8]) then
       key:=#0;
end;

//Ԥ����Ʒ�к����
procedure TW_POS_MainWindow.intgrfldYSSP_XHGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text:=IntToStr(uniqueryYSSP.RecNo);  //�ڱ������ʾ�к�
end;

end.

