unit C_POS_quantity;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TW_POS_quantityForm = class(TForm)
    lbl1: TLabel;
    edtnum: TEdit;
    pnl1: TPanel;
    lbl2: TLabel;
    procedure edtnumKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  W_POS_quantityForm: TW_POS_quantityForm;
  quality:Double=1.0;

implementation

{$R *.dfm}

procedure TW_POS_quantityForm.edtnumKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then
  begin
     quality:=StrToFloat(edtnum.Text);
     //TODO
     close;
  end;

end;

end.
