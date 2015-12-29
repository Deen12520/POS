unit C_POS_Settlement;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, MemDS, DBAccess, Uni, Grids, DBGrids, ExtCtrls, StrUtils,
  Mask,DateUtils;

type
  TW_POS_SettlementForm = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    grp1: TGroupBox;
    grp2: TGroupBox;
    pnl3: TPanel;
    lbl1: TLabel;
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    btn4: TButton;
    btn5: TButton;
    btn6: TButton;
    btn7: TButton;
    btn8: TButton;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    pnl4: TPanel;
    dbgrd1: TDBGrid;
    uniqueryHJ: TUniQuery;
    uniqueryZFFS: TUniQuery;
    ds1: TUniDataSource;
    lbl10: TLabel;
    edtJE: TEdit;
    strngfldZFFSpay_way_name: TStringField;
    intgrfldZFFS_XH: TIntegerField;
    uniqueryZF_Sol: TUniQuery;
    fltfldZFFSpay_money: TFloatField;
    btnLQ: TButton;
    lbl11: TLabel;
    lbl12: TLabel;
    con1: TUniConnection;
    uniqueryJSCX: TUniQuery;
    procedure FormShow(Sender: TObject);
    procedure edtJEKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtJEKeyPress(Sender: TObject; var Key: Char);
    procedure intgrfldZFFS_XHGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure btnLQClick(Sender: TObject);
    procedure Print80;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  W_POS_SettlementForm: TW_POS_SettlementForm;
  setflag:Boolean=False;  //��־λ����־�Ƿ���֧���ɹ�
  moneyYS:Double;    //Ӧ�ս��
  tradeLSH:string;     //������ˮ��
  //paywayName:string='�ֽ�';    //֧������
  HY_flag:Boolean;  // �Ƿ��ǻ�Ա
  HY_ID:string;   //��ԱID
 // formalScore:Integer; //ԭ����
 // formal_rest:Double;  //ԭ��Ǯ
implementation

uses C_ZB_DataModule, C_POS_Bank, C_POS_CZcard, C_POS_SQMa,C_POS_YJia,
      C_POS_OtherPayWay,C_POS_Vip,C_POS_UserChange,cx;
      //C_POS_inputChange,cx
const
// ĩβ��ֽ����
c_run_paper_lines = 6;
// ESCָ�� ��Ǯ��
c_OpenMoneyBoxCommand = CHR(27) + CHR(112) + CHR(0) + CHR(17) + CHR(8);
// ESCָ�� �Զ���ֽ
c_cut_paper = CHR(29) + CHR(86) + CHR(66) + CHR(0);

{$R *.dfm}
var
  paywayName:string='�ֽ�';    //֧������
  //moneyYS:Double;    //Ӧ�ս��
  //tradeLSH:string;     //������ˮ��
  moneyRest:Double;   //����

//POSСƱ��ӡ
procedure TW_POS_SettlementForm.Print80;
var
  sPort: string;
  RPrinter: TextFile;
  i: Integer;
  sBill, sPortType: string;
  MyList: TStringList;
  BillId: string;
  sXH,sTmp: string;
  iTmp: Integer;
  sMoney: string;
  sGoodName,tradeLSH: string;
  iLen: Integer;
  sTmp2: string;
  BalanceAmount: Double;   //ʵ�����۶�
