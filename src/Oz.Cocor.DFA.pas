unit Oz.Cocor.DFA;
// Compiler Generator Coco/R, for Delphi
// Copyright (c) 2020 Tomsk, Marat Shaimardanov

// Generation of the Scanner Automaton

interface

uses
  System.Classes, System.SysUtils, System.IOUtils, System.Character,
  System.Contnrs, System.Generics.Collections,
  Oz.Cocor.Utils, Oz.Cocor.Lib, Oz.Cocor.Tab;

type

  TAction = class;

  // state of finite automaton
  TState = class
  private
    nr: Integer;            // state number
    firstAction: TAction;   // to first action of this state
    endOf: TSymbol;         // recognized token if state is final
    ctx: Boolean;           // true if state is reached via contextTrans
    next: TState;
  public
    procedure AddAction(action: TAction);
    procedure DetachAction(action: TAction);
    procedure Print(trace: TTextWriter; tab: TTab);
  end;

  // set of states that are reached by an action
  TTarget = class
  public
    state: TState;        // target state
    next: TTarget;
    constructor Create(s: TState);
  end;

  // action of finite automaton
  TAction = class
  private
    typ: TNodeKind;  // type of action symbol: clas, chr
    sym: Integer;    // action symbol
    tc: Integer;     // transition code: normalTrans, contextTrans
    target: TTarget; // states reached from this action
    next: TAction;
    FTargets: TObjectList;
  public
    constructor Create(typ: TNodeKind; sym, tc: Integer);
    destructor Destroy; override;
    function NewTarget(s: TState): TTarget;
    // add t to the action.targets
    procedure AddTarget(t: TTarget);
    // add copy of a.targets to action.targets
    procedure AddTargets(a: TAction);
    function Symbols(tab: TTab): TCharSet;
    procedure ShiftWith(s: TCharSet; tab: TTab);
  end;

  // TMelted: info about melted states
  TMelted = class
    sets: TBitSet;    // set of old states
    state: TState;    // new state
    next: TMelted;
    constructor Create(sets: TBitSet; state: TState);
  end;

  // info about comment syntax
  TComment = class
  var
    start: string;
    stop: string;
    nested: Boolean;
    next: TComment;
  public
    constructor Create(const start, stop: string; nested: Boolean);
  end;

{$Region 'TGenerator'}

  TGenerator = class(TCocoPart)
  const
    EOF = -1;
  var
    fram: PBuffer;
    gen: TStreamWriter;
    frameFile: string;
  strict private
    LeftMargin: Integer;
    function framRead: Integer;
  public
    constructor Create(parser: TBaseParser; const fram: TBuffer);
    destructor Destroy; override;
    function OpenFrame(const frame: string): TBuffer;
    function OpenGen(const target: string): TStreamWriter;
    procedure GenCopyright;
    // if stop = '', copies until end of file
    function GetFramePart(const stop: string): string;
    procedure CopyFramePart(const stop: String);
  end;

{$EndRegion}

{$Region 'TDFA: Deterministic finite automaton'}

  TDFA = class(TCocoPart)
  private
    maxStates: Integer;
    lastStateNr: Integer;  // highest state number
    firstState: TState;
    lastState: TState;     // last allocated state
    lastSimState: Integer; // last non melted state
    fram: TBuffer;         // scanner frame input
    gen: TStreamWriter;    // generated scanner file
    curSy: TSymbol;        // current token to be recognized (in FindTrans)
    dirtyDFA: Boolean;     // DFA may become nondeterministic in MatchLiteral
    FStates: TObjectList;
    FActions: TObjectList;
    FMelteds: TObjectList;
    // Output primitives
    function ChCond(c: char): string;
    procedure PutRange(s: TCharSet; Indent: Integer);
    // TState handling
    function NewState: TState;
    procedure NewTransition(head, tail: TState; typ: TNodeKind; sym, tc: Integer);
    procedure CombineShifts;
    procedure FindUsedStates(state: TState; used: TBitSet);
    procedure DeleteRedundantStates;
    function TheState(p: TNode): TState;
    procedure Step(from: TState; p: TNode; stepped: TBitSet);
    // Assigns a state n.state to every node n. There will be a transition from
    // n.state to n.next.state triggered by n.val. All nodes in an alternative
    // chain are represented by the same state.
    // Numbering scheme:
    //  - any node after a chr, clas, opt, or alt, must get a new number
    //  - if a nested structure starts with an iteration
    //    the iter node must get a new number
    //  - if an iteration follows an iteration, it must get a new number
    procedure NumberNodes(p: TNode; state: TState; renumIter: Boolean);
    procedure FindTrans(p: TNode; start: Boolean; marked: TBitSet);
    procedure SplitActions(state: TState; a, b: TAction);
    function Overlap(a, b: TAction): Boolean;
    procedure FindCtxStates;

  {$Region 'Actions'}
    function FindAction(state: TState; ch: char): TAction;
  public
    function NewAction(typ: TNodeKind; sym, tc: Integer): TAction;
    procedure GetTargetStates(a: TAction; var targets: TBitSet;
      var endOf: TSymbol; var ctx: Boolean);
  {$EndRegion}

  {$Region 'Melted states'}
  private
    firstMelted: TMelted;   // head of melted state list
    function NewMelted(sets: TBitSet; state: TState): TMelted;
    function MeltedSet(nr: Integer): TBitSet;
    function StateWithSet(s: TBitSet): TMelted;
    // copy actions of s to state
    procedure MeltWith(s, state: TState);

  {$EndRegion}

  {$Region 'Comments'}
  private
    firstComment: TComment;  // list of comments
    FComments: TObjectList;
  public
    function CommentStr(p: TNode): string;
    procedure NewComment(start, stop: TNode; nested: Boolean);
  {$EndRegion}

  {$Region 'Scanner generation'}
  private
    procedure Indent(n: Integer);
    procedure GenComBody(com: TComment);
    procedure GenComment(com: TComment; i: Integer);
    function SymName(sym: TSymbol): string;
    procedure GenLiterals;
    procedure WriteState(state: TState);
    procedure WriteStartTab;
  public
    procedure WriteScanner;
  {$EndRegion}

  public
    ignoreCase: Boolean;   // true if input should be treated case-insensitively
    hasCtxMoves: Boolean;  // DFA has context transitions
  public
    constructor Create(parser: TBaseParser);
    destructor Destroy; override;
    procedure ConvertToStates(p: TNode; sym: TSymbol);
    procedure FixString(var name: string);
    // match string against current automaton;
    // store it either as a fixedToken or as a litToken
    procedure MatchLiteral(s: string; sym: TSymbol);
    procedure MakeUnique(state: TState);
    procedure MeltStates(state: TState);
    procedure MakeDeterministic;
    procedure PrintStates;
  end;

