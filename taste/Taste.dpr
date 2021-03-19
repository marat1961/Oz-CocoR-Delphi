program Taste;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Taste.Gen in 'Taste.Gen.pas',
  Taste.Parser in 'Taste.Parser.pas',
  Taste.Scanner in 'Taste.Scanner.pas',
  Taste.Tab in 'Taste.Tab.pas';

begin
  try

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
