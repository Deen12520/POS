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
  setflag:Boolean=False;  //标志位，标志是否已支付成功
  moneyYS:Double;    //应收金额
  tradeLSH:string;     //交易流水号
  //paywayName:string='现金';    //支付名称
  HY_flag:Boolean;  // 是否是会员
  HY_ID:string;   //会员ID
 // formalScore:Integer; //原积分
 // formal_rest:Double;  //原零钱
implementation

uses C_ZB_DataModule, C_POS_Bank, C_POS_CZcard, C_POS_SQMa,C_POS_YJia,
      C_POS_OtherPayWay,C_POS_Vip,C_POS_UserChange,cx;
      //C_POS_inputChange,cx
const
// 末尾走纸几行
c_run_paper_lines = 6;
// ESC指令 开钱箱
c_OpenMoneyBoxCommand = CHR(27) + CHR(112) + CHR(0) + CHR(17) + CHR(8);
// ESC指令 自动切纸
c_cut_paper = CHR(29) + CHR(86) + CHR(66) + CHR(0);

{$R *.dfm}
var
  paywayName:string='现金';    //支付名称
  //moneyYS:Double;    //应收金额
  //tradeLSH:string;     //交易流水号
  moneyRest:Double;   //找零

//POS小票打印
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
  BalanceAmount: Double;   //实际销售额