{$EndRegion}

implementation

uses Oz.Cocor.Parser;

constructor TComment.Create(const start, stop: string; nested: Boolean);
begin
  Self.start := start;
  Self.stop := stop;
  Self.nested := nested;
end;

procedure TState.AddAction(action: TAction);
var q, p: TAction;
begin
  q := nil; p := firstAction;
  while (p <> nil) and (action.typ >= p.typ) do
  begin
    q := p; p := p.next;
  end;
  // collecting classes at the beginning gives better performance
  action.next := p;
  if p = firstAction then
    firstAction := action
  else
    q.next := action;
end;

procedure TState.DetachAction(action: TAction);
var
  q, p: TAction;
begin
  q := nil; p := firstAction;
  while (p <> nil) and (p <> action) do
  begin
    q := p; p := p.next;
  end;
  if p = nil then exit;
  if p = firstAction then
    firstAction := p.next
  else
    q.next := p.next;
end;

procedure TState.Print(trace: TTextWriter; tab: TTab);
var
  first: Boolean;
  a: TAction;
  targ: TTarget;
begin
  first := true;
  if endOf = nil then
    trace.Write(Blank(12))
  else
    trace.Write('E(%12s)', [AsName(endOf.name)]);
  trace.Write('%3d:', [nr]);
  if firstAction = nil then
    trace.WriteLine;
  a := firstAction;
  while a <> nil do
  begin
    if first then
    begin
      trace.Write(' ');
      first := false;
    end
    else
      trace.Write(Blank(21));
    if a.typ = TNodeKind.clas then
      trace.Write(tab.classes[a.sym].name)
    else
      trace.Write('%3s', [ToChar(a.sym)]);
    targ := a.target;
    while targ <> nil do
    begin
      trace.Write(' %3d', [targ.state.nr]);
      targ := targ.next;
    end;
    if a.tc = TNode.contextTrans then
      trace.WriteLine(' context')
    else
      trace.WriteLine;
    a := a.next;
  end;
end;

constructor TTarget.Create(s: TState);
begin
  state := s;
end;

constructor TAction.Create(typ: TNodeKind; sym, tc: Integer);
begin
  inherited Create;
  FTargets := TObjectList.Create(True);
  Self.typ := typ;
  Self.sym := sym;
  Self.tc := tc;
end;

destructor TAction.Destroy;
begin
  FTargets.Free;
  inherited;
end;

function TAction.NewTarget(s: TState): TTarget;
begin
  Result := TTarget.Create(s);
  FTargets.Add(Result);
end;

procedure TAction.AddTarget(t: TTarget);
var
  last, p: TTarget;
begin
  last := nil;
  p := target;
  while (p <> nil) and (t.state.nr >= p.state.nr) do
  begin
    if t.state = p.state then exit;
    last := p;
    p := p.next;
  end;
  t.next := p;
  if p = target then
    target := t
  else
    last.next := t;
end;

procedure TAction.AddTargets(a: TAction);
var
  p, t: TTarget;
begin
  p := a.target;
  while p <> nil do
  begin
    t := NewTarget(p.state);
    AddTarget(t);
    p := p.next;
  end;
  if a.tc = TNode.contextTrans then
    tc := TNode.contextTrans;
end;

function TAction.Symbols(tab: TTab): TCharSet;
var
  s: TCharSet;
begin
  if typ = TNodeKind.clas then
    s := tab.Clone(tab.CharClassSet(sym))
  else
  begin
    s := tab.NewCharSet;
    s.Incl(sym);
  end;
  Result := s;
end;

procedure TAction.ShiftWith(s: TCharSet; tab: TTab);
var
  c: TCharClass;
begin
  if s.Elements = 1 then
  begin
    typ := TNodeKind.chr;
    sym := s.First;
  end
  else
  begin
    c := tab.FindCharClass(s);
    if c = nil then
      c := tab.NewCharClass('#', s); // class with dummy name
    typ := TNodeKind.clas;
    sym := c.n;
  end;
end;

constructor TMelted.Create(sets: TBitSet; state: TState);
begin
  Self.sets := sets;
  Self.state := state;
end;

//  TGenerator

constructor TGenerator.Create(parser: TBaseParser; const fram: TBuffer);
begin
  inherited Create(parser);
  Self.fram := @fram;
  LeftMargin := 0;
end;

destructor TGenerator.Destroy;
begin
  gen.Free;
end;

