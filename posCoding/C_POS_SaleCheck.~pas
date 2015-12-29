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
    procedure btnESCClick(Sender: TObject); //流水号生成
    procedure check_right(Sender: TObject; var Key: Char);
    procedure edtRMBKeyPress(Sender: TObject; var Key: Char);
    procedure edtBankKeyPress(Sender: TObject; var Key: Char);
    procedure edtCZKKeyPress(Sender: TObject; var Key: Char);
    procedure edtGWQKeyPress(Sender: TObject; var Key: Char);//编辑框合法性判断
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
  liushuihao:string;//流水号
  
procedure TW_POS_SaleCheckForm.FormShow(Sender: TObject);
var
  Currency_time:TDateTime;
begin
    if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
      DM_ZB_Common.SetupConnection;
   //unqrySaleCheck.Active:=True;

   //接受从主界面传来的收银员ID
   lblCashierId.Caption:= DM_ZB_Common.vg_str_CashierID;
   //lblCashierId.Caption:= '012';  

   //生成交易时间
   Currency_time:=DM_ZB_Common.GetDBDatetime;
   lblSDate.Caption:= DateTimeToStr(Currency_time);

   //生成流水号
   liushuihao:=generateLSH(Currency_time);

   //焦点移动到现金编辑框，并且总计的编辑框设置为只读
   edtRMB.SetFocus;
   edtTotal.ReadOnly := True;

end;

//流水号生成
function TW_POS_SaleCheckForm.generateLSH(var Currency_time:TDateTime):string;
var
  penal_num:string;  //流水号编号
  str_date:string;
  m,s:string;
  mdstr,posstr,datestr:string;
  i:Integer;
  l_sql:string;  //流水号查询语句
begin
    //生成一个新的流水号

    //to do 从总部获取数据     -----done!
    posstr:=DM_ZB_Common.vg_str_PosID;       //获取POS编号
    mdstr:=DM_ZB_Common.vg_str_DepartmentID;    //获取门店编号
    str_date:=SysUtils.FormatDateTime('yyyymmdd',Currency_time);//获取年月日
    penal_num:='DZ'+mdstr+posstr+str_date;

    //to do 根据时间、门店编号、pos号查询    -----done!
    // 取出同一天中的最大流水号
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
     result:=penal_num;           //返回值只能传给result
end;

//确认提交钱箱的金额
procedure TW_POS_SaleCheckForm.btnOKClick(Sender: TObject);
var
  i:Integer;
  Currency_time:TDateTime;
  c_sql:string;//应缴金额查询
  sum : Double;//总计金额
  a : array[0..3]  of Double;//用来保存查询到的各支付方式对应金额
  b : array[0..3] of Double;//用来保存输入的各支付方式对应金额
