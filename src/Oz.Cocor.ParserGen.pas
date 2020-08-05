unit Oz.Cocor.ParserGen;
// Compiler Generator Coco/R, for Delphi
// Copyright (c) 2020 Tomsk, Marat Shaimardanov

interface

uses
  System.Classes, System.SysUtils, System.Character,
  System.Generics.Collections,
  Oz.Cocor.Utils, Oz.Cocor.Lib, Oz.Cocor.Tab, Oz.Cocor.DFA;

type
  TParserGen = class(TCocoPart)
  const
    maxTerm = 3;    // sets of size < maxTerm are enumerated
    LF = 10;
    CR = 13;
    tErr = 0;       // error codes
    altErr = 1;
    syncErr = 2;
  private
    sb: TStringBuilder;
    buffer: PBuffer;         // scanner buffer
    curSy: TSymbol;          // symbol whose production is currently generated
    gen: TStreamWriter;      // generated parser source file
    err: TStringList;        // generated parser error messages
    symSet: TList<TBitSet>;
    procedure Indent(n: Integer);
    function Overlaps(s1, s2: TBitSet): Boolean;
    // use a switch if more than 5 alternatives
    // and none starts with a resolver, and no LL1 warning
    function UseCase(p: TNode): Boolean;
    // Get text described by pos from atg
    function GetFromAtg(const pos: TPosition; n: Integer): string;
    procedure GenAttributes(const attr: string; indent: Integer);
    function GetErrorNr: Integer;
    procedure GenErrorMsg(errTyp: Integer; sym: TSymbol);
    function NewCondSet(s: TBitSet): Integer;
    procedure GenCond(s: TBitSet; p: TNode);
    procedure PutCaseLabels(s: TBitSet);
    procedure GenCode(p: TNode; n: Integer; isChecked: TBitSet);
    procedure GenTokens;
    procedure GenPragmas;
    procedure GenCodePragmas;
    procedure GenHeaders;
    procedure GenProductions;
    procedure InitSets;
    procedure GenErrors;
  public
    // 'uses' modules from the attributed grammar
    importPos: TPosition;
    // parser frame file
    fram: TBuffer;
    constructor Create(parser: TBaseParser; buffer: PBuffer);
    destructor Destroy; override;
    procedure WriteParser;
    procedure WriteStatistics;
  end;

implementation

uses Oz.Cocor.Parser;

constructor TParserGen.Create(parser: TBaseParser; buffer: PBuffer);
begin
  inherited Create(parser);
  Self.buffer := buffer;
  symSet := TList<TBitSet>.Create;
  sb := TStringBuilder.Create;
end;

destructor TParserGen.Destroy;
begin
  symSet.Free;
  FreeAndNil(err);
  sb.Free;
  inherited;
end;

procedure TParserGen.Indent(n: Integer);
begin
  if n > 0 then
    gen.Write(Blank(n * 2));
end;

function TParserGen.Overlaps(s1, s2: TBitSet): Boolean;
var
  i, len: Integer;
begin
  len := s1.Size;
  for i := 0 to len - 1 do
  begin
    if (s1[i] and s2[i]) then
      exit(true);
  end;
  Result := false;
end;

function TParserGen.UseCase(p: TNode): Boolean;
var
  s1, s2: TBitSet;
  nAlts: Integer;
begin
  if p.typ <> TNodeKind.alt then exit(false);
  nAlts := 0;
  s1 := tab.NewBitSet(tab.terminals.Count);
  while p <> nil do
  begin
    s2 := tab.Expected0(p.sub, curSy);
    // must not optimize with switch statement, if there are ll1 warnings
    if Overlaps(s1, s2) then exit(false);
    s1.Unite(s2);
    Inc(nAlts);
    // must not optimize with switch-statement, if alt uses a resolver expression
    if p.sub.typ = TNodeKind.rslv then exit(false);
    p := p.down;
  end;
  Result := nAlts > 5;
end;

function TParserGen.GetFromAtg(const pos: TPosition; n: Integer): string;
label
  done;
var
  ch, i: Integer;
