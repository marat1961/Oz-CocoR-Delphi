
unit Oz.Cocor.Parser;

interface

uses
  System.Classes, System.SysUtils, System.Character, System.IOUtils,
  Oz.Cocor.Utils, Oz.Cocor.Lib, Oz.Cocor.Options, Oz.Cocor.Scanner,
  Oz.Cocor.Tab, Oz.Cocor.DFA, Oz.Cocor.ParserGen;

type

{$Region 'TcrParser'}

  TcrParser= class(TBaseParser)
  const
    id = 0;
    str = 1;
    _EOFSym = 0;
    _identSym = 1;
    _numberSym = 2;
    _stringSym = 3;
    _charSym = 4;
    _ddtSym = 44;
    _optionSym = 45;
  private
    FTraceStream: TMemoryStream;
    genScanner: Boolean;
    procedure _Coco;
    procedure _MacroDecl;
    procedure _SetDecl;
    procedure _TokenDecl(typ: TNodeKind);
    procedure _NameDecl;
    procedure _TokenExpr(var g: TGraph);
    procedure _Set(var s: TCharSet);
    procedure _AttrDecl(sym: TSymbol);
    procedure _SemText(var pos: TPosition);
    procedure _Expression(var g: TGraph);
    procedure _SimSet(var s: TCharSet);
    procedure _Char(var n: Integer);
    procedure _Sym_(var name: string; var kind: Integer);
    procedure _Term(var g: TGraph);
    procedure _Resolver(var pos: TPosition);
    procedure _Factor(var g: TGraph);
    procedure _Attribs(p: TNode);
    procedure _Condition;
    procedure _TokenTerm(var g: TGraph);
    procedure _TokenFactor(var g: TGraph);
  protected
    function Starts(s, kind: Integer): Boolean; override;
    procedure Get; override;
  public
    // other Coco objects that refer to these variables
    options: TOptions;
    trace: TStreamWriter;
    tab: TTab;
    dfa: TDFA;
    pgen: TParserGen;
    tokenString: string;
  public
    constructor Create(scanner: TBaseScanner; listing: TStrings);
    destructor Destroy; override;
    function ErrorMsg(nr: Integer): string; override;
    procedure Parse; override;
    procedure SaveTraceToFile(const fileName: string);
  end;

{$EndRegion}

{$Region 'TCocoPartHelper'}

  TCocoPartHelper = class helper for TCocoPart
  private
    function GetParser: TcrParser;
    function GetScanner: TcrScanner;
    function GetOptions: TOptions;
    function GetTab: TTab;
    function GetDfa: TDFA;
    function GetPgen: TParserGen;
    function GetTrace: TTextWriter;
    function GetErrors: TErrors;
  public
    property parser: TcrParser read GetParser;
    property scanner: TcrScanner read GetScanner;
    property options: TOptions read GetOptions;
    property tab: TTab read GetTab;
    property dfs: TDFA read GetDFA;
    property pgen: TParserGen read GetPgen;
    property trace: TTextWriter read GetTrace;
    property errors: TErrors read GetErrors;
 end;

{$EndRegion}

implementation

{$Region 'TcrParser'}

constructor TcrParser.Create(scanner: TBaseScanner; listing: TStrings);
begin
  inherited Create(scanner, listing);
  options := GetOptions;
  FTraceStream := TMemoryStream.Create;
  trace := TStreamWriter.Create(FTraceStream);
  tab := TTab.Create(Self);
  dfa := TDFA.Create(Self);
  pgen := TParserGen.Create(Self, scanner.buffer);
end;

destructor TcrParser.Destroy;
begin
  trace.Free;
  tab.Free;
  dfa.Free;
  pgen.Free;
  FTraceStream.Free;
  inherited;
end;

procedure TcrParser.SaveTraceToFile(const fileName: string);
begin
  FTraceStream.Position := 0;
  FTraceStream.SaveToFile(fileName);
  trace.Close;
end;

procedure TcrParser.Get;
begin
  repeat
    t := la;
    la := scanner.Scan;
    if la.kind <= scanner.MaxToken then
    begin
      Inc(errDist);
      break;
    end;
    if la.kind = 44 then
      Options.SetDDT(la.val);
    if la.kind = 45 then
      Options.SetOption(la.val);
    la := t;
  until False;
