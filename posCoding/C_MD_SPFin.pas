unit C_MD_SPFin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBAccess, Uni, MemDS, Grids, DBGrids, StdCtrls;

type
  TW_MD_SPFinForm = class(TForm)
    edtSPFin: TEdit;
    btnSPF_Fin: TButton;
    btnSPF_Esc: TButton;
    dbgrdSPF: TDBGrid;
    unqrySPFin: TUniQuery;
    dsSPFin: TUniDataSource;
    strngfldSPFincommodity_id: TStringField;
    strngfldSPFincommodity_name: TStringField;
    strngfldSPFinunit: TStringField;
    strngfldSPFinguige: TStringField;
    strngfldSPFincommodity_bar: TStringField;
    strngfldSPFincomm_self_code: TStringField;
    strngfldSPFincomm_type_id: TStringField;
    strngfldSPFinis_expensive: TStringField;
    strngfldSPFinis_allow_point: TStringField;
    strngfldSPFinis_direct: TStringField;
    intgrfldSPFinField: TIntegerField;
    procedure FormShow(Sender: TObject);
    procedure intgrfldSPFinFieldGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure btnSPF_FinClick(Sender: TObject);
    procedure btnSPF_EscClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtSPFinKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtSPFinChange(Sender: TObject);
    procedure dbgrdSPFDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  W_MD_SPFinForm: TW_MD_SPFinForm;
  CX_spmb:string;  //从商品查询中返回的商品编号
  CX_flag:Boolean=False;   //是否查询成功标志

implementation
   uses C_ZB_DataModule,C_POS_MainWindow;
{$R *.dfm}

procedure TW_MD_SPFinForm.FormShow(Sender: TObject);
begin
if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
   DM_ZB_Common.SetupConnection;

   KeyPreview:=True;
   //unqrySPFin.Active:=True;
   edtSPFin.Text:=spbm;  //从主界面中传值过来
end;

//行号递增
procedure TW_MD_SPFinForm.intgrfldSPFinFieldGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
     Text := IntToStr(unqrySPFin.RecNo);
end;

//通过关键字：商品编码、商品条码、商品自编码、商品助记码、商品名称查询商品
procedure TW_MD_SPFinForm.btnSPF_FinClick(Sender: TObject);

begin
  {
  with unqrySPFin do
  begin
     temp := 'select * from t_bi_commbaseinfo where '+
     '(status=''1'' and (commodity_bar='''+edtSPFin.Text+''' or commodity_name like ''%'+edtSPFin.Text+'%'' or '+
     'comm_self_code like ''%'+edtSPFin.Text+'%'' or commodity_id like ''%'+edtSPFin.Text+'%'' or '+
     'mnemonic_id like ''%'+edtSPFin.Text+'%''))';
    SQL.Clear;
    SQL.Add(temp);
    Open;
    if ( recordcount= 0) then
      showmessage('无查询结果！');
  end; }


  if unqrySPFin.RecordCount>0 then
  begin
    CX_spmb:=unqrySPFin.FieldByName('commodity_id').AsString;
    CX_flag:=True;
    Self.Close;
  end
  else
  begin
    ShowMessage('当前未选中商品，请选择');
  end;
  //ShowMessage(CX_spmb);
  //btnSPF_Esc.SetFocus;




end;

//退出
procedure TW_MD_SPFinForm.btnSPF_EscClick(Sender: TObject);
begin
   CX_flag:=false;
   close;
end;

//快捷键查询Enter和退出ESC
procedure TW_MD_SPFinForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if(Key=#13) then
     btnSPF_Fin.Click;
   if(Key=#27) then
     btnSPF_Esc.Click;
end;

procedure TW_MD_SPFinForm.edtSPFinKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   //默认焦点在最后一行，上下移动 (焦点必须在DBgrid中才可行)

  if key=vk_up then
      if unqrySPFin.Bof =false then
        unqrySPFin.Prior;
  if key=vk_down then
      if unqrySPFin.eof =false then
        unqrySPFin.next;

end;

//编辑框中字符变化引起列表中的信息的变化
procedure TW_MD_SPFinForm.edtSPFinChange(Sender: TObject);
var
  temp:string;
begin
  if Trim(edtSPFin.Text)='' then
    unqrySPFin.SQL.Clear
  else
  begin
      with unqrySPFin do
      begin
         temp := 'select * from t_bi_commbaseinfo where '+
         '(status=''1'' and (commodity_bar='''+edtSPFin.Text+''' or commodity_name like ''%'+edtSPFin.Text+'%'' or '+
         'comm_self_code like ''%'+edtSPFin.Text+'%'' or commodity_id like ''%'+edtSPFin.Text+'%'' or '+
         'mnemonic_id like ''%'+edtSPFin.Text+'%''))';
        SQL.Clear;
        SQL.Add(temp);
        Open;
        //if ( recordcount= 0) then
          //showmessage('无查询结果！');
      end;
      //unqrySPFin.First;
      //CX_spmb:=unqrySPFin.FieldByName('commodity_id').AsString;  //获取当前行的商品编码
      //ShowMessage(CX_spmb);        //test
  end;
end;

procedure TW_MD_SPFinForm.dbgrdSPFDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
// dbgrid的options属性里的dgrowselect=true
  if gdselected in state then
     dbgrdSPF.Canvas.Brush.Color:=clgradientinactivecaption
   else
   dbgrdSPF.Canvas.Brush.Color := clwindow;
   dbgrdSPF.DefaultDrawColumnCell(rect,datacol,column,state);
end;

end.
