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
  //flag:Boolean=True;   //状态位，判断流水号是否自增
  //no:Integer=1;    //流水号末尾5位
  //quality:Double=1.0;    //数量
  //spbh:string='S123456';   //商品编号
  liushuihao:string;     //流水号
  flag:Integer=0;  //判断是第一次点击还是第二次点击
  spbm:string;            //商品编码,商品查询中使用
  //TotalAmount:string='0.00';  //合计金额



implementation

{$R *.dfm}
uses C_ZB_DataModule, C_POS_quantity,C_POS_Vip, C_POS_Other, C_POS_guadan,
  C_POS_Settlement,C_POS_SQMa,C_MD_SPFin,C_POS_Login;
//端口初始化
var
  i:Integer=1;   //同一流水号下的商品序号
procedure TW_POS_MainWindow.FormCreate(Sender: TObject);

begin
  //应用程序加载主窗体，主窗体创建时调用登录
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
  Currency_time:TDateTime;   //当前时间
begin
  if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
     DM_ZB_Common.SetupConnection;

     lbl6.Caption:=DM_ZB_Common.vg_str_CashierID;
     lbl15.Caption:='欢迎进入收银界面！';

     //预设商品短码显示
     with uniqueryYSSP do
     begin
       Close;
       SQL.Clear;
       SQL.Add('SELECT * from t_bi_shortcode where store_id=:a');
       ParamByName('a').Value:=DM_ZB_Common.vg_str_DepartmentID;
       Open;
     end; 

    //UniQuery1.Active:=True;
    //商品列表显示
    with UniQuery1 do
    begin
      Close;
      sql.Clear;
      SQL.Add('select * from t_bi_saledealdetail where 1=2');
      Open;
    end;
    Currency_time:=DM_ZB_Common.GetDBDatetime;//获取数据库时间
    liushuihao:=generateLSH(Currency_time);    //生成流水号
    lbl4.Caption:=DateTimeToStr(Now);
    edt1.SetFocus;
    //edt1.Clear;
    lbl8.Caption:='0.00';
    lbl10.Caption:='0.00';
end;

//快捷键设置
procedure TW_POS_MainWindow.FormKeyPress(Sender: TObject; var Key: Char);
begin
    //当按下的是*时就单击button1
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

//删除功能的实现
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

     TotalNumAndFee(Sender,liushuihao);    //数量和金额统计
  end
  else
  begin
      lbl15.Caption:='当前无商品，无法删除';
      lbl8.Caption:='0.00';
      lbl10.Caption:='0.00';
  end;
  }
  if dbgrd1.DataSource.DataSet.IsEmpty then
  begin
      lbl15.Caption:='当前无商品，无法删除';
      lbl8.Caption:='0.00';
      lbl10.Caption:='0.00';
  end
  else
  begin
    UniQuery1.Delete;
  end;
  edt1.SelectAll;     //输入完选择文本框所有文本
end;

//会员
procedure TW_POS_MainWindow.btn4Click(Sender: TObject);
var
 // t_sql:string;
  KJ_jf:Integer;   //扣减积分
