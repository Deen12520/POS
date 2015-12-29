unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    edt1: TEdit;
    lbSerach: TListBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  //DataLst:TStringList;   //用于存放共选择的数据

implementation
uses UnitAutoComplete;
{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var  
  FStrings: TStrings;  
begin  
  FStrings := TStringList.Create;  
  FStrings.Add('无幻');  
  FStrings.Add('无幻博客');  
  FStrings.Add('无幻欢迎你');  
  FStrings.Add('CSDN社区');  
  TAutoComplete.EnableAutoComplete(edt1, FStrings, ACO_AUTOSUGGEST + ACO_UPDOWNKEYDROPSLIST);
end;

end.