begin
  // 生成一个小票的文本文件
  sBill := ExtractFilePath(Application.ExeName) + 'bill.txt';
  AssignFile(RPrinter, sBill);
  Rewrite(RPrinter);
  try
    // 店名             
    Writeln(RPrinter, ' ' +DM_ZB_Common.vg_str_CompanyName);
    Writeln(RPrinter, '机号 收款员 交易流水号');

    sTmp := DM_ZB_Common.vg_str_PosID + ' ' + DM_ZB_Common.vg_str_CashierID;
    iTmp := 32 - Length(sTmp);

    //读取当前商品销售交易表
    with uniqueryHJ do
    begin
      Close;
      sql.Clear;
      SQL.Add('select * from t_bi_saledeal where status=:a');
      ParamByName('a').Value:='0';
      Open;
    end;
    tradeLSH:=uniqueryHJ.FieldByName('trade_turnover_num').AsString;  //获得流水号
    BalanceAmount:=uniqueryHJ.FieldByName('sale_real_total').AsFloat;  //实际销售额

    //读取当前商品销售详细交易表
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
    Writeln(RPrinter, '打印时间：' + FormatDatetime('yyyy-mm-dd hh:nn', now));

    Writeln(RPrinter, '-------------------------------------');
    Writeln(RPrinter, '品名     单价   数量   小计');
    uniqueryHJ.First;
    while not uniqueryHJ.Eof do
    begin
      // 序号
      sXH := IntToStr(uniqueryHJ.FieldByName('row_id').AsInteger);
      while Length(sXH) < 2 do
      begin
        sXH := sXH + ' ';
      end;
      // 金额
      sMoney := FormatFloat('0.00', uniqueryHJ.FieldByName('sale_total').AsFloat);
      i := Length(sMoney);
      sTmp := '';
      while i < 9 do
      begin
        sTmp := sTmp + ' ';
        i := i + 1;
      end;
      sMoney := sTmp + sMoney;
      // 商品名称
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
    Writeln(RPrinter, '金额：' + FormatFloat('0.00',BalanceAmount));
    Writeln(RPrinter, sTmp2);
    Writeln(RPrinter, ' 谢谢惠顾!');
    // 末尾走纸 行数
    for i := 1 to c_run_paper_lines do
    Writeln(RPrinter, '');
  finally
    CloseFile(RPrinter);
  end;
  if SameText(DM_ZB_Common.PrintPort, 'lpt') then // 直接并口输出 不要安装票打驱动
  begin
    // 读取文本文件打印小票
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
          // 开钱箱
          write(RPrinter, c_OpenMoneyBoxCommand);
          write(RPrinter, c_cut_paper);
          CloseFile(RPrinter);
        except
      // 如果LPT1端口不存在，会报错：the specified file not found
      // 有些主板不提供LPT并口，不屏蔽错误，无法收银
        end;
    finally
     MyList.Free;
    end;
  end
   {
  else if SameText(DM_ZB_Common.PrintPort, 'usb') then // 需要安装票打驱动
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
  i:Integer;   //循环的变量
  totalAcount:Double;    //合计
  cardType:string;  //卡类型
  ZK_Type:string;    //折扣卡类型
  discount:Double;  //折扣
  BalanceAmount: Double;   //实际销售额
  rr:array [0..100] of PromotionResult;    //促销计算的结果
  IsMember:Boolean;  //是否是会员
  sd:array of SaleReceiptDetail;   //需要传入的参数（商品信息）动态数组

begin
  if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
     DM_ZB_Common.SetupConnection;
     
  IsMember:=False;// 是否为会员，初始为否
  HY_flag:=False;
  with uniqueryHJ do
  begin                        
    Close;
    sql.Clear;
    SQL.Add('select * from t_bi_saledeal where status=:a');
    ParamByName('a').Value:='0';
    Open;
  end;
  totalAcount:=uniqueryHJ.FieldByName('sale_real_total').Value;    //合计
  tradeLSH:=uniqueryHJ.FieldByName('trade_turnover_num').AsString;  //获得流水号
  lbl6.Caption:=FloatToStr(totalAcount);    //合计
  // moneyYS:=totalAcount;           //应收


  //判断是否输入会员卡号
  if vipKH<>'' then
  begin
    IsMember:=True;   //卡号不为空，为会员
     //判断卡类型，若是折扣卡，对应收金额打折
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
      ShowMessage('积分卡');
     // formalScore:=uniqueryHJ.FieldByName('mem_add_point').AsInteger-uniqueryHJ.FieldByName('mem_sub_point').AsInteger;
     // formal_rest:=uniqueryHJ.FieldByName('change_total').AsFloat;
      moneyYS:=totalAcount;           //应收
    end
    else if cardType='1' then
    begin
      //ShowMessage('折扣卡');
      //判断折扣卡类型,打几折
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

      //实收金额改变
      moneyYS:=totalAcount*discount;           //应收
      lbl10.Caption:='折扣卡打折！';
    end
    else
    //卡为其他类型
    begin
      moneyYS:=totalAcount;           //应收
    end;
  end
  else
  begin
    moneyYS:=totalAcount;           //应收
  end;

  //*********传递商品类型信息**********
  //1、从销售详细表中找到该单下的商品信息
  //2、通过商品ID找到供应商ID 和 商品类型名称
                      
  //读取当前商品销售交易表
  with uniqueryHJ do
  begin
    Close;
    sql.Clear;
    SQL.Add('select * from t_bi_saledeal where status=:a');
    ParamByName('a').Value:='0';
    Open;
  end;
  tradeLSH:=uniqueryHJ.FieldByName('trade_turnover_num').AsString;  //获得流水号
  BalanceAmount:=uniqueryHJ.FieldByName('sale_real_total').AsFloat;  //实际销售额

  //读取当前商品销售详细交易表
  with uniqueryHJ do
  begin
    Close;
    sql.Clear;
    SQL.Add('SELECT * from t_bi_saledealdetail WHERE tran_seri_num=:b');
    ParamByName('b').Value:=tradeLSH;
    Open;
  end;
  SetLength(sd,uniqueryHJ.RecordCount);
  //循环读出商品列表
  uniqueryHJ.First;  //第一行
  for i:=0 to  uniqueryHJ.RecordCount-1 do
  begin
     sd[i].commodity_id:=uniqueryHJ.FieldByName('commodity_id').AsString;
     sd[i].Sale_num:=uniqueryHJ.FieldByName('sale_count').AsFloat;
     sd[i].SalePrice:=uniqueryHJ.FieldByName('sale_price').AsFloat;

     //通过商品ID 找到供应商ID 和商品类型ID
     with uniqueryJSCX do
     begin
        Close;
        sql.Clear;
        SQL.Add('SELECT * from t_bi_commbaseinfo where commodity_id=:a');
        ParamByName('a').Value:=sd[i].commodity_id;
        Open;
     end;
     sd[i].SupplierID:=uniqueryJSCX.FieldByName('main_supplier').AsString;   //供应商ID
     sd[i].CommType:=uniqueryJSCX.FieldByName('comm_type_id').AsString;   //商品类型ID;
 
  end;

  //促销计算
 Form1.ComputePromotion(IsMember,sd,rr);
 
 //更改应收金额

 
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
  moneyEnter:string;   //输入金额
  paywayID:string;       //支付方式ID
  RPrinter:TextFile;
  //i:Integer;
  PDStr:string;
begin
    if (Key=VK_RETURN)  then
    begin
        if edtJE.Text='' then
        begin
          lbl10.Caption:='输入为空，请输入金额！';
          edtJE.SetFocus;
        end
        else if edtJE.Text='0.00' then
        begin
           lbl10.Caption:='支付完成！';
           setflag:=True;
           //Print80;       调用打印函数

           //更新数据库，比如零钱数据表、储值卡
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
           //****弹出钱箱、打印***
           //设置打印机
           AssignFile(RPrinter,'lpt1');
           //准备写文件
           Rewrite(RPrinter);
           //打印
           Writeln(RPrinter,'测试:****');
           //向后倒纸
           Writeln(RPrinter,chr($b)+chr(27)+'K'+chr(40));
           //向前进纸
           Writeln(RPrinter,chr($b)+chr(27)+'J'+chr(140));
           //开钱箱
           PDStr:= #27+#112+#0+#100+#100;  // 开钱箱指令
           Write(RPrinter, PDStr);         //写入一行
           //关闭打印机
           CloseFile(RPrinter);
          }
        end
        else
        begin
          //To Do 获取支付方式ID
          //判断是否是购物券
          if paywayName='购物券' then
          begin
              with uniqueryZF_Sol do
              begin
                Close;
                SQL.Clear;
                SQL.Add('select pay_way_id from t_bi_payway where pay_way_name=:a');
                ParamByName('a').Value:=paywayName;   //正在使用的支付方式
                open;
              end;
              paywayID:=uniqueryZF_Sol.FieldByName('pay_way_id').AsString;
          end
          //不是购物券，默认是现金
          else
          begin
             paywayID:='0';    //默认现金付款
          end;
          //  ********TO do 如何控制不出现两个状态为1*********

          moneyEnter:=edtJE.Text;
           //支付金额大于等于应收
          if moneyYS<=StrToFloat(moneyEnter) then
          begin
            moneyRest:=StrToFloat(moneyEnter)-moneyYS;
            lbl9.Caption:=FloatToStr(moneyRest);   //找零
            moneyYS:=0.00;
            lbl7.Caption:=FloatToStr(moneyYS); //应收
            lbl8.Caption:=moneyEnter;
            //提示信息
            lbl10.Caption:=paywayName+'付款，金额为'+lbl8.Caption;
            //写支付方式到数据表
            with uniqueryZF_Sol do
            begin
              Close;
              SQL.Clear;
              SQL.Add('insert into t_dealpaydetail values(:a,:b,:c,:d,:e,:f)');
              ParamByName('a').Value:=DM_ZB_Common.vg_str_DepartmentID;  //门店编码
              ParamByName('b').Value:=Now;       //交易时间
              ParamByName('c').Value:=tradeLSH;       //交易流水号
              ParamByName('d').Value:=paywayID;       //支付方式ID
              ParamByName('e').Value:=StrToFloat(moneyEnter)-StrToFloat(lbl9.Caption); //支付金额

              //*******To do 如果储值卡号或会员卡号******
              ParamByName('f').Value:='';       //卡号
              ExecSQL;
            end;

            //读取支付方式并显示
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
          //支付金额小于应收
          while moneyYS>StrToFloat(moneyEnter) do
          begin
             lbl8.Caption:=moneyEnter;      //已收
             //提示信息
             lbl10.Caption:=paywayName+'付款，金额为'+lbl8.Caption;
             //计算应收金额
             moneyYS:=moneyYS-StrToFloat(moneyEnter);
             lbl7.Caption:=FloatToStr(moneyYS); //应收

            //*************TO Do 放到一个函数中*****
             //写支付方式到数据表
            with uniqueryZF_Sol do
            begin
              Close;
              SQL.Clear;
              SQL.Add('insert into t_dealpaydetail values(:a,:b,:c,:d,:e,:f)');
              ParamByName('a').Value:=DM_ZB_Common.vg_str_DepartmentID;  //门店编码
              ParamByName('b').Value:=Now;       //交易时间
              ParamByName('c').Value:=tradeLSH;       //交易流水号
              ParamByName('d').Value:=paywayID;       //支付方式ID
              ParamByName('e').Value:=StrToFloat(moneyEnter); //支付金额

              //*******To do 如果储值卡号或会员卡号******
              ParamByName('f').Value:='';       //卡号
              ExecSQL;
            end;

            //读取支付方式并显示
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
            //ShowMessage('支付完成！');
            //setflag:=True;
            //close;



          end
          else
          begin
            setflag:=false;      //未支付完成就为废单
          end;
          paywayName:='现金';
        end;
    end;