end;

procedure TcrParser._Coco;
var
  sym: TSymbol;
  g, g1, g2: TGraph;
  gramName: string;
  s: TCharSet;
  nested, undef, noAttrs: Boolean;
begin
  if StartOf(1) then
  begin
    Get;
    pgen.importPos.Start(t);
    while StartOf(1) do
    begin
      Get;
    end;
    pgen.importPos.Update(la, 0);
  end;
  Expect(5);
  genScanner := true;
  tab.ignored := tab.NewCharSet;
  Expect(1);
  gramName := t.val;
  tab.semDeclPos.Start(la);
  while StartOf(2) do
  begin
    Get;
  end;
  tab.semDeclPos.Update(la, 0);
  if la.kind = 6 then
  begin
    Get;
    dfa.ignoreCase := true;
  end;
  if la.kind = 7 then
  begin
    Get;
    while la.kind = 1 do
    begin
      _MacroDecl;
    end;
  end;
  if la.kind = 8 then
  begin
    Get;
    while la.kind = 1 do
    begin
      _SetDecl;
    end;
  end;
  if la.kind = 9 then
  begin
    Get;
    while (la.kind = 1) or (la.kind = 3) or (la.kind = 4) do
    begin
      _TokenDecl(TNodeKind.t);
    end;
  end;
  if la.kind = 10 then
  begin
    Get;
    while la.kind = 1 do
    begin
      _NameDecl;
    end;
  end;
  if la.kind = 11 then
  begin
    Get;
    while (la.kind = 1) or (la.kind = 3) or (la.kind = 4) do
    begin
      _TokenDecl(TNodeKind.pr);
    end;
  end;
  while la.kind = 12 do
  begin
    Get;
    nested := false;
    Expect(13);
    _TokenExpr(g1);
    Expect(14);
    _TokenExpr(g2);
    if la.kind = 15 then
    begin
      Get;
      nested := true;
    end;
    dfa.NewComment(g1.l, g2.l, nested);
  end;
  while la.kind = 16 do
  begin
    Get;
    _Set(s);
    tab.ignored.Unite(s);
  end;
  while not ((la.kind = 0) or (la.kind = 17)) do
  begin
    SynErr(44); Get;
  end;
  Expect(17);
  if genScanner then
    dfa.MakeDeterministic;
  tab.DeleteNodes;
  while la.kind = 1 do
  begin
    Get;
    sym := tab.FindSym(t.val);
    undef := sym = nil;
    if undef then
      sym := tab.NewSym(TNodeKind.nt, t.val, t.line)
    else
    begin
      if sym.typ = TNodeKind.nt then
      begin
        if sym.graph <> nil then
          SemErr('name declared twice');
      end
      else
        SemErr('this symbol kind not allowed on left side of production');
      sym.line := t.line;
    end;
    noAttrs := sym.attrPos.Empty;
    sym.attrPos.SetEmpty;
    if (la.kind = 28) or (la.kind = 30) then
    begin
      _AttrDecl(sym);
    end;
    if not undef then
      if noAttrs <> sym.attrPos.Empty then
        SemErr('attribute mismatch between declaration and use of this symbol');
    if la.kind = 41 then
    begin
      _SemText(sym.semPos);
    end;
    ExpectWeak(18, 3);
    _Expression(g);
    sym.graph := g.l;
    tab.Finish(g);
    ExpectWeak(19, 4);
  end;
  Expect(20);
  Expect(1);
  if gramName <> t.val then
    SemErr('name does not match grammar name');
  tab.gramSy := tab.FindSym(gramName);
  if tab.gramSy = nil then
    SemErr('missing production for grammar name')
  else
  begin
    sym := tab.gramSy;
    if not sym.attrPos.Empty then
      SemErr('grammar symbol must not have attributes');
  end;
  tab.noSym := tab.NewSym(TNodeKind.t, '???', 0); // noSym gets highest number
  tab.SetupAnys;
  tab.RenumberPragmas;
  if Options.ddt[2] then tab.PrintNodes;
  if errors.count = 0 then
  begin
    Writeln('checking');
    tab.CompSymbolSets;
    if Options.ddt[7] then tab.XRef;
    if tab.GrammarOk then
    begin
      Write('parser');
      pgen.WriteParser;
      if genScanner then
      begin
        Write(' + scanner');
        dfa.WriteScanner;
        if Options.ddt[0] then
          dfa.PrintStates;
      end;
      Writeln(' generated');
      if Options.ddt[8] then pgen.WriteStatistics;
    end;
  end;
  if Options.ddt[6] then tab.PrintSymbolTable;
  Expect(19);