begin
  // ����һ��СƱ���ı��ļ�
  sBill := ExtractFilePath(Application.ExeName) + 'bill.txt';
  AssignFile(RPrinter, sBill);
  Rewrite(RPrinter);
  try
    // ����             
    Writeln(RPrinter, ' ' +DM_ZB_Common.vg_str_CompanyName);
    Writeln(RPrinter, '���� �տ�Ա ������ˮ��');

    sTmp := DM_ZB_Common.vg_str_PosID + ' ' + DM_ZB_Common.vg_str_CashierID;
    iTmp := 32 - Length(sTmp);

    //��ȡ��ǰ��Ʒ���۽��ױ�
    with uniqueryHJ do
    begin
      Close;
      sql.Clear;
      SQL.Add('select * from t_bi_saledeal where status=:a');
      ParamByName('a').Value:='0';
      Open;
    end;
    tradeLSH:=uniqueryHJ.FieldByName('trade_turnover_num').AsString;  //�����ˮ��
    BalanceAmount:=uniqueryHJ.FieldByName('sale_real_total').AsFloat;  //ʵ�����۶�

    //��ȡ��ǰ��Ʒ������ϸ���ױ�
    with uniqueryHJ do
    begin
      Close;
      sql.Clear;
      SQL.Add('SELECT * from t_bi_saledealdetail WHERE tran_seri_num=:b');
      ParamByName('b').Value:=tradeLSH;
      Open;
    end;

    i := Length(tradeLSH);
    while i < iTmp do
    begin
      BillId := BillId + ' ';
      i := i + 1;
    end;
    BillId := BillId + tradeLSH;

    Writeln(RPrinter, sTmp + BillId);
    Writeln(RPrinter, '��ӡʱ�䣺' + FormatDatetime('yyyy-mm-dd hh:nn', now));

    Writeln(RPrinter, '-------------------------------------');
    Writeln(RPrinter, 'Ʒ��     ����   ����   С��');
    uniqueryHJ.First;
    while not uniqueryHJ.Eof do
    begin
      // ���
      sXH := IntToStr(uniqueryHJ.FieldByName('row_id').AsInteger);
      while Length(sXH) < 2 do
      begin
        sXH := sXH + ' ';
      end;
      // ���
      sMoney := FormatFloat('0.00', uniqueryHJ.FieldByName('sale_total').AsFloat);
      i := Length(sMoney);
      sTmp := '';
      while i < 9 do
      begin
        sTmp := sTmp + ' ';
        i := i + 1;
      end;
      sMoney := sTmp + sMoney;
      // ��Ʒ����
      sGoodName := uniqueryHJ.FieldByName('commodity_name').AsString;
      iLen := Length(sGoodName);
      while iLen < 9 do
      begin
        sGoodName := sGoodName + ' ';
        iLen := iLen + 1;
      end;
      Writeln(RPrinter, sXH + ' ' + sGoodName + FormatFloat('0.00',
      uniqueryHJ.FieldByName('sale_price').AsFloat) + '      '
      + FormatFloat('0.00', uniqueryHJ.FieldByName('sale_count').AsFloat) + sMoney);
      uniqueryHJ.Next;
    end;
    Writeln(RPrinter, '-------------------------------------');
    Writeln(RPrinter, '��' + FormatFloat('0.00',BalanceAmount));
    Writeln(RPrinter, sTmp2);
    Writeln(RPrinter, ' лл�ݹ�!');
    // ĩβ��ֽ ����
    for i := 1 to c_run_paper_lines do
    Writeln(RPrinter, '');
  finally
    CloseFile(RPrinter);
  end;
  if SameText(DM_ZB_Common.PrintPort, 'lpt') then // ֱ�Ӳ������ ��Ҫ��װƱ������
  begin
    // ��ȡ�ı��ļ���ӡСƱ
    sPort := 'LPT1';
    MyList := TStringList.Create;
    try
        AssignFile(RPrinter, sPort);
        try
          Rewrite(RPrinter);
          MyList.LoadFromFile(sBill);
          for i := 0 to MyList.Count - 1 do
          begin
            Writeln(RPrinter, MyList.Strings[i]);
          end;
          // ��Ǯ��
          write(RPrinter, c_OpenMoneyBoxCommand);
          write(RPrinter, c_cut_paper);
          CloseFile(RPrinter);
        except
      // ���LPT1�˿ڲ����ڣ��ᱨ��the specified file not found
      // ��Щ���岻�ṩLPT���ڣ������δ����޷�����
        end;
    finally
     MyList.Free;
    end;
  end
   {
  else if SameText(DM_ZB_Common.PrintPort, 'usb') then // ��Ҫ��װƱ������
  begin
    try
      RichEdit1.Font.Size := 12;
      RichEdit1.Lines.Clear;
      RichEdit1.Lines.LoadFromFile(sBill);
      RichEdit1.Print('');
      if UserInfo.openMoneyBox = 1 then
         OpenUSBMoneyBox;
    except
      on e: Exception do
      SysLog.WriteLog('TfrmReprint.Print80' + e.Message);
    end;
  end;
  }
end;

procedure TW_POS_SettlementForm.FormShow(Sender: TObject);
var
  i:Integer;   //ѭ���ı���
  totalAcount:Double;    //�ϼ�
  cardType:string;  //������
  ZK_Type:string;    //�ۿۿ�����
  discount:Double;  //�ۿ�
  BalanceAmount: Double;   //ʵ�����۶�
  rr:array [0..100] of PromotionResult;    //��������Ľ��
  IsMember:Boolean;  //�Ƿ��ǻ�Ա
  sd:array of SaleReceiptDetail;   //��Ҫ����Ĳ�������Ʒ��Ϣ����̬����

