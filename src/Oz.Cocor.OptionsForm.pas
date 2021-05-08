unit Oz.Cocor.OptionsForm;

interface

uses
  System.SysUtils, System.Variants, System.IniFiles, System.Classes,
  Winapi.Windows, Winapi.Messages, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Oz.Cocor.Options;

type
  TOptionsForm = class(TForm)
  private
    FOptions: TOptions;
  public
    constructor Create(Options: TOptions);
    // загрузить параметры из ини файла
    procedure LoadFromIni;
    // загрузить параметры в ини файл
    procedure SaveToIni;
  end;

implementation

{$R *.dfm}

constructor TOptionsForm.Create(Options: TOptions);
begin

end;

procedure TOptionsForm.LoadFromIni;
var
  appIni: TIniFile;
begin
  appIni := TIniFile.Create('./Cocor.ini');
  try

  finally
    appIni.Free;
  end;
end;

procedure TOptionsForm.SaveToIni;
begin

end;

end.