end;

procedure TcrParser._MacroDecl;
var name, s: string;
begin
  Expect(1);
  name := t.val;
  Expect(18);
  Expect(3);
  s := tab.Unescape(t.val.Substring(1, t.val.Length - 2));
  tab.NewMacro(name, s);
  Expect(19);
end;

procedure TcrParser._SetDecl;
var s: TCharSet; name: string; c: TCharClass;
begin
  Expect(1);
  name := t.val;
  c := tab.FindCharClass(name);
  if c <> nil then SemErr('name declared twice');
  Expect(18);
  _Set(s);
  if s.Elements = 0 then SemErr('character set must not be empty');
    tab.NewCharClass(name, s);
  Expect(19);
end;

procedure TcrParser._TokenDecl(typ: TNodeKind);
var name: string; kind: Integer; sym: TSymbol; g: TGraph;
begin
  _Sym_(name, kind);
  sym := tab.FindSym(name);
  if sym <> nil then
    SemErr('name declared twice')
  else
  begin
    sym := tab.NewSym(typ, name, t.line);
    sym.tokenKind := TTokenKind.fixedToken;
  end;
  tokenString := '';
  while not (StartOf(5)) do
  begin
    SynErr(45); Get;
  end;
  if la.kind = 18 then
  begin
    Get;
    _TokenExpr(g);
    Expect(19);
    if kind = str then
      SemErr('a literal must not be declared with a structure');
    tab.Finish(g);
    if (tokenString = '') or tokenString.Equals(noString) then
      dfa.ConvertToStates(g.l, sym)
    else
    begin
      // TokenExpr is a single string
      if tab.literals.ContainsKey(tokenString) then
        SemErr('token string declared twice');
      tab.literals.Add(tokenString, sym);
      dfa.MatchLiteral(tokenString, sym);
    end;
  end
  else if StartOf(6) then
  begin
    if kind = id then
      genScanner := false
    else
      dfa.MatchLiteral(sym.name, sym);
  end
  else
    SynErr(46);
  if la.kind = 41 then
  begin
    _SemText(sym.semPos);
    if typ <> TNodeKind.pr then
      SemErr('semantic action not allowed here');
  end;
end;

procedure TcrParser._NameDecl;
var name, s: string;
begin
  Expect(1);
  name := t.val;
  Expect(18);
  if la.kind = 1 then
  begin
    Get;
    s := t.val;
  end
  else if la.kind = 3 then
  begin
    Get;
    s := t.val;
    Dfa.FixString(s);
  end
  else
    SynErr(47);
  tab.NewName(name, s);
  Expect(19);
end;

procedure TcrParser._TokenExpr(var g: TGraph);
var g2: TGraph; first: Boolean;
begin
  _TokenTerm(g);
  first := true;
  while WeakSeparator(32, 7, 8) do
  begin
    _TokenTerm(g2);
    if first then
    begin
      tab.MakeFirstAlt(g);
      first := false;
    end;
    tab.MakeAlternative(g, g2);
  end;
end;

procedure TcrParser._Set(var s: TCharSet);
var s2: TCharSet;
begin
  _SimSet(s);
  while (la.kind = 21) or (la.kind = 22) do
  begin
    if la.kind = 21 then
    begin
      Get;
      _SimSet(s2);
      s.Unite(s2);
    end
    else
    begin
      Get;
      _SimSet(s2);
      s := tab.Subtract(s, s2);
    end;
  end;
end;

