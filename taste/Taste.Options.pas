(* Compiler Generator Coco/R, for Delphi
 * Copyright (c) 2021 Tomsk, Marat Shaimardanov
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
unit Taste.Options;

interface

uses
  System.Classes, System.SysUtils, System.Character, System.IOUtils,
  Oz.Cocor.Utils;

type

{$Region 'TOptions: Compilation settings'}

  TOptions = class
  const
    Version = '1.0 (for Delphi)';
    ReleaseDate = '20 March 2021';
  var
    // name of the atg file (including path)
    srcName: string;
    // directory path of the atg file
    srcDir: string;
    // directory for generated files
    outDir: string;
    // should coco generate a check for EOF at the end of Parser.Parse():
    checkEOF: Boolean;
  private
    // trace options
    ddtString: string;
  public
    constructor Create;
    function GetVersion: string;
    procedure Help;
    // Get options from the command line
    procedure ParseCommandLine;
    procedure SetOption(const s: string);
  end;

{$EndRegion}

// Return current settings (sigleton)
function GetOptions: TOptions;

implementation

var FOptions: TOptions = nil;

function GetOptions: TOptions;
begin
  if FOptions = nil then
    FOptions := TOptions.Create;
  Result := FOptions;
end;

procedure FreeOptions;
begin
  FreeAndNil(FOptions);
end;

{$Region 'TOptions'}

constructor TOptions.Create;
begin
end;

function TOptions.GetVersion: string;
begin
  Result := Format(
    'Taste - Simple compiler, V%s'#13#10 +
    'Delphi version by Marat Shaimardanov %s'#13#10,
    [Version, ReleaseDate]);
end;

procedure TOptions.Help;
begin
  WriteLn('Usage: Taste filename.TAS {Option}');
  WriteLn('Options:');
  WriteLn('  -o <outputDirectory>');
end;

procedure TOptions.ParseCommandLine;
var
  i: Integer;
  p: string;

  function GetParam: Boolean;
  begin
    Result := i < ParamCount;
    if Result then
    begin
      Inc(i);
      p := ParamStr(i).Trim;
    end;
  end;

begin
  i := 0;
  while GetParam do
  begin
    if (p = '-o') and GetParam then
      outDir := p
    else if (p = '-checkEOF') then
      checkEOF := True
    else
      srcName := p;
  end;
  if outDir = '' then
    outDir := srcDir;
end;

procedure TOptions.SetOption(const s: string);
var
  name, value: string;
  option: TArray<string>;
begin
  option := s.Split(['=', ' '], 2);
  name := option[0];
  value := option[1];
  if '$checkEOF'.Equals(name) then
    checkEOF := 'true'.Equals(value);
end;

{$EndRegion}

initialization

finalization
  FreeOptions;

end.

