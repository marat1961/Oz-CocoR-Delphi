unit Oz.Cocor.Tab;
// Compiler Generator Coco/R, for Delphi
// Copyright (c) 2020 Tomsk, Marat Shaimardanov

interface

uses
  System.Classes, System.SysUtils, System.Contnrs,
  System.Generics.Defaults, System.Generics.Collections,
  Oz.Cocor.Utils, Oz.Cocor.Lib;

type

{$Region 'TTokenKind, TNodeKind, TSymbol, TNode'}

  TTokenKind = (
    fixedToken    = 0,    // e.g. 'a' ('b' | 'c') (structure of literals)
    classToken    = 1,    // e.g. digit {digit}   (at least one char class)
    litToken      = 2,    // e.g. 'while'
    classLitToken = 3);   // e.g. letter {letter} but without literals that have the same structure

  TNodeKind = (
    // constants for node kinds
    undef = 0,
    t    =  1,  // terminal symbol
    pr   =  2,  // pragma
    nt   =  3,  // nonterminal symbol
    clas =  4,  // character class
    chr  =  5,  // character
    wt   =  6,  // weak terminal symbol
    any  =  7,  // any
    eps  =  8,  // empty
    sync =  9,  // synchronization symbol
    sem  = 10,  // semantic action: (. .)
    alt  = 11,  // alternative: |
    iter = 12,  // iteration: { }
    opt  = 13,  // option: [ ]
    rslv = 14   // resolver expr
  );

  TNode = class;
  TSymbol = class
  public
    n: Integer;             // symbol number
    typ: TNodeKind;         // t, nt, pr, undef, rslv
    name: string;           // symbol name
    graph: TNode;           // nt: to first node of syntax graph
    tokenKind: TTokenKind;  // t:  token kind (fixedToken, classToken, ...)
    deletable: Boolean;     // nt: true if nonterminal is deletable
    firstReady: Boolean;    // nt: true if terminal start symbols have already been computed
    first: TBitSet;         // nt: terminal start symbols
    follow: TBitSet;        // nt: terminal followers
    nts: TBitSet;           // nt: nonterminals whose followers have to be added to this sym
    line: Integer;          // source text line number of item in this node
    attrPos: TPosition;     // nt: position of attributes in source text (or nil)
    semPos: TPosition;      // pr: pos of semantic action in source text (or nil)
                            // nt: pos of local declarations in source text (or nil)
    constructor Create(typ: TNodeKind; const name: string; line: Integer);
    function AsIdent: string;
  end;

{$EndRegion}

{$Region 'TNode'}

  TNode = class
  const
    // transition codes
    normalTrans  = 0;
    contextTrans = 1;
  public
    n: Integer;      // node number
    typ: TNodeKind;  // t, nt, wt, chr, clas, any, eps, sem, sync, alt, iter, opt, rslv
    next: TNode;     // to successor node
    down: TNode;     // alt: to next alternative
    sub: TNode;      // alt, iter, opt: to first node of substructure
    up: Boolean;     // true: 'next' leads to successor in enclosing structure
    sym: TSymbol;    // nt, t, wt: symbol represented by this node
    val: Integer;    // chr:  ordinal character value
                     // clas: index of character class
    code: Integer;   // chr, clas: transition code
    sets: TBitSet;   // any, sync: the set represented by this node
    pos: TPosition;  // nt, t, wt: pos of actual attributes
                     // sem:       pos of semantic action in source text
                     // rslv:      pos of resolver in source text
    line: Integer;   // source text line number of item in this node
    state: TObject{TState};  // DFA state corresponding to this node
    constructor Create(typ: TNodeKind; sym: TSymbol; line: Integer);
  end;

{$EndRegion}

{$Region 'TGraph, TCharClass'}

  TGraph = class
    l: TNode;        // left end of graph = head
    r: TNode;        // right end of graph = list of nodes to be linked to successor graph
  end;

  TCharClass = class
    n: Integer;      // class number
    name: string;    // class name
    cset: TCharSet;  // set representing the class
    constructor Create(name: string; s: TCharSet);
  end;

{$EndRegion}

type
  // macro declaration
  TMacroDef = class
    name, stuff: string;
  end;
  // token name declaration
  TNameDecl = class
    name, definition: string;
  end;