begin
  sb.Clear;
  if not pos.Empty then
  begin
    buffer.Pos := pos.beg; ch := buffer.Read;
    if Options.emitLines then
    begin
      sb.AppendLine;
      sb.AppendLine(Format('// line %d "%s"', [pos.line, Options.srcName]));
    end;
    sb.Append(Blank(n * 2));
    while buffer.Pos <= pos.ends do
    begin
      while (ch = CR) or (ch = LF) do
      begin
        // eol is either CR or CRLF or LF
        sb.AppendLine; sb.Append(Blank(n * 2));
        if ch = CR then ch := buffer.Read; // skip CR
        if ch = LF then ch := buffer.Read; // skip LF
        i := 1;
        while (i < pos.col) and (ch = Ord(' ')) or (ch = 9) do
        begin
          // skip blanks at beginning of line
          ch := buffer.Read;
          Inc(i);
        end;
        if buffer.Pos > pos.ends then goto done;
      end;
      sb.Append(char(ch));
      ch := buffer.Read;
    end;
    done:
    if n > 0 then sb.AppendLine;
  end;
  Result := sb.ToString;
end;

procedure TParserGen.GenAttributes(const attr: string; indent: Integer);
var
  i: Integer;
  s: string;
  list: TStringList;
begin
  if attr = '' then exit;
  list := TStringList.Create;
  list.Text := attr;
  for i := 0 to list.Count - 1 do
  begin
    s := list.Strings[i];
    if i = 0 then
      s := '(' + s
    else if indent > 0 then
      s := Blank(indent * 2) + s;
    if i = list.Count - 1 then
      s := s + ');';
    gen.WriteLine(s);
  end;
  list.Free;
end;

function TParserGen.GetErrorNr: Integer;
begin
  Result := err.Count - 1;
end;

procedure TParserGen.GenErrorMsg(errTyp: Integer; sym: TSymbol);
var
  s: string;
begin
  case errTyp of
    tErr:
      if sym.name[1] = '''' then
        s := tab.Escape(sym.name) + ' expected'
      else
        s := sym.name + ' expected';
    altErr:
      s := 'invalid ' + sym.name;
    syncErr:
      s := 'this symbol not expected in ' + sym.name;
  end;
  err.Add(s);
end;

procedure TParserGen.GenErrors;
var
  i: Integer;
begin
  gen.WriteLine('const');
  gen.WriteLine('  MaxErr = %d;', [GetErrorNr]);
  gen.WriteLine('  Errors: array [0 .. MaxErr] of string = (');
  for i := 0 to err.Count - 1 do
  begin
    gen.Write('    {%d} ''%s''', [i, err.Strings[i]]);
    if i < err.Count - 1 then gen.WriteLine(',') else gen.Write(');');
  end;
end;

function TParserGen.NewCondSet(s: TBitSet): Integer;
var
  i: Integer;
begin
  for i := 1 to symSet.Count - 1 do
    // skip symSet[0] (reserved for union of SYNC sets)
    if s.Equals(symSet[i]) then
      exit(i);
  symSet.Add(tab.CloneBitSet(s));
  Result := symSet.Count - 1;
end;

procedure TParserGen.GenCond(s: TBitSet; p: TNode);
var
  sym: TSymbol;
  n: Integer;
  withBrackets: Boolean;
begin
  if p.typ = TNodeKind.rslv then
    gen.Write(GetFromAtg(p.pos, 0))
  else
  begin
    n := s.Elements;
    withBrackets := n > 1;
    if n = 0 then
      gen.Write('false') // happens if an ANY set matches no symbol
    else if n > maxTerm then
      gen.Write('StartOf(%d)', [NewCondSet(s)])
    else
    begin
      for sym in tab.terminals do
      begin
        if s[sym.n] then
        begin
          if withBrackets then
            gen.Write('(la.kind = %d)', [sym.n])
          else
            gen.Write('la.kind = %d', [sym.n]);
          Dec(n);
          if n > 0 then gen.Write(' or ');
        end;
      end
    end
  end;
end;

procedure TParserGen.PutCaseLabels(s: TBitSet);
var
  sym: TSymbol;
  r: string;