begin
  if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
     DM_ZB_Common.SetupConnection;
     
  IsMember:=False;// �Ƿ�Ϊ��Ա����ʼΪ��
  HY_flag:=False;
  with uniqueryHJ do
  begin                        
    Close;
    sql.Clear;
    SQL.Add('select * from t_bi_saledeal where status=:a');
    ParamByName('a').Value:='0';
    Open;
  end;
  totalAcount:=uniqueryHJ.FieldByName('sale_real_total').Value;    //�ϼ�
  tradeLSH:=uniqueryHJ.FieldByName('trade_turnover_num').AsString;  //�����ˮ��
  lbl6.Caption:=FloatToStr(totalAcount);    //�ϼ�
  // moneyYS:=totalAcount;           //Ӧ��


  //�ж��Ƿ������Ա����
  if vipKH<>'' then
  begin
    IsMember:=True;   //���Ų�Ϊ�գ�Ϊ��Ա
     //�жϿ����ͣ������ۿۿ�����Ӧ�ս�����
    with uniqueryHJ do
    begin
      close;
      sql.Clear;
      sql.Add('SELECT * from t_mem_membaseinfo WHERE mem_card_id=:a and card_status=''1''');
      ParamByName('a').Value:=Trim(vipKH);
      Open;
    end;
    cardType:=uniqueryHJ.FieldByName('card_type').AsString;
    HY_ID:=uniqueryHJ.FieldByName('mem_id').AsString;

    if cardType='0' then
    begin
      HY_flag:=True;
      ShowMessage('���ֿ�');
     // formalScore:=uniqueryHJ.FieldByName('mem_add_point').AsInteger-uniqueryHJ.FieldByName('mem_sub_point').AsInteger;
     // formal_rest:=uniqueryHJ.FieldByName('change_total').AsFloat;
      moneyYS:=totalAcount;           //Ӧ��
    end
    else if cardType='1' then
    begin
      //ShowMessage('�ۿۿ�');
      //�ж��ۿۿ�����,����
      ZK_Type:=uniqueryHJ.FieldByName('discount_card_type').AsString;
      with uniqueryHJ do
      begin
        Close;
        sql.Clear;
        SQL.Add('SELECT * from t_mem_memdisccardtype where card_type_id=:b');
        ParamByName('b').Value:=ZK_Type;
        Open;
      end;
      discount:=uniqueryHJ.FieldByName('discount').AsFloat;

      //ʵ�ս��ı�
      moneyYS:=totalAcount*discount;           //Ӧ��
      lbl10.Caption:='�ۿۿ����ۣ�';
    end
    else
    //��Ϊ��������
    begin
      moneyYS:=totalAcount;           //Ӧ��
    end;
  end
  else
  begin
    moneyYS:=totalAcount;           //Ӧ��
  end;

  //*********������Ʒ������Ϣ**********
  //1����������ϸ�����ҵ��õ��µ���Ʒ��Ϣ
  //2��ͨ����ƷID�ҵ���Ӧ��ID �� ��Ʒ��������
                      
  //��ȡ��ǰ��Ʒ���۽��ױ�
  with uniqueryHJ do
  begin
    Close;
    sql.Clear;
    SQL.Add('select * from t_bi_saledeal where status=:a');
    ParamByName('a').Value:='0';
    Open;
  end;
  tradeLSH:=uniqueryHJ.FieldByName('trade_turnover_num').AsString;  //�����ˮ��
  BalanceAmount:=uniqueryHJ.FieldByName('sale_real_total').AsFloat;  //ʵ�����۶�

  //��ȡ��ǰ��Ʒ������ϸ���ױ�
  with uniqueryHJ do
  begin
    Close;
    sql.Clear;
    SQL.Add('SELECT * from t_bi_saledealdetail WHERE tran_seri_num=:b');
    ParamByName('b').Value:=tradeLSH;
    Open;
  end;
  SetLength(sd,uniqueryHJ.RecordCount);
  //ѭ��������Ʒ�б�
  uniqueryHJ.First;  //��һ��
  for i:=0 to  uniqueryHJ.RecordCount-1 do
  begin
     sd[i].commodity_id:=uniqueryHJ.FieldByName('commodity_id').AsString;
     sd[i].Sale_num:=uniqueryHJ.FieldByName('sale_count').AsFloat;
     sd[i].SalePrice:=uniqueryHJ.FieldByName('sale_price').AsFloat;

     //ͨ����ƷID �ҵ���Ӧ��ID ����Ʒ����ID
     with uniqueryJSCX do
     begin
        Close;
        sql.Clear;
        SQL.Add('SELECT * from t_bi_commbaseinfo where commodity_id=:a');
        ParamByName('a').Value:=sd[i].commodity_id;
        Open;
     end;
     sd[i].SupplierID:=uniqueryJSCX.FieldByName('main_supplier').AsString;   //��Ӧ��ID
     sd[i].CommType:=uniqueryJSCX.FieldByName('comm_type_id').AsString;   //��Ʒ����ID;
 
  end;

  //��������
 Form1.ComputePromotion(IsMember,sd,rr);
 
 //����Ӧ�ս��

 
 //MoneyYS:=rr[1].TotalPrice;
 

 

  {
  while not uniqueryHJ.Eof do
  begin

  end;}

    //Form1.ComputePromotion();
  lbl7.Caption:=FloatToStr(moneyYS);
  edtJE.Text:=FloatToStr(moneyYS);
  edtJE.SetFocus;
  //ShowMessage(FormatDateTime('yyyy:mm:dd:hh:nn:ss',Now()));