{$Region 'TTab'}

  THashtable = TDictionary<string, TSymbol>;

  TTab = class(TCocoPart)
  var
    semDeclPos: TPosition;   // position of global semantic declarations
    ignored: TCharSet;       // characters ignored by the scanner
    gramSy: TSymbol;         // root nonterminal; filled by ATG
    eofSy: TSymbol;          // end of file symbol
    noSym: TSymbol;          // used in case of an error
    allSyncSets: TBitSet;    // union of all synchronisation sets
    literals: THashtable;    // symbols that are used as literals
    visited: TBitSet;        // mark list for graph traversals
    curSy: TSymbol;          // current symbol in computation of sets
  private
    FGraphs: TObjectList;
    FBitsets: TObjectList;
    FCharsets: TObjectList;
  public
    constructor Create(parser: TBaseParser);
    destructor Destroy; override;

  {$Region 'Symbol list management'}
  const
    tKind: array [TTokenKind] of string = (
      'fixedToken', 'classToken', 'litToken', 'classLitToken');
  private
    function Num(p: TNode): Integer;
    procedure PrintSym(sym: TSymbol);
    procedure PrintSet(s: TBitSet; indent: Integer);
  public
    terminals: TOwnedList<TSymbol>;
    pragmas: TOwnedList<TSymbol>;
    nonterminals: TOwnedList<TSymbol>;
    function FindSym(const name: string): TSymbol;
    function NewSym(typ: TNodeKind; name: string; line: Integer): TSymbol;
    procedure PrintSymbolTable;
  {$EndRegion}

  {$Region 'Syntax graph management'}
  const
    nTyp: array [TNodeKind] of string = (
      '    ', 't   ', 'pr  ', 'nt  ', 'clas', 'chr ', 'wt  ', 'any ',
      'eps ', 'sync', 'sem ', 'alt ', 'iter', 'opt ', 'rslv');
  var
    nodes: TOwnedList<TNode>;
    dummyNode: TNode;
  public
    function StrToGraph(const str: string): TGraph;
    function NewNode(typ: TNodeKind; sym: TSymbol; line: Integer): TNode; overload;
    function NewNode(typ: TNodeKind; sub: TNode): TNode; overload;
    function NewNode(typ: TNodeKind; val, line: Integer): TNode; overload;
    procedure SetContextTrans(p: TNode);
    procedure DeleteNodes;
    procedure Finish(g: TGraph);
    procedure MakeFirstAlt(g: TGraph);
    // The result will be in g1
    procedure MakeAlternative(g1, g2: TGraph);
    // The result will be in g1
    procedure MakeSequence(g1, g2: TGraph);
    procedure MakeIteration(g: TGraph);
    procedure MakeOption(g: TGraph);
  {$EndRegion}

  {$Region 'graph deletability check'}
  private
    class function DelNode(p: TNode): Boolean;
  public
    function NewGraph: TGraph; overload;
    function NewGraph(left, right: TNode): TGraph; overload;
    function NewGraph(p: TNode): TGraph; overload;
    class function DelGraph(p: TNode): Boolean;
    class function DelSubGraph(p: TNode): Boolean;
  {$EndRegion}

  {$Region 'graph printing'}
  private
    function Ptr(p: TNode; up: Boolean): string;
    function Pos(const p: TPosition): string;
  public
    procedure PrintNodes;
  {$EndRegion}

  {$Region 'Character class management'}
  var
    classes: TOwnedList<TCharClass>;
    dummyName: Integer;
  public
    function NewCharSet: TCharSet;
    function NewCharClass(name: string; s: TCharSet): TCharClass;
    function Clone(s: TCharSet): TCharSet;
    function Subtract(s1, s2: TCharSet): TCharSet;
    function FindCharClass(const name: string): TCharClass; overload;
    function FindCharClass(s: TCharSet): TCharClass; overload;
    function CharClassSet(i: Integer): TCharSet;
  {$EndRegion}

  {$Region 'Character class printing'}
  private
    procedure WriteTCharSet(s: TCharSet);
  public
    procedure WriteCharClasses;
  {$EndRegion}

  {$Region 'Symbol set computations'}
  private
    // Computes the first set for the graph rooted at p
    function First0(p: TNode; mark: TBitSet): TBitSet;
    procedure CompFirstSets;
    procedure CompFollow(p: TNode);
    procedure Complete(sym: TSymbol);
    procedure CompFollowSets;
    function LeadingAny(p: TNode): TNode;
    // find ANY sets
    procedure FindAS(p: TNode);
    procedure CompAnySets;
    procedure CompSync(p: TNode);
    procedure CompSyncSets;
    procedure CompDeletableSymbols;
  public
    function NewBitSet(Size: Cardinal; defVal: Boolean = false): TBitSet;
    function CloneBitSet(s: TBitSet): TBitSet;
    function First(p: TNode): TBitSet;
    procedure SetupAnys;
    procedure RenumberPragmas;
    procedure CompSymbolSets;
    // does not look behind resolvers; only called during LL(1) test and in CheckRes
    function Expected0(p: TNode; curSy: TSymbol): TBitSet;
    function Expected(p: TNode; curSy: TSymbol): TBitSet;
  {$EndRegion}

  {$Region 'String handling'}
  private
    // table of token name declarations
    FNames: TOwnedDictionary<string, TNameDecl>;
    // table of macro definition
    FMacros: TOwnedDictionary<string, TMacroDef>;
    function Hex2Char(const s: string): char;
  public
    // replaces escape sequences in s by their Unicode values.
    function Unescape(const s: string): string;
    function Escape(const s: string): string;
    procedure UpdateScannerAndParserTypes;
    function NewName(const name, definition: string): TNameDecl;
    function NewMacro(const name, stuff: string): TMacroDef;
    function EvalMacros(s: string): string;
    function GetPrefix: string;
    function GetScannerType: string;
    function GetParserType: string;
  {$EndRegion}

  {$Region 'Grammar checks'}
  private
    procedure GetSingles(p: TNode; singles: TList<TSymbol>);
    function NoCircularProductions: Boolean;
    procedure LL1Error(cond: Integer; sym: TSymbol);
    procedure CheckOverlap(s1, s2: TBitSet; cond: Integer);
    procedure CheckAlts(p: TNode);
    procedure CheckLL1;
    procedure ResErr(p: TNode; const s: string);
    procedure CheckRes(p: TNode; rslvAllowed: Boolean);
    procedure CheckResolvers;
    function NtsComplete: Boolean;
    procedure MarkReachedNts(p: TNode);
    function AllNtReached: Boolean;
    // check if every nts can be derived to terminals
    function IsTerm(p: TNode; mark: TBitSet): Boolean;
    function AllNtToTerm(): Boolean;
  public
    function GrammarOk: Boolean;
  {$EndRegion}
  public
    //  Cross reference list
    procedure XRef;
  end;

{$EndRegion}

implementation

uses Oz.Cocor.Options, Oz.Cocor.Parser;

{$Region 'TSymbol'}

constructor TSymbol.Create(typ: TNodeKind; const name: string; line: Integer);
begin
  Self.typ := typ;
  Self.name := name;
  Self.line := line;
end;

function TSymbol.AsIdent: string;
begin
  case typ of
    t:  Result := name + 'Sym';
    nt: Result := '_' + name;
    else Result := name;
  end;
end;

{$EndRegion}

{$Region 'TNode'}

constructor TNode.Create(typ: TNodeKind; sym: TSymbol; line: Integer);
begin
  Self.typ := typ;
  Self.sym := sym;
  Self.line := line;
end;

{$EndRegion}

{$Region 'TCharClass'}

constructor TCharClass.Create(name: string; s: TCharSet);
begin
  Self.name := name;
  Self.cset := s;
end;

{$EndRegion}

{$Region 'TTab'}

constructor TTab.Create(parser: TBaseParser);
begin
  inherited;
  terminals := TOwnedList<TSymbol>.Create;
  pragmas := TOwnedList<TSymbol>.Create;
  nonterminals := TOwnedList<TSymbol>.Create;
  eofSy := NewSym(TNodeKind.t, 'EOF', 0);
  literals := TDictionary<string, TSymbol>.Create;
  nodes := TOwnedList<TNode>.Create;
  dummyNode := NewNode(TNodeKind.eps, nil, 0);
  classes := TOwnedList<TCharClass>.Create;
  dummyName := Ord('A');
  FGraphs := TObjectList.Create(True);
  FBitsets := TObjectList.Create(True);
  FCharsets := TObjectList.Create(True);
  FNames := TOwnedDictionary<string, TNameDecl>.Create;
  FMacros := TOwnedDictionary<string, TMacroDef>.Create;
