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
  CX_spmb:string;  //����Ʒ��ѯ�з��ص���Ʒ���
  CX_flag:Boolean=False;   //�Ƿ��ѯ�ɹ���־

implementation
   uses C_ZB_DataModule,C_POS_MainWindow;
{$R *.dfm}

procedure TW_MD_SPFinForm.FormShow(Sender: TObject);
begin
if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
   DM_ZB_Common.SetupConnection;

   KeyPreview:=True;
   //unqrySPFin.Active:=True;
   edtSPFin.Text:=spbm;  //���������д�ֵ����
end;

//�кŵ���
procedure TW_MD_SPFinForm.intgrfldSPFinFieldGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
     Text := IntToStr(unqrySPFin.RecNo);
end;

//ͨ���ؼ��֣���Ʒ���롢��Ʒ���롢��Ʒ�Ա��롢��Ʒ�����롢��Ʒ���Ʋ�ѯ��Ʒ
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
      showmessage('�޲�ѯ�����');
  end; }


  if unqrySPFin.RecordCount>0 then
  begin
    CX_spmb:=unqrySPFin.FieldByName('commodity_id').AsString;
    CX_flag:=True;
    Self.Close;
  end
  else
  begin
    ShowMessage('��ǰδѡ����Ʒ����ѡ��');
  end;
  //ShowMessage(CX_spmb);
  //btnSPF_Esc.SetFocus;




end;

//�˳�
procedure TW_MD_SPFinForm.btnSPF_EscClick(Sender: TObject);
begin
   CX_flag:=false;
   close;
end;

//��ݼ���ѯEnter���˳�ESC
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
   //Ĭ�Ͻ��������һ�У������ƶ� (���������DBgrid�вſ���)

  if key=vk_up then
      if unqrySPFin.Bof =false then
        unqrySPFin.Prior;
  if key=vk_down then
      if unqrySPFin.eof =false then
        unqrySPFin.next;

end;

//�༭�����ַ��仯�����б��е���Ϣ�ı仯
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
          //showmessage('�޲�ѯ�����');
      end;
      //unqrySPFin.First;
      //CX_spmb:=unqrySPFin.FieldByName('commodity_id').AsString;  //��ȡ��ǰ�е���Ʒ����
      //ShowMessage(CX_spmb);        //test
  end;
end;

procedure TW_MD_SPFinForm.dbgrdSPFDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
// dbgrid��options�������dgrowselect=true
  if gdselected in state then
     dbgrdSPF.Canvas.Brush.Color:=clgradientinactivecaption
   else
   dbgrdSPF.Canvas.Brush.Color := clwindow;
   dbgrdSPF.DefaultDrawColumnCell(rect,datacol,column,state);
end;

end.