begin
  //动态创建窗体和释放窗体
  Application.CreateForm(TW_POS_VipForm,W_POS_VipForm);
  W_POS_VipForm.ShowModal;
  W_POS_VipForm.Free;

  //vipKH:=C_POS_Vip.vipKH;   //获取会员卡号
  //t_sql:='select * from t_mem_membaseinfo where mem_card_id='''+vipKH+'''';
  with unqryeditVip do      //查询会员信息
  begin
     SQL.Clear;
     SQL.Add('select * from t_mem_membaseinfo where mem_card_id=:a and card_status=''1''');
     ParamByName('a').Value:=vipKH;
     Open;
  end;
  //当前积分=累计增加积分-累计消费积分
  KJ_jf:=formalScore-unqryeditVip.FieldByName('mem_sub_point').AsInteger;
  //ShowMessage(IntToStr(jf));
  if vip_flag then
  begin
    lblHYH.Caption:=vipKH;
    lblHYJF.Caption:= IntToStr(KJ_jf);
    lblLQZE.Caption:=FloatToStr(formal_rest);   //numric 类型可直接使用asstring
    lbl15.Caption:='会员输入！';
  end
  else
  begin
     lblHYH.Caption:='';
     lblHYJF.Caption:= '';
     lblLQZE.Caption:='';   //numric 类型可直接使用asstring
  end;

  //lblLQZE.Caption:=unqryeditVip.FieldValues['change_total'];
  //ShowMessage('button4....');
  //更新会员ID到销售交易表中  TO DO
 { with unqryeditVip do
  begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE t_bi_saledeal SET men_id=:a where trade_turnover_num=:b');
    ParamByName('a').Value:=lblHYH.Caption;
    ParamByName('b').Value:=liushuihao;
    ExecSQL;
  end; }

  edt1.SelectAll;     //输入完选择文本框所有文本
end;

//**********结算*********
procedure TW_POS_MainWindow.btn7Click(Sender: TObject);
var
  //Currency_time:TDateTime;   //当前时间
  onsaleLSH:string;      //当前交易流水号
  moneySS:Double;    //实收金额
