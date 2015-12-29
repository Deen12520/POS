object DM_ZB_Common: TDM_ZB_Common
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 145
  Top = 244
  Height = 313
  Width = 447
  object VG_ZB_ADOConnection: TUniConnection
    ProviderName = 'PostgreSQL'
    Port = 5432
    Database = 'store'
    Username = 'postgres'
    Server = 'localhost'
    Connected = True
    Left = 144
    Top = 72
    EncryptedPassword = 'CEFFCDFFCCFFCBFFCAFFC9FF'
  end
  object PostgreSQLUniProvider1: TPostgreSQLUniProvider
    Left = 320
    Top = 56
  end
end
