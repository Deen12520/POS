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
  spid_temp : array[ 0..20] of string;        //获取当前选中行的商品id
  spmc_temp : array[ 0..20] of string;       //获取当前单据号的商品名称
  scount_temp : array[ 0..20] of string;      //获取当前商品的销售数量
 // j : Integer;    //用于循环销售交易单对应的销售交易详单的数量
  k : Integer;    //用于循环销售交易详单对应的不同商品的数量

implementation
  uses C_ZB_DataModule,UnitAutoComplete;
{$R *.dfm}
var
  i:Integer=1;   //同一退货流水号下的商品序号
  liushuihao:string;  //当前流水号
  THshuihaohao:string;  //退货流水号
  LStrings: TStringList;    //存储数据的序列
//开始时页面不显示
procedure TW_MD_ReturnForm.FormShow(Sender: TObject);
var
  temp,s_time,e_time : string;
  
begin
    s_time := DateTimeToStr(Now);
    e_time := DateTimeToStr(incday(Now,-7));//当前日期前七天

   //百度搜索功能实现
    LStrings := TStringList.Create;
    //加入数据字段  (近7天的记录)
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
           Next;  //指针下移
        end;
    end;
    TAutoComplete.EnableAutoComplete(edtRetrn, LStrings, ACO_AUTOSUGGEST + ACO_UPDOWNKEYDROPSLIST);
    
   temp := 'select * from t_bi_saledeal'
    +' LEFT JOIN t_bi_saledealdetail on t_bi_saledeal.trade_turnover_num=t_bi_saledealdetail.tran_seri_num'
    +' where 1=2';
   if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
   DM_ZB_Common.SetupConnection;
   {初始化时显示空表}
   with uniqueryJY do
   begin
     SQL.Clear;
     SQL.Add(temp);
     Open;
   end;
   KeyPreview:=True;
end;

//退出当前窗口
procedure TW_MD_ReturnForm.btnRetrn_EscClick(Sender: TObject);
begin
  if Application.MessageBox(PChar('您确定要退出吗？'), '询问', MB_ICONQUESTION + MB_YESNO) = ID_YES then
      Self.Close;
end;

//行号递增
procedure TW_MD_ReturnForm.intgrfldTHFieldGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := IntToStr(unqrySelect.RecNo);
end;

//交易表行数递增
procedure TW_MD_ReturnForm.intgrflduniquery2HHGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := IntToStr(uniqueryJY.RecNo);
end;

//点击退货按钮跳转到退货页面，并将选中商品传入退货页面
// 退货成功后需要弹钱箱  TO Do
procedure TW_MD_ReturnForm.btnRetrnClick(Sender: TObject);
begin
    i:=1;
    //将退货记录写入到销售交易表中（是否大于现金？是否新增状态，退货？？？？）
    if StrToFloat(edtXJ.Text)<-StrToFloat(lbl6.Caption) then
    begin
      lbl8.Caption:='退款费用大于现金，无法退货！';// ＴＯ　ＤＯ需要删减退货数量
      //uniqueryTH.Delete;
    end
    else
    begin
       with uniqueryTJ do
       begin
          Close;
          SQL.Clear;
          SQL.Add('insert into t_bi_saledeal values(:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k)');
          ParamByName('a').Value:=Trim(DM_ZB_Common.vg_str_DepartmentID);     //门店编号
          ParamByName('b').Value:=Now();                                      //退货时间
          ParamByName('c').Value:=Trim(THshuihaohao);                          //退货流水号
          ParamByName('d').Value:=Trim(DM_ZB_Common.vg_str_PosID);          //POS机号
          ParamByName('e').Value:=StrToFloat(lbl6.Caption);                 //销售应收总额
          ParamByName('f').Value:=StrToFloat(lbl6.Caption);                //销售实收总额

          ParamByName('g').Value:='';                        //授权码
          ParamByName('h').Value:='2';                                     //状态
          ParamByName('i').Value:='';                  //会员ID

          ParamByName('j').Value:=0;        //会员积分
          ParamByName('k').Value:=Trim(DM_ZB_Common.vg_str_CashierID);      //收银员ID
          ExecSQL;

          //退货信息写入支付信息表
          Close;
          SQL.Clear;
          SQL.Add('insert into t_dealpaydetail values(:a,:b,:c,:d,:e,:f)');
          ParamByName('a').Value:=DM_ZB_Common.vg_str_DepartmentID;  //门店编码
          ParamByName('b').Value:=Now;       //交易时间
          ParamByName('c').Value:=THshuihaohao;       //退货流水号
          ParamByName('d').Value:='0';       //支付方式ID ，默认现金退款
          ParamByName('e').Value:=StrToFloat(lbl6.Caption); //支付金额

          //*******To do 如果储值卡号或会员卡号******
          ParamByName('f').Value:='';       //卡号
          ExecSQL;

       end;
       lbl8.Caption:='退货成功！';
       btnRetrn_Esc.SetFocus;
    end;

end;