begin
  // 取出该收银员上班时间内的各支付方式的应收金额
   c_sql:='select c.pay_way_name as name,sum(b.pay_money) as sum from t_dealpaydetail as b'+
           ' left JOIN  t_bi_storeturnwork as stw on b.store_id = stw.store_id'+
           ' left JOIN t_bi_payway  as c on  b.pay_way_id=c.pay_way_id'+
           '  where (stw.employee_id ='''+lblCashierId.Caption+''' and'+
           '  (b.trade_date >= stw.onwork_time'+
           ' and b.trade_date <= stw.offwork_time))'+
           ' GROUP BY name';

           {？？？？？ 查询该收银员最近一次的上班时间并对该时间段内的金额分类汇总（？？支付金额会加倍）
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

    //计算应缴总额
    sum := 0;
    dbgrdPMoney.Columns[0].Title.Caption := '支付方式';
    dbgrdPMoney.Columns[0].Width := 80;
    dbgrdPMoney.Columns[1].Title.Caption := '金额';
    dbgrdPMoney.Columns[1].Width := 60;
    //unqrySaleCheck.RecNo := 1;//将光标指向第一行
    unqrySaleCheck.First;
    //累加各支付方式金额，即总额
    while not unqrySaleCheck.Eof do
    begin
      sum := sum+dbgrdPMoney.DataSource.DataSet.FieldByName('sum').AsFloat;
      if dbgrdPMoney.DataSource.DataSet.FieldByName('name').AsString = '现金' then
      begin
        //插入应收现金总额
        a[0] := dbgrdPMoney.DataSource.DataSet.FieldByName('sum').AsFloat;
        b[0] :=  StrToFloat(edtRMB.Text);
      end
      else if dbgrdPMoney.DataSource.DataSet.FieldByName('name').AsString = '银行卡' then
      begin
      //插入应收银行卡总额
        a[1] := dbgrdPMoney.DataSource.DataSet.FieldByName('sum').AsFloat;
        b[1] :=  StrToFloat(edtBank.Text);
      end
      else if dbgrdPMoney.DataSource.DataSet.FieldByName('name').AsString = '储值卡' then
      begin
      //插入应收储值卡总额
        a[2] := dbgrdPMoney.DataSource.DataSet.FieldByName('sum').AsFloat;
        b[2] :=  StrToFloat(edtCZK.Text);
      end
      else if dbgrdPMoney.DataSource.DataSet.FieldByName('name').AsString = '购物券' then
      begin
      //插入应收购物券总额
        a[3] := dbgrdPMoney.DataSource.DataSet.FieldByName('sum').AsFloat;
        b[3] :=  StrToFloat(edtGWQ.Text);
      end;
      unqrySaleCheck.Next;
    end;
     lbl_PTotal.Caption := FloatToStr(sum);
     edtTotal.ReadOnly := False;
     edtTotal.Text := FloatToStr(StrToFloat(edtRMB.Text)+ StrToFloat(edtBank.Text)+ StrToFloat(edtCZK.Text)+ StrToFloat(edtGWQ.Text));
     pnlPMoney.Visible := True;

     //将所有编辑框的属性设置为只读
     edtRMB.ReadOnly := True;
     edtBank.ReadOnly := True;
     edtCZK.ReadOnly := True;
     edtGWQ.ReadOnly :=True;
     edtTotal.ReadOnly := True;

    //新建一条缴款详细表记录
    for i:=0 to 3  do
    begin
       with unqrySelect do
       begin
          Close;
          SQL.Clear;
          SQL.Add('insert into t_bi_penitydetail values(:a,:b,:c,:d,:e,:f)');
          ParamByName('a').Value:=Trim(DM_ZB_Common.vg_str_DepartmentID);     //门店编号
          ParamByName('b').Value:=StrToDateTime(lblSDate.Caption);           //交易时间
          ParamByName('c').Value:=Trim(liushuihao);                          //缴款流水号
          ParamByName('d').Value:=IntToStr(i);                             //支付方式id
          ParamByName('e').Value:=a[i];                                   //应收金额
          ParamByName('f').Value:=b[i];                                  //实收金额
          ExecSQL;
        end;
    end;

    //新建一条缴款记录
     with unqrySelect do
       begin
         // Close;
          SQL.Clear;
          SQL.Add('insert into t_bi_penalty values(:a,:b,:c,:d,:e,:f,:g)');
          ParamByName('a').Value:=Trim(DM_ZB_Common.vg_str_DepartmentID);     //门店编号
          ParamByName('b').Value:=StrToDateTime(lblSDate.Caption);           //交易时间
          ParamByName('c').Value:=Trim(liushuihao);                         //缴款流水号
          ParamByName('d').Value:=Trim(lblCashierId.Caption);              //收银员ID
          ParamByName('e').Value:=Now;                                   //缴款时间
          ParamByName('f').Value:=StrToFloat(lbl_PTotal.Caption);        //实收总金额
          ParamByName('g').Value:=StrToFloat(edtTotal.Text);            //应收总金额
          ExecSQL;
        end;
     Currency_time:=DM_ZB_Common.GetDBDatetime;//获取数据库时间
     liushuihao:=generateLSH(Currency_time);    //生成流水号
end;

//编辑框合法性判断
procedure TW_POS_SaleCheckForm.check_right(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',#46,#8,'.'])then
    key:= #0
  else
  begin
    if   key = '.' then
    begin
        if pos('.',TEdit(Sender).Text)> 0 then key:=#0;   //只能输入一个小数点
        if (length(TEdit(Sender).Text) = 0)   then       //如果第一次输入'.'则自动加'0';
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

//按下键跳转到银行卡编辑框 ，按上键跳转到购物券编辑框
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

//按下键跳转到储值卡编辑框，按上键跳转到现金编辑框
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

//按下键跳转到购物券卡编辑框，按上键跳转到银行卡编辑框
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

//按下键跳转到现金编辑框，按上键跳转到储值卡编辑框
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

//退出当前窗口
procedure TW_POS_SaleCheckForm.btnESCClick(Sender: TObject);
begin
  if Application.MessageBox('是否退出收银对账界面！', '询问', MB_ICONQUESTION + MB_YESNO) = ID_YES then
    close;
end;

//现金输入判断
procedure TW_POS_SaleCheckForm.edtRMBKeyPress(Sender: TObject;
  var Key: Char);
begin
 check_right(Sender,Key);
end;

//银行卡输入判断
procedure TW_POS_SaleCheckForm.edtBankKeyPress(Sender: TObject;
  var Key: Char);
begin
 check_right(Sender,Key);
end;

//储值卡输入判断
procedure TW_POS_SaleCheckForm.edtCZKKeyPress(Sender: TObject;
  var Key: Char);
begin
  check_right(Sender,Key);
end;

//购物券输入判断
procedure TW_POS_SaleCheckForm.edtGWQKeyPress(Sender: TObject;
  var Key: Char);
begin
  check_right(Sender,Key);
end;

end.