begin
  r := '';
  for sym in tab.terminals do
  begin
    if s[sym.n] then
    begin
      if r <> '' then r := r + ', ';
      r := r + IntToStr(sym.n);
    end;
  end;
  gen.WriteLine('%s:', [r]);
end;

procedure TParserGen.GenCode(p: TNode; n: Integer; isChecked: TBitSet);
var
  s1, s2: TBitSet;
  p2: TNode;
  acc: Integer;
  equal, ucase: Boolean;
  s: string;
begin
  while p <> nil do
  begin
    case p.typ of
      TNodeKind.nt:
      begin
        Indent(n);
        gen.Write(p.sym.AsIdent);
        s := GetFromAtg(p.pos, 0);
        if s <> '' then gen.Write('(%s)', [s]);
        gen.WriteLine(';');
      end;
      TNodeKind.t:
      begin
        Indent(n);
        // assert: if isChecked[p.sym.n] is true, then
        // isChecked contains only p.sym.n
        if isChecked[p.sym.n] then
          gen.WriteLine('Get;')
        else
          gen.WriteLine('Expect(%d);', [p.sym.n]);
      end;
      TNodeKind.wt:
      begin
        Indent(n);
        s1 := tab.Expected(p.next, curSy);
        s1.Unite(tab.allSyncSets);
        gen.WriteLine('ExpectWeak(%d, %d);', [p.sym.n, NewCondSet(s1)]);
      end;
      TNodeKind.any:
      begin
        Indent(n);
        acc := p.sets.Elements;
        if (tab.terminals.Count = acc + 1) or
           ((acc > 0) and p.sets.Equals(isChecked)) then
          // either this ANY accepts any terminal (the + 1 = end of file), or exactly what's allowed here
          gen.WriteLine('Get;')
        else
        begin
          GenErrorMsg(altErr, curSy);
          if acc > 0 then
          begin
            gen.Write('if ');
            GenCond(p.sets, p);
            gen.WriteLine(' then Get else SynErr(%d);', [GetErrorNr]);
          end
          else
            gen.WriteLine('SynErr(%d); // ANY node that matches no symbol', [GetErrorNr]);
        end;
      end;
      TNodeKind.eps, TNodeKind.rslv: ; // nothing
      TNodeKind.sem:
        gen.WriteLine(RTrim(GetFromAtg(p.pos, n)));
      TNodeKind.sync:
      begin
        Indent(n);
        GenErrorMsg(syncErr, curSy);
        s1 := tab.CloneBitSet(p.sets);
        gen.Write('while not ('); GenCond(s1, p); gen.WriteLine(') do');
        Indent(n); gen.WriteLine('begin');
        Indent(n + 1); gen.WriteLine('SynErr(%d); Get;', [GetErrorNr]);
        Indent(n); gen.WriteLine('end;');
      end;
      TNodeKind.alt:
      begin
        s1 := tab.First(p);
        equal := s1.Equals(isChecked);
        ucase := UseCase(p);
        if ucase then
        begin
          Indent(n);
          gen.WriteLine('case la.kind of');
        end;
        if ucase then Inc(n);
        p2 := p;
        while p2 <> nil do
        begin
          s1 := tab.Expected(p2.sub, curSy);
          if ucase then
          begin
            Indent(n); PutCaseLabels(s1);
            Indent(n); gen.WriteLine('begin');
          end
          else if p2 = p then
          begin
            Indent(n); gen.Write('if ');
            GenCond(s1, p2.sub);
            gen.WriteLine(' then');
            Indent(n); gen.WriteLine('begin');
          end
          else if (p2.down = nil) and equal then
          begin
            Indent(n); gen.WriteLine('end');
            Indent(n); gen.WriteLine('else');
            Indent(n); gen.WriteLine('begin');
          end
          else
          begin
            Indent(n); gen.WriteLine('end');
            Indent(n); gen.Write('else if ');
            GenCond(s1, p2.sub);
            gen.WriteLine(' then');
            Indent(n); gen.WriteLine('begin');
          end;
          GenCode(p2.sub, n + 1, s1);
          if ucase then
          begin
            Indent(n); gen.WriteLine('end;');
          end;
          p2 := p2.down;
        end;
        if equal then
        begin
          Indent(n); gen.WriteLine('end;')
        end
        else
        begin
          GenErrorMsg(altErr, curSy);
          if ucase then
          begin
            Indent(n); gen.WriteLine('else');
            Indent(n); gen.WriteLine('  SynErr(%d);', [GetErrorNr]);
            Dec(n);
            Indent(n); gen.WriteLine('end;');
          end
          else
          begin
            Indent(n); gen.WriteLine('end');
            Indent(n); gen.WriteLine('else');
            Indent(n); gen.WriteLine('  SynErr(%d);', [GetErrorNr]);
          end;
        end;
      end;
      TNodeKind.iter:
      begin
        Indent(n);
        p2 := p.sub;
        gen.Write('while ');
        if p2.typ = TNodeKind.wt then
        begin
          s1 := tab.Expected(p2.next, curSy);
          s2 := tab.Expected(p.next, curSy);
          gen.Write('WeakSeparator(%d, %d, %d)',
            [p2.sym.n, NewCondSet(s1), NewCondSet(s2)]);
          s1 := tab.NewBitSet(tab.terminals.Count);  // for inner structure
          if p2.up or (p2.next = nil) then
            p2 := nil
          else
            p2 := p2.next;
        end
        else
        begin
          s1 := tab.First(p2);
          GenCond(s1, p2);
        end;
        gen.WriteLine(' do');
        Indent(n); gen.WriteLine('begin');
        GenCode(p2, n + 1, s1);
        Indent(n); gen.WriteLine('end;');
      end;
      TNodeKind.opt:
      begin
        s1 := tab.First(p.sub);
        Indent(n); gen.Write('if ');
        GenCond(s1, p.sub);
        gen.WriteLine(' then');
        Indent(n); gen.WriteLine('begin');
        GenCode(p.sub, n + 1, s1);
        Indent(n); gen.WriteLine('end;');
      end;
    end;
    if (p.typ <> TNodeKind.eps) and (p.typ <> TNodeKind.sem) and (p.typ <> TNodeKind.sync) then
      isChecked.SetAll(false);  // = new TBitSet(tab.terminals.Count);
    if p.up then break;
    p := p.next;
  end;
