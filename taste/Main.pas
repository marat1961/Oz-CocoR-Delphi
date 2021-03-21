(* Compiler Generator Coco/R, for Delphi * Copyright (c) 2021 Tomsk, Marat Shaimardanov
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
*)

unit Main;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils, Oz.Cocor.Utils,
  Taste.Scanner, Taste.Parser, Taste.Options, Taste.Tab, Taste.Gen;

procedure Run;

implementation

procedure Run;
var
  options: TOptions;
  str: TStringList;
  parser: TTasteParser;
  sr: TSearchRec;
  src, stem, filename: string;
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
      parser := TTasteParser.Create(TTasteScanner.Create(src), str);
      try
        parser.Parse;
        parser.gen.Decode();
        parser.gen.Interpret('Taste.IN');
        parser.SaveTraceToFile(options.traceFileName);
        FindFirst(options.traceFileName, faAnyFile, sr);
        if sr.Size = 0 then
          TFile.Delete(options.traceFileName)
        else
          Writeln('trace output is in ', options.traceFileName);
        FindClose(sr);
        Writeln(parser.errors.count, ' errors detected');
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
