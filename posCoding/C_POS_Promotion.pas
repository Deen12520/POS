unit C_POS_Promotion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBAccess, Uni, MemDS, Grids, DBGrids, StdCtrls, ComCtrls,
  DBCtrls;

type
  TW_POS_PromotionForm = class(TForm)
    lblFinPro: TLabel;
    dbgrdFinPro: TDBGrid;
    unqryFinPro: TUniQuery;
    dsFinPro: TUniDataSource;
    btnFinPro_esc: TButton;
    unqryFinPropromotion_id: TStringField;
    unqryFinPropromotion_name: TStringField;
    unqryFinPropromotion_brief: TStringField;
    unqryFinProbegin_date: TDateField;
    unqryFinProend_date: TDateField;
    unqryFinPropromotion_detail: TStringField;
    dbmmoProDetail: TDBMemo;
    unqryFinProdesignated_week: TStringField;
    unqryFinProdesignated_date: TSmallintField;
    unqryFinProstatus: TStringField;
    unqryFinProis_allow_point: TStringField;
    unqryFinProis_mem_prom: TStringField;
    unqryFinPromodify_oper: TStringField;
    unqryFinPromodify_date: TDateField;
    unqryFinProbegin_time: TTimeField;
    unqryFinProend_time: TTimeField;
    btnRef: TButton;
    lbl1: TLabel;
    lbl2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnRefClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFinPro_escClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  W_POS_PromotionForm: TW_POS_PromotionForm;

implementation

{$R *.dfm}
  uses  C_ZB_DataModule;

procedure TW_POS_PromotionForm.FormCreate(Sender: TObject);
begin
   KeyPreview := true;
end;

procedure TW_POS_PromotionForm.FormShow(Sender: TObject);
var
  vsql:string;
begin
  if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
   DM_ZB_Common.SetupConnection;

   vsql:='select * from t_bi_promotion where begin_date <= current_date AND '+
   'end_date >= current_date AND begin_time <= current_time AND '+
   'end_time >= current_time AND (designated_week=NULL or '+
   'designated_week=to_char(now(),''day'')) or (designated_date=0 or '+
   'designated_date=extract(day from now())) order by modify_date';

   //促销查询
   with unqryFinPro do
   begin
     Close;
     SQL.Clear;
     SQL.Add(vsql);
     Open;
   end;
   if unqryFinPro.RecordCount<1 then
   begin
     lbl2.Caption:='当前无促销！';
     btnRef.Enabled:=False;
   end
   else
   begin
     lbl2.Caption:='当前有正在进行的促销！';
   end;
   //unqryFinPro.Active:=True;
end;

 //点击刷新键刷新数据
procedure TW_POS_PromotionForm.btnRefClick(Sender: TObject);
begin
  dbgrdFinPro.DataSource.DataSet.Refresh;
  dbgrdFinPro.Refresh;
end;

//设置F5快捷键刷新
procedure TW_POS_PromotionForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  begin
    if Key=VK_F5 then
      btnRef.Click;
  end;

//退出当前窗口
procedure TW_POS_PromotionForm.btnFinPro_escClick(Sender: TObject);
begin
  Self.Close;
end;

//ESC快捷键设置
procedure TW_POS_PromotionForm.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#27 then
    btnFinPro_esc.Click;
end;

end.
