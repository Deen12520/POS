unit C_POS_guadan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, DB,
  MemDS, DBAccess, Uni;

type
  TW_POS_guadanForm = class(TForm)
    lvguadan: TListView;
    pnl1: TPanel;
    dbgrdguadan: TDBGrid;
    btndel: TBitBtn;
    btnenter: TBitBtn;
    btnquit: TBitBtn;
    uniqueryguadan: TUniQuery;
    intgrfldXH: TIntegerField;
    strngfld_id: TStringField;
    fltfld_price: TFloatField;
    fltfld_count: TFloatField;
    fltfld_total: TFloatField;
    strngfld_name: TStringField;
    dsguadan: TUniDataSource;
    uniqueryGD2: TUniQuery;
    procedure FormShow(Sender: TObject);
    procedure intgrfldXHGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure ShowInfo(Sender: TObject;var temp:string);
    procedure lvguadanSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btndelClick(Sender: TObject);    ////显示选中流水号下的商品挂单信息
    procedure insertGDH(Sender: TObject);
    procedure btnquitClick(Sender: TObject);
    procedure btnenterClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    //procedure btnquitKeyPress(Sender: TObject; var Key: Char);  //获得流水号，并将其插入到listview中
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  W_POS_guadanForm: TW_POS_guadanForm;

implementation
 uses C_ZB_DataModule;
{$R *.dfm}

procedure TW_POS_guadanForm.FormShow(Sender: TObject);
begin
   if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
     DM_ZB_Common.SetupConnection;
    {
   //获取流水号，查询挂单信息
   gd_sql1:='select trade_turnover_num from t_bi_saledeal where status=''1''';
   with uniqueryGD2 do
   begin
     SQL.Clear;
     SQL.Add(gd_sql1);
     Open;
   end;
   lvguadan.Items.Clear;  //清空数据
   if uniqueryGD2.RecordCount>0 then
      uniqueryGD2.First;    //定位到第一行
   begin
     for i:=0 to uniqueryGD2.RecordCount-1 do
     begin
       guadanhao:= uniqueryGD2.FieldByName('trade_turnover_num').AsString;
       newitem:=lvguadan.Items.Add;
       //newitem.Caption:=guadanhao;
       newitem.Caption:=IntToStr(i+1);
       newitem.SubItems.Add(guadanhao);
       uniqueryGD2.Next;    //移到下一行
     end;

   end;   }
   insertGDH(Sender);
   lvguadan.SetFocus;
   lvguadan.TopItem.Selected:=True;  //默认选中第一行
end;

//获得流水号，并将其插入到listview中
procedure TW_POS_guadanForm.insertGDH(Sender: TObject);
var
  newitem:TListItem;
  guadanhao:string;  //挂单号
  gd_sql1:string;
  i:Integer;
begin
 //获取流水号，查询挂单信息
   gd_sql1:='select trade_turnover_num from t_bi_saledeal where status=''1''';
   with uniqueryGD2 do
   begin
     SQL.Clear;
     SQL.Add(gd_sql1);
     Open;
   end;
   lvguadan.Items.Clear;  //清空数据
   if uniqueryGD2.RecordCount>0 then
      uniqueryGD2.First;    //定位到第一行
   begin
     for i:=0 to uniqueryGD2.RecordCount-1 do
     begin
       guadanhao:= uniqueryGD2.FieldByName('trade_turnover_num').AsString;
       newitem:=lvguadan.Items.Add;
       //newitem.Caption:=guadanhao;
       newitem.Caption:=IntToStr(i+1);
       newitem.SubItems.Add(guadanhao);
       uniqueryGD2.Next;    //移到下一行
     end;

   end;
end;


//显示选中流水号下的商品挂单信息
procedure TW_POS_guadanForm.ShowInfo(Sender: TObject;var temp:string);
var
  gd_sql2:string;
begin
   gd_sql2:='select * from t_bi_saledealdetail where tran_seri_num='''+temp+'''';
   with uniqueryguadan do
   begin
      sql.Clear;
      SQL.Add(gd_sql2);
      Open;
   end;
end;

procedure TW_POS_guadanForm.intgrfldXHGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := IntToStr(uniqueryguadan.RecNo);  //在表格中显示行号
end;

procedure TW_POS_guadanForm.FormCreate(Sender: TObject);
begin
   KeyPreview := true;
   lvguadan.ViewStyle:=vsReport;
   lvguadan.Columns.Add.Caption:='行号';
   lvguadan.Columns.Add.Caption:='流水号';
   lvguadan.Columns[1].Width:=-2;  // 标题自适应SubItems里最宽的字符长度
end;

procedure TW_POS_guadanForm.lvguadanSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
  var
    temp:string;
    //j:Integer;
begin
   if lvguadan.Selected<> nil then
   begin
      temp:=lvguadan.Selected.SubItems.Strings[0];   //获取选中行第二列的值
      ShowInfo(Sender,temp); //显示选中流水号下的商品交易信息
   end;
end;

//删除挂单信息
procedure TW_POS_guadanForm.btndelClick(Sender: TObject);
var
  gd_sql,temp:string;
begin
    //删除选择的挂单号
    if lvguadan.Selected<> nil then
    begin
      temp:=lvguadan.Selected.SubItems.Strings[0];
      gd_sql:='update t_bi_saledeal set status=''3'' where trade_turnover_num='''+temp+'''';
      with uniqueryGD2 do
      begin
        sql.Clear;
        SQL.Add(gd_sql);
        ExecSQL;
      end;
    end;
    insertGDH(Sender);
end;

//关闭窗口
procedure TW_POS_guadanForm.btnquitClick(Sender: TObject);
begin
    Close;  
end;

//返回到收银界面
procedure TW_POS_guadanForm.btnenterClick(Sender: TObject);
var
  gd_sql,temp:string;
begin

if lvguadan.Selected<> nil then
    begin
      temp:=lvguadan.Selected.SubItems.Strings[0];
      gd_sql:='update t_bi_saledeal set status=''0'' where trade_turnover_num='''+temp+'''';
      with uniqueryGD2 do
      begin
        sql.Clear;
        SQL.Add(gd_sql);
        ExecSQL;
      end;
    end;
    close;
end;

//返回到收银界面,快捷键的方式
procedure TW_POS_guadanForm.FormKeyPress(Sender: TObject; var Key: Char);
var
  gd_sql,temp:string;
begin
  if (Key=#13) then
  begin
    if lvguadan.Selected<> nil then
      begin
        temp:=lvguadan.Selected.SubItems.Strings[0];
        gd_sql:='update t_bi_saledeal set status=''0'' where trade_turnover_num='''+temp+'''';
        with uniqueryGD2 do
        begin
          sql.Clear;
          SQL.Add(gd_sql);
          ExecSQL;
        end;
      end;
      close;
  end;

end;

end.