end;

procedure TW_POS_SettlementForm.edtJEKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  moneyEnter:string;   //������
  paywayID:string;       //֧����ʽID
  RPrinter:TextFile;
  //i:Integer;
  PDStr:string;
begin
    if (Key=VK_RETURN)  then
    begin
        if edtJE.Text='' then
        begin
          lbl10.Caption:='����Ϊ�գ��������';
          edtJE.SetFocus;
        end
        else if edtJE.Text='0.00' then
        begin
           lbl10.Caption:='֧����ɣ�';
           setflag:=True;
           //Print80;       ���ô�ӡ����

           //�������ݿ⣬������Ǯ���ݱ���ֵ��
           {
           with uniqueryHJ do
           begin
             Close;
             sql.Clear;
             SQL.Add('UPDATE t_mem_membaseinfo SET change_total=:a WHERE mem_card_id=:b');
             ParamByName('a').value:=(formal_rest-useChange);
             ParamByName('b').value:=vipKH;
             ExecSQL;
           end;
           }
           //formal_rest:=formal_rest-useChange;

           close;
           {
           //****����Ǯ�䡢��ӡ***
           //���ô�ӡ��
           AssignFile(RPrinter,'lpt1');
           //׼��д�ļ�
           Rewrite(RPrinter);
           //��ӡ
           Writeln(RPrinter,'����:****');
           //���ֽ
           Writeln(RPrinter,chr($b)+chr(27)+'K'+chr(40));
           //��ǰ��ֽ
           Writeln(RPrinter,chr($b)+chr(27)+'J'+chr(140));
           //��Ǯ��
           PDStr:= #27+#112+#0+#100+#100;  // ��Ǯ��ָ��
           Write(RPrinter, PDStr);         //д��һ��
           //�رմ�ӡ��
           CloseFile(RPrinter);
          }
        end
        else
        begin
          //To Do ��ȡ֧����ʽID
          //�ж��Ƿ��ǹ���ȯ
          if paywayName='����ȯ' then
          begin
              with uniqueryZF_Sol do
              begin
                Close;
                SQL.Clear;
                SQL.Add('select pay_way_id from t_bi_payway where pay_way_name=:a');
                ParamByName('a').Value:=paywayName;   //����ʹ�õ�֧����ʽ
                open;
              end;
              paywayID:=uniqueryZF_Sol.FieldByName('pay_way_id').AsString;
          end
          //���ǹ���ȯ��Ĭ�����ֽ�
          else
          begin
             paywayID:='0';    //Ĭ���ֽ𸶿�
          end;
          //  ********TO do ��ο��Ʋ���������״̬Ϊ1*********

          moneyEnter:=edtJE.Text;
           //֧�������ڵ���Ӧ��
          if moneyYS<=StrToFloat(moneyEnter) then
          begin
            moneyRest:=StrToFloat(moneyEnter)-moneyYS;
            lbl9.Caption:=FloatToStr(moneyRest);   //����
            moneyYS:=0.00;
            lbl7.Caption:=FloatToStr(moneyYS); //Ӧ��
            lbl8.Caption:=moneyEnter;
            //��ʾ��Ϣ
            lbl10.Caption:=paywayName+'������Ϊ'+lbl8.Caption;
            //д֧����ʽ�����ݱ�
            with uniqueryZF_Sol do
            begin
              Close;
              SQL.Clear;
              SQL.Add('insert into t_dealpaydetail values(:a,:b,:c,:d,:e,:f)');
              ParamByName('a').Value:=DM_ZB_Common.vg_str_DepartmentID;  //�ŵ����
              ParamByName('b').Value:=Now;       //����ʱ��
              ParamByName('c').Value:=tradeLSH;       //������ˮ��
              ParamByName('d').Value:=paywayID;       //֧����ʽID
              ParamByName('e').Value:=StrToFloat(moneyEnter)-StrToFloat(lbl9.Caption); //֧�����

              //*******To do �����ֵ���Ż��Ա����******
              ParamByName('f').Value:='';       //����
              ExecSQL;
            end;

            //��ȡ֧����ʽ����ʾ
            with uniqueryZFFS do
            begin
              Close;
              SQL.Clear;
              SQL.Add('select b.pay_way_name,a.pay_money');
              SQL.Add(' FROM (SELECT * from t_dealpaydetail where tran_seri_num=:a) as a JOIN t_bi_payway as b');
              SQL.Add(' on a.pay_way_id=b.pay_way_id');
              ParamByName('a').Value:=tradeLSH;
              Open;
            end;

          end;
          //֧�����С��Ӧ��
          while moneyYS>StrToFloat(moneyEnter) do
          begin
             lbl8.Caption:=moneyEnter;      //����
             //��ʾ��Ϣ
             lbl10.Caption:=paywayName+'������Ϊ'+lbl8.Caption;
             //����Ӧ�ս��
             moneyYS:=moneyYS-StrToFloat(moneyEnter);
             lbl7.Caption:=FloatToStr(moneyYS); //Ӧ��

            //*************TO Do �ŵ�һ��������*****
             //д֧����ʽ�����ݱ�
            with uniqueryZF_Sol do
            begin
              Close;
              SQL.Clear;
              SQL.Add('insert into t_dealpaydetail values(:a,:b,:c,:d,:e,:f)');
              ParamByName('a').Value:=DM_ZB_Common.vg_str_DepartmentID;  //�ŵ����
              ParamByName('b').Value:=Now;       //����ʱ��
              ParamByName('c').Value:=tradeLSH;       //������ˮ��
              ParamByName('d').Value:=paywayID;       //֧����ʽID
              ParamByName('e').Value:=StrToFloat(moneyEnter); //֧�����

              //*******To do �����ֵ���Ż��Ա����******
              ParamByName('f').Value:='';       //����
              ExecSQL;
            end;

            //��ȡ֧����ʽ����ʾ
            with uniqueryZFFS do
            begin
              Close;
              SQL.Clear;
              SQL.Add('select b.pay_way_name,a.pay_money');
              SQL.Add(' FROM (SELECT * from t_dealpaydetail where tran_seri_num=:a) as a JOIN t_bi_payway as b');
              SQL.Add(' on a.pay_way_id=b.pay_way_id');
              ParamByName('a').Value:=tradeLSH;
              Open;
            end;
             edtJE.SelectAll;
          end;
          if moneyYS=0 then
          begin
            edtJE.Text:='0.00';
            //ShowMessage('֧����ɣ�');
            //setflag:=True;
            //close;



          end
          else
          begin
            setflag:=false;      //δ֧����ɾ�Ϊ�ϵ�
          end;
          paywayName:='�ֽ�';
        end;
    end;