end;

procedure TParserGen.GenTokens;
var sym: TSymbol;
begin
  for sym in tab.terminals do
    if sym.name[1].IsLetter then
      gen.WriteLine('    _%s = %d;', [sym.AsIdent, sym.n]);
end;

procedure TParserGen.GenPragmas;
var sym: TSymbol;
begin
  for sym in tab.pragmas do
    gen.WriteLine('    _%s = %d;', [sym.AsIdent, sym.n]);
end;

procedure TParserGen.GenCodePragmas;
var
  i, n: Integer;
  sym: TSymbol;
begin
  gen.WriteLine;
  n := tab.pragmas.Count - 1;
  for i := 0 to n do
  begin
    sym := tab.pragmas[i];
    gen.WriteLine('    if la.kind = %d then', [sym.n]);
    gen.Write(RTrim(GetFromAtg(sym.semPos, 3)));
    if i <> n then gen.WriteLine;
  end;
end;

procedure TParserGen.GenHeaders;
var
  sym: TSymbol;
  s: string;
begin
  gen.WriteLine;
  for sym in tab.nonterminals do
  begin
    s := GetFromAtg(sym.attrPos, 0);
    gen.Write('    procedure ' + sym.AsIdent);
    if s = '' then
      gen.WriteLine(';')
    else
      GenAttributes(s, 2);
  end;
end;

procedure TParserGen.GenProductions;
var
  sym: TSymbol;
  s: string;
  i, n: Integer;