end;

destructor TTab.Destroy;
begin
  terminals.Free;
  pragmas.Free;
  nonterminals.Free;
  literals.Free;
  nodes.Free;
  classes.Free;
  FGraphs.Free;
  FBitsets.Free;
  FCharsets.Free;
  FNames.Free;
  FMacros.Free;
  inherited;
end;

function TTab.NewSym(typ: TNodeKind; name: string; line: Integer): TSymbol;
var
  r: TSymbol;
begin
  if (Length(name) = 2) and (name[1] = '''') then
  begin
    parser.SemErr('empty token not allowed');
    name := '???';
  end;
  r := TSymbol.Create(typ, name, line);
  case typ of
    TNodeKind.t: begin r.n := terminals.Count; terminals.Add(r); end;
    TNodeKind.pr: pragmas.Add(r);
    TNodeKind.nt: begin r.n := nonterminals.Count; nonterminals.Add(r); end;
  end;
  Result := r;
end;

function TTab.FindSym(const name: string): TSymbol;
var s: TSymbol;
begin
  for s in terminals do
    if s.name = name then exit(s);
  for s in nonterminals do
    if s.name = name then exit(s);
  Result := nil;
end;

function TTab.Num(p: TNode): Integer;
begin
  if p = nil then
    Result := 0
  else
    Result := p.n;
end;

procedure TTab.PrintSym(sym: TSymbol);
begin
  trace.Write('%3d %14s %s', [sym.n, AsName(sym.name), nTyp[sym.typ]]);
  if sym.attrPos.Empty then
    trace.Write(' false ')
  else
    trace.Write(' true  ');
  if sym.typ = TNodeKind.nt then
  begin
    trace.Write('%5d', [Num(sym.graph)]);
    if sym.deletable then
      trace.Write(' true  ')
    else
      trace.Write(' false ');
  end
  else
    trace.Write('            ');
  trace.WriteLine('%5d %s', [sym.line, tKind[sym.tokenKind]]);
end;

procedure TTab.PrintSymbolTable;
var
  sym: TSymbol;
  e: TPair<string, TSymbol>;
begin
  trace.WriteLine('Symbol Table:');
  trace.WriteLine('------------'); trace.WriteLine;
  trace.WriteLine(' nr name          typ  hasAt graph  del    line tokenKind');
  for sym in terminals do PrintSym(sym);
  for sym in pragmas do PrintSym(sym);
  for sym in nonterminals do PrintSym(sym);
  trace.WriteLine;
  trace.WriteLine('Literal Tokens:');
  trace.WriteLine('--------------');
  for e in literals do
    trace.WriteLine('_' + e.Value.name + ' = ' + e.Key + '.');
  trace.WriteLine;
end;

procedure TTab.PrintSet(s: TBitSet; indent: Integer);
var
  col, len: Integer;
  sym: TSymbol;
begin
  col := indent;
  for sym in terminals do
  begin
    if s[sym.n] then
    begin
      len := sym.name.Length;
      if col + len >= 80 then
      begin
        trace.WriteLine;
        col := 1;
        while col < indent do
        begin
          trace.Write(' ');
          Inc(col);
        end;
      end;
      trace.Write('%s ', [sym.name]);
      col := col + len + 1;
    end;
  end;
  if col = indent then
    trace.Write('-- empty set --');
  trace.WriteLine;
end;

function TTab.NewNode(typ: TNodeKind; sym: TSymbol; line: Integer): TNode;
var r: TNode;
begin
  r := TNode.Create(typ, sym, line);
  r.n := nodes.Count;
  nodes.Add(r);
  Result := r;
end;

function TTab.NewNode(typ: TNodeKind; sub: TNode): TNode;
var r: TNode;
begin
  r := NewNode(typ, nil, 0);
  r.sub := sub;
  Result := r;
end;

function TTab.NewNode(typ: TNodeKind; val, line: Integer): TNode;
var r: TNode;
begin
  r := NewNode(typ, nil, line);
  r.val := val;
  Result := r;
end;

procedure TTab.MakeFirstAlt(g: TGraph);
begin
  g.l := NewNode(TNodeKind.alt, g.l);
  g.l.line := g.l.sub.line;
  g.r.up := true;
  g.l.next := g.r;
  g.r := g.l;
end;

procedure TTab.MakeAlternative(g1, g2: TGraph);
var p: TNode;
begin
  g2.l := NewNode(TNodeKind.alt, g2.l); g2.l.line := g2.l.sub.line;
  g2.l.up := true;
  g2.r.up := true;
  p := g1.l;
  while p.down <> nil do p := p.down;
  p.down := g2.l;
  p := g1.r;
  while p.next <> nil do p := p.next;
  // append alternative to g1 end list
  p.next := g2.l;
  // append g2 end list to g1 end list
  g2.l.next := g2.r;
end;

procedure TTab.MakeSequence(g1, g2: TGraph);
var p, q: TNode;
begin
  p := g1.r.next; g1.r.next := g2.l; // link head node
  while p <> nil do
  begin
    // link substructure
    q := p.next; p.next := g2.l;
    p := q;
  end;
  g1.r := g2.r;
end;

procedure TTab.MakeIteration(g: TGraph);
var p, q: TNode;
begin
  g.l := NewNode(TNodeKind.iter, g.l);
  g.r.up := true;
  p := g.r;
  g.r := g.l;
  while p <> nil do
  begin
    q := p.next; p.next := g.l;
    p := q;
  end;
end;

procedure TTab.MakeOption(g: TGraph);
begin
  g.l := NewNode(TNodeKind.opt, g.l);
  g.r.up := true;
  g.l.next := g.r;
  g.r := g.l;
end;

procedure TTab.Finish(g: TGraph);
var p, q: TNode;
begin
  p := g.r;
  while p <> nil do
  begin
    q := p.next; p.next := nil;
    p := q;
  end;
end;

procedure TTab.DeleteNodes;
begin
  nodes.Free;
  nodes := TOwnedList<TNode>.Create;
  dummyNode := NewNode(TNodeKind.eps, nil, 0);
end;

function TTab.StrToGraph(const str: string): TGraph;
var
  s: string;
  g: TGraph;
  p: TNode;
  i: Integer;
begin
  s := Unescape(str.Substring(1, str.Length - 2));
  if s.Length = 0 then
    parser.SemErr('empty token not allowed');
  g := NewGraph;
  g.r := dummyNode;
  for i := 1 to s.Length do
  begin
    p := NewNode(TNodeKind.chr, Integer(s[i]), 0);
    g.r.next := p; g.r := p;
  end;
  g.l := dummyNode.next; dummyNode.next := nil;
  Result := g;
end;

procedure TTab.SetContextTrans(p: TNode);
begin
  // set transition code in the graph rooted at p
  while p <> nil do
  begin
    if (p.typ = TNodeKind.chr) or (p.typ = TNodeKind.clas) then
      p.code := TNode.contextTrans
    else if (p.typ = TNodeKind.opt) or (p.typ = TNodeKind.iter) then
      SetContextTrans(p.sub)
    else if p.typ = TNodeKind.alt then
    begin
      SetContextTrans(p.sub);
      SetContextTrans(p.down);
    end;
    if p.up then break;
    p := p.next;
  end;
end;

function TTab.NewGraph: TGraph;
begin
  Result := TGraph.Create;
  FGraphs.Add(Result);
end;

function TTab.NewGraph(left, right: TNode): TGraph;
begin
  Result := TGraph.Create;
  Result.l := left;
  Result.r := right;
  FGraphs.Add(Result);
end;

function TTab.NewGraph(p: TNode): TGraph;
begin
  Result := TGraph.Create;
  Result.l := p;
  Result.r := p;
  FGraphs.Add(Result);
end;

class function TTab.DelGraph(p: TNode): Boolean;
begin
  Result := (p = nil) or DelNode(p) and DelGraph(p.next);
end;

class function TTab.DelSubGraph(p: TNode): Boolean;
begin
  Result := (p = nil) or DelNode(p) and (p.up or DelSubGraph(p.next));
end;

class function TTab.DelNode(p: TNode): Boolean;
begin
  if p.typ = TNodeKind.nt then
    Result := p.sym.deletable
  else if p.typ = TNodeKind.alt then
    Result := DelSubGraph(p.sub) or (p.down <> nil) and DelSubGraph(p.down)
  else
    Result := (p.typ = TNodeKind.iter) or (p.typ = TNodeKind.opt) or
      (p.typ = TNodeKind.sem) or (p.typ = TNodeKind.eps) or
      (p.typ = TNodeKind.rslv) or (p.typ = TNodeKind.sync);
end;

function TTab.Ptr(p: TNode; up: Boolean): string;
begin
  if p = nil then
    Result := '0'
  else
    Result := p.n.ToString;
  if up then
    Result := '-' + Result;
end;

function TTab.Pos(const p: TPosition): string;
begin
  if p.Empty then
    Result := '     '
  else
    Result := Format('%5d', [p.beg]);
end;

procedure TTab.PrintNodes;
var
  p: TNode;
  c: TCharClass;
begin
  trace.WriteLine('Graph nodes:');
  trace.WriteLine('----------------------------------------------------');
  trace.WriteLine('   n type name          next  down   sub   pos  line');
  trace.WriteLine('                               val  code');
  trace.WriteLine('----------------------------------------------------');
  for p in nodes do
  begin
    trace.Write('%4d %1s ', [p.n, nTyp[p.typ]]);
    if p.sym <> nil then
      trace.Write('%12s ', [AsName(p.sym.name)])
    else if p.typ = TNodeKind.clas then
    begin
      c := classes[p.val];
      trace.Write('%12s ', [AsName(c.name)]);
    end
    else
      trace.Write('             ');
    trace.Write('%5s ', [Ptr(p.next, p.up)]);
    case p.typ of
      TNodeKind.t, TNodeKind.nt, TNodeKind.wt:
        trace.Write('             %5s', [Pos(p.pos)]);
      TNodeKind.chr:
        trace.Write('%5d %5d       ', [p.val, p.code]);
      TNodeKind.clas:
        trace.Write('      %5d       ', [p.code]);
      TNodeKind.alt, TNodeKind.iter, TNodeKind.opt:
        trace.Write('%5s %5s       ', [Ptr(p.down, false), Ptr(p.sub, false)]);
      TNodeKind.sem:
        trace.Write('             %5s', [Pos(p.pos)]);
      TNodeKind.eps, TNodeKind.any, TNodeKind.sync:
        trace.Write('                  ');
    end;
    trace.WriteLine('%5d', [p.line]);
  end;
  trace.WriteLine;
end;

function TTab.NewCharSet: TCharSet;
begin
  Result := TCharSet.Create;
  FCharsets.Add(Result);
end;

function TTab.NewCharClass(name: string; s: TCharSet): TCharClass;
var
  c: TCharClass;
begin
  if name = '#' then
  begin
    name := '#' + char(dummyName);
    Inc(dummyName);
  end;
  c := TCharClass.Create(name, s);
  c.n := classes.Count;
  classes.Add(c);
  Result := c;
end;

function TTab.Clone(s: TCharSet): TCharSet;
begin
  Result := s.Clone;
  FCharsets.Add(Result);
end;

function TTab.Subtract(s1, s2: TCharSet): TCharSet;
begin
  Result := s1.Subtract(s2);
  FCharsets.Add(Result);
end;

function TTab.FindCharClass(const name: string): TCharClass;
var c: TCharClass;
begin
  for c in classes do
    if c.name = name then exit(c);
  Result := nil;
end;

function TTab.FindCharClass(s: TCharSet): TCharClass;
var c: TCharClass;
begin
  for c in classes do
    if s.Equals(c.cset) then exit(c);
  Result := nil;
end;

function TTab.CharClassSet(i: Integer): TCharSet;
begin
  Result := classes[i].cset;
end;

procedure TTab.WriteTCharSet(s: TCharSet);
begin
  s.Scan(
    function(const r: TCharSet.TRange): Boolean
    begin
      if r.lo < r.hi then
        trace.Write(ToChar(r.lo) + '..' + ToChar(r.hi) + ' ')
      else
        trace.Write(ToChar(r.lo) + ' ');
      Result := False;
    end);
end;

procedure TTab.WriteCharClasses;
var
  c: TCharClass;
begin
  for c in classes do
  begin
    trace.Write('%-10s: ', [c.name]);
    WriteTCharSet(c.cset);
    trace.WriteLine;
  end;
  trace.WriteLine;
end;

function TTab.NewBitSet(Size: Cardinal; defVal: Boolean = false): TBitSet;
begin
  Result := TBitSet.Create(Size, defVal);
  FBitsets.Add(Result);
end;

function TTab.CloneBitSet(s: TBitSet): TBitSet;
begin
  Result := s.Clone;
  FBitsets.Add(Result);
end;

function TTab.First0(p: TNode; mark: TBitSet): TBitSet;
var
  fs: TBitSet;
begin
  fs := NewBitSet(terminals.Count);
  while (p <> nil) and not mark[p.n] do
  begin
    mark[p.n] := true;
    case p.typ of
      TNodeKind.nt:
      begin
        if p.sym.firstReady then
          fs.Unite(p.sym.first)
        else
          fs.Unite(First0(p.sym.graph, mark));
      end;
      TNodeKind.t, TNodeKind.wt:
      begin
        fs[p.sym.n] := true;
      end;
      TNodeKind.any:
      begin
        fs.Unite(p.sets);
      end;
      TNodeKind.alt:
      begin
        fs.Unite(First0(p.sub, mark));
        fs.Unite(First0(p.down, mark));
      end;
      TNodeKind.iter, TNodeKind.opt:
      begin
        fs.Unite(First0(p.sub, mark));
      end;
    end;
    if not DelNode(p) then break;
    p := p.next;
  end;
  Result := fs;
end;

function TTab.First(p: TNode): TBitSet;
var
  fs: TBitSet;
begin
  fs := First0(p, NewBitSet(nodes.Count));
  if Options.ddt[3] then
  begin
    trace.WriteLine;
    if p <> nil then
      trace.WriteLine('First: node = %d', [p.n])
    else
      trace.WriteLine('First: node = nil');
    PrintSet(fs, 0);
  end;
  Result := fs;
end;

procedure TTab.CompFirstSets;
var
  sym: TSymbol;
begin
  for sym in nonterminals do
  begin
    sym.first := NewBitSet(terminals.Count);
    sym.firstReady := false;
  end;
  for sym in nonterminals do
  begin
    sym.first := First(sym.graph);
    sym.firstReady := true;
  end;
end;

procedure TTab.CompFollow(p: TNode);
var
  s: TBitSet;
begin
  while (p <> nil) and not visited[p.n] do
  begin
    visited[p.n] := true;
    if p.typ = TNodeKind.nt then
    begin
      s := First(p.next);
      p.sym.follow.Unite(s);
      if DelGraph(p.next) then
        p.sym.nts[curSy.n] := true;
    end
    else if (p.typ = TNodeKind.opt) or (p.typ = TNodeKind.iter) then
      CompFollow(p.sub)
    else if p.typ = TNodeKind.alt then
    begin
      CompFollow(p.sub);
      CompFollow(p.down);
    end;
    p := p.next;
  end;
end;

procedure TTab.Complete(sym: TSymbol);
var
  s: TSymbol;
begin
  if not visited[sym.n] then
  begin
    visited[sym.n] := true;
    for s in nonterminals do
    begin
      if sym.nts[s.n] then
      begin
        Complete(s);
        sym.follow.Unite(s.follow);
        if sym = curSy then
          sym.nts[s.n] := false;
      end;
    end;
  end;
end;

procedure TTab.CompFollowSets;
var sym: TSymbol;
begin
  for sym in nonterminals do
  begin
    sym.follow := NewBitSet(terminals.Count);
    sym.nts := NewBitSet(nonterminals.Count);
  end;
  gramSy.follow[eofSy.n] := true;
  visited := NewBitSet(nodes.Count);
  for sym in nonterminals do
  begin
    // get direct successors of nonterminals
    curSy := sym;
    CompFollow(sym.graph);
  end;
  for sym in nonterminals do
  begin
    // add indirect successors to followers
    visited := NewBitSet(nonterminals.Count);
    curSy := sym;
    Complete(sym);
  end;
end;

function TTab.LeadingAny(p: TNode): TNode;
var
  a: TNode;
begin
  if p = nil then exit(nil);
  a := nil;
  if p.typ = TNodeKind.any then
    a := p
  else if p.typ = TNodeKind.alt then
  begin
    a := LeadingAny(p.sub);
    if a = nil then
      a := LeadingAny(p.down);
  end
  else if (p.typ = TNodeKind.opt) or (p.typ = TNodeKind.iter) then
    a := LeadingAny(p.sub);
  if (a = nil) and DelNode(p) and not p.up then
    a := LeadingAny(p.next);
  Result := a;
end;

// find ANY sets
procedure TTab.FindAS(p: TNode);
var
  a, q: TNode;
  s1, s2: TBitSet;
begin
  while p <> nil do
  begin
    if (p.typ = TNodeKind.opt) or (p.typ = TNodeKind.iter) then
    begin
      FindAS(p.sub);
      a := LeadingAny(p.sub);
      if a <> nil then
        a.sets.Differ(First(p.next));
    end
    else if p.typ = TNodeKind.alt then
    begin
      s1 := NewBitSet(terminals.Count);
      q := p;
      while q <> nil do
      begin
        FindAS(q.sub);
        a := LeadingAny(q.sub);
        if a = nil then
          s1.Unite(First(q.sub))
        else
        begin
          // q.down changed!
          s2 := First(q.down);
          s2.Unite(s1);
          a.sets.Differ(s2);
        end;
        q := q.down;
      end;
    end;

    // Remove alternative terminals before ANY, in the following
    // examples a and b must be removed from the ANY set:
    // [a] ANY, or begina|bend; ANY, or [a][b] ANY, or (a|) ANY, or
    // A = [a]. A ANY
    if DelNode(p) then
    begin
      a := LeadingAny(p.next);
      if a <> nil then
      begin
        if p.typ = TNodeKind.nt then
          q := p.sym.graph
        else
          q := p.sub;
        a.sets.Differ(First(q));
      end;
    end;
    if p.up then break;
    p := p.next;
  end;
end;

procedure TTab.CompAnySets;
var sym: TSymbol;
begin
  for sym in nonterminals do FindAS(sym.graph);
end;

function TTab.Expected(p: TNode; curSy: TSymbol): TBitSet;
var s: TBitSet;
begin
  s := First(p);
  if DelGraph(p) then s.Unite(curSy.follow);
  Result := s;
end;

function TTab.Expected0(p: TNode; curSy: TSymbol): TBitSet;
begin
  if p.typ = TNodeKind.rslv then
    Result := NewBitSet(terminals.Count)
  else
    Result := Expected(p, curSy);
end;

procedure TTab.CompSync(p: TNode);
var
  s: TBitSet;
begin
  while (p <> nil) and not visited[p.n] do
  begin
    visited[p.n] := true;
    if p.typ = TNodeKind.sync then
    begin
      s := Expected(p.next, curSy);
      s[eofSy.n] := true;
      allSyncSets.Unite(s);
      p.sets := s;
    end
    else if p.typ = TNodeKind.alt then
    begin
      CompSync(p.sub);
      CompSync(p.down);
    end
    else if (p.typ = TNodeKind.opt) or (p.typ = TNodeKind.iter) then
      CompSync(p.sub);
    p := p.next;
  end;
end;

procedure TTab.CompSyncSets;
var
  sym: TSymbol;
begin
  allSyncSets := NewBitSet(terminals.Count);
  allSyncSets[eofSy.n] := true;
  visited := NewBitSet(nodes.Count);
  for sym in nonterminals do
  begin
    curSy := sym;
    CompSync(curSy.graph);
  end;
end;

procedure TTab.SetupAnys;
var p: TNode;
begin
  for p in nodes do
    if p.typ = TNodeKind.any then
    begin
      p.sets := NewBitSet(terminals.Count, true);
      p.sets[eofSy.n] := false;
    end;
end;

procedure TTab.CompDeletableSymbols;
var
  changed: Boolean;
  sym: TSymbol;
begin
  repeat
    changed := false;
    for sym in nonterminals do
      if not sym.deletable and (sym.graph <> nil) and DelGraph(sym.graph) then
      begin
        sym.deletable := true;
        changed := true;
      end;
  until not changed;
  for sym in nonterminals do
    if sym.deletable then
      errors.Warning('  ' + sym.name + ' deletable');
end;

procedure TTab.RenumberPragmas;
var
  n: Integer;
  sym: TSymbol;
begin
  n := terminals.Count;
  for sym in pragmas do
  begin
    sym.n := n;
    Inc(n);
  end;
end;

procedure TTab.CompSymbolSets;
var
  sym: TSymbol;
  p: TNode;
begin
  CompDeletableSymbols;
  CompFirstSets;
  CompAnySets;
  CompFollowSets;
  CompSyncSets;
  if Options.ddt[1] then
  begin
    trace.WriteLine;
    trace.WriteLine('First & follow symbols:');
    trace.WriteLine('----------------------'); trace.WriteLine;
    for sym in nonterminals do
    begin
      trace.WriteLine(sym.name);
      trace.Write('first:   '); PrintSet(sym.first, 10);
      trace.Write('follow:  '); PrintSet(sym.follow, 10);
      trace.WriteLine;
    end;
  end;
  if Options.ddt[4] then
  begin
    trace.WriteLine;
    trace.WriteLine('ANY and SYNC sets:');
    trace.WriteLine('-----------------');
    for p in nodes do
      if (p.typ = TNodeKind.any) or (p.typ = TNodeKind.sync) then
      begin
        trace.Write('%4d %4s: ', [p.n, nTyp[p.typ]]);
        PrintSet(p.sets, 11);
      end;
  end;
end;

function TTab.Hex2Char(const s: string): char;
var
  val: Integer;
  p: PChar;
  ch: char;
begin
  val := 0;
  p := PChar(s);
  while p^ <> #0 do
  begin
    ch := p^; Inc(p);
    if ('0' <= ch) and (ch <= '9') then
      val := 16 * val + (Ord(ch) - Ord('0'))
    else if ('a' <= ch) and (ch <= 'f') then
      val := 16 * val + (10 + Ord(ch) - Ord('a'))
    else if ('A' <= ch) and (ch <= 'F') then
      val := 16 * val + (10 + Ord(ch) - Ord('A'))
    else
      parser.SemErr('bad escape sequence in string or character');
  end;
  if val > Ord(High(char)) then
    parser.SemErr('bad escape sequence in string or character');
  Result := char(val);
end;

function TTab.Unescape(const s: string): string;
var
  r: string;
  i: Integer;
begin
  r := '';
  i := 1;
  while i <= s.Length do
  begin
    if s[i] = '\' then
    begin
      case s[i + 1] of
        '\':  begin r := r + '\'; Inc(i, 2); end;
        '''': begin r := r + ''''; Inc(i, 2); end;
        '"':  begin r := r + '"'; Inc(i, 2); end;
        'r':  begin r := r + #13; Inc(i, 2); end;
        'n':  begin r := r + #10; Inc(i, 2); end;
        't':  begin r := r + #9; Inc(i, 2); end;
        '0':  begin r := r + #0; Inc(i, 2); end;
        'a':  begin r := r + '\a'; Inc(i, 2); end;
        'b':  begin r := r + '\b'; Inc(i, 2); end;
        'f':  begin r := r + '\f'; Inc(i, 2); end;
        'v':  begin r := r + '\v'; Inc(i, 2); end;
        'u', 'x':
          if (i + 5 <= s.Length) then
          begin
            r := r + (Hex2Char(s.Substring(i + 1, 4)));
            Inc(i, 6);
          end
          else
          begin
            parser.SemErr('bad escape sequence in string or character');
            i := s.Length;
          end;
        else
        begin
          parser.SemErr('bad escape sequence in string or character');
          Inc(i, 2);
        end;
      end;
    end
    else
    begin
      r := r + s[i];
      Inc(i);
    end;
  end;
  Result := r;
end;

function TTab.Escape(const s: string): string;
var
  r: string;
  ch: char;
  printable: Boolean;
begin
  r := '';
  printable := false;
  for ch in s do
  begin
    if Between(ch, ' ', Char(127)) then
    begin
      if not printable then
        r := r + '''';
      if ch = '''' then
        r := r + ''''
      else
        r := r + ch;
      printable := true;
    end
    else
    begin
      if printable then
        r := r + '''';
      r := r + Format('#%d', [Ord(ch)]);
      printable := false;
    end;
  end;
  if printable then
    r := r + '''';
  Result := r;
end;

function TTab.NewName(const name, definition: string): TNameDecl;
begin
  if FNames.TryGetValue(name, Result) then
  begin
    parser.SemErr('Name declared twice');
    exit;
  end;
  Result := TNameDecl.Create;
  Result.name := name;
  Result.definition := definition;
  FNames.Add(name, Result);
end;

procedure TTab.UpdateScannerAndParserTypes;
begin
  NewMacro('scanner', GetScannerType);
  NewMacro('parser', GetParserType);
end;

function TTab.NewMacro(const name, stuff: string): TMacroDef;
begin
  if FMacros.TryGetValue(name, Result) then
  begin
    parser.SemErr('Macro declared twice');
    exit;
  end;
  Result := TMacroDef.Create;
  Result.name := name;
  Result.stuff := stuff;
  FMacros.Add(name, Result);
end;

function TTab.EvalMacros(s: string): string;
var
  m: TMacroDef;
begin
  for m in FMacros.Values do
    s := StringReplace(s, '-->' + m.name + '<', m.stuff, [rfReplaceAll]);
  Result := s;
end;

function TTab.GetPrefix: string;
var
  m: TMacroDef;
begin
  if not FMacros.TryGetValue('prefix', m) then
    m := NewMacro('prefix', gramSy.name);
  Result := m.stuff;
end;

function TTab.GetScannerType: string;
begin
  Result := 'T' + GetPrefix + 'Scanner';
end;

function TTab.GetParserType: string;
begin
  Result := 'T' + GetPrefix + 'Parser';
end;

function TTab.GrammarOk: Boolean;
begin
  Result := NtsComplete
    and AllNtReached
    and NoCircularProductions
    and AllNtToTerm;
  if Result then
  begin
    CheckResolvers;
    CheckLL1;
  end;
end;

// check for circular productions
type
  // node of list for finding circular productions
  TCNode = class
    left, right: TSymbol;
    constructor Create(l, r: TSymbol);
  end;

constructor TCNode.Create(l, r: TSymbol);
begin
  left := l;
  right := r;
end;

procedure TTab.GetSingles(p: TNode; singles: TList<TSymbol>);
begin
  if p = nil then exit;  // end of graph
  if (p.typ = TNodeKind.nt) then
  begin
    if p.up or DelGraph(p.next) then
      singles.Add(p.sym);
  end
  else if (p.typ = TNodeKind.alt) or (p.typ = TNodeKind.iter) or (p.typ = TNodeKind.opt) then
  begin
    if p.up or DelGraph(p.next) then
    begin
      GetSingles(p.sub, singles);
      if p.typ = TNodeKind.alt then
        GetSingles(p.down, singles);
    end;
  end;
  if not p.up and DelNode(p) then
    GetSingles(p.next, singles);
end;

function TTab.NoCircularProductions: Boolean;
var
  ok, changed, onLeftSide, onRightSide: Boolean;
  list: TOwnedList<TCNode>;
  singles: TList<TSymbol>;
  sym, s: TSymbol;
  i: Integer;
  n, m: TCNode;
begin
  list := TOwnedList<TCNode>.Create;
  try
    for sym in nonterminals do
    begin
      singles := TList<TSymbol>.Create;
      try
        GetSingles(sym.graph, singles); // get nonterminals s such that sym-->s
        for s in singles do
          list.Add(TCNode.Create(sym, s));
      finally
        singles.Free;
      end;
    end;
    repeat
      changed := false; i := 0;
      while i < list.Count do
      begin
        n := list[i];
        onLeftSide := false; onRightSide := false;
        for m in list do
        begin
          if n.left = m.right then onRightSide := true;
          if n.right = m.left then onLeftSide := true;
        end;
        if not onLeftSide or not onRightSide then
        begin
          list.Remove(n);
          Dec(i); changed := true;
        end;
        Inc(i);
      end;
    until not changed;
    ok := true;
    for n in list do
    begin
      ok := false;
      errors.SemErr('  ' + n.left.name + ' --> ' + n.right.name);
    end;
    Result := ok;
  finally
    list.Free;
  end;
end;

// check for LL(1) errors

procedure TTab.LL1Error(cond: Integer; sym: TSymbol);
var
  s: string;
begin
  s := '  LL1 warning in ' + curSy.name + ': ';
  if sym <> nil then
    s := s + sym.name + ' is ';
  case cond of
    1: s := s + 'start of several alternatives';
    2: s := s + 'start & successor of deletable structure';
    3: s := s + 'an ANY node that matches no symbol';
    4: s := s + 'contents of [...] or begin...end; must not be deletable';
  end;
  errors.Warning(s);
end;

procedure TTab.CheckOverlap(s1, s2: TBitSet; cond: Integer);
var sym: TSymbol;
begin
  for sym in terminals do
    if s1[sym.n] and s2[sym.n] then
      LL1Error(cond, sym);
end;

procedure TTab.CheckAlts(p: TNode);
var
  s1, s2: TBitSet;
  q: TNode;
begin
  while p <> nil do
  begin
    if p.typ = TNodeKind.alt then
    begin
      q := p;
      s1 := NewBitSet(terminals.Count);
      while q <> nil do
      begin
        // for all alternatives
        s2 := Expected0(q.sub, curSy);
        CheckOverlap(s1, s2, 1);
        s1.Unite(s2);
        CheckAlts(q.sub);
        q := q.down;
      end;
    end
    else if (p.typ = TNodeKind.opt) or (p.typ = TNodeKind.iter) then
    begin
      if DelSubGraph(p.sub) then
        LL1Error(4, nil) // e.g. [[...]]
      else
      begin
        s1 := Expected0(p.sub, curSy);
        s2 := Expected(p.next, curSy);
        CheckOverlap(s1, s2, 2);
      end;
      CheckAlts(p.sub);
    end
    else if p.typ = TNodeKind.any then
    begin
      if p.sets.Elements = 0 then
        LL1Error(3, nil);
      // e.g. beginANYend; ANY or [ANY] ANY or ( ANY | ANY )
    end;
    if p.up then break;
    p := p.next;
  end;
end;

procedure TTab.CheckLL1;
var sym: TSymbol;
begin
  for sym in nonterminals do
  begin
    curSy := sym;
    CheckAlts(curSy.graph);
  end;
end;

//------------- check if resolvers are legal  --------------------

procedure TTab.ResErr(p: TNode; const s: string);
begin
  errors.Warning(s, p.line, p.pos.col);
end;

procedure TTab.CheckRes(p: TNode; rslvAllowed: Boolean);
var
  ex: TBitSet;
  q: TNode;
  soFar, fs, fsNext: TBitSet;
begin
  while p <> nil do
  begin
    case p.typ of
      TNodeKind.alt:
      begin
        ex := NewBitSet(terminals.Count);
        q := p;
        while q <> nil do
        begin
          ex.Unite(Expected0(q.sub, curSy));
          q := q.down;
        end;
        soFar := NewBitSet(terminals.Count);
        q := p;
        while q <> nil do
        begin
          if q.sub.typ = TNodeKind.rslv then
          begin
            fs := Expected(q.sub.next, curSy);
            if fs.Intersects(soFar) then
              ResErr(q.sub, 'Warning: Resolver will never be evaluated. ' +
              'Place it at previous conflicting alternative.');
            if not fs.Intersects(ex) then
              ResErr(q.sub, 'Warning: Misplaced resolver: no LL(1) conflict.');
          end
          else
            soFar.Unite(Expected(q.sub, curSy));
          CheckRes(q.sub, true);
          q := q.down;
        end;
      end;
      TNodeKind.iter, TNodeKind.opt:
      begin
        if p.sub.typ = TNodeKind.rslv then
        begin
          fs := First(p.sub.next);
          fsNext := Expected(p.next, curSy);
          if not fs.Intersects(fsNext) then
            ResErr(p.sub, 'Warning: Misplaced resolver: no LL(1) conflict.');
        end;
        CheckRes(p.sub, true);
      end;
      TNodeKind.rslv:
      begin
        if not rslvAllowed then
          ResErr(p, 'Warning: Misplaced resolver: no alternative.');
      end;
    end;
    if p.up then break;
    p := p.next;
    rslvAllowed := false;
  end;
end;

procedure TTab.CheckResolvers;
var sym: TSymbol;
begin
  for sym in nonterminals do
  begin
    curSy := sym;
    CheckRes(curSy.graph, false);
  end;
end;

//------------- check if every nts has a production --------------------

function TTab.NtsComplete: Boolean;
var
  complete: Boolean;
  sym: TSymbol;
begin
  complete := true;
  for sym in nonterminals do
  begin
    if sym.graph = nil then
    begin
      complete := false;
      errors.SemErr('  No production for ' + sym.name);
    end;
  end;
  Result := complete;
end;

//-------------- check if every nts can be reached  -----------------

procedure TTab.MarkReachedNts(p: TNode);
begin
  while p <> nil do
  begin
    if (p.typ = TNodeKind.nt) and not visited[p.sym.n] then
    begin
      // new nt reached
      visited[p.sym.n] := true;
      MarkReachedNts(p.sym.graph);
    end
    else if (p.typ = TNodeKind.alt) or (p.typ = TNodeKind.iter) or (p.typ = TNodeKind.opt) then
    begin
      MarkReachedNts(p.sub);
      if p.typ = TNodeKind.alt then
        MarkReachedNts(p.down);
    end;
    if p.up then
      break;
    p := p.next;
  end;
end;

function TTab.AllNtReached: Boolean;
var
  ok: Boolean;
  sym: TSymbol;
begin
  ok := true;
  visited := NewBitSet(nonterminals.Count);
  visited[gramSy.n] := true;
  MarkReachedNts(gramSy.graph);
  for sym in nonterminals do
  begin
    if not visited[sym.n] then
    begin
      ok := false;
      errors.Warning('  ' + sym.name + ' cannot be reached');
    end;
  end;
  Result := ok;
end;

function TTab.IsTerm(p: TNode; mark: TBitSet): Boolean;
begin
  // true if graph can be derived to terminals
  while p <> nil do
  begin
    if (p.typ = TNodeKind.nt) and not mark[p.sym.n] then exit(false);
    if (p.typ = TNodeKind.alt) and not IsTerm(p.sub, mark) and
       ((p.down = nil) or not IsTerm(p.down, mark)) then exit(false);
    if p.up then break;
    p := p.next;
  end;
  Result := true;
end;

function TTab.AllNtToTerm: Boolean;
var
  changed, ok: Boolean;
  mark: TBitSet;
  sym: TSymbol;
begin
  ok := true;
  mark := NewBitSet(nonterminals.Count);
  // a nonterminal is marked if it can be derived to terminal symbols
  repeat
    changed := false;
    for sym in nonterminals do
      if (not mark[sym.n] and IsTerm(sym.graph, mark)) then
      begin
        mark[sym.n] := true;
        changed := true;
      end;
  until not changed;
  for sym in nonterminals do
    if not mark[sym.n] then
    begin
      ok := false;
      errors.SemErr('  ' + sym.name + ' cannot be derived to terminals');
    end;
  Result := ok;
end;

//  Cross reference list

procedure TTab.XRef;
type
  TxrefPair = TPair<TSymbol, TList<Integer>>;
var
  xref: TOwnedDictionary<TSymbol, TList<Integer>>;
  sym: TSymbol;
  list: TList<Integer>;
  n: TNode;
  pair: TxrefPair;
  pairs: TArray<TxrefPair>;
  Comparer: IComparer<TxrefPair>;
  col, line: Integer;
begin
  xref := TOwnedDictionary<TSymbol, TList<Integer>>.Create;
  try
    // collect lines where symbols have been defined
    for sym in nonterminals do
    begin
      if not xref.TryGetValue(sym, list) then
      begin
        list := TList<Integer>.Create;
        xref.Add(sym, list);
      end;
      list.Add(-sym.line);
    end;
    // collect lines where symbols have been referenced
    for n in nodes do
    begin
      if (n.typ = TNodeKind.t) or (n.typ = TNodeKind.wt) or (n.typ = TNodeKind.nt) then
      begin
        if not xref.TryGetValue(n.sym, list) then
        begin
          list := TList<Integer>.Create;
          xref.Add(n.sym, list);
        end;
        list.Add(n.line);
      end;
    end;
    pairs := xref.ToArray;
    Comparer := TDelegatedComparer<TxrefPair>.Create(
      function(const a, b: TxrefPair): Integer
      begin
        Result := CompareText(a.Key.name, b.Key.name);
      end);
    TArray.Sort<TxrefPair>(pairs, Comparer);
    // print cross reference list
    trace.WriteLine;
    trace.WriteLine('Cross reference list:');
    trace.WriteLine('--------------------'); trace.WriteLine;
    for pair in pairs do
    begin
      trace.Write('  %12s', [AsName(pair.Key.name)]);
      col := 14;
      for line in pair.Value do
      begin
        if col + 5 > 80 then
        begin
          trace.WriteLine;
          col := 1;
          while col <= 14 do
          begin
            trace.Write(' ');
            Inc(col);
          end;
        end;
        trace.Write('%5d', [line]); Inc(col, 5);
      end;
      trace.WriteLine;
    end;
    trace.WriteLine; trace.WriteLine;
  finally
    xref.Free;
  end;
end;

{$EndRegion}

end.