end;

//����ֻ���������֣���ֻ��һ��С����
procedure TW_POS_SettlementForm.edtJEKeyPress(Sender: TObject;
  var Key: Char);
begin
 // if(not(Key in ['0'..'9','.',#8])) or ((key='.')and (pos('.',edtJE.Text)>0)) then
    // key:= #0;
    if not (key in ['0'..'9',#13,#8,'.']) then
        key:=#0;

    if ((key='.')and (pos('.',edtJE.Text)>0)) then
        key:=#0;

end;

//����֧����ʽ���
procedure TW_POS_SettlementForm.intgrfldZFFS_XHGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
   Text := IntToStr(uniqueryZFFS.RecNo);  //�ڱ������ʾ�к�
end;

procedure TW_POS_SettlementForm.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
    //���ð�ť��ݼ��������ٿ�
    if (Key = #82)or (Key=#114) then
       btn1.Click;            //�����
    if (Key = #66) or (Key = #98) then
       btn2.Click;            //���п�
    if (Key = #83) or (Key = #115) then
       btn3.Click;            //����ȯ
    if (Key = #67) or (Key = #99) then
       btn4.Click;            //��ֵ��
    if (Key = #79) or (Key = #111) then
       btn5.Click;            //����
    if (Key = #89) or (Key = #121) then
       btn6.Click;             //���
    if (Key = #76) or (Key = #108) then
       btnLQ.Click;            //��Ǯ
    if (Key = #81) or (Key=#113) then
       btn7.Click;             //ȡ��
    if (Key=#27) then
        btn8.Click;            //�˳�
end;

//�����
procedure TW_POS_SettlementForm.btn1Click(Sender: TObject);
begin
  //ShowMessage('ddddddddddddd');
  paywayName:='�ֽ�';
  lbl10.Caption:='����Ҹ��';
end;

//���п�
procedure TW_POS_SettlementForm.btn2Click(Sender: TObject);
var
  paywayID:string;   //֧��ID
begin
   Application.CreateForm(TW_POS_BankForm,W_POS_BankForm);
   W_POS_BankForm.ShowModal;
   W_POS_BankForm.Free;
   //W_POS_BankForm.showmodal;
   //ShowMessage(Test);
   //ShowMessage('bbbbbbbbbbb');
   //���п�����������
   if bankflag then
   begin
       //���п���������ڵ���Ӧ�ս��
     if C_POS_Bank.moneyPay>=moneyYS then
     begin
       lbl8.Caption:=FloatToStr(C_POS_Bank.moneyPay);
       moneyRest:=C_POS_Bank.moneyPay-moneyYS;
       lbl9.Caption:=FloatToStr(moneyRest);
       lbl7.Caption:='0.00';
       edtJE.Text:='0.00';

       paywayName:=C_POS_Bank.PayName;
       //��֧����Ϣд�����ݿ�  To Do
       //****1��ͨ��֧�����ƻ�ȡ֧��ID****
       with uniqueryZF_Sol do
       begin
         Close;
         SQL.Clear;
         SQL.Add('select pay_way_id from t_bi_payway where pay_way_name=:a');
         ParamByName('a').Value:=paywayName;
         Open;
       end;
        paywayID:=uniqueryZF_Sol.FieldByName('pay_way_id').AsString;

        //*****2��д֧����ʽ�����ݱ� ***
        with uniqueryZF_Sol do
        begin
          Close;
          SQL.Clear;
          SQL.Add('insert into t_dealpaydetail values(:a,:b,:c,:d,:e,:f)');
          ParamByName('a').Value:=DM_ZB_Common.vg_str_DepartmentID;  //�ŵ����
          ParamByName('b').Value:=Now;       //����ʱ��
          ParamByName('c').Value:=tradeLSH;       //������ˮ��
          ParamByName('d').Value:=paywayID;       //֧����ʽID
          ParamByName('e').Value:=moneyYS; //֧�����

          //*******To do �����ֵ���Ż��Ա����******
          ParamByName('f').Value:='';       //����
          ExecSQL;
        end;

        //��ȡ֧����ʽ����ʾ
        with uniqueryZFFS do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select b.pay_way_name,a.pay_money');
          SQL.Add(' FROM (SELECT * from t_dealpaydetail where tran_seri_num=:a) as a JOIN t_bi_payway as b');
          SQL.Add(' on a.pay_way_id=b.pay_way_id');
          ParamByName('a').Value:=tradeLSH;
          Open;
        end;

     end
     else
     begin
       lbl8.Caption:=FloatToStr(C_POS_Bank.moneyPay);
       moneyYS:=moneyYS-C_POS_Bank.moneyPay;
       lbl7.Caption:=FloatToStr(moneyYS);
       edtJE.Text:=lbl7.Caption;
       lbl9.Caption:='0.00';

       paywayName:=C_POS_Bank.PayName;
       //��֧����Ϣд�����ݿ�  To Do
       //****1��ͨ��֧�����ƻ�ȡ֧��ID****
       with uniqueryZF_Sol do
       begin
         Close;
         SQL.Clear;
         SQL.Add('select pay_way_id from t_bi_payway where pay_way_name=:a');
         ParamByName('a').Value:=paywayName;
         Open;
       end;
        paywayID:=uniqueryZF_Sol.FieldByName('pay_way_id').AsString;

        //*****2��д֧����ʽ�����ݱ� ***
        with uniqueryZF_Sol do
        begin
          Close;
          SQL.Clear;
          SQL.Add('insert into t_dealpaydetail values(:a,:b,:c,:d,:e,:f)');
          ParamByName('a').Value:=DM_ZB_Common.vg_str_DepartmentID;  //�ŵ����
          ParamByName('b').Value:=Now;       //����ʱ��
          ParamByName('c').Value:=tradeLSH;       //������ˮ��
          ParamByName('d').Value:=paywayID;       //֧����ʽID
          ParamByName('e').Value:=C_POS_Bank.moneyPay; //֧�����

          //*******To do �����ֵ���Ż��Ա����******
          ParamByName('f').Value:='';       //����
          ExecSQL;
        end;

        //��ȡ֧����ʽ����ʾ
        with uniqueryZFFS do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select b.pay_way_name,a.pay_money');
          SQL.Add(' FROM (SELECT * from t_dealpaydetail where tran_seri_num=:a) as a JOIN t_bi_payway as b');
          SQL.Add(' on a.pay_way_id=b.pay_way_id');
          ParamByName('a').Value:=tradeLSH;
          Open;
        end;
     end;
   end;
   edtJE.SetFocus;
end;

procedure TW_POS_SettlementForm.FormCreate(Sender: TObject);
begin
   KeyPreview := true;
end;

//����ȯ
procedure TW_POS_SettlementForm.btn3Click(Sender: TObject);
begin
  //ShowMessage('sssssssss');
  paywayName:='����ȯ';
  lbl10.Caption:='����ȯ����';
end;

//��ֵ��
procedure TW_POS_SettlementForm.btn4Click(Sender: TObject);
var
  paywayID:string;   //֧��ID
begin
   lbl10.Caption:='���������ܲ��������ĵȴ�...';
 //�����ܲ����ݿⴢֵ����
  with con1 do
  begin
    ProviderName := 'PostgreSQL';
    Username := 'postgres';
    Password := 'bld123';
    Server := '49.123.112.95';   //TO DO ����ܲ����ݿ�IP
    Port := 5432;
    Database:='headquarters';
    SpecificOptions.Values['UseUnicode'] := 'True';   //���ñ����ʽ�����������������
  end;
  try
    begin
      con1.Connect;
      lbl10.Caption:='�������ܲ����ݿ⣡';
      //������ֵ������
      Application.CreateForm(TW_POS_CZcardForm,W_POS_CZcardForm);
       W_POS_CZcardForm.ShowModal;
       W_POS_CZcardForm.Free;
      // W_POS_CZcardForm.showmodal;
       //ShowMessage('bbbbbbbbbbb');
       if CZflag then
       begin
          //��ֵ����������ڵ���Ӧ�ս��

         if moneyPay>=moneyYS then
         begin
           lbl8.Caption:=FloatToStr(moneyPay);
           moneyRest:=moneyPay-moneyYS;
           lbl9.Caption:=FloatToStr(moneyRest);
           lbl7.Caption:='0.00';
           edtJE.Text:='0.00';
         end
         else
         begin
           lbl8.Caption:=FloatToStr(moneyPay);
           moneyYS:=moneyYS-moneyPay;
           lbl7.Caption:=FloatToStr(moneyYS);
           edtJE.Text:=FloatToStr(moneyYS);
           lbl9.Caption:='0.00';
         end;
         paywayName:=C_POS_CZcard.PayName;
         //��֧����Ϣд�����ݿ�  To Do
         //****1��ͨ��֧�����ƻ�ȡ֧��ID****
         with uniqueryZF_Sol do
         begin
           Close;
           SQL.Clear;
           SQL.Add('select pay_way_id from t_bi_payway where pay_way_name=:a');
           ParamByName('a').Value:=paywayName;
           Open;
         end;
          paywayID:=uniqueryZF_Sol.FieldByName('pay_way_id').AsString;

          //*****2��д֧����ʽ�����ݱ� ***
          with uniqueryZF_Sol do
          begin
            Close;
            SQL.Clear;
            SQL.Add('insert into t_dealpaydetail values(:a,:b,:c,:d,:e,:f)');
            ParamByName('a').Value:=DM_ZB_Common.vg_str_DepartmentID;  //�ŵ����
            ParamByName('b').Value:=Now;       //����ʱ��
            ParamByName('c').Value:=tradeLSH;       //������ˮ��
            ParamByName('d').Value:=paywayID;       //֧����ʽID
            ParamByName('e').Value:=moneyPay; //֧�����

            //*******To do �����ֵ���Ż��Ա����******
            ParamByName('f').Value:=CZcardID;       //����
            ExecSQL;
          end;

          //��ȡ֧����ʽ����ʾ
          with uniqueryZFFS do
          begin
            Close;
            SQL.Clear;
            SQL.Add('select b.pay_way_name,a.pay_money');
            SQL.Add(' FROM (SELECT * from t_dealpaydetail where tran_seri_num=:a) as a JOIN t_bi_payway as b');
            SQL.Add(' on a.pay_way_id=b.pay_way_id');
            ParamByName('a').Value:=tradeLSH;
            Open;
          end;

       end;

       edtJE.SetFocus;
       con1.Disconnect;
       lbl10.Caption:='���׳ɹ�,�����ѶϿ���';
    end;
  except
    lbl10.Caption:='�����ܲ����ݿ�ʧ�ܣ��޷�ʹ�ô�ֵ��';
    con1.Disconnect;
  end;


  //ShowMessage('cccccc');
end;

//����
procedure TW_POS_SettlementForm.btn5Click(Sender: TObject);
begin
  // ShowMessage('oooooo');
   Application.CreateForm(TW_POS_OtherPayWayForm,W_POS_OtherPayWayForm);
   W_POS_OtherPayWayForm.ShowModal;
   W_POS_OtherPayWayForm.Free;
   //W_POS_OtherPayWayForm.ShowModal;
end;

//���,ֻ���������
procedure TW_POS_SettlementForm.btn6Click(Sender: TObject);
//var
  //vm:Integer;
begin

   //ShowMessage('yyyyyyy');
    if (StrToFloat(lbl7.Caption)<StrToFloat(lbl6.Caption)) and (StrToFloat(lbl7.Caption)>0)  then
        lbl10.Caption:='��ǰ���ڽ��ף�������ۣ�'
    else
    begin
       Application.CreateForm(TW_POS_SQMaForm,W_POS_SQMaForm);
       W_POS_SQMaForm.ShowModal;
       W_POS_SQMaForm.Free;
      // W_POS_SQMaForm.showmodal;
       //��ۺ�Ӧ�մ������㴰����
       if YJflag then
       begin
         paywayName:=payName;
         moneyYS:=Yjia;
         lbl7.Caption:=FloatToStr(moneyYS);
         edtJE.Text:=FloatToStr(moneyYS);
         //��۳ɹ����޸���Ȩ���״̬
         with uniqueryZF_Sol do
         begin
           Close;
           SQL.Clear;
           SQL.Add('UPDATE t_bi_authorcode SET status=''2'',author_use_time=now()');
           SQL.Add('WHERE author_code=:a');
           ParamByName('a').Value:=sqma;
           ExecSQL;
         end;
      end;
  end;

    {
     vm:=MessageBox(Handle,'�Ƿ�ȡ����ۣ�','������Ϣ��',MB_OKCANCEL);
     if vm=idCANCEL then
        Exit
     else
        close; }
end;

//ȡ��
procedure TW_POS_SettlementForm.btn7Click(Sender: TObject);
var
  vm:Integer;  //����messagebox��ֵ
begin
    //ShowMessage('qqqqqq');
    if (StrToFloat(lbl7.Caption)<StrToFloat(lbl6.Caption)) and (StrToFloat(lbl7.Caption)>0)  then
        lbl10.Caption:='��ǰ���ڽ��ף�����ȡ����'
    else
    begin
       vm:=MessageBox(Handle,'�Ƿ�ȡ����ǰ���ף�','������Ϣ��',MB_OKCANCEL);
       if vm=idCANCEL then
          Exit
       else
          close;
    end;

end;

procedure TW_POS_SettlementForm.btn8Click(Sender: TObject);
begin
  close;
end;

//��Ǯ �����㡢ȡ�㣩
procedure TW_POS_SettlementForm.btnLQClick(Sender: TObject);
var
  storeChange:Double;   //��С������Ǯ
  useChange:Double;     //ʹ����Ǯ��
begin
    //ShowMessage('ʹ����Ǯ');
    //�жϿ����ͣ��ۿۿ��������
    if cardType1='0' then
    begin
      lbl10.Caption:='ʹ����Ǯ��';

      //Ӧ���Ƿ�Ϊ0���ж��Ǵ��㻹��ȡ��
      //����
      if moneyYS=0 then
      begin
        //ѯ���Ƿ����
        //�����ȥ������
        storeChange:=Frac(moneyRest);
        //ShowMessage(FloatToStr(storeChange));
        moneyRest:=moneyRest-storeChange;
        lbl9.Caption:=FloatToStr(moneyRest);
        lbl10.Caption:='������Ϊ'+FloatToStr(storeChange);
        formal_rest:=formal_rest+storeChange;
        edtJE.SetFocus;
      end
      else
      //ȡ��
      begin
        Application.CreateForm(TW_POS_UserChangeForm,W_POS_UserChangeForm);
        W_POS_UserChangeForm.ShowModal;
        W_POS_UserChangeForm.Free;
        if useLQ_flag then
        begin
          //�ж���Ǯ�ܶ��Ƿ����С��
          //��Ǯ�ܶ����Ӧ��С��
          useChange:=Frac(moneyYS);
          if (formal_rest>useChange) and (useChange<>0) then
          begin
            lbl12.Caption:=FloatToStr(useChange);
            moneyYS:=moneyYS-useChange;
            lbl7.Caption:=FloatToStr(moneyYS);
            edtJE.Text:=FloatToStr(moneyYS);
            formal_rest:=formal_rest-useChange;
            lbl10.Caption:='ʹ����Ǯ�ɹ���';
          end
          else
          begin
            lbl10.Caption:='����ʹ����Ǯ��';
          end;

          //lbl9.Caption:=FloatToStr()


        end
        else
        begin
          lbl10.Caption:='�˳�ʹ����Ǯ��';
        end;
      end;

    end
    else
    begin
      lbl10.Caption:='�ÿ�Ϊ�ۿۿ�������ʹ����Ǯ��';
      btnLQ.Enabled:=True;
    end;

end;

end.