procedure TcrParser._AttrDecl(sym: TSymbol);
begin
  if la.kind = 28 then
  begin
    Get;
    sym.attrPos.Start(la);
    while StartOf(9) do
    begin
      Get;
    end;
    Expect(29);
    if t.pos > sym.attrPos.beg then
      sym.attrPos.Update(t, 0);
  end
  else if la.kind = 30 then
  begin
    Get;
    sym.attrPos.Start(la);
    while StartOf(10) do
    begin
      Get;
    end;
    Expect(31);
    if t.pos > sym.attrPos.beg then
      sym.attrPos.Update(t, 0);
  end
  else
    SynErr(48);
end;

procedure TcrParser._SemText(var pos: TPosition);
begin
  SkipCommentsOn;
  Expect(41);
  pos.Start(la);
  while StartOf(11) do
  begin
    if StartOf(12) then
    begin
      Get;
    end
    else
    begin
      Get;
      SemErr('missing end of previous semantic action');
    end;
  end;
  Expect(42);
  pos.Update(t); SkipCommentsOff;
end;

procedure TcrParser._Expression(var g: TGraph);
var g2: TGraph; first: Boolean;
begin
  _Term(g);
  first := true;
  while WeakSeparator(32, 13, 14) do
  begin
    _Term(g2);
    if first then
    begin
      tab.MakeFirstAlt(g);
      first := false;
    end;
    tab.MakeAlternative(g, g2);
  end;
end;

procedure TcrParser._SimSet(var s: TCharSet);
var n1, n2, i: Integer; c: TCharClass; name: string; ch: Char;
begin
  s := tab.NewCharSet;
  if la.kind = 1 then
  begin
    Get;
    c := tab.FindCharClass(t.val);
    if c = nil then
      SemErr('undefined name')
    else
      s.Unite(c.cset);
  end
  else if la.kind = 3 then
  begin
    Get;
    name := t.val;
    name := tab.Unescape(name.Substring(1, name.Length - 2));
    for ch in name do
      if dfa.ignoreCase then
        s.Incl(ch.ToLower)
      else
        s.Incl(ch);
  end
  else if (la.kind = 4) or (la.kind = 25) then
  begin
    _Char(n1);
    s.Incl(n1);
    if la.kind = 23 then
    begin
      Get;
      _Char(n2);
      for i := n1 to n2 do s.Incl(i);
    end;
  end
  else if la.kind = 24 then
  begin
    Get;
    s := tab.NewCharSet; s.Fill;
  end
  else
    SynErr(49);
end;

procedure TcrParser._Char(var n: Integer);
const
  msg = 'unacceptable character value';
var
  s: string;
  i: Integer;
begin
  if la.kind = 25 then
  begin
    Get;
    Expect(26);
    Expect(2);
    s := t.val;
    Val(s, n, i);
    IF n > 65535 then
    begin
      SemErr(msg);
      n := n MOD 65535;
    end;
    Expect(27);
  end
  else if la.kind = 4 then
  begin
    Get;
    s := t.val; n := 0;
    s := tab.Unescape(s.Substring(1, s.Length - 2));
    if s.Length = 1 then
      n := Ord(s[1])
    else
      SemErr(msg);
  end
  else
    SynErr(50);
  if dfa.ignoreCase and Between(char(n), 'A', 'Z') then
    Inc(n, 32);
end;

procedure TcrParser._Sym_(var name: string; var kind: Integer);
begin
  name := '???'; kind := id;
  if la.kind = 1 then
  begin
    Get;
    kind := id; name := t.val;
  end
  else if (la.kind = 3) or (la.kind = 4) then
  begin
    if la.kind = 3 then
    begin
      Get;
      name := t.val;
    end
    else
    begin
      Get;
      name := '''' + t.val.Substring(1, t.val.Length - 2) + '''';
    end;
    kind := str;
    if dfa.ignoreCase then name := name.ToLower;
    if name.IndexOf(' ') >= 0 then
      SemErr('literal tokens must not contain blanks');
  end
  else
    SynErr(51);
end;