begin

  //当前交易窗口是否为空
   DM_ZB_Common.VG_ZB_ADOConnection.StartTransaction;  //开始一个事务
  try   //异常捕捉
     onsaleLSH:=UniQuery1.FieldByName('tran_seri_num').AsString;
     //当前销售界面不为空
     if  onsaleLSH<>'' then
     begin
       //判断是直接销售还是从挂单返回销售
       with unqryeditCX do
       begin
         Close;
         SQL.Clear;
         SQL.Add('select * from t_bi_saledeal where trade_turnover_num=:a');
         ParamByName('a').Value:=onsaleLSH;
         Open;
       end;
       //直接销售
       if unqryeditCX.RecordCount<1 then
         with UniQuery1 do
         begin
            Close;
            SQL.Clear;
            SQL.Add('insert into t_bi_saledeal values(:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k)');
            ParamByName('a').Value:=Trim(DM_ZB_Common.vg_str_DepartmentID);     //门店编号
            ParamByName('b').Value:=Now();                                      //交易时间
            ParamByName('c').Value:=Trim(liushuihao);                          //交易流水号
            ParamByName('d').Value:=Trim(DM_ZB_Common.vg_str_PosID);          //POS机号
            ParamByName('e').Value:=StrToFloat(lbl10.Caption);                 //销售应收总额
            ParamByName('f').Value:=StrToFloat(lbl10.Caption);                //销售实收总额
            //******To do 授权码值传入交易表中,授权码放在此处不合理******

            ParamByName('g').Value:='';                        //授权码
            ParamByName('h').Value:='0';                                     //状态
            ParamByName('i').Value:='';                  //会员ID

            //TO do 会员积分
            if lblHYJF.Caption<>'' then
                 ParamByName('j').Value:=StrToInt(lblHYJF.Caption)
            else
                 ParamByName('j').Value:=0;
            ParamByName('k').Value:=Trim(DM_ZB_Common.vg_str_CashierID);      //收银员ID
            ExecSQL;                         
          end;
       //从挂单返回销售    TO do

        //动态创建窗体和释放窗体
        Application.CreateForm(TW_POS_SettlementForm,W_POS_SettlementForm);
        W_POS_SettlementForm.ShowModal;
        W_POS_SettlementForm.Free;
        //判断是否结算成功,结算成功修改交易状态
        //TO do
        if setflag then
        begin
           //查找实收金额
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

       

           //交易成功后，若是会员，则计入会员积分
           //*******TO DO  应除去促销金额*******
           if HY_flag then
           begin
              with unqryeditVip do
              begin
                Close;
                sql.Clear;
                SQL.Add('INSERT into t_mem_pointchangeinfo VALUES(:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k,:l,:m,:n,:o)');
                ParamByName('a').Value:=HY_ID;       //会员ID
                ParamByName('b').Value:=vipKH;       //会员卡号
                ParamByName('c').Value:=Now;       //销售时间
                ParamByName('d').Value:=DM_ZB_Common.vg_str_DepartmentID;       //销售门店编号
                ParamByName('e').Value:=DM_ZB_Common.vg_str_PosID;       //POS机号
                ParamByName('f').Value:=DM_ZB_Common.vg_str_CashierID;       //收银员ID
                ParamByName('g').Value:=liushuihao;       //交易流水号
                ParamByName('h').Value:=moneySS;       //整单金额
                ParamByName('i').Value:=formalScore;      //原累计积分？？？？？
                ParamByName('j').Value:=Floor(moneySS);       //积分变化量
                ParamByName('k').Value:=formalScore+Floor(moneySS);       //现累计积分
                ParamByName('l').Value:=formal_rest;      //原零钱
                ParamByName('m').Value:=0;       //零钱变化量
                ParamByName('n').Value:=formal_rest;       //现零钱
                ParamByName('o').Value:='';       //备注
                ExecSQL;
              end;

              //更新会员累计积分、累计消费额，零钱总量、修改时间、修改人
              with unqryeditVip do
              begin
                Close;
                sql.Clear;
                SQL.Add('UPDATE t_mem_membaseinfo SET mem_add_point=:a,mem_sum_sale_acco=:b,change_total=:c,modify_date=:d,modify_oper=:e');
                SQL.Add(' WHERE mem_card_id=:f');
                ParamByName('a').Value:=formalScore+Floor(moneySS);    //累计积分
                ParamByName('b').Value:=formal_totalXF+moneySS;    //累计消费额
                ParamByName('c').Value:=formal_rest;    //零钱总额   ???
                ParamByName('d').Value:=Now;    //修改时间
                ParamByName('e').Value:=DM_ZB_Common.vg_str_CashierID;    //修改人
                ParamByName('f').Value:=vipKH;
                ExecSQL;
              end;
              
              

           end;
           vipKH:='';   //会员卡号为空
           lblHYH.Caption:='';
           lblHYJF.Caption:='';
           lblLQZE.Caption:='';
           lbl8.Caption:='0.00';
           lbl10.Caption:='0.00';
           UniQuery1.Close;
          // Currency_time:=DM_ZB_Common.GetDBDatetime;//获取数据库时间
           //liushuihao:=generateLSH(Currency_time);    //生成流水号
           // W_POS_SettlementForm.ShowModal;
           i:=1;
        end
        else         //废单处理
        begin
           with unqryeditCX do
           begin
              Close;
              SQL.Clear;
              SQL.Add('UPDATE t_bi_saledeal SET status=''3'' where trade_turnover_num=:a');
              ParamByName('a').Value:=liushuihao;
              ExecSQL;
           end;
           //Currency_time:=DM_ZB_Common.GetDBDatetime;//获取数据库时间
           //liushuihao:=generateLSH(Currency_time);    //生成流水号
           // W_POS_SettlementForm.ShowModal;
           i:=1;
        end;

      
     end
     else
     begin
       lbl15.Caption:='当前无商品销售，无法结算！';
     end;

     DM_ZB_Common.VG_ZB_ADOConnection.Commit;
  except
     DM_ZB_Common.VG_ZB_ADOConnection.Rollback;  //事件回滚
     ShowMessage('Error!');
     close;
  end;
  //UniQuery1.SQL.Clear;

end;

//修改数量       //TO DO .....页面细化
procedure TW_POS_MainWindow.btn1Click(Sender: TObject);
//var
  //v_sql:='update t_bi_saledealdetail set sale_count=a''
