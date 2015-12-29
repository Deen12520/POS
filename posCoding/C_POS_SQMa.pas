unit C_POS_SQMa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, MemDS, DBAccess, Uni;

type
  TW_POS_SQMaForm = class(TForm)
    edtSQM: TEdit;
    btn1: TBitBtn;
    btn2: TBitBtn;
    uniquerySQMa: TUniQuery;
    lbl1: TLabel;
    lbl2: TLabel;
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure edtSQMKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    //procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  W_POS_SQMaForm: TW_POS_SQMaForm;
  sqma:string;   //授权码
  
implementation

uses C_POS_YJia,C_ZB_DataModule;

{$R *.dfm}

procedure TW_POS_SQMaForm.btn2Click(Sender: TObject);
begin
    Close;
end;

procedure TW_POS_SQMaForm.btn1Click(Sender: TObject);
var
  input:string;  //输入的字符
begin
      input:=UpperCase(Trim(edtSQM.Text));
      //To DO 判断输入的授权码是否有效
      with uniquerySQMa do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * from t_bi_authorcode where store_id=:a and status=''1'' and author_code=:b');
        ParamByName('a').Value:=DM_ZB_Common.vg_str_DepartmentID;
        ParamByName('b').Value:=input;
        Open;
      end;
      if uniquerySQMa.RecordCount<1 then
      begin
         lbl2.Caption:='该授权码不存在或不可用！请先核对是否输入有误。';
         edtSQM.SetFocus;
      end
      else
      begin
        lbl2.Caption:='该授权码可正常使用！';
        sqma:=input;
        Close;
        //TO DO 关闭授权码窗口，打开议价窗口
        Application.CreateForm(TW_POS_YJiaForm,W_POS_YJiaForm);
        W_POS_YJiaForm.ShowModal;
        W_POS_YJiaForm.Free;
        //W_POS_YJiaForm.ShowModal;

      end;


end;

procedure TW_POS_SQMaForm.edtSQMKeyPress(Sender: TObject; var Key: Char);
begin
  //只能输数字
  if not (Key in['0'..'9',#13,#8]) then
    Key:=#0;
end;

procedure TW_POS_SQMaForm.FormShow(Sender: TObject);
begin
   if DM_ZB_Common=nil then DM_ZB_Common:=TDM_ZB_Common.Create(nil);
     DM_ZB_Common.SetupConnection;

     KeyPreview:=True;
     edtSQM.SetFocus;
end;

procedure TW_POS_SQMaForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #68) or (Key = #100) then
      btn1.Click;
end;

end.