//控制输入 以及 快捷键设置
procedure TW_MD_ReturnForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if(Key=#84) then   //T键快速退货
      btnRetrn.Click;

    if(Key=#27) then    //ESC键退出
      btnRetrn_Esc.Click;
end;

//小票查询
procedure TW_MD_ReturnForm.edtRetrnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  danjuhao : string;     //输入的小票单号
begin
    danjuhao:=Trim(edtRetrn.Text);
    if (Key=VK_RETURN) then
    begin
      //从销售交易表中获取该单的pos机号，收银员id，交易时间
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
         showmessage('无查询结果！');
         btnRetrn.Enabled:=False;
         edtRetrn.SetFocus;
      end
      else
      begin
        btnRetrn.Enabled:=True;
        liushuihao:=danjuhao;    //当前单的流水号
         //单号
         edtDH.Text:=liushuihao;
        // POS机号
        edtPOS.Text:=unqrySelect.FieldValues['sale_pose_id'];
        //收银员ID
        edtSYY.Text:=unqrySelect.FieldValues['cashier_id'];
        //交易时间
        edtJYSJ.Text:=unqrySelect.FieldValues['trade_time'];
        //总计
        edtZJ.Text:=unqrySelect.FieldValues['sale_real_total'];
        //现金
        edtXJ.Text:=unqrySelect.FieldValues['pay_money'];

        //商品列表信息显示
        with uniqueryJY do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM t_bi_saledealdetail where tran_seri_num=:a');
          ParamByName('a').Value:=danjuhao;
          Open;
        end;

        //默认焦点在最后一行，上下移动 (焦点必须在DBgrid中才可行)
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

//dbgrd1的整行选取、颜色设置
procedure TW_MD_ReturnForm.dbgrdJYDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  // dbgrid的options属性里的dgrowselect=true
  if gdselected in state then
     dbgrdJY.Canvas.Brush.Color:=clgradientinactivecaption
   else
     dbgrdJY.Canvas.Brush.Color := clwindow;
   dbgrdJY.DefaultDrawColumnCell(rect,datacol,column,state);
end;

//显示选中行的记录信息
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

//往退货列表中加入退货记录
procedure TW_MD_ReturnForm.edtTHSLKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  numTH:Double;   //退货数量
  spbh,spmc:string;   //商品编号、商品名称
  spjg,spsl:double;     //商品价格

begin
   if (Key=VK_RETURN) then
    begin
      //1、获取当前小票号下销售基本信息
      if uniqueryJY.Eof and uniqueryJY.Bof then
            Exit
      else
      begin
        spbh:=uniqueryJY.FieldByName('commodity_id').AsString;
        spmc:=uniqueryJY.FieldByName('commodity_name').AsString;
        spjg:=uniqueryJY.FieldByName('sale_price').AsFloat;
        spsl:=uniqueryJY.FieldByName('sale_count').AsFloat;
      end;

      //2、生成新的退货流水号
      THshuihaohao:='R'+copy(liushuihao,2,Length(liushuihao));
      //ShowMessage(THshuihaohao);

      //3、生成退货记录

      numTH:=StrToFloat(edtTHSL.Text);
      //退货数量不能大于购买数量
      if numTH>spsl then
         lbl8.Caption:='退货数量不能大于购买数量，请核对！'
      else if  -StrToFloat(lbl6.Caption)> StrToFloat(edtXJ.Text)  then
      begin
        lbl8.Caption:='退货金额超出现金！无法退货'
      end
      else
      begin
         with uniqueryTJ do
        begin
          Close;
          sql.Clear;
          SQL.Add('insert into t_bi_saledealdetail values(:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k,:l,:m)');
          ParamByName('a').Value:=IntToStr(i);                          //流水号的序号
          ParamByName('b').Value:=DM_ZB_Common.vg_str_DepartmentID;         // 门店编码
          ParamByName('c').Value:=Trim(THshuihaohao);                          //退货流水号
          ParamByName('d').Value:=Trim(spbh);                               //商品编码
          ParamByName('e').Value:=Trim(spmc);                             //商品名称
          ParamByName('f').Value:=spjg;                       //零售单价
          ParamByName('g').Value:=spjg;                        //销售价格
          ParamByName('h').Value:=spjg;                       //成本单价
          ParamByName('i').Value:=-numTH;                  // 退货数量
          ParamByName('j').Value:=0.00;                                  //促销数量
          ParamByName('k').Value:=0.00;                                 //促销价格
          ParamByName('l').Value:=-spjg*numTH;           //退货总额 (小计)
          ParamByName('m').Value:=0;                               //会员积分
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
    

        //4、计算退货数量和退货金额
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

//下拉列表实时更新
procedure TW_MD_ReturnForm.edtRetrnChange(Sender: TObject);
var
  temp1,temp2:string;
begin
  temp1:=UpperCase(Trim(edtRetrn.Text));
  temp2:='SELECT trade_turnover_num from t_bi_saledeal where store_id=''1001'''+
     ' and (trade_turnover_num like '''+temp1+'%'')' +
     ' limit 5';
     {
   //百度搜索功能实现
    //LStrings.Clear;  //清空数据
    //LStrings.Free;   //释放
    LStrings := TStringList.Create;
    //加入数据字段
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
           Next;  //指针下移
        end;
    end;
    TAutoComplete.EnableAutoComplete(edtRetrn, LStrings, ACO_AUTOSUGGEST + ACO_UPDOWNKEYDROPSLIST);
     }
end;

end.
