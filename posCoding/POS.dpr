program POS;

uses
  Forms,
  C_POS_MainWindow in 'C_POS_MainWindow.pas' {W_POS_MainWindow},
  C_ZB_DataModule in 'C_ZB_DataModule.pas' {DM_ZB_Common: TDataModule},
  C_ZB_DBConfig in 'C_ZB_DBConfig.pas' {W_ZB_DB_CFG},
  C_POS_quantity in 'C_POS_quantity.pas' {W_POS_quantityForm},
  C_POS_Vip in 'C_POS_Vip.pas' {W_POS_VipForm},
  C_POS_Other in 'C_POS_Other.pas' {W_POS_OtherForm},
  C_POS_guadan in 'C_POS_guadan.pas' {W_POS_guadanForm},
  C_POS_Settlement in 'C_POS_Settlement.pas' {W_POS_SettlementForm},
  C_POS_Bank in 'C_POS_Bank.pas' {W_POS_BankForm},
  C_POS_CZcard in 'C_POS_CZcard.pas' {W_POS_CZcardForm},
  C_POS_OtherPayWay in 'C_POS_OtherPayWay.pas' {W_POS_OtherPayWayForm},
  C_POS_SQMa in 'C_POS_SQMa.pas' {W_POS_SQMaForm},
  C_POS_YJia in 'C_POS_YJia.pas' {W_POS_YJiaForm},
  C_MD_SPFin in 'C_MD_SPFin.pas' {W_MD_SPFinForm},
  C_MD_Return in 'C_MD_Return.pas' {W_MD_ReturnForm},
  UnitAutoComplete in 'UnitAutoComplete.pas',
  C_ZB_Login in 'C_ZB_Login.pas' {w_ZB_login},
  C_POS_SaleCheck in 'C_POS_SaleCheck.pas' {W_POS_SaleCheckForm},
  C_POS_Promotion in 'C_POS_Promotion.pas' {W_POS_PromotionForm},
  C_POS_CashBox in 'C_POS_CashBox.pas' {W_POS_CashBox},
  C_POS_Login in 'C_POS_Login.pas' {W_POS_LoginForm},
  C_POS_UserChange in 'C_POS_UserChange.pas' {W_POS_UserChangeForm},
  C_POS_inputChange in 'C_POS_inputChange.pas' {W_POS_inputChangeForm},
  cx in 'cx.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TW_POS_MainWindow, W_POS_MainWindow);
  Application.CreateForm(TW_POS_UserChangeForm, W_POS_UserChangeForm);
  Application.CreateForm(TW_POS_inputChangeForm, W_POS_inputChangeForm);
  Application.Run;
end.
