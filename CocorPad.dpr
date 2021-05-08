program CocorPad;

uses
  FastMM4,
  System.SysUtils,
  Vcl.Forms,
  Oz.Cocor.Utils in 'src\Oz.Cocor.Utils.pas',
  Oz.Cocor.Lib in 'src\Oz.Cocor.Lib.pas',
  Oz.Cocor.Options in 'src\Oz.Cocor.Options.pas',
  Oz.Cocor.Scanner in 'src\Oz.Cocor.Scanner.pas',
  Oz.Cocor.Parser in 'src\Oz.Cocor.Parser.pas',
  Oz.Cocor.Tab in 'src\Oz.Cocor.Tab.pas',
  Oz.Cocor.DFA in 'src\Oz.Cocor.DFA.pas',
  Oz.Cocor.ParserGen in 'src\Oz.Cocor.ParserGen.pas',
  Oz.Cocor.Rsc in 'src\Oz.Cocor.Rsc.pas',
  Oz.Cocor.Compiler in 'src\Oz.Cocor.Compiler.pas',
  Oz.Cocor.AboutForm in 'src\Oz.Cocor.AboutForm.pas' {AboutBox},
  Oz.Cocor.MainForm in 'src\Oz.Cocor.MainForm.pas' {MainForm},
  Oz.Cocor.OptionsForm in 'src\Oz.Cocor.OptionsForm.pas' {OptionsForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
