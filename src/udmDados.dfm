object dmDados: TdmDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 370
  Width = 488
  object Conexao: TFDConnection
    ConnectionName = 'DataBase'
    Params.Strings = (
      'DriverID=FB'
      
        'Database=C:\Users\HDTEC DESENV\Documents\GitHub\desafio_delphi_0' +
        '2\data\SIAGRI.GDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Server=localhost')
    Connected = True
    LoginPrompt = False
    Left = 232
    Top = 32
  end
end