begin
  //动态创建窗体和释放窗体
  Application.CreateForm(TW_POS_quantityForm,W_POS_quantityForm);
  W_POS_quantityForm.ShowModal;
  W_POS_quantityForm.Free;
  quality:=C_POS_quantity.quality;
  with UniQuery1 do//uniquery1只做显示，不做其他sql操作
  begin
    //UniQuery1.Locate('row_id',UniQuery1.FieldByName('row_id').value,[loPartialKey]);
    Edit;   //进入编辑状态
    dbgrd1.DataSource.DataSet.FieldByName('sale_count').AsFloat:=quality;
    dbgrd1.DataSource.DataSet.FieldByName('sale_total').AsFloat:=quality*UniQuery1.FieldByName('sale_price').AsFloat;
    //UniQuery1.FieldByName('sale_count').AsFloat:=quality;
    //UniQuery1.FieldByName('sale_total').AsFloat:=quality*UniQuery1.FieldByName('sale_price').AsFloat;
    Post ;   //提交数据
  end;
  TotalNumAndFee(Sender,liushuihao);    //数量和金额统计
  //ShowMessage('******...');
  edt1.SelectAll;     //输入完选择文本框所有文本
end;

procedure TW_POS_MainWindow.intgrfldUniQuery1XuhaoGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := IntToStr(UniQuery1.RecNo);  //在表格中显示行号
end;

//流水号生成，20位
function TW_POS_MainWindow.generateLSH(var Currency_time:TDateTime):string;
var
    m,s:string;
    mdstr,posstr,datestr:string;
    j:Integer;
    l_sql:string;
begin

    //to do 从总部获取数据     -----done!
    posstr:=DM_ZB_Common.vg_str_PosID;       //获取POS编号
    mdstr:=DM_ZB_Common.vg_str_DepartmentID;    //获取门店编号
    //z_len:=4;   //   流水保留5位
    datestr:=FormatDateTime('yyyymmdd',Currency_time); //时间转Sting
    //endstring:=LeftStr(datestr,8);    //截取左边8位
    s:='S'+mdstr+posstr+datestr;

    //to do 根据时间、门店编号、pos号查询    -----done!
    // 取出同一天中的最大流水号
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

//退出
procedure TW_POS_MainWindow.btn6Click(Sender: TObject);
var
  ExitFlag:Integer;
begin
   ExitFlag:=Application.MessageBox('是否确认退出?','提示',MB_ICONINFORMATION+MB_OkCancel);
  If ExitFlag=2 then//不退出
    Begin
      Exit;
    end
  else
    Begin
      Application.Terminate;     //退出
    End;
end;

//退出系统
procedure TW_POS_MainWindow.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  ExitFlag:Integer;//退出标志
begin
  ExitFlag:=Application.MessageBox('是否确认退出?','提示',MB_ICONINFORMATION+MB_OkCancel);
  If ExitFlag=2 then//不退出
    Begin
    //TCloseAction = (caNone, caHide, caFree, caMinimize);
      Action:=caNone;
      Exit;
    end
  else
    Begin
      Application.Terminate;     //退出
    End;
end;

//dbgrd1的整行选取、颜色设置
procedure TW_POS_MainWindow.dbgrd1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  // dbgrid的options属性里的dgrowselect=true
  if gdselected in state then
     dbgrd1.Canvas.Brush.Color:=clgradientinactivecaption
   else
     dbgrd1.Canvas.Brush.Color := clwindow;
   dbgrd1.DefaultDrawColumnCell(rect,datacol,column,state);
end;

//通过商品编码查询，若查不到，报错，若查出多条结果，弹出选择框
procedure TW_POS_MainWindow.edt1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var

  //spbm:string;            //商品编码
  v_sql1,v_sql3:string;
  rows:Integer;          //行号
  spbh,spmc,splx_id,gys_id:string;   //商品编号、商品名称  商品类型ID 供应商ID
  spjg:double;     //商品价格
  //Currency_time:TDateTime;   //当前时间
  edtLengh:Integer;   //字符长度
  comId:string;  //通过短码查询到的商品自编码
  Currency_time:TDateTime;   //当前时间