function TGenerator.OpenFrame(const frame: string): TBuffer;
begin
  if options.frameDir <> '' then
    frameFile := TPath.Combine(options.frameDir, frame);
  if (frameFile = '') or not TFile.Exists(frameFile) then
    frameFile := TPath.Combine(options.srcDir, frame);
  if (frameFile = '') or not TFile.Exists(frameFile) then
    raise FatalError.Create('Cannot find: ' + frame);
  Result.Open(frameFile);
end;

function TGenerator.OpenGen(const target: string): TStreamWriter;
var
  fn: string;
begin
  fn := TPath.Combine(options.outDir, target);
  try
    if TFile.Exists(fn) then
      TFile.Copy(fn, fn + '.old', true);
    gen := TFile.CreateText(fn);
  except
    on EFileStreamError do
      raise FatalError.Create('Cannot generate file: ' + fn);
  end;
  Result := gen;
end;

procedure TGenerator.GenCopyright;
var
  copyrightFrame: string;
  temp: TBuffer;
begin
  copyrightFrame := '';
  if options.frameDir <> '' then
    copyrightFrame := TPath.Combine(options.frameDir, 'Copyright.frame');
  if (copyrightFrame = '') or not TFile.Exists(copyrightFrame) then
    copyrightFrame := TPath.Combine(options.srcDir, 'Copyright.frame');
  if (copyrightFrame = '') or not TFile.Exists(copyrightFrame) then
    exit;
  temp := fram^;
  try
    fram.Open(copyrightFrame);
    CopyFramePart('');
  finally
    fram^ := temp;
  end;
end;

function TGenerator.GetFramePart(const stop: string): string;
var
  ch, startCh: Char;
  i, n: Integer;
  s, temp: string;