procedure TcrParser._Term(var g: TGraph);
var g2: TGraph; rslv: TNode;
begin
  rslv := nil; g := nil;
  if StartOf(15) then
  begin
    if la.kind = 39 then
    begin
      rslv := tab.NewNode(TNodeKind.rslv, nil, la.line);
      _Resolver(rslv.pos);
      g := tab.NewGraph(rslv);
    end;
    _Factor(g2);
    if rslv <> nil then
      tab.MakeSequence(g, g2)
    else
      g := g2;
    while StartOf(16) do
    begin
      _Factor(g2);
      tab.MakeSequence(g, g2);
    end;
  end
  else if StartOf(17) then
  begin
    g := tab.NewGraph(tab.NewNode(TNodeKind.eps, nil, 0));
  end
  else
    SynErr(52);
  if g = nil then
    // invalid start of Term
    g := tab.NewGraph(tab.NewNode(TNodeKind.eps, nil, 0));
end;

procedure TcrParser._Resolver(var pos: TPosition);
begin
  Expect(39);
  Expect(26);
  pos.Start(la);
  _Condition;
  pos.Update(t);
end;

procedure TcrParser._Factor(var g: TGraph);
var
  name: string; kind: Integer; typ: TNodeKind;
  weak, undef: Boolean; sym: TSymbol; p: TNode;
begin
  weak := false; g := nil;
  case la.kind of
    1, 3, 4, 33:
    begin
      if la.kind = 33 then
      begin
        Get;
        weak := true;
      end;
      _Sym_(name, kind);
      sym := tab.FindSym(name);
      if (sym = nil) and (kind = str) then
        tab.literals.TryGetValue(name, sym);
      undef := sym = nil;
      if undef then
      begin
        if kind = id then
          // forward nt
          sym := tab.NewSym(TNodeKind.nt, name, 0)
       else if genScanner then
       begin
         sym := tab.NewSym(TNodeKind.t, name, t.line);
         dfa.MatchLiteral(sym.name, sym);
       end
       else
       begin
         // undefined string in production
         SemErr('undefined string in production');
         sym := tab.eofSy;  // dummy
       end;
      end;
      typ := sym.typ;
      if (typ <> TNodeKind.t) and (typ <> TNodeKind.nt) then
        SemErr('this symbol kind is not allowed in a production');
      if weak then
        if typ = TNodeKind.t then
          typ := TNodeKind.wt
        else
          SemErr('only terminals may be weak');
      p := tab.NewNode(typ, sym, t.line);
      g := tab.NewGraph(p);
      if (la.kind = 28) or (la.kind = 30) then
      begin
        _Attribs(p);
        if kind <> id then
          SemErr('a literal must not have attributes');
      end;
      if undef then
        // dummy
        sym.attrPos := p.pos
      else if p.pos.Empty <> sym.attrPos.Empty then
        SemErr('attribute mismatch between declaration and use of this symbol');
    end;
    26:
    begin
      Get;
      _Expression(g);
      Expect(27);
    end;
    34:
    begin
      Get;
      _Expression(g);
      Expect(35);
      tab.MakeOption(g);
    end;
    36:
    begin
      Get;
      _Expression(g);
      Expect(37);
      tab.MakeIteration(g);
    end;
    41:
    begin
      p := tab.NewNode(TNodeKind.sem, nil, 0);
      _SemText(p.pos);
      g := tab.NewGraph(p);
    end;
    24:
    begin
      Get;
      p := tab.NewNode(TNodeKind.any, nil, 0);  // p.set is set in tab.SetupAnys
      g := tab.NewGraph(p);
    end;
    38:
    begin
      Get;
      p := tab.NewNode(TNodeKind.sync, nil, 0);
      g := tab.NewGraph(p);
    end;
    else
      SynErr(53);
  end;
  if g = nil then
    // invalid start of Factor
    g := tab.NewGraph(tab.NewNode(TNodeKind.eps, nil, 0));
end;

procedure TcrParser._Attribs(p: TNode);
begin
  if la.kind = 28 then
  begin
    Get;
    p.pos.Start(la);
    while StartOf(9) do
    begin
      Get;
    end;
    Expect(29);
    if t.pos > p.pos.beg then
      p.pos.Update(t);
  end
  else if la.kind = 30 then
  begin
    Get;
    p.pos.Start(la);
    while StartOf(10) do
    begin
      Get;
    end;
    Expect(31);
    if t.pos > p.pos.beg then
      p.pos.Update(t);
  end
  else
    SynErr(54);
