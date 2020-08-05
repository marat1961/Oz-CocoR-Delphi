program Cocor;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  FastMM4,
  System.SysUtils,
  Oz.Cocor.Utils in 'src\Oz.Cocor.Utils.pas',
  Oz.Cocor.Lib in 'src\Oz.Cocor.Lib.pas',
  Oz.Cocor.Options in 'src\Oz.Cocor.Options.pas',
  Oz.Cocor.Scanner in 'src\Oz.Cocor.Scanner.pas',
  Oz.Cocor.Parser in 'src\Oz.Cocor.Parser.pas',
  Oz.Cocor.Tab in 'src\Oz.Cocor.Tab.pas',
  Oz.Cocor.DFA in 'src\Oz.Cocor.DFA.pas',
  Oz.Cocor.ParserGen in 'src\Oz.Cocor.ParserGen.pas',
  Oz.Cocor.Coco in 'src\Oz.Cocor.Coco.pas';

begin
  try
    Run;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