end;

//设置只能输入数字，且只有一个小数点
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

//设置支付方式序号
procedure TW_POS_SettlementForm.intgrfldZFFS_XHGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
   Text := IntToStr(uniqueryZFFS.RecNo);  //在表格中显示行号
end;

procedure TW_POS_SettlementForm.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
    //设置按钮快捷键，单键操控
    if (Key = #82)or (Key=#114) then
       btn1.Click;            //人民币
    if (Key = #66) or (Key = #98) then
       btn2.Click;            //银行卡
    if (Key = #83) or (Key = #115) then
       btn3.Click;            //购物券
    if (Key = #67) or (Key = #99) then
       btn4.Click;            //储值卡
    if (Key = #79) or (Key = #111) then
       btn5.Click;            //其他
    if (Key = #89) or (Key = #121) then
       btn6.Click;             //议价
    if (Key = #76) or (Key = #108) then
       btnLQ.Click;            //零钱
    if (Key = #81) or (Key=#113) then
       btn7.Click;             //取消
    if (Key=#27) then
        btn8.Click;            //退出
end;

//人民币
procedure TW_POS_SettlementForm.btn1Click(Sender: TObject);
begin
  //ShowMessage('ddddddddddddd');
  paywayName:='现金';
  lbl10.Caption:='人民币付款！';
end;

//银行卡
procedure TW_POS_SettlementForm.btn2Click(Sender: TObject);
var
  paywayID:string;   //支付ID
begin
   Application.CreateForm(TW_POS_BankForm,W_POS_BankForm);
   W_POS_BankForm.ShowModal;
   W_POS_BankForm.Free;
   //W_POS_BankForm.showmodal;
   //ShowMessage(Test);
   //ShowMessage('bbbbbbbbbbb');
   //银行卡金额输入完成
   if bankflag then
   begin
       //银行卡付款金额大于等于应收金额
     if C_POS_Bank.moneyPay>=moneyYS then
     begin
       lbl8.Caption:=FloatToStr(C_POS_Bank.moneyPay);
       moneyRest:=C_POS_Bank.moneyPay-moneyYS;
       lbl9.Caption:=FloatToStr(moneyRest);
       lbl7.Caption:='0.00';
       edtJE.Text:='0.00';

       paywayName:=C_POS_Bank.PayName;
       //将支付信息写入数据库  To Do
       //****1、通过支付名称获取支付ID****
       with uniqueryZF_Sol do
       begin
         Close;
         SQL.Clear;
         SQL.Add('select pay_way_id from t_bi_payway where pay_way_name=:a');
         ParamByName('a').Value:=paywayName;
         Open;
       end;
        paywayID:=uniqueryZF_Sol.FieldByName('pay_way_id').AsString;

        //*****2、写支付方式到数据表 ***
        with uniqueryZF_Sol do
        begin
          Close;
          SQL.Clear;
          SQL.Add('insert into t_dealpaydetail values(:a,:b,:c,:d,:e,:f)');
          ParamByName('a').Value:=DM_ZB_Common.vg_str_DepartmentID;  //门店编码
          ParamByName('b').Value:=Now;       //交易时间
          ParamByName('c').Value:=tradeLSH;       //交易流水号
          ParamByName('d').Value:=paywayID;       //支付方式ID
          ParamByName('e').Value:=moneyYS; //支付金额

          //*******To do 如果储值卡号或会员卡号******
          ParamByName('f').Value:='';       //卡号
          ExecSQL;
        end;

        //读取支付方式并显示
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
       //将支付信息写入数据库  To Do
       //****1、通过支付名称获取支付ID****
       with uniqueryZF_Sol do
       begin
         Close;
         SQL.Clear;
         SQL.Add('select pay_way_id from t_bi_payway where pay_way_name=:a');
         ParamByName('a').Value:=paywayName;
         Open;
       end;
        paywayID:=uniqueryZF_Sol.FieldByName('pay_way_id').AsString;

        //*****2、写支付方式到数据表 ***
        with uniqueryZF_Sol do
        begin
          Close;
          SQL.Clear;
          SQL.Add('insert into t_dealpaydetail values(:a,:b,:c,:d,:e,:f)');
          ParamByName('a').Value:=DM_ZB_Common.vg_str_DepartmentID;  //门店编码
          ParamByName('b').Value:=Now;       //交易时间
          ParamByName('c').Value:=tradeLSH;       //交易流水号
          ParamByName('d').Value:=paywayID;       //支付方式ID
          ParamByName('e').Value:=C_POS_Bank.moneyPay; //支付金额

          //*******To do 如果储值卡号或会员卡号******
          ParamByName('f').Value:='';       //卡号
          ExecSQL;
        end;

        //读取支付方式并显示
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

//购物券
procedure TW_POS_SettlementForm.btn3Click(Sender: TObject);
begin
  //ShowMessage('sssssssss');
  paywayName:='购物券';
  lbl10.Caption:='购物券付款';
end;

//储值卡
procedure TW_POS_SettlementForm.btn4Click(Sender: TObject);
var
  paywayID:string;   //支付ID
begin
   lbl10.Caption:='正在连接总部，请耐心等待...';
 //访问总部数据库储值卡表
  with con1 do
  begin
    ProviderName := 'PostgreSQL';
    Username := 'postgres';
    Password := 'bld123';
    Server := '49.123.112.95';   //TO DO 获得总部数据库IP
    Port := 5432;
    Database:='headquarters';
    SpecificOptions.Values['UseUnicode'] := 'True';   //设置编码格式，解决中文乱码问题
  end;
  try
    begin
      con1.Connect;
      lbl10.Caption:='连接上总部数据库！';
      //弹出储值卡窗口
      Application.CreateForm(TW_POS_CZcardForm,W_POS_CZcardForm);
       W_POS_CZcardForm.ShowModal;
       W_POS_CZcardForm.Free;
      // W_POS_CZcardForm.showmodal;
       //ShowMessage('bbbbbbbbbbb');
       if CZflag then
       begin
          //储值卡付款金额大于等于应收金额

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
         //将支付信息写入数据库  To Do
         //****1、通过支付名称获取支付ID****
         with uniqueryZF_Sol do
         begin
           Close;
           SQL.Clear;
           SQL.Add('select pay_way_id from t_bi_payway where pay_way_name=:a');
           ParamByName('a').Value:=paywayName;
           Open;
         end;
          paywayID:=uniqueryZF_Sol.FieldByName('pay_way_id').AsString;

          //*****2、写支付方式到数据表 ***
          with uniqueryZF_Sol do
          begin
            Close;
            SQL.Clear;
            SQL.Add('insert into t_dealpaydetail values(:a,:b,:c,:d,:e,:f)');
            ParamByName('a').Value:=DM_ZB_Common.vg_str_DepartmentID;  //门店编码
            ParamByName('b').Value:=Now;       //交易时间
            ParamByName('c').Value:=tradeLSH;       //交易流水号
            ParamByName('d').Value:=paywayID;       //支付方式ID
            ParamByName('e').Value:=moneyPay; //支付金额

            //*******To do 如果储值卡号或会员卡号******
            ParamByName('f').Value:=CZcardID;       //卡号
            ExecSQL;
          end;

          //读取支付方式并显示
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
       lbl10.Caption:='交易成功,连接已断开！';
    end;
  except
    lbl10.Caption:='连接总部数据库失败！无法使用储值卡';
    con1.Disconnect;
  end;


  //ShowMessage('cccccc');
end;

//其他
procedure TW_POS_SettlementForm.btn5Click(Sender: TObject);
begin
  // ShowMessage('oooooo');
   Application.CreateForm(TW_POS_OtherPayWayForm,W_POS_OtherPayWayForm);
   W_POS_OtherPayWayForm.ShowModal;
   W_POS_OtherPayWayForm.Free;
   //W_POS_OtherPayWayForm.ShowModal;
end;

//议价,只能整单议价
procedure TW_POS_SettlementForm.btn6Click(Sender: TObject);
//var
  //vm:Integer;
begin

   //ShowMessage('yyyyyyy');
    if (StrToFloat(lbl7.Caption)<StrToFloat(lbl6.Caption)) and (StrToFloat(lbl7.Caption)>0)  then
        lbl10.Caption:='当前正在交易，不能议价！'
    else
    begin
       Application.CreateForm(TW_POS_SQMaForm,W_POS_SQMaForm);
       W_POS_SQMaForm.ShowModal;
       W_POS_SQMaForm.Free;
      // W_POS_SQMaForm.showmodal;
       //议价后应收传到结算窗体中
       if YJflag then
       begin
         paywayName:=payName;
         moneyYS:=Yjia;
         lbl7.Caption:=FloatToStr(moneyYS);
         edtJE.Text:=FloatToStr(moneyYS);
         //议价成功后，修改授权码的状态
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
     vm:=MessageBox(Handle,'是否取消议价？','警告信息框',MB_OKCANCEL);
     if vm=idCANCEL then
        Exit
     else
        close; }
end;

//取消
procedure TW_POS_SettlementForm.btn7Click(Sender: TObject);
var
  vm:Integer;  //返回messagebox的值
begin
    //ShowMessage('qqqqqq');
    if (StrToFloat(lbl7.Caption)<StrToFloat(lbl6.Caption)) and (StrToFloat(lbl7.Caption)>0)  then
        lbl10.Caption:='当前正在交易，不能取消！'
    else
    begin
       vm:=MessageBox(Handle,'是否取消当前交易？','警告信息框',MB_OKCANCEL);
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

//零钱 （存零、取零）
procedure TW_POS_SettlementForm.btnLQClick(Sender: TObject);
var
  storeChange:Double;   //存小数到零钱
  useChange:Double;     //使用零钱数
begin
    //ShowMessage('使用零钱');
    //判断卡类型，折扣卡不能议价
    if cardType1='0' then
    begin
      lbl10.Caption:='使用零钱！';

      //应收是否为0，判断是存零还是取零
      //存零
      if moneyYS=0 then
      begin
        //询问是否存零
        //找零减去存零金额
        storeChange:=Frac(moneyRest);
        //ShowMessage(FloatToStr(storeChange));
        moneyRest:=moneyRest-storeChange;
        lbl9.Caption:=FloatToStr(moneyRest);
        lbl10.Caption:='存零金额为'+FloatToStr(storeChange);
        formal_rest:=formal_rest+storeChange;
        edtJE.SetFocus;
      end
      else
      //取零
      begin
        Application.CreateForm(TW_POS_UserChangeForm,W_POS_UserChangeForm);
        W_POS_UserChangeForm.ShowModal;
        W_POS_UserChangeForm.Free;
        if useLQ_flag then
        begin
          //判断零钱总额是否大于小数
          //零钱总额大于应收小数
          useChange:=Frac(moneyYS);
          if (formal_rest>useChange) and (useChange<>0) then
          begin
            lbl12.Caption:=FloatToStr(useChange);
            moneyYS:=moneyYS-useChange;
            lbl7.Caption:=FloatToStr(moneyYS);
            edtJE.Text:=FloatToStr(moneyYS);
            formal_rest:=formal_rest-useChange;
            lbl10.Caption:='使用零钱成功！';
          end
          else
          begin
            lbl10.Caption:='不能使用零钱！';
          end;

          //lbl9.Caption:=FloatToStr()


        end
        else
        begin
          lbl10.Caption:='退出使用零钱！';
        end;
      end;

    end
    else
    begin
      lbl10.Caption:='该卡为折扣卡，不能使用零钱！';
      btnLQ.Enabled:=True;
    end;

end;

end.