end;

procedure TcrParser._Condition;
begin
  while StartOf(18) do
  begin
    if la.kind = 26 then
    begin
      Get;
      _Condition;
    end
    else
    begin
      Get;
    end;
  end;
  Expect(27);
end;

procedure TcrParser._TokenTerm(var g: TGraph);
var g2: TGraph;
begin
  _TokenFactor(g);
  while StartOf(7) do
  begin
    _TokenFactor(g2);
    tab.MakeSequence(g, g2);
  end;
  if la.kind = 40 then
  begin
    Get;
    Expect(26);
    _TokenExpr(g2);
    tab.SetContextTrans(g2.l); dfa.hasCtxMoves := true;
    tab.MakeSequence(g, g2);
    Expect(27);
  end;
end;

procedure TcrParser._TokenFactor(var g: TGraph);
var name: string; kind: Integer; c: TCharClass; p: TNode;
begin
  g := nil;
  if (la.kind = 1) or (la.kind = 3) or (la.kind = 4) then
  begin
    _Sym_(name, kind);
    if kind = id then
    begin
      c := tab.FindCharClass(name);
      if c = nil then
      begin
        SemErr('undefined name');
        c := tab.NewCharClass(name, tab.NewCharSet);
      end;
      p := tab.NewNode(TNodeKind.clas, nil, 0); p.val := c.n;
      g := tab.NewGraph(p);
      tokenString := noString;
    end
    else
    begin
      // str
      g := tab.StrToGraph(name);
      if tokenString = '' then
        tokenString := name
      else
        tokenString := noString;
    end;
  end
  else if la.kind = 26 then
  begin
    Get;
    _TokenExpr(g);
    Expect(27);
  end
  else if la.kind = 34 then
  begin
    Get;
    _TokenExpr(g);
    Expect(35);
    tab.MakeOption(g); tokenString := noString;
  end
  else if la.kind = 36 then
  begin
    Get;
    _TokenExpr(g);
    Expect(37);
    tab.MakeIteration(g); tokenString := noString;
  end
  else
    SynErr(55);
  if g = nil then
    // invalid start of TokenFactor
    g := tab.NewGraph(tab.NewNode(TNodeKind.eps, nil, 0));
end;

procedure TcrParser.Parse;
begin
  la := scanner.NewToken;
  la.val := '';
  Get;
  _Coco;
  Expect(0);
end;

function TcrParser.Starts(s, kind: Integer): Boolean;
const
  x = false;
  T = true;
  sets: array [0..18] of array [0..44] of Boolean = (
    (T,T,x,T, T,x,x,x, x,x,T,T, T,x,x,x, T,T,T,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,T,x,x, x),
    (x,T,T,T, T,x,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, x),
    (x,T,T,T, T,T,x,x, x,x,x,x, x,T,T,T, x,x,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, x),
    (T,T,x,T, T,x,x,x, x,x,T,T, T,x,x,x, T,T,T,T, x,x,x,x, T,x,T,x, x,x,x,x, T,T,T,x, T,x,T,T, x,T,x,x, x),
    (T,T,x,T, T,x,x,x, x,x,T,T, T,x,x,x, T,T,T,x, T,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,T,x,x, x),
    (T,T,x,T, T,x,x,x, x,x,T,T, T,x,x,x, T,T,T,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,T,x,x, x),
    (x,T,x,T, T,x,x,x, x,x,T,T, T,x,x,x, T,T,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,T,x,x, x),
    (x,T,x,T, T,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,T,x, x,x,x,x, x,x,T,x, T,x,x,x, x,x,x,x, x),
    (x,x,x,x, x,x,x,x, x,x,x,x, T,x,T,T, T,T,x,T, x,x,x,x, x,x,x,T, x,x,x,x, x,x,x,T, x,T,x,x, x,x,x,x, x),
    (x,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,x,T,T, T,T,T,T, T,T,T,T, T,T,T,T, x),
    (x,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,x, T,T,T,T, T,T,T,T, T,T,T,T, x),
    (x,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,x,T, x),
    (x,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,x,x,T, x),
    (x,T,x,T, T,x,x,x, x,x,x,x, x,x,x,x, x,x,x,T, x,x,x,x, T,x,T,T, x,x,x,x, T,T,T,T, T,T,T,T, x,T,x,x, x),
    (x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,T, x,x,x,x, x,x,x,T, x,x,x,x, x,x,x,T, x,T,x,x, x,x,x,x, x),
    (x,T,x,T, T,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, T,x,T,x, x,x,x,x, x,T,T,x, T,x,T,T, x,T,x,x, x),
    (x,T,x,T, T,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, T,x,T,x, x,x,x,x, x,T,T,x, T,x,T,x, x,T,x,x, x),
    (x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,T, x,x,x,x, x,x,x,T, x,x,x,x, T,x,x,T, x,T,x,x, x,x,x,x, x),
    (x,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,x, T,T,T,T, T,T,T,T, T,T,T,T, T,T,T,T, x));