begin
  s := '';
  if stop = '' then 
    while not fram.Eof do
      s := s + Char(framRead)
  else
  begin
    startCh := stop[1];
    while not fram.Eof do
    begin
      ch := Char(framRead);
      if (ch = #13) or (ch = #10) then
        leftMargin := 0
      else
        Inc(leftMargin);
      // check if stopString occurs
      if ch <> startCh then
        s := s + ch
      else
      begin
        temp := ch;
        i := 1;
        n := Length(stop);
        while not fram.Eof and (i < n) and (ch = stop[i]) do
        begin
          Inc(i);
          ch := Char(framRead);
          temp := temp + ch;
        end;
        if ch = stop[i] then
        begin
          Dec(leftMargin);
          break;
        end;
        { found ==> exit; , else continue }
        s := s + temp;
        Inc(leftMargin, i);
      end;
    end;
  end;
  Result := tab.EvalMacros(s);
end;

procedure TGenerator.CopyFramePart(const stop: string);
begin
  gen.Write(GetFramePart(stop));
end;

function TGenerator.framRead: Integer;
begin
  try
    Result := fram.Read;
  except
    on Exception do
      raise FatalError.Create('Error reading frame file: ' + frameFile);
  end;
end;

// TDfa

constructor TDfa.Create(parser: TBaseParser);
begin
  inherited Create(parser);
  FStates := TObjectList.Create;
  FActions := TObjectList.Create;
  FComments := TObjectList.Create;
  FMelteds := TObjectList.Create;
  firstState := nil;
  lastState := nil;
  lastStateNr := -1;
  firstState := NewState;
  firstMelted := nil;
  firstComment := nil;
  ignoreCase := false;
  dirtyDFA := false;
  hasCtxMoves := false;
end;

destructor TDFA.Destroy;
begin
  FStates.Free;
  FActions.Free;
  FComments.Free;
  FMelteds.Free;
  inherited;
end;

function TDfa.ChCond(c: char): string;
begin
  Result := Format('ch = %s', [ToChar(Ord(c))]);
end;

procedure TDfa.PutRange(s: TCharSet; Indent: Integer);
var
  col: Integer;
begin
  col := Indent;
  s.Scan(
    function(const r: TCharSet.TRange): Boolean
    var
      i: Integer;
      s: string;
    begin
      if r.lo = r.hi then
        s := Format('(ch = %s)', [ToChar(r.lo)])
      else if r.lo = 0 then
        s := Format('(ch <= %s)', [ToChar(r.hi)])
      else
        s := Format('Between(ch, %s, %s)', [ToChar(r.lo), ToChar(r.hi)]);
      col := col + Length(s) + 3;
      gen.Write(s);
      if r.next <> nil then
      begin
        gen.Write(' or');
        if col < 60 then
          gen.Write(' ')
        else
        begin
          gen.WriteLine;
          for i := 1 to Indent do gen.Write(' ');
          col := Indent;
        end;
      end;
     Result := False;
   end);
end;

function TDfa.NewState: TState;
var
  s: TState;
begin
  s := TState.Create;
  FStates.Add(s);
  Inc(lastStateNr);
  s.nr := lastStateNr;
  if firstState = nil then
    firstState := s
  else
    lastState.next := s;
  lastState := s;
  Result :=  s;
end;

procedure TDfa.NewTransition(head, tail: TState; typ: TNodeKind; sym, tc: Integer);
var
  a: TAction;
begin
  a := NewAction(typ, sym, tc);
  a.target := a.NewTarget(tail);;
  head.AddAction(a);
  if typ = TNodeKind.clas then
    curSy.tokenKind := TTokenKind.classToken;
end;

procedure TDfa.CombineShifts;
var
  state: TState;
  a, b, c: TAction ;
  seta, setb: TCharSet;
begin
  state := firstState;
  while state <> nil do
  begin
    a := state.firstAction;
    while a <> nil do
    begin
      b := a.next;
      while b <> nil do
        if (a.target.state = b.target.state) and (a.tc = b.tc) then
        begin
          seta := a.Symbols(tab);
          setb := b.Symbols(tab);
          seta.Unite(setb);
          a.ShiftWith(seta, tab);
          c := b;
          b := b.next;
          state.DetachAction(c);
        end
        else
          b := b.next;
      a := a.next;
    end;
    state := state.next;
  end;
end;

procedure TDfa.FindUsedStates(state: TState; used: TBitSet);
var
  a: TAction;
begin
  if used[state.nr] then exit;
  used[state.nr] := true;
  a := state.firstAction;
  while a <> nil do
  begin
    FindUsedStates(a.target.state, used);
    a := a.next;
  end;
end;

procedure TDfa.DeleteRedundantStates;
var
  newState: TArray<TState>;
  used: TBitSet;
  s1, s2, state: TState;
  a: TAction;
begin
  SetLength(newState, lastStateNr + 1);
  used := tab.NewBitSet(lastStateNr + 1);
  FindUsedStates(firstState, used);
  // combine equal final states
  s1 := firstState.next;
  while s1 <> nil do
  begin
    // firstState cannot be final
    if used[s1.nr] and (s1.endOf <> nil) and (s1.firstAction = nil) and not s1.ctx then
    begin
      s2 := s1.next;
      while s2 <> nil do
      begin
        if used[s2.nr] and (s1.endOf = s2.endOf) and (s2.firstAction = nil) and not s2.ctx then
        begin
          used[s2.nr] := false;
          newState[s2.nr] := s1;
        end;
        s2 := s2.next;
      end;
    end;
    s1 := s1.next;
  end;
  state := firstState;
  while state <> nil do
  begin
    if used[state.nr] then
    begin
      a := state.firstAction;
      while a <> nil do
      begin
        if not used[a.target.state.nr] then
          a.target.state := newState[a.target.state.nr];
        a := a.next;
      end;
    end;
    state := state.next;
  end;
  // delete unused states
  lastState := firstState; lastStateNr := 0; // firstState has number 0
  state := firstState.next;
  while state <> nil do
  begin
    if used[state.nr] then
    begin
      Inc(lastStateNr);
      state.nr := lastStateNr;
      lastState := state;
    end
    else
      lastState.next := state.next;
    state := state.next;
  end;
end;

function TDfa.TheState(p: TNode): TState;
var
  state: TState;
begin
  if p <> nil then
    Result := p.state as TState
  else
  begin
    state := NewState;
    state.endOf := curSy;
    Result := state;
  end;
end;

procedure TDfa.Step(from: TState; p: TNode; stepped: TBitSet);
begin
  if p = nil then exit;
  stepped[p.n] := true;
  case p.typ of
    TNodeKind.clas, TNodeKind.chr:
      NewTransition(from, TheState(p.next), p.typ, p.val, p.code);
    TNodeKind.alt:
      begin
        Step(from, p.sub, stepped);
        Step(from, p.down, stepped);
      end;
    TNodeKind.iter:
      begin
        if TTab.DelSubGraph(p.sub) then
        begin
          parser.SemErr('contents of begin...end; must not be deletable');
          exit;
        end;
        if (p.next <> nil) and not stepped[p.next.n] then
          Step(from, p.next, stepped);
        Step(from, p.sub, stepped);
        if p.state <> from then
          Step(p.state as TState, p, tab.NewBitSet(tab.nodes.Count));
      end;
    TNodeKind.opt:
      begin
        if (p.next <> nil) and not stepped[p.next.n] then
          Step(from, p.next, stepped);
        Step(from, p.sub, stepped);
      end;
  end;
end;

procedure TDfa.NumberNodes(p: TNode; state: TState; renumIter: Boolean);
begin
  if p = nil then exit;
  if p.state <> nil then exit; // already visited;
  if (state = nil) or (p.typ = TNodeKind.iter) and renumIter then
    state := NewState;
  p.state := state;
  if TTab.DelGraph(p) then
    state.endOf := curSy;
  case p.typ of
    TNodeKind.clas, TNodeKind.chr:
      NumberNodes(p.next, nil, false);
    TNodeKind.opt:
      begin
        NumberNodes(p.next, nil, false);
        NumberNodes(p.sub, state, true);
      end;
    TNodeKind.iter:
      begin
        NumberNodes(p.next, state, true);
        NumberNodes(p.sub, state, true);
      end;
    TNodeKind.alt:
      begin
        NumberNodes(p.next, nil, false);
        NumberNodes(p.sub, state, true);
        NumberNodes(p.down, state, renumIter);
      end;
  end;
end;

procedure TDfa.FindTrans(p: TNode; start: Boolean; marked: TBitSet);
begin
  if (p = nil) or marked[p.n] then exit;
  marked[p.n] := true;
  if start then
    // start of group of equally numbered nodes
    Step(p.state as TState, p, tab.NewBitSet(tab.nodes.Count));
  case p.typ of
     TNodeKind.clas, TNodeKind.chr:
      FindTrans(p.next, true, marked);
    TNodeKind.opt:
      begin
        FindTrans(p.next, true, marked);
        FindTrans(p.sub, false, marked);
      end;
    TNodeKind.iter:
      begin
        FindTrans(p.next, false, marked);
        FindTrans(p.sub, false, marked);
      end;
    TNodeKind.alt:
      begin
        FindTrans(p.sub, false, marked);
        FindTrans(p.down, false, marked);
      end;
  end;
end;

procedure TDfa.ConvertToStates(p: TNode; sym: TSymbol);
begin
  curSy := sym;
  if TTab.DelGraph(p) then
  begin
    parser.SemErr('token might be empty');
    exit;
  end;
  NumberNodes(p, firstState, true);
  FindTrans(p, true, tab.NewBitSet(tab.nodes.Count));
  if p.typ = TNodeKind.iter then
    Step(firstState, p, tab.NewBitSet(tab.nodes.Count));
end;

procedure TDfa.FixString(var name: string);
var
  double, spaces: Boolean;
  len, i: INTEGER;
begin
  len := Length(name);
  if ignoreCase then (* force uppercase *)
    for i := 2 to len - 1 do
      name[i] := UpCase(name[i]);
  double := False;
  spaces := False;
  len := Length(name);
  for i := 2 to len - 1 do
  begin
    // search for interior " or spaces
    if name[i] = '"' then
      double := True;
    if name[i] = ' ' then
      spaces := True;
  end;
  if not double then
  begin
    // force delimiters to be " quotes
    name[1] := '"';
    name[len] := '"'
  end;
  if spaces then
    parser.SemErr('spaces not allowed within tokens');
end;

procedure TDfa.MatchLiteral(s: string; sym: TSymbol);
var
  i, len: Integer;
  state: TState;
  a: TAction;
  tail: TState;
  matchedSym: TSymbol;
begin
  s := tab.Unescape(s.Substring(1, s.Length - 2));
  len := s.Length;
  state := firstState;
  a := nil;
  i := 0;
  while i < len do
  begin
    // try to match s against existing DFA
    a := FindAction(state, s[i + 1]);
    if a = nil then break;
    state := a.target.state;
    Inc(i);
  end;
  // if s was not totally consumed or
  // leads to a non-final state => make new DFA from it
  if (i <> len) or (state.endOf = nil) then
  begin
    state := firstState;
    i := 0;
    a := nil;
    dirtyDFA := true;
  end;
  while i < len do
  begin
    // make new DFA for s[i..len - 1], ML: i is either 0 or len
    tail := NewState;
    NewTransition(state, tail, TNodeKind.chr, Ord(s[i + 1]), TNode.normalTrans);
    state := tail;
    Inc(i);
  end;
  matchedSym := state.endOf;
  if state.endOf = nil then
    state.endOf := sym
  else if (matchedSym.tokenKind = TTokenKind.fixedToken) or
          (a <> nil) and (a.tc = TNode.contextTrans) then
    // s matched a token with a fixed definition
    // or a token with an appendix that will be cut off
    parser.SemErr('tokens ' + sym.name + ' and ' +
      matchedSym.name + ' cannot be distinguished')
  else
  begin
    // matchedSym = classToken or classLitToken
    matchedSym.tokenKind := TTokenKind.classLitToken;
    sym.tokenKind := TTokenKind.litToken;
  end;
end;

procedure TDFA.SplitActions(state: TState; a, b: TAction);
var
  c: TAction;
  seta, setb, setc: TCharSet;
begin
  seta := a.Symbols(tab);
  setb := b.Symbols(tab);
  if seta.Equals(setb) then
  begin
    a.AddTargets(b);
    state.DetachAction(b);
  end
  else if seta.Includes(setb) then
  begin
    setc := tab.Subtract(seta, setb);
    b.AddTargets(a);
    a.ShiftWith(setc, tab);
  end
  else if setb.Includes(seta) then
  begin
    setc := tab.Subtract(setb, seta);
    a.AddTargets(b);
    b.ShiftWith(setc, tab);
  end
  else
  begin
    setc := tab.Clone(seta);
    setc.Intersect(setb);
    seta := tab.Subtract(seta, setc);
    setb := tab.Subtract(setb, setc);
    a.ShiftWith(seta, tab);
    b.ShiftWith(setb, tab);
    // typ and sym are set in ShiftWith
    c := NewAction(TNodeKind.undef, 0, TNode.normalTrans);
    c.AddTargets(a);
    c.AddTargets(b);
    c.ShiftWith(setc, tab);
    state.AddAction(c);
  end;
end;

function TDFA.Overlap(a, b: TAction): Boolean;
var
  seta, setb: TCharSet;
begin
  if a.typ = TNodeKind.chr then
    if b.typ = TNodeKind.chr then
      Result := a.sym = b.sym
    else
    begin
      setb := tab.CharClassSet(b.sym);
      Result := setb[a.sym];
    end
  else
  begin
    seta := tab.CharClassSet(a.sym);
    if b.typ = TNodeKind.chr then
      Result := seta[b.sym]
    else
    begin
      setb := tab.CharClassSet(b.sym);
      Result := seta.Intersects(setb);
    end;
  end;
end;

procedure TDFA.MakeUnique(state: TState);
var
  changed: Boolean;
  a, b: TAction;
begin
  repeat
    changed := false;
    a := state.firstAction;
    while a <> nil do
    begin
      b := a.next;
      while b <> nil do
      begin
        if Overlap(a, b) then
        begin
          SplitActions(state, a, b);
          changed := true;
        end;
        b := b.next;
      end;
      a := a.next;
    end;
  until not changed;
end;

procedure TDFA.MeltStates(state: TState);
var
  a: TAction;
  ctx: Boolean;
  targets: TBitSet;
  endOf: TSymbol;
  melt: TMelted;
  s: TState;
  targ: TTarget;
begin
  a := state.firstAction;
  while a <> nil do
  begin
    if a.target.next <> nil then
    begin
      GetTargetStates(a, targets, endOf, ctx);
      melt := StateWithSet(targets);
      if melt = nil then
      begin
        s := NewState;
        s.endOf := endOf;
        s.ctx := ctx;
        targ := a.target;
        while targ <> nil do
        begin
          MeltWith(targ.state, s);
          targ := targ.next;
        end;
        MakeUnique(s);
        melt := NewMelted(targets, s);
      end;
      a.target.next := nil;
      a.target.state := melt.state;
    end;
    a := a.next;
  end;
end;

procedure TDFA.FindCtxStates;
var
  state: TState;
  a: TAction;
begin
  state := firstState;
  while state <> nil do
  begin
    a := state.firstAction;
    while a <> nil do
    begin
      if a.tc = TNode.contextTrans then
        a.target.state.ctx := true;
      a := a.next;
    end;
    state := state.next;
  end;
end;

procedure TDFA.MakeDeterministic;
var
  state: TState;
begin
  lastSimState := lastState.nr;
  // heuristic for set size in TMelted.set
  maxStates := 2 * lastSimState;
  FindCtxStates;
  state := firstState;
  while state <> nil do
  begin
    MakeUnique(state);
    state := state.next;
  end;
  state := firstState;
  while state <> nil do
  begin
    MeltStates(state);
    state := state.next;
  end;
  DeleteRedundantStates;
  CombineShifts;
end;

procedure TDFA.PrintStates;
var
  state: TState;
begin
  trace.WriteLine;
  trace.WriteLine('---------- states ----------');
  state := firstState;
  while state <> nil do
  begin
    state.Print(trace, tab);
    state := state.next;
  end;
  trace.WriteLine;
  trace.WriteLine('---------- character classes ----------');
  tab.WriteCharClasses;
end;

function TDFA.FindAction(state: TState; ch: char): TAction;
var
  a: TAction;
  s: TCharSet;
  c: Integer;
begin
  c := Ord(ch);
  a := state.firstAction;
  while a <> nil do
  begin
    if (a.typ = TNodeKind.chr) and (c = a.sym) then exit(a);
    if a.typ = TNodeKind.clas then
    begin
      s := tab.CharClassSet(a.sym);
      if s[c] then exit(a);
    end;
    a := a.next;
  end;
  Result := nil;
end;

function TDFA.NewAction(typ: TNodeKind; sym, tc: Integer): TAction;
begin
  Result := TAction.Create(typ, sym, tc);
  FActions.Add(Result);
end;

procedure TDFA.GetTargetStates(a: TAction; var targets: TBitSet;
  var endOf: TSymbol; var ctx: Boolean);
var
  t: TTarget;
  stateNr: Integer;
begin
  // compute the set of target states
  targets := tab.NewBitSet(maxStates);
  endOf := nil;
  ctx := false;
  t := a.target;
  while t <> nil do
  begin
    stateNr := t.state.nr;
    if stateNr <= lastSimState then
      targets[stateNr] := true
    else
      targets.Unite(MeltedSet(stateNr));
    if t.state.endOf <> nil then
      if (endOf = nil) or (endOf = t.state.endOf) then
        endOf := t.state.endOf
      else
        errors.SemErr('Tokens ' + endOf.name + ' and ' +
          t.state.endOf.name + ' cannot be distinguished');
    if t.state.ctx then
    begin
      ctx := true;
      // The following check seems to be unnecessary. It reported an error
      // if a symbol + context was the prefix of another symbol, e.g.
      //   s1 = 'a' 'b' 'c'.
      //   s2 = 'a' CONTEXT('b').
      // But this is ok.
      // if (t.state.endOf <> nil) begin
      //   Console.WriteLine('Ambiguous context clause');
      //   errors.count++;
      // end;
    end;
    t := t.next;
  end;
end;

// melted states

function TDFA.NewMelted(sets: TBitSet; state: TState): TMelted;
var
  m: TMelted;
begin
  m := TMelted.Create(sets, state);
  FMelteds.Add(m);
  m.next := firstMelted;
  firstMelted := m;
  Result := m;
end;

function TDFA.MeltedSet(nr: Integer): TBitSet;
var
  m: TMelted;
begin
  m := firstMelted;
  while m <> nil do
  begin
    if m.state.nr = nr then exit(m.sets);
    m := m.next;
  end;
  raise FatalError.Create('compiler error in TMelted.Set');
end;

function TDFA.StateWithSet(s: TBitSet): TMelted;
var
  m: TMelted;
begin
  m := firstMelted;
  while m <> nil do
  begin
    if s.Equals(m.sets) then exit(m);
    m := m.next;
  end;
  Result := nil;
end;

procedure TDFA.MeltWith(s, state: TState);
var
  action, a: TAction;
begin
  action := s.firstAction;
  while action <> nil do
  begin
    a := NewAction(action.typ, action.sym, action.tc);
    a.AddTargets(action);
    state.AddAction(a);
    action := action.next;
  end;
end;

// comments

function TDFA.CommentStr(p: TNode): string;
var
  r: string;
  sets: TCharSet;
begin
  r := '';
  while p <> nil do
  begin
    if p.typ = TNodeKind.chr then
      r := r + char(p.val)
    else if p.typ = TNodeKind.clas then
    begin
      sets := tab.CharClassSet(p.val);
      if sets.Elements <> 1 then
        parser.SemErr('character set contains more than 1 character');
      r := r + char(sets.First);
    end
    else
      parser.SemErr('comment delimiters may not be structured');
    p := p.next;
  end;
  if (r.Length = 0) or (r.Length > 2) then
  begin
    parser.SemErr('comment delimiters must be 1 or 2 characters long');
    r := '?';
  end;
  Result := r;
end;

procedure TDFA.NewComment(start, stop: TNode; nested: Boolean);
var
  c: TComment;
begin
  c := TComment.Create(CommentStr(start), CommentStr(stop), nested);
  FComments.Add(c);
  c.next := firstComment;
  firstComment := c;
end;

// scanner generation

procedure TDFA.Indent(n: Integer);
begin
  if n > 0 then
    gen.Write(Blank(n * 2));
end;

procedure TDFA.GenComBody(com: TComment);
begin
  gen.WriteLine(  '    repeat');
  gen.WriteLine(  '      if %s then', [ChCond(com.stop[1])]);
  gen.WriteLine(  '      begin');
  if com.stop.Length = 1 then
  begin
    gen.WriteLine('        Dec(level);');
    gen.WriteLine('        if level = 0 then');
    gen.WriteLine('        begin');
    gen.WriteLine('          oldEols := line - line0; NextCh;');
    gen.WriteLine('          exit(True);');
    gen.WriteLine('        end;');
    gen.WriteLine('        NextCh;');
  end
  else
  begin
    gen.WriteLine('        NextCh;');
    gen.WriteLine('        if %s then', [ChCond(com.stop[2])]);
    gen.WriteLine('        begin');
    gen.WriteLine('          Dec(level);');
    gen.WriteLine('          if level = 0 then');
    gen.WriteLine('          begin');
    gen.WriteLine('            oldEols := line - line0; NextCh;');
    gen.WriteLine('            exit(True);');
    gen.WriteLine('          end;');
    gen.WriteLine('          NextCh;');
    gen.WriteLine('        end;');
  end;
  if com.nested then
  begin
    gen.WriteLine('      end');
    gen.WriteLine('      else if %s then', [ChCond(com.start[1])]);
    gen.WriteLine('      begin');
    if com.start.Length = 1 then
      gen.WriteLine('        Inc(level); NextCh;')
    else
    begin
      gen.WriteLine('        NextCh;');
      gen.WriteLine('        if %s then', [ChCond(com.start[2])]);
      gen.WriteLine('        begin');
      gen.WriteLine('          Inc(level); NextCh;');
      gen.WriteLine('        end;');
    end;
  end;
  gen.WriteLine(    '      end');
  gen.WriteLine(    '      else if ch = TBuffer.EF then');
  gen.WriteLine(    '        exit(False)');
  gen.WriteLine(    '      else');
  gen.WriteLine(    '        NextCh;');
  gen.WriteLine(    '    until False;');
end;

procedure TDFA.GenComment(com: TComment; i: Integer);
begin
  gen.WriteLine;
  gen.WriteLine  ('function ' + tab.GetScannerType + '.Comment%d: Boolean;', [i]);
  gen.WriteLine  ('var');
  gen.WriteLine  ('  level, pos0, line0, col0: Integer;');
  gen.WriteLine  ('begin');
  gen.WriteLine  ('  level := 1; pos0 := pos; line0 := line; col0 := col;');
  if com.start.Length = 1 then
  begin
    gen.WriteLine('  NextCh;');
    GenComBody(com);
  end
  else
  begin
    gen.WriteLine('  NextCh;');
    gen.WriteLine('  if %s then', [ChCond(com.start[2])]);
    gen.WriteLine('  begin');
    gen.WriteLine('    NextCh;');
    GenComBody(com);
    gen.WriteLine('  end');
    gen.WriteLine('  else');
    gen.WriteLine('  begin');
    gen.WriteLine('    buffer.Pos := pos0; NextCh;');
    gen.WriteLine('    line := line0; col := col0;');
    gen.WriteLine('  end;');
    gen.WriteLine('  Result := False;');
  end;
  gen.WriteLine('end;');
end;

function TDFA.SymName(sym: TSymbol): string;
var
  e: TPair<string, TSymbol>;
begin
  if sym.name[1].IsLetter then
  begin
    // real name value is stored in TTab.literals
    for e in tab.literals do
      if e.Value = sym then
        exit(e.Key);
  end;
  Result := sym.name;
end;

procedure TDFA.GenLiterals;

  procedure GenList(ts: TList<TSymbol>);
  var
    sym: TSymbol;
    name, f: string;
    n: Integer;
  begin
    n := 0;
    for sym in ts do
    begin
      if sym.tokenKind = TTokenKind.litToken then
      begin
        name := ToPascalString(SymName(sym));
        if ignoreCase then
          name := name.ToLower;
        // sym.name stores literals with quotes, e.g. '"Literal"'
        if n = 0 then gen.Write('  if') else gen.Write('  else if');;
        if ignoreCase then f := 's' else f := 't.val';
        gen.WriteLine(' %s = %s then', [f, name]);
        gen.WriteLine('    t.kind := %d', [sym.n]);
        Inc(n);
      end;
    end;
  end;

begin
  if not ignoreCase then
    gen.WriteLine('begin')
  else
  begin
    gen.WriteLine('var s: string;');
    gen.WriteLine('begin');
    gen.WriteLine('  s := t.val.ToLower;');
  end;
  GenList(tab.terminals);
  GenList(tab.pragmas);
  gen.Write('end;');
end;

procedure TDFA.WriteState(state: TState);
var
  n: Integer;
  endOf: TSymbol;
  ctxEnd, needEnd: Boolean;
  a: TAction;
begin
  endOf := state.endOf;
  n := 3;
  Indent(n);
  gen.WriteLine('%d:', [state.nr]);
  needEnd := (endOf <> nil) and (state.firstAction <> nil);
  if needEnd then
  begin
    Indent(n);
    gen.WriteLine('begin');
    Inc(n); Indent(n);
    gen.WriteLine('recEnd := pos; recKind := %d;', [endOf.n]);
  end;
  ctxEnd := state.ctx;
  a := state.firstAction;
  while a <> nil do
  begin
    Indent(n);
    if a = state.firstAction then
      gen.Write('if ')
    else
      gen.Write('else if ');
    if a.typ = TNodeKind.chr then
      gen.Write(ChCond(char(a.sym)))
    else
      PutRange(tab.CharClassSet(a.sym), (n + 1) * 2 + 1);
    gen.WriteLine(' then');
    Indent(n); gen.WriteLine('begin');
    Inc(n);
    if a.tc = TNode.contextTrans then
    begin
      Indent(n);
      gen.WriteLine('Inc(apx);');
      ctxEnd := false;
    end
    else if state.ctx then
    begin
      Indent(n);
      gen.WriteLine('apx := 0;');
    end;
    Indent(n);
    gen.WriteLine('AddCh; state := %d;', [a.target.state.nr]);
    Dec(n); Indent(n);
    gen.WriteLine('end');
    a := a.next;
  end;
  if state.firstAction <> nil then
  begin
    Indent(n);
    gen.WriteLine('else');
  end;
  Indent(n);
  gen.WriteLine('begin'); Inc(n);
  if ctxEnd then
  begin
    // final context state: cut appendix
    gen.WriteLine;
    Indent(n);
    gen.WriteLine('Dec(tlen, apx);');
    Indent(n);
    gen.WriteLine('SetScannerBehindT;');
    Indent(n);
  end;
  if endOf = nil then
  begin
    Indent(n);
    gen.WriteLine('state := 0;');
    Dec(n); Indent(n);
    gen.WriteLine('end;');
  end
  else
  begin
    Indent(n);
    gen.Write('t.kind := %d;', [endOf.n]);
    if endOf.tokenKind = TTokenKind.classLitToken then
    begin
      gen.WriteLine(' t.val := tval; CheckLiteral;');
      Indent(n);
      gen.WriteLine('exit(t);');
    end
    else
      gen.WriteLine(' break;');
    Dec(n); Indent(n);
    gen.WriteLine('end;');
  end;
  if needEnd then
  begin
    Dec(n); Indent(n);
    gen.WriteLine('end;');
  end;
end;

procedure TDFA.WriteStartTab;
var
  s: TCharSet;
  a: TAction;
  targetState: Integer;
begin
  a := firstState.firstAction;
  while a <> nil do
  begin
    targetState := a.target.state.nr;
    if a.typ = TNodeKind.chr then
      gen.WriteLine('  start.Add(%d, %d);', [a.sym, targetState])
    else
    begin
      s := tab.CharClassSet(a.sym);
      s.Scan(
        function(const r: TCharSet.TRange): Boolean
        begin
          gen.WriteLine('  for i := %d to %d do start.Add(i, %d);',
            [r.lo, r.hi, targetState]);
          Result := False;
        end);
    end;
    a := a.next;
  end;
  gen.Write('  start.Add(Ord(TBuffer.EF), -1);');
end;

procedure TDFA.WriteScanner;
var
  g: TGenerator;
  com: TComment;
  comIdx: Integer;
  state: TState;
  unitName: string;
begin
  g := TGenerator.Create(parser, fram);
  try
    fram := g.OpenFrame('Scanner.frame');
    if options.namespace = '' then
      unitName := 'Scanner'
    else
      unitName := options.namespace + '.Scanner';
    gen := g.OpenGen(unitName + '.pas');
    if dirtyDFA then
      MakeDeterministic;
    g.GenCopyright;
    g.GetFramePart('-->begin<');
    g.CopyFramePart('-->unitname<');
    gen.Write(unitName);
    g.CopyFramePart('-->valch_decl<');
    if ignoreCase then
      gen.Write('    valCh: char;');
    g.CopyFramePart('-->declarations<');
    gen.WriteLine('  MaxToken := %d;', [tab.terminals.Count - 1]);
    gen.WriteLine('  NoSym := %d;', [tab.noSym.n]);
    WriteStartTab;

    g.CopyFramePart('-->initialization<');
    g.CopyFramePart('-->nextchcase<');
    if ignoreCase then
    begin
      gen.WriteLine('  if ch <> Buffer.EOF then');
      gen.WriteLine('  begin');
      gen.WriteLine('    valCh := char(ch);');
      gen.WriteLine('    ch := char.ToLower(char(ch));');
      gen.WriteLine('  end;');
    end;
    gen.WriteLine('end;');
    g.CopyFramePart('-->addchcase<');
    gen.Write('    tval := tval + ');
    if ignoreCase then
      gen.Write('valCh; Inc(tlen);')
    else
      gen.Write('ch; Inc(tlen);');
    g.CopyFramePart('-->comments<');
    com := firstComment;
    comIdx := 0;
    while com <> nil do
    begin
      GenComment(com, comIdx);
      com := com.next;
      Inc(comIdx);
    end;
    g.CopyFramePart('-->literals<'); GenLiterals;
    g.CopyFramePart('-->scan1<');
    if tab.ignored.Elements > 0 then
      PutRange(tab.ignored, 0)
    else
      gen.Write('false');
    g.CopyFramePart('-->scan2<');
    if firstComment <> nil then
    begin
      gen.Write('  if ');
      com := firstComment; comIdx := 0;
      while com <> nil do
      begin
        gen.Write('((' + ChCond(com.start[1]) + ')');
        gen.Write(' and Comment%d)', [comIdx]);
        if com.next <> nil then
        begin
          gen.WriteLine(' or');
          gen.Write('     ');
        end;
        com := com.next;
        Inc(comIdx);
      end;
      gen.Write(' then exit(NextToken);');
    end;
    if hasCtxMoves then
    begin
      gen.WriteLine;
      gen.Write('  var apx := 0;');
    end; // pdt
    g.CopyFramePart('-->scan3<');
    state := firstState.next;
    while state <> nil do
    begin
      WriteState(state);
      state := state.next;
    end;
    g.CopyFramePart('');
    gen.Close;
  finally
    g.Free;
  end;
end;

end.