begin
  gen.WriteLine;
  gen.WriteLine;
  n := tab.nonterminals.Count - 1;
  for i := 0 to n do
  begin
    sym := tab.nonterminals[i];
    curSy := sym;
    gen.Write('procedure %s.%s', [tab.GetParserType, sym.AsIdent]);
    if sym.attrPos.Empty then
      gen.WriteLine(';')
    else
    begin
      s := GetFromAtg(sym.attrPos, 0);
      GenAttributes(s, 0);
    end;
    s := Rtrim(GetFromAtg(sym.semPos, 0));
    if Pos(';', s) > 0 then
      gen.WriteLine(s);
    gen.WriteLine('begin');
    GenCode(sym.graph, 1, tab.NewBitSet(tab.terminals.Count));
    gen.WriteLine('end;');
    if i < n then gen.WriteLine;
  end;
end;

procedure TParserGen.InitSets;
const
  BoolStrings: array [Boolean] of string = ('x', 'T');
var
  i, j, sn: Integer;
  sym: TSymbol;
  s: TBitSet;
begin
  sn := symSet.Count - 1;
  gen.WriteLine('const');
  gen.WriteLine('  %s = false;', [BoolStrings[false]]);
  gen.WriteLine('  %s = true;', [BoolStrings[true]]);
  gen.WriteLine('  sets: array [0..%d] of array [0..%d] of Boolean = (',
    [sn, tab.terminals.Count]);
  for i := 0 to sn do
  begin
    s := symSet[i];
    gen.Write('    (');
    j := 0;
    for sym in tab.terminals do
    begin
      gen.Write(BoolStrings[s[sym.n]]); gen.Write(',');
      Inc(j);
      if j mod 4 = 0 then gen.Write(' ');
    end;
    gen.Write(BoolStrings[false] + ')');
    if i < symSet.Count - 1 then
      gen.WriteLine(',');
  end;
  gen.Write(');')
end;

procedure TParserGen.WriteParser;
var
  sym: TSymbol;
  g: TGenerator;
  oldPos: Integer;
  unitName: string;
begin
  tab.UpdateScannerAndParserTypes;
  g := TGenerator.Create(parser, fram);
  oldPos := buffer.Pos;  // Pos is modified by CopySourcePart
  try
    symSet.Add(tab.allSyncSets);
    fram := g.OpenFrame('Parser.frame');
    if Options.namespace = '' then
      unitName := 'Parser'
    else
      unitName := Options.namespace + '.Parser';
    gen := g.OpenGen(unitName + '.pas');
    err := TStringList.Create;
    for sym in tab.terminals do
      GenErrorMsg(tErr, sym);
    g.GenCopyright;
    g.GetFramePart('-->begin<');
    if not importPos.Empty then
    begin
      gen.Write(GetFromAtg(importPos, 0));
      gen.WriteLine;
    end;
    g.CopyFramePart('-->unitname<');
    gen.Write(unitName);
    g.CopyFramePart('-->declarations<');
    gen.Write(RTrim(GetFromAtg(tab.semDeclPos, 2)));
    g.CopyFramePart('-->constants<');
    // генерация констант которые могут быть использованы в .atg
    GenTokens;
    GenPragmas;
    gen.Write(RTrim(g.GetFramePart('-->headers<')));
    GenHeaders;
    gen.Write(RTrim(g.GetFramePart('-->pragmas<')));
    GenCodePragmas;
    gen.Write(RTrim(g.GetFramePart('-->productions<')));
    GenProductions;

    g.CopyFramePart('-->parseRoot<');
    gen.Write('  %s;', [tab.gramSy.AsIdent]);
    if Options.checkEOF then
    begin
      gen.WriteLine;
      gen.Write('  Expect(0);');
    end;
    g.CopyFramePart('-->initialization<'); InitSets;
    g.CopyFramePart('-->errors<'); GenErrors;
    g.CopyFramePart('');
    gen.Close;
  finally
    buffer.Pos := oldPos;
    g.Free;
  end;
end;

procedure TParserGen.WriteStatistics;
begin
  trace.WriteLine;
  trace.WriteLine('%d terminals', [tab.terminals.Count]);
  trace.WriteLine('%d symbols',
    [tab.terminals.Count + tab.pragmas.Count + tab.nonterminals.Count]);
  trace.WriteLine('%d nodes', [tab.nodes.Count]);
  trace.WriteLine('%d sets', [symSet.Count]);
end;

end.

