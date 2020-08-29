
unit Oz.Cocor.Scanner;

interface

uses
  System.SysUtils, Oz.Cocor.Utils, Oz.Cocor.Lib;

type

  TcrScanner = class(TBaseScanner)
  private
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

constructor TcrScanner.Create(const src: string);
var
  i: Integer;
begin
  inherited;
  MaxToken := 44;
  NoSym := 44;
  for i := 65 to 90 do start.Add(i, 1);
  for i := 95 to 95 do start.Add(i, 1);
  for i := 97 to 122 do start.Add(i, 1);
  for i := 48 to 57 do start.Add(i, 2);
  start.Add(34, 3);
  start.Add(39, 6);
  start.Add(36, 13);
  start.Add(61, 15);
  start.Add(46, 32);
  start.Add(43, 16);
  start.Add(45, 17);
  start.Add(40, 33);
  start.Add(41, 19);
  start.Add(60, 34);
  start.Add(62, 20);
  start.Add(124, 23);
  start.Add(91, 24);
  start.Add(93, 25);
  start.Add(123, 26);
  start.Add(125, 27);
  start.Add(47, 29);
  start.Add(Ord(TBuffer.EF), -1);
end;

procedure TcrScanner.NextCh;
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
end;

procedure TcrScanner.AddCh;
begin
  if ch <> TBuffer.EF then
  begin
    tval := tval + ch; Inc(tlen);
    NextCh;
  end;
end;

function TcrScanner.Comment0: Boolean;
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

function TcrScanner.Comment1: Boolean;
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

procedure TcrScanner.CheckLiteral;
begin
  if t.val = 'COMPILER' then
    t.kind := 5
  else if t.val = 'IGNORECASE' then
    t.kind := 6
  else if t.val = 'MACROS' then
    t.kind := 7
  else if t.val = 'CHARACTERS' then
    t.kind := 8
  else if t.val = 'TOKENS' then
    t.kind := 9
  else if t.val = 'NAMES' then
    t.kind := 10
  else if t.val = 'PRAGMAS' then
    t.kind := 11
  else if t.val = 'COMMENTS' then
    t.kind := 12
  else if t.val = 'FROM' then
    t.kind := 13
  else if t.val = 'TO' then
    t.kind := 14
  else if t.val = 'NESTED' then
    t.kind := 15
  else if t.val = 'IGNORE' then
    t.kind := 16
  else if t.val = 'PRODUCTIONS' then
    t.kind := 17
  else if t.val = 'END' then
    t.kind := 20
  else if t.val = 'ANY' then
    t.kind := 24
  else if t.val = 'CHR' then
    t.kind := 25
  else if t.val = 'WEAK' then
    t.kind := 33
  else if t.val = 'SYNC' then
    t.kind := 38
  else if t.val = 'IF' then
    t.kind := 39
  else if t.val = 'CONTEXT' then
    t.kind := 40
end;

