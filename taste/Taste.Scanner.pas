(* Compiler Generator Coco/R, for Delphi
 * Copyright (c) 2021, Marat Shaimardanov
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

unit Taste.Scanner;

interface

uses
  System.SysUtils, System.Character, Oz.Cocor.Utils, Oz.Cocor.Lib;

type

  TTasteScanner = class(TBaseScanner)
  private
    valCh: char;
    function Comment0: Boolean;
    function Comment1: Boolean;
    procedure CheckLiteral;
  protected
    procedure NextCh; override;
    procedure AddCh; override;
    function NextToken: TToken; override;
  public
    constructor Create(const src: string);
  end;

implementation

constructor TTasteScanner.Create(const src: string);
var
  i: Integer;
begin
  inherited;
  MaxToken := 28;
  NoSym := 28;
  for i := 97 to 122 do start.Add(i, 1);
  for i := 48 to 57 do start.Add(i, 2);
  start.Add(43, 3);
  start.Add(45, 4);
  start.Add(42, 5);
  start.Add(47, 6);
  start.Add(40, 7);
  start.Add(41, 8);
  start.Add(123, 9);
  start.Add(125, 10);
  start.Add(61, 16);
  start.Add(60, 12);
  start.Add(62, 13);
  start.Add(59, 14);
  start.Add(44, 15);
  start.Add(Ord(TBuffer.EF), -1);
end;

procedure TTasteScanner.NextCh;
begin
  if oldEols > 0 then
  begin
    ch := LF; Dec(oldEols);
  end
  else
  begin
    pos := buffer.Pos; ch := Chr(buffer.Read); Inc(col);
    // replace isolated CR by LF in order to make
    // eol handling uniform across Windows, Unix and Mac
    if (ch = CR) and (buffer.Peek <> Ord(LF)) then
      ch := LF;
    if ch = LF then
    begin
      Inc(line); col := 0;
    end;
  end;
  if not Buffer.EOF then
  begin
    valCh := char(ch);
    ch := System.Character.ToLower(char(ch));
  end;
end;

procedure TTasteScanner.AddCh;
begin
  if ch <> TBuffer.EF then
  begin
    tval := tval + valCh; Inc(tlen);
    NextCh;
  end;
end;

function TTasteScanner.Comment0: Boolean;
var
  level, pos0, line0, col0: Integer;
begin
  level := 1; pos0 := pos; line0 := line; col0 := col;
  NextCh;
  if ch = '/' then
  begin
    NextCh;
    repeat
      if ch = #10 then
      begin
        Dec(level);
        if level = 0 then
        begin
          oldEols := line - line0; NextCh;
          exit(True);
        end;
        NextCh;
      end
      else if ch = TBuffer.EF then
        exit(False)
      else
        NextCh;
    until False;
  end
  else
  begin
    buffer.Pos := pos0; NextCh;
    line := line0; col := col0;
  end;
  Result := False;
end;

function TTasteScanner.Comment1: Boolean;
var
  level, pos0, line0, col0: Integer;
begin
  level := 1; pos0 := pos; line0 := line; col0 := col;
  NextCh;
  if ch = '*' then
  begin
    NextCh;
    repeat
      if ch = '*' then
      begin
        NextCh;
        if ch = '/' then
        begin
          Dec(level);
          if level = 0 then
          begin
            oldEols := line - line0; NextCh;
            exit(True);
          end;
          NextCh;
        end;
      end
      else if ch = '/' then
      begin
        NextCh;
        if ch = '*' then
        begin
          Inc(level); NextCh;
        end;
      end
      else if ch = TBuffer.EF then
        exit(False)
      else
        NextCh;
    until False;
  end
  else
  begin
    buffer.Pos := pos0; NextCh;
    line := line0; col := col0;
  end;
  Result := False;
end;

procedure TTasteScanner.CheckLiteral;
var s: string;
begin
  s := t.val.ToLower;
  if s = 'true' then
    t.kind := 5
  else if s = 'false' then
    t.kind := 6
  else if s = 'void' then
    t.kind := 9
  else if s = 'if' then
    t.kind := 19
  else if s = 'else' then
    t.kind := 20
  else if s = 'while' then
    t.kind := 21
  else if s = 'read' then
    t.kind := 22
  else if s = 'write' then
    t.kind := 23
  else if s = 'program' then
    t.kind := 24
  else if s = 'int' then
    t.kind := 25
  else if s = 'bool' then
    t.kind := 26
end;

function TTasteScanner.NextToken: TToken;
var
  recKind, recEnd, state: Integer;
begin
  while (ch = ' ') or Between(ch, #9, #10) or (ch = #13) do
    NextCh;
  if not SkipComments then
  if ((ch = '/') and Comment0) or
     ((ch = '/') and Comment1) then exit(NextToken);
  recKind := NoSym;
  recEnd := pos;
  t := NewToken;
  t.pos := pos; t.col := col; t.line := line;
  if start.ContainsKey(Ord(ch)) then
    state := start[Ord(ch)]
  else
    state := 0;
  tval := ''; tlen := 0;
  AddCh;
  repeat
    case state of
      -1:
      begin
        t.kind := eofSym;
        break; // NextCh already done
      end;
      0:
      begin
        if recKind <> NoSym then
        begin
          tlen := recEnd - t.pos;
          SetScannerBehindT;
        end;
        t.kind := recKind;
        break; // NextCh already done
      end;
      1:
      begin
        recEnd := pos; recKind := 1;
        if Between(ch, '0', '9') or Between(ch, 'a', 'z') then
        begin
          AddCh; state := 1;
        end
        else
        begin
          t.kind := 1; t.val := tval; CheckLiteral;
          exit(t);
        end;
      end;
      2:
      begin
        recEnd := pos; recKind := 2;
        if Between(ch, '0', '9') then
        begin
          AddCh; state := 2;
        end
        else
        begin
          t.kind := 2; break;
        end;
      end;
      3:
      begin
        t.kind := 3; break;
      end;
      4:
      begin
        t.kind := 4; break;
      end;
      5:
      begin
        t.kind := 7; break;
      end;
      6:
      begin
        t.kind := 8; break;
      end;
      7:
      begin
        t.kind := 10; break;
      end;
      8:
      begin
        t.kind := 11; break;
      end;
      9:
      begin
        t.kind := 12; break;
      end;
      10:
      begin
        t.kind := 13; break;
      end;
      11:
      begin
        t.kind := 14; break;
      end;
      12:
      begin
        t.kind := 15; break;
      end;
      13:
      begin
        t.kind := 16; break;
      end;
      14:
      begin
        t.kind := 18; break;
      end;
      15:
      begin
        t.kind := 27; break;
      end;
      16:
      begin
        recEnd := pos; recKind := 17;
        if ch = '=' then
        begin
          AddCh; state := 11;
        end
        else
        begin
          t.kind := 17; break;
        end;
      end;
    end;
  until false;
  t.val := tval;
  Result := t;
end;

end.

