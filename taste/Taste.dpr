program Taste;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Taste.Gen in 'Taste.Gen.pas',
  Taste.Parser in 'Taste.Parser.pas',
  Taste.Scanner in 'Taste.Scanner.pas',
  Taste.Tab in 'Taste.Tab.pas',
  Oz.Cocor.Lib in '..\src\Oz.Cocor.Lib.pas',
  Oz.Cocor.Utils in '..\src\Oz.Cocor.Utils.pas',
  Taste.Options in 'Taste.Options.pas',
  Main in 'Main.pas';

begin
  try

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