function TcrScanner.NextToken: TToken;
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
        if Between(ch, '0', '9') or Between(ch, 'A', 'Z') or (ch = '_') or
           Between(ch, 'a', 'z') then
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
      if (ch <= #9) or Between(ch, #11, #12) or Between(ch, #14, '!') or
         Between(ch, '#', '[') or Between(ch, ']', #65535) then
      begin
        AddCh; state := 3;
      end
      else if ch = '"' then
      begin
        AddCh; state := 5;
      end
      else if ch = '\' then
      begin
        AddCh; state := 4;
      end
      else
      begin
        state := 0;
      end;
      4:
      if Between(ch, ' ', '~') then
      begin
        AddCh; state := 3;
      end
      else
      begin
        state := 0;
      end;
      5:
      begin
        t.kind := 3; break;
      end;
      6:
      if (ch <= #9) or Between(ch, #11, #12) or Between(ch, #14, '&') or
         Between(ch, '(', '[') or Between(ch, ']', #65535) then
      begin
        AddCh; state := 7;
      end
      else if ch = '\' then
      begin
        AddCh; state := 8;
      end
      else
      begin
        state := 0;
      end;
      7:
      if ch = #39 then
      begin
        AddCh; state := 10;
      end
      else
      begin
        state := 0;
      end;
      8:
      if Between(ch, ' ', '~') then
      begin
        AddCh; state := 9;
      end
      else
      begin
        state := 0;
      end;
      9:
      if Between(ch, '0', '9') or Between(ch, 'a', 'f') then
      begin
        AddCh; state := 9;
      end
      else if ch = #39 then
      begin
        AddCh; state := 10;
      end
      else
      begin
        state := 0;
      end;
      10:
      begin
        t.kind := 4; break;
      end;
      11:
      begin
        recEnd := pos; recKind := 45;
        if Between(ch, '0', '9') or Between(ch, 'A', 'Z') or (ch = '_') or
           Between(ch, 'a', 'z') then
        begin
          AddCh; state := 11;
        end
        else
        begin
          t.kind := 45; break;
        end;
      end;
      12:
      begin
        recEnd := pos; recKind := 46;
        if Between(ch, '-', '.') or Between(ch, '0', ':') or Between(ch, 'A', 'Z') or
           (ch = '_') or Between(ch, 'a', 'z') then
        begin
          AddCh; state := 12;
        end
        else
        begin
          t.kind := 46; break;
        end;
      end;
      13:
      begin
        recEnd := pos; recKind := 45;
        if Between(ch, '0', '9') then
        begin
          AddCh; state := 11;
        end
        else if Between(ch, 'A', 'Z') or (ch = '_') or Between(ch, 'a', 'z') then
        begin
          AddCh; state := 14;
        end
        else
        begin
          t.kind := 45; break;
        end;
      end;
      14:
      begin
        recEnd := pos; recKind := 45;
        if Between(ch, '0', '9') then
        begin
          AddCh; state := 11;
        end
        else if Between(ch, 'A', 'Z') or (ch = '_') or Between(ch, 'a', 'z') then
        begin
          AddCh; state := 14;
        end
        else if ch = '=' then
        begin
          AddCh; state := 12;
        end
        else
        begin
          t.kind := 45; break;
        end;
      end;
      15:
      begin
        t.kind := 18; break;
      end;
      16:
      begin
        t.kind := 21; break;
      end;
      17:
      begin
        t.kind := 22; break;
      end;
      18:
      begin
        t.kind := 23; break;
      end;
      19:
      begin
        t.kind := 27; break;
      end;
      20:
      begin
        t.kind := 29; break;
      end;
      21:
      begin
        t.kind := 30; break;
      end;
      22:
      begin
        t.kind := 31; break;
      end;
      23:
      begin
        t.kind := 32; break;
      end;
      24:
      begin
        t.kind := 34; break;
      end;
      25:
      begin
        t.kind := 35; break;
      end;
      26:
      begin
        t.kind := 36; break;
      end;
      27:
      begin
        t.kind := 37; break;
      end;
      28:
      begin
        t.kind := 41; break;
      end;
      29:
      if ch = '/' then
      begin
        AddCh; state := 30;
      end
      else
      begin
        state := 0;
      end;
      30:
      begin
        t.kind := 42; break;
      end;
      31:
      begin
        t.kind := 43; break;
      end;
      32:
      begin
        recEnd := pos; recKind := 19;
        if ch = '.' then
        begin
          AddCh; state := 18;
        end
        else if ch = '>' then
        begin
          AddCh; state := 22;
        end
        else if ch = ')' then
        begin
          AddCh; state := 31;
        end
        else
        begin
          t.kind := 19; break;
        end;
      end;
      33:
      begin
        recEnd := pos; recKind := 26;
        if ch = '.' then
        begin
          AddCh; state := 28;
        end
        else
        begin
          t.kind := 26; break;
        end;
      end;
      34:
      begin
        recEnd := pos; recKind := 28;
        if ch = '.' then
        begin
          AddCh; state := 21;
        end
        else
        begin
          t.kind := 28; break;
        end;
      end;
    end;
  until false;
  t.val := tval;
  Result := t;
end;

end.