begin
  Result := sets[s, kind];
end;

function TcrParser.ErrorMsg(nr: Integer): string;
const
  MaxErr = 55;
  Errors: array [0 .. MaxErr] of string = (
    {0} 'EOF expected',
    {1} 'ident expected',
    {2} 'number expected',
    {3} 'string expected',
    {4} 'char expected',
    {5} '"COMPILER" expected',
    {6} '"IGNORECASE" expected',
    {7} '"MACROS" expected',
    {8} '"CHARACTERS" expected',
    {9} '"TOKENS" expected',
    {10} '"NAMES" expected',
    {11} '"PRAGMAS" expected',
    {12} '"COMMENTS" expected',
    {13} '"FROM" expected',
    {14} '"TO" expected',
    {15} '"NESTED" expected',
    {16} '"IGNORE" expected',
    {17} '"PRODUCTIONS" expected',
    {18} '''='' expected',
    {19} '''.'' expected',
    {20} '"END" expected',
    {21} '''+'' expected',
    {22} '''-'' expected',
    {23} '".." expected',
    {24} '"ANY" expected',
    {25} '"CHR" expected',
    {26} '''('' expected',
    {27} ''')'' expected',
    {28} '''<'' expected',
    {29} '''>'' expected',
    {30} '"<." expected',
    {31} '".>" expected',
    {32} '''|'' expected',
    {33} '"WEAK" expected',
    {34} '''['' expected',
    {35} ''']'' expected',
    {36} '''{'' expected',
    {37} '''}'' expected',
    {38} '"SYNC" expected',
    {39} '"IF" expected',
    {40} '"CONTEXT" expected',
    {41} '"(." expected',
    {42} '".)" expected',
    {43} '??? expected',
    {44} 'this symbol not expected in Coco',
    {45} 'this symbol not expected in TokenDecl',
    {46} 'invalid TokenDecl',
    {47} 'invalid NameDecl',
    {48} 'invalid AttrDecl',
    {49} 'invalid SimSet',
    {50} 'invalid Char',
    {51} 'invalid Sym_',
    {52} 'invalid Term',
    {53} 'invalid Factor',
    {54} 'invalid Attribs',
    {55} 'invalid TokenFactor');
begin
  if nr <= MaxErr then
    Result := Errors[nr]
  else
    Result := 'error ' + IntToStr(nr);
end;

{$EndRegion}

{$Region 'TCocoPartHelper'}

function TCocoPartHelper.GetParser: TcrParser;
begin
  Result := FParser as TcrParser;
end;

function TCocoPartHelper.GetScanner: TcrScanner;
begin
  Result := parser.scanner as TcrScanner;
end;

function TCocoPartHelper.GetOptions: TOptions;
begin
  Result := parser.options;
end;

function TCocoPartHelper.GetTab: TTab;
begin
  Result := parser.tab;
end;

function TCocoPartHelper.GetDfa: TDFA;
begin
  Result := parser.dfa;
end;

function TCocoPartHelper.GetPgen: TParserGen;
begin
  Result := parser.pgen;
end;

function TCocoPartHelper.GetTrace: TTextWriter;
begin
  Result := parser.trace;
end;

function TCocoPartHelper.GetErrors: TErrors;
begin
  Result := parser.errors;
end;

{$EndRegion}

end.