begin

  if (Key=VK_RETURN)  then
  begin
    //判断当前交易列表是否为空*****To  Do
   if dbgrd1.DataSource.DataSet.IsEmpty then
   begin
      //vipKH:='';   //会员卡号为空
      //lblHYH.Caption:='';
      //lblHYJF.Caption:='';
     // lblLQZE.Caption:='';
      Currency_time:=DM_ZB_Common.GetDBDatetime;//获取数据库时间
      liushuihao:=generateLSH(Currency_time);    //生成流水号
   end;
  
  //To DO ***短码2位，商品编码至少3位模糊查询****

  spbm:=Trim(edt1.Text);
  edtLengh:=Length(spbm);    //输入的字符长度
  if edtLengh<2 then
  begin
     lbl15.Caption:='您输入的字符少于2位,请重新输入！';
     edt1.SetFocus;
  end
  //短码查询
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
     //通过短码未查到记录
     if uniqueryYSSP.RecordCount<1 then
     begin
       lbl15.Caption:='未找到记录，请核对后输入！';
       edt1.SetFocus;
     end
     else
     //TO Do 短码精确查询，查到之后自动加入商品到列表中? 将自编码输入到edit中
     begin
        comId:=uniqueryYSSP.FieldByName('commodity_id').AsString;
        //edt1.Text:=comId;
        //找到该商品，并直接加入到商品交易列表中
        v_sql1:='select * from t_bi_commbaseinfo'+
         ' where commodity_id = '''+comID+''' and status=''1''';                       //where前面加一个空格
        with unqryedit1 do
        begin
           close;
           SQL.Clear;
           SQL.Add(v_sql1);
           Open;
        end;
        //可能出现短码上的编号过期情况，即通过短码找不到商品
        if unqryedit1.RecordCount<1 then
        begin
           lbl15.Caption:='未找到记录，请核对该短码是否过期！';
        end
        else
        begin

          //spbh:=unqryedit1.Fields.Fields[0].Value;       //商品编号
          //spmc:=unqryedit1.Fields.Fields[1].Value;       //商品名称
         // spjg:=unqryedit1.Fields.Fields[2].Value;       //商品价格
          spbh:=unqryedit1.FieldByName('commodity_id').AsString;       //商品编号
          spmc:=unqryedit1.FieldByName('commodity_name').AsString;       //商品名称
          spjg:=unqryedit1.FieldByName('retail_price').AsFloat;      //商品价格
          //splx_id:=unqryedit1.FieldByName('comm_type_id').AsString;  //商品类型ID
          //gys_id:=unqryedit1.FieldByName('main_supplier').AsString;  // 供应商ID

          quality:=1.0;  //数量默认为1

          {//促销---传入结构体
          sd[i].commodity_id:=spbh;
          sd[i].Sale_num:=quality;
          sd[i].SalePrice:=spjg;
          sd[i].CommType:=splx_id;
          sd[i].SupplierID:=gys_id;}


           with UniQuery1 do
           begin
               //将数据插入商品交易信息表
               begin
                  Close;
                  SQL.Clear;
                  //SQL.Add(v_sql2);
                  SQL.Add('insert into t_bi_saledealdetail values(:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k,:l,:m)');
                  ParamByName('a').Value:=IntToStr(i);                     //流水号的序号
                  ParamByName('b').Value:=DM_ZB_Common.vg_str_DepartmentID;         // 门店编码
                  ParamByName('c').Value:=Trim(liushuihao);                          //交易流水号
                  ParamByName('d').Value:=Trim(spbh);                               //商品编码
                  ParamByName('e').Value:=Trim(spmc);                             //商品名称
                  ParamByName('f').Value:=FloatToStr(spjg);                       //零售单价
                  ParamByName('g').Value:=FloatToStr(spjg);                        //销售价格
                  ParamByName('h').Value:=FloatToStr(spjg);                       //成本单价
                  ParamByName('i').Value:=FloatToStr(quality);                  // 销售数量
                  ParamByName('j').Value:=0.00;                                  //促销数量
                  ParamByName('k').Value:=0.00;                                 //促销价格
                  ParamByName('l').Value:=FloatToStr(spjg*quality);           //销售总额 (小计)
                  ParamByName('m').Value:=0;                               //会员积分
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
           TotalNumAndFee(Sender,liushuihao);    //数量和金额统计
        end;
     end;
  end
  else
  //3位以上模糊查询
  begin
     v_sql1:='select commodity_id,commodity_name,retail_price from t_bi_commbaseinfo'+
     ' where status=''1'' and commodity_id like '''+spbm+'%''';             //where前面加一个空格
      with unqryedit1 do
      begin
         close;
         SQL.Clear;
         SQL.Add(v_sql1);
         Open;
      end;
     //Currency_time:=DM_ZB_Common.GetDBDatetime;
     rows:=unqryedit1.RecordCount;     //查询到的记录数

     if  rows<1 then
        ShowMessage('没有查询到记录！请重新输入！')
     else if rows>1 then
     begin
        //ShowMessage('弹出一个商品查询框')
        Application.CreateForm(TW_MD_SPFinForm,W_MD_SPFinForm);
        W_MD_SPFinForm.ShowModal;
        W_MD_SPFinForm.Free;
        //W_MD_SPFinForm.ShowModal;
        //判断是否查询成功
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
            spbh:=unqryeditCX.FieldByName('commodity_id').AsString;       //商品编号
            spmc:=unqryeditCX.FieldByName('commodity_name').AsString;       //商品名称
            spjg:=unqryeditCX.FieldByName('retail_price').AsFloat;      //商品价格

            //splx_id:=unqryeditCX.FieldByName('comm_type_id').AsString;  //商品类型ID
            //gys_id:=unqryeditCX.FieldByName('main_supplier').AsString;  // 供应商ID

            quality:=1.0;  //数量默认为1

            {//促销---传入结构体
            sd[i].commodity_id:=spbh;
            sd[i].Sale_num:=quality;
            sd[i].SalePrice:=spjg;
            sd[i].CommType:=splx_id;
            sd[i].SupplierID:=gys_id;    }

            with UniQuery1 do
            begin
               //将数据插入商品交易信息表
               begin
                  Close;
                  SQL.Clear;
                  //SQL.Add(v_sql2);
                  SQL.Add('insert into t_bi_saledealdetail values(:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k,:l,:m)');
                  ParamByName('a').Value:=IntToStr(i);                      //流水号的序号
                  ParamByName('b').Value:=DM_ZB_Common.vg_str_DepartmentID;         // 门店编码
                  ParamByName('c').Value:=Trim(liushuihao);                          //交易流水号
                  ParamByName('d').Value:=Trim(spbh);                               //商品编码
                  ParamByName('e').Value:=Trim(spmc);                             //商品名称
                  ParamByName('f').Value:=FloatToStr(spjg);                       //零售单价
                  ParamByName('g').Value:=FloatToStr(spjg);                        //销售价格
                  ParamByName('h').Value:=FloatToStr(spjg);                       //成本单价
                  ParamByName('i').Value:=FloatToStr(quality);                  // 销售数量
                  ParamByName('j').Value:=0.00;                                  //促销数量
                  ParamByName('k').Value:=0.00;                                 //促销价格
                  ParamByName('l').Value:=FloatToStr(spjg*quality);           //销售总额 (小计)
                  ParamByName('m').Value:=0;                                  //会员积分
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
           TotalNumAndFee(Sender,liushuihao);    //数量和金额统计

        end;
     end
     else
     begin
       //spbh:=unqryedit1.Fields.Fields[0].Value;       //商品编号
       //spmc:=unqryedit1.Fields.Fields[1].Value;       //商品名称
       //spjg:=unqryedit1.Fields.Fields[2].Value;       //商品价格
       spbh:=unqryedit1.FieldByName('commodity_id').AsString;       //商品编号
       spmc:=unqryedit1.FieldByName('commodity_name').AsString;       //商品名称
       spjg:=unqryedit1.FieldByName('retail_price').AsFloat;      //商品价格
       //splx_id:=unqryedit1.FieldByName('comm_type_id').AsString;  //商品类型ID
       //gys_id:=unqryedit1.FieldByName('main_supplier').AsString;  // 供应商ID

        quality:=1.0;  //数量默认为1
       begin

        {//促销---传入结构体
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


        //to do 相同扫描记录可重复出现  -------done!
       with UniQuery1 do
       begin
           //将数据插入商品交易信息表
           begin
              Close;
              SQL.Clear;
              //SQL.Add(v_sql2);
              SQL.Add('insert into t_bi_saledealdetail values(:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k,:l,:m)');
              ParamByName('a').Value:=IntToStr(i);                     //流水号的序号
              ParamByName('b').Value:=DM_ZB_Common.vg_str_DepartmentID;         // 门店编码
              ParamByName('c').Value:=Trim(liushuihao);                          //交易流水号
              ParamByName('d').Value:=Trim(spbh);                               //商品编码
              ParamByName('e').Value:=Trim(spmc);                             //商品名称
              ParamByName('f').Value:=FloatToStr(spjg);                       //零售单价
              ParamByName('g').Value:=FloatToStr(spjg);                        //销售价格
              ParamByName('h').Value:=FloatToStr(spjg);                       //成本单价
              ParamByName('i').Value:=FloatToStr(quality);                  // 销售数量
              ParamByName('j').Value:=0.00;                                  //促销数量
              ParamByName('k').Value:=0.00;                                 //促销价格
              ParamByName('l').Value:=FloatToStr(spjg*quality);           //销售总额 (小计)
              ParamByName('m').Value:=0;                               //会员积分
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
       TotalNumAndFee(Sender,liushuihao);    //数量和金额统计

     end;
    end;
  end;




  // spjg:=1.0;


       //默认焦点在最后一行，上下移动 (焦点必须在DBgrid中才可行)
      UniQuery1.Last;
      if key=vk_up then
          if uniquery1.Bof =false then
            uniquery1.Prior;
      if key=vk_down then
          if uniquery1.eof =false then
            uniquery1.next;
     edt1.SelectAll;     //输入完选择文本框所有文本
  end;
end;

//数量和金额统计
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

//其他
procedure TW_POS_MainWindow.btn3Click(Sender: TObject);
begin
  //动态创建窗体和释放窗体
  Application.CreateForm(TW_POS_OtherForm,W_POS_OtherForm);
  W_POS_OtherForm.ShowModal;
  W_POS_OtherForm.Free;
  W_POS_OtherForm:=nil;
//ShowMessage('112234');
end;

//挂单
procedure TW_POS_MainWindow.btn5Click(Sender: TObject);
var
  gd_sql1,onsaleLSH:string;    //当前流水号
  //Currency_time:TDateTime;   //当前时间
begin
  //****1、正在销售，挂单，当前的交易记录添加到挂单信息表中***
  //****3、若有多条挂单记录，选择相应的挂单号，进入收银**

   DM_ZB_Common.VG_ZB_ADOConnection.StartTransaction;  //开始一个事务
   try   //异常捕捉
     onsaleLSH:=UniQuery1.FieldByName('tran_seri_num').AsString;

     //当前销售界面不为空
     if  onsaleLSH<>'' then
     begin
        //查询当前流水号是否存在于挂单表中
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
          //该流水号不存在挂单信息表中
          with UniQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('insert into t_bi_saledeal values(:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k)');
            ParamByName('a').Value:=Trim(DM_ZB_Common.vg_str_DepartmentID);     //门店编号
            ParamByName('b').Value:=Now();                                      //交易时间
            ParamByName('c').Value:=Trim(liushuihao);                          //交易流水号
            ParamByName('d').Value:=Trim(DM_ZB_Common.vg_str_PosID);          //POS机号
            ParamByName('e').Value:=StrToFloat(lbl10.Caption);                //销售应收总额
            ParamByName('f').Value:=StrToFloat(lbl10.Caption);                //销售实收总额
            ParamByName('g').Value:='';                                         //授权码
            ParamByName('h').Value:='1';                                     //状态

            ParamByName('i').Value:='';                                         //会员ID
            //TO do 会员积分
            if lblHYJF.Caption<>'' then
               ParamByName('j').Value:=StrToInt(lblHYJF.Caption)
            else
               ParamByName('j').Value:=0;
            ParamByName('k').Value:=Trim(DM_ZB_Common.vg_str_CashierID);      //收银员ID
            ExecSQL;
          end;

          //*******TO do,  连续处理，会出现两个相同商品的两个流水号******
          //Currency_time:=DM_ZB_Common.GetDBDatetime;//获取数据库时间
          //liushuihao:=generateLSH(Currency_time);    //生成流水号
       end
       else
       //该流水号存在挂单信息表中
       begin
          unqryeditCX.Edit;
          unqryeditCX.FieldByName('status').AsString:='1';
          unqryeditCX.Post;
          UniQuery1.Close;
          
       end;
       //挂单成功后，生成新的流水号,进行新的交易
        lbl15.Caption:='挂单成功！';
        //Currency_time:=DM_ZB_Common.GetDBDatetime;//获取数据库时间
        //liushuihao:=generateLSH(Currency_time);    //生成流水号
     end
     //当前销售界面为空
     else
     begin
       //判断是否有挂单信息
        with unqryeditCX do
        begin
          Close;
          sql.Clear;
          SQL.Add('select * from t_bi_saledeal where status=''1''');
          Open;
        end;
        if unqryeditCX.RecordCount<1 then
        begin
           lbl15.Caption:='当前无商品销售，不能挂单！';
        end
        //只有一条挂单信息，直接返回销售界面
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
            TotalNumAndFee(Sender,onsaleLSH);    //数量和金额统计

            //返回销售界面，修改状态为0
            with  unqryeditCX do
            begin
              Close;
              SQL.Clear;
              SQL.Add('update t_bi_saledeal set status=''0'' where trade_turnover_num=:a');
              ParamByName('a').Value:=onsaleLSH;
              ExecSQL;
            end;
            lbl15.Caption:='调出挂单成功！';
        end
        //有多条挂单信息，弹出挂单界面
        else
        begin
            //动态创建窗体和释放窗体
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
            TotalNumAndFee(Sender,onsaleLSH);    //数量和金额统计

            //返回销售界面，修改状态为0
            with  unqryeditCX do
            begin
              Close;
              SQL.Clear;
              SQL.Add('update t_bi_saledeal set status=''0'' where trade_turnover_num=:a');
              ParamByName('a').Value:=onsaleLSH;
              ExecSQL;
            end;
            lbl15.Caption:='调出挂单成功！';
        end;

     end;

     DM_ZB_Common.VG_ZB_ADOConnection.Commit;
  except
     DM_ZB_Common.VG_ZB_ADOConnection.Rollback;  //事件回滚
     ShowMessage('Error!');
     close;
  end;
 end;

 //编辑框输入设置
procedure TW_POS_MainWindow.edt1KeyPress(Sender: TObject; var Key: Char);
begin
    if not (Key in ['0'..'9',#13,#8]) then
       key:=#0;
end;

//预设商品行号设计
procedure TW_POS_MainWindow.intgrfldYSSP_XHGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text:=IntToStr(uniqueryYSSP.RecNo);  //在表格中显示行号
end;

end.

