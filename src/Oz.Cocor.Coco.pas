(* Compiler Generator Coco/R, for Delphi
 * Copyright (c) 2020 Tomsk, Marat Shaimardanov
 *
 * Compiler Generator Coco/R, C# version
 * Copyright (c) 1990, 2004 Hanspeter Moessenboeck, University of Linz
 * extended by M. Loeberbauer & A. Woess, Univ. of Linz
 * with improvements by Pat Terry, Rhodes University
 *
 * This file is part of Compiler Generator Coco/R, for Delphi
 * is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this file. If not, see <https://www.gnu.org/licenses/>.
 *
 * If not otherwise stated, any source code generated by Coco/R (other than
 * Coco/R itself) does not fall under the GNU General Public License.
*)

unit Oz.Cocor.Coco;

(*
  Trace output options
  0 | A: prints the states of the scanner automaton
  1 | F: prints the First and Follow sets of all nonterminals
  2 | G: prints the syntax graph of the productions
  3 | I: traces the computation of the First sets
  4 | J: prints the sets associated with ANYs and synchronisation sets
  6 | S: prints the symbol table (terminals, nonterminals, pragmas)
  7 | X: prints a cross reference list of all syntax symbols
  8 | P: prints statistics about the Coco run

  Trace output can be switched on by the pragma
    $ { digit | letter }
  in the attributed grammar or as a command-line option
*)

interface

uses
  System.Classes, System.SysUtils, System.IOUtils,
  Oz.Cocor.Utils, Oz.Cocor.Parser, Oz.Cocor.Scanner, Oz.Cocor.Tab,
  Oz.Cocor.DFA, Oz.Cocor.ParserGen, Oz.Cocor.Options;

procedure Run;

implementation

procedure Run;
var
  options: TOptions;
  str: TStringList;
  parser: TcrParser;
  sr: TSearchRec;
  src, stem, filename: string;
  errors, warnings: Integer;
begin
  options := GetOptions;
  Writeln(options.GetVersion);
  options.ParseCommandLine;
  if (ParamCount = 0) or (options.srcName = '') then
    options.Help
  else
  begin
    try
      options.srcDir := TPath.GetDirectoryName(options.srcName);
      options.traceFileName := TPath.Combine(options.srcDir, 'trace.txt');
      str := TStringList.Create;
      try
        str.LoadFromFile(options.srcName);
        src := str.Text;
      finally
        str.Free;
      end;
      str := TStringList.Create;
      parser := TcrParser.Create(TcrScanner.Create(src), str);
      try
        parser.Parse;
        parser.SaveTraceToFile(options.traceFileName);
        FindFirst(options.traceFileName, faAnyFile, sr);
        if sr.Size = 0 then
          TFile.Delete(options.traceFileName)
        else
          Writeln('trace output is in ', options.traceFileName);
        FindClose(sr);
        parser.errors.GetInfo(errors, warnings);
        if errors > 0 then
          Writeln(errors, ' errors detected');
        if warnings > 0 then
          Writeln(warnings, ' warnings detected');
        parser.PrintErrors;
        stem := TPath.GetFilenameWithoutExtension(options.SrcName);
        filename := TPath.Combine(options.srcDir, stem + '.lst');
        str.SaveToFile(filename);
      finally
        str.Free;
        parser.Free;
      end;
    except
      on EFileStreamError do
        Writeln('-- could not open ' + options.traceFileName);
      on e: FatalError do
        Writeln('-- ', e.Message);
    end;
  end;
end;

end.


