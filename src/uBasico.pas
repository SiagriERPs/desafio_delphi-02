unit uBasico;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Datasnap.DBClient,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, uFuncoes,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Mask, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TfrmBasico = class(TForm)
    btnSalvar: TButton;
    btnCancelar: TButton;
    Label1: TLabel;
    dsTabela: TDataSource;
    qryTabela: TFDQuery;
    edtCodigo: TDBEdit;
    Label4: TLabel;
    edtNome: TDBEdit;
    DBGrid2: TDBGrid;
    btnNovo: TButton;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dsTabelaDataChange(Sender: TObject; Field: TField);
    procedure btnNovoClick(Sender: TObject);
    procedure qryTabelaNewRecord(DataSet: TDataSet);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    GeneID,
    Table : String;
    procedure OpenFDQuery(); virtual;
  end;

var
  SQL : String;
  frmBasico: TfrmBasico;

implementation

{$R *.dfm}

uses udmDados, uPesquisa;

procedure TfrmBasico.btnNovoClick(Sender: TObject);
begin
  qryTabela.Append;
  if edtNome.CanFocus then
    edtNome.SetFocus;
end;

procedure TfrmBasico.btnSalvarClick(Sender: TObject);
begin
  try
    if (qryTabela.State in [dsEdit,dsInsert]) then
      qryTabela.ApplyUpdates(-1);
    btnNovo.Click;
  except on e: exception do
    ShowMessage('Erro ao tentar salvar o registro!'+#13#13+'Error: '+e.Message);
  end;
end;

procedure TfrmBasico.dsTabelaDataChange(Sender: TObject; Field: TField);
begin
  if (TDataSource(Sender).DataSet.State in [dsEdit,dsInsert]) then
    btnSalvar.Enabled := true
  else btnSalvar.Enabled := false;
  btnNovo.Enabled := not btnSalvar.Enabled;
end;

procedure TfrmBasico.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Shift = [ssAlt]) and (key = 40)) or (key = VK_F5) then
  begin
    if (TDBEdit(Sender).Tag) > 0 then
    begin
      frmPesquisa.qryPesquisa.SQL.Text := Pesquisa(TDBEdit(Sender).Tag);
      frmPesquisa.ShowModal;
      TDBEdit(Sender).Text := frmPesquisa.qryPesquisa.Fields[1].AsString;
      if Trim(TDBEdit(Sender).Text) <> '' then
      begin
        TDBEdit(Sender).Modified := true;
        TDBEdit(Sender).OnExit(Sender);
      end;
    end;
  end;
end;

procedure TfrmBasico.FormCreate(Sender: TObject);
var
  intI     : Integer;
  strField : String;
begin
  for intI := 0 to Self.ComponentCount - 1 do
  begin
    if (Components[intI] is TDBEdit) then
    begin
      (Components[intI] as TDBEdit).CharCase := ecUpperCase;
      if ((Components[intI] as TDBEdit).Tag > 0) then
        (Components[intI] as TDBEdit).OnKeyDown := OnKeyDown;
    end;
  end;
end;

procedure TfrmBasico.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    perform(WM_NEXTDLGCTL,0,0);
  if key = 27 then
    Self.Close;
end;

procedure TfrmBasico.FormShow(Sender: TObject);
begin
  qryTabela.SQL.Text := SQL;
  qryTabela.Open();
  if (edtNome.CanFocus) and (not edtNome.ReadOnly) then
  begin
    edtNome.SetFocus;
    qryTabela.Append;
  end;
end;

procedure TfrmBasico.OpenFDQuery;
begin
  inherited;
end;

procedure TfrmBasico.qryTabelaNewRecord(DataSet: TDataSet);
begin
  qryTabela.FieldByName(GeneID).AsInteger := Generation(Table);
end;

procedure TfrmBasico.btnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

end.
