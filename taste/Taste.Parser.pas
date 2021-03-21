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

unit Taste.Parser;

interface

uses
  System.Classes, System.SysUtils, System.Character, System.IOUtils,
  Oz.Cocor.Utils, Oz.Cocor.Lib, Taste.Scanner, Taste.Options, Taste.Tab, Taste.Gen;

type

{$Region 'TTasteParser'}

  TTasteParser= class(TBaseParser)
  const

    _EOFSym = 0;
    _identSym = 1;
    _numberSym = 2;
  private
    FTraceStream: TMemoryStream;
    genScanner: Boolean;
    procedure _AddOp(var op: TOp);
    procedure _Expr(var typ: TType);
    procedure _SimExpr(var typ: TType);
    procedure _RelOp(var op: TOp);
    procedure _Factor(var typ: TType);
    procedure _Ident(var name: string);
    procedure _MulOp(var op: TOp);
    procedure _ProcDecl;
    procedure _VarDecl;
    procedure _Stat;
    procedure _Term(var typ: TType);
    procedure _Taste;
    procedure _typ(var typ: TType);
  protected
    function Starts(s, kind: Integer): Boolean; override;
    procedure Get; override;
  public
    options: TOptions;
    trace: TStreamWriter;
    tab: TSymbolTable;
    gen: TCodeGenerator;
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
    function GetParser: TTasteParser;
    function GetScanner: TTasteScanner;
    function GetOptions: TOptions;
    function GetTab: TSymbolTable;
    function GetPgen: TCodeGenerator;
    function GetTrace: TTextWriter;
    function GetErrors: TErrors;
  public
    property parser: TTasteParser read GetParser;
    property scanner: TTasteScanner read GetScanner;
    property options: TOptions read GetOptions;
    property tab: TSymbolTable read GetTab;
    property gen: TCodeGenerator read GetPgen;
    property trace: TTextWriter read GetTrace;
    property errors: TErrors read GetErrors;
 end;

{$EndRegion}

implementation

{$Region 'TTasteParser'}

constructor TTasteParser.Create(scanner: TBaseScanner; listing: TStrings);
begin
  inherited Create(scanner, listing);
  options := GetOptions;
  FTraceStream := TMemoryStream.Create;
  trace := TStreamWriter.Create(FTraceStream);
  tab := TSymbolTable.Create(Self);
  gen := TCodeGenerator.Create(Self);
end;

destructor TTasteParser.Destroy;
begin
  trace.Free;
  tab.Free;
  gen.Free;
  FTraceStream.Free;
  inherited;
end;

procedure TTasteParser.SaveTraceToFile(const fileName: string);
begin
  FTraceStream.Position := 0;
  FTraceStream.SaveToFile(fileName);
  trace.Close;
end;

procedure TTasteParser.Get;
begin
  repeat
    t := la;
    la := scanner.Scan;
    if la.kind <= scanner.MaxToken then
    begin
      Inc(errDist);
      break;
    end;

    la := t;
  until False;
end;

procedure TTasteParser._AddOp(var op: TOp);
begin
  op := TOp.ADD;
  if la.kind = 3 then
  begin
    Get;
  end
  else if la.kind = 4 then
  begin
    Get;
    op := TOp.SUB;
  end
  else
    SynErr(30);
end;

procedure TTasteParser._Expr(var typ: TType);
var
  typ1: TType;
  op: TOp;
begin
  _SimExpr(typ);
  if (la.kind = 14) or (la.kind = 15) or (la.kind = 16) then
  begin
    _RelOp(op);
    _SimExpr(typ1);
    if typ <> typ1 then SemErr('incompatible types');
    gen.Emit(op);
    typ := TType.bool;
  end;
end;

procedure TTasteParser._SimExpr(var typ: TType);
var
  typ1: TType;
  op: TOp;
begin
  _Term(typ);
  while (la.kind = 3) or (la.kind = 4) do
  begin
    _AddOp(op);
    _Term(typ1);
    if (typ <> TType.int) or (typ1 <> TType.int) then
      SemErr('TType.int type expected');
    gen.Emit(op);
  end;
end;

procedure TTasteParser._RelOp(var op: TOp);
begin
  op := TOp.EQU;
  if la.kind = 14 then
  begin
    Get;
  end
  else if la.kind = 15 then
  begin
    Get;
    op := TOp.LSS;
  end
  else if la.kind = 16 then
  begin
    Get;
    op := TOp.GTR;
  end
  else
    SynErr(31);
end;

procedure TTasteParser._Factor(var typ: TType);
var
  n: Integer;
  obj: TObj;
  name: string;
begin
  typ := TType.undef;
  if la.kind = 1 then
  begin
    _Ident(name);
    obj := tab.Find(name);
    typ := obj.typ;
    if obj.kind = variable then
    begin
      if obj.level = 0 then
        gen.Emit(TOp.LOADG, obj.adr)
      else
        gen.Emit(TOp.LOAD, obj.adr);
    end else
      SemErr('variable expected');
  end
  else if la.kind = 2 then
  begin
    Get;
    n := StrToInt(t.val);
    gen.Emit(TOp.opCONST, n);
    typ := TType.int;
  end
  else if la.kind = 4 then
  begin
    Get;
    _Factor(typ);
    if typ <> TType.int then
    begin
      SemErr('TType.int type expected');
      typ := TType.int;
    end;
    gen.Emit(TOp.NEG);
  end
  else if la.kind = 5 then
  begin
    Get;
    gen.Emit(TOp.opCONST, 1);
    typ := TType.bool;
  end
  else if la.kind = 6 then
  begin
    Get;
    gen.Emit(TOp.opCONST, 0);
    typ := TType.bool;
  end
  else
    SynErr(32);
end;

procedure TTasteParser._Ident(var name: string);
begin
  Expect(1);
  name := t.val;
end;

procedure TTasteParser._MulOp(var op: TOp);
begin
  op := TOp.MUL;
  if la.kind = 7 then
  begin
    Get;
  end
  else if la.kind = 8 then
  begin
    Get;
    op := TOp.opDIV;
  end
  else
    SynErr(33);
end;

procedure TTasteParser._ProcDecl;
var
  name: string;
  obj: TObj;
  adr: Integer;
begin
  Expect(9);
  _Ident(name);
  obj := tab.NewObj(name, proc, TType.undef);
  obj.adr := gen.pc;
  if name = 'Main' then
    gen.progStart := gen.pc;
  tab.OpenScope;
  Expect(10);
  Expect(11);
  Expect(12);
  gen.Emit(TOp.ENTER, 0);
  adr := gen.pc - 2;
  while StartOf(1) do
  begin
    if (la.kind = 26) or (la.kind = 27) then
    begin
      _VarDecl;
    end
    else
    begin
      _Stat;
    end;
  end;
  Expect(13);
  gen.Emit(TOp.LEAVE);
  gen.Emit(TOp.RET);
  gen.Patch(adr, tab.topScope.nextAdr);
  tab.CloseScope;
end;

procedure TTasteParser._VarDecl;
var
  name: string;
  typ: TType;
begin
  _typ(typ);
  _Ident(name);
  tab.NewObj(name, variable, typ);
  while la.kind = 28 do
  begin
    Get;
    _Ident(name);
    tab.NewObj(name, variable, typ);
  end;
  Expect(18);
end;

procedure TTasteParser._Stat;
var
  typ: TType;
  name: string;
  obj: TObj;
  adr, adr2, loopstart: Integer;
begin
  case la.kind of
    1:
    begin
      _Ident(name);
      obj := tab.Find(name);
      if la.kind = 17 then
      begin
        Get;
        if obj.kind <> variable then
          SemErr('cannot assign to procedure');
        _Expr(typ);
        Expect(18);
        if typ <> obj.typ then
          SemErr('incompatible types');
        if obj.level = 0 then
          gen.Emit(TOp.STOG, obj.adr)
        else
          gen.Emit(TOp.STO, obj.adr);
      end
      else if la.kind = 10 then
      begin
        Get;
        Expect(11);
        Expect(18);
        if obj.kind <> proc then
          SemErr('object is not a procedure');
        gen.Emit(TOp.CALL, obj.adr);
      end
      else
        SynErr(34);
    end;
    19:
    begin
      Get;
      _Expr(typ);
      Expect(20);
      if typ <> TType.bool then
        SemErr('TType.bool type expected');
      gen.Emit(TOp.FJMP, 0);
      adr := gen.pc - 2;
      _Stat;
      if la.kind = 21 then
      begin
        Get;
        gen.Emit(TOp.JMP, 0);
        adr2 := gen.pc - 2;
        gen.Patch(adr, gen.pc);
        adr := adr2;
        _Stat;
      end;
      gen.Patch(adr, gen.pc);
    end;
    22:
    begin
      Get;
      loopstart := gen.pc;
      Expect(10);
      _Expr(typ);
      Expect(11);
      if typ <> TType.bool then
        SemErr('TType.bool type expected');
      gen.Emit(TOp.FJMP, 0);
      adr := gen.pc - 2;
      _Stat;
      gen.Emit(TOp.JMP, loopstart);
      gen.Patch(adr, gen.pc);
    end;
    23:
    begin
      Get;
      _Ident(name);
      Expect(18);
      obj := tab.Find(name);
      if obj.typ <> TType.int then
        SemErr('integer type expected');
      gen.Emit(TOp.READ);
      if obj.level = 0 then
        gen.Emit(TOp.STOG, obj.adr)
      else
        gen.Emit(TOp.STO, obj.adr);
    end;
    24:
    begin
      Get;
      _Expr(typ);
      Expect(18);
      if typ <> TType.int then
        SemErr('integer type expected');
      gen.Emit(TOp.WRITE);
    end;
    12:
    begin
      Get;
      while StartOf(1) do
      begin
        if StartOf(2) then
        begin
          _Stat;
        end
        else
        begin
          _VarDecl;
        end;
      end;
      Expect(13);
    end;
    else
      SynErr(35);
  end;
end;

procedure TTasteParser._Term(var typ: TType);
var
  typ1: TType;
  op: TOp;
begin
  _Factor(typ);
  while (la.kind = 7) or (la.kind = 8) do
  begin
    _MulOp(op);
    _Factor(typ1);
    if (typ <> TType.int) or (typ1 <> TType.int) then
      SemErr('integer type expected');
    gen.Emit(op);
  end;
end;

procedure TTasteParser._Taste;
var
  name: string;
begin
  Expect(25);
  _Ident(name);
  tab.OpenScope;
  Expect(12);
  while (la.kind = 9) or (la.kind = 26) or (la.kind = 27) do
  begin
    if (la.kind = 26) or (la.kind = 27) then
    begin
      _VarDecl;
    end
    else
    begin
      _ProcDecl;
    end;
  end;
  Expect(13);
  tab.CloseScope;
  if gen.progStart = -1 then
    SemErr('main function never defined');
end;

procedure TTasteParser._typ(var typ: TType);
begin
  typ := TType.undef;
  if la.kind = 26 then
  begin
    Get;
    typ := TType.int;
  end
  else if la.kind = 27 then
  begin
    Get;
    typ := TType.bool;
  end
  else
    SynErr(36);
end;

procedure TTasteParser.Parse;
begin
  la := scanner.NewToken;
  la.val := '';
  Get;
  _Taste;
  Expect(0);
end;

function TTasteParser.Starts(s, kind: Integer): Boolean;
const
  x = false;
  T = true;
  sets: array [0..2] of array [0..30] of Boolean = (
    (T,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,x,x, x,x,x),
    (x,T,x,x, x,x,x,x, x,x,x,x, T,x,x,x, x,x,x,T, x,x,T,T, T,x,T,T, x,x,x),
    (x,T,x,x, x,x,x,x, x,x,x,x, T,x,x,x, x,x,x,T, x,x,T,T, T,x,x,x, x,x,x));
begin
  Result := sets[s, kind];
end;

function TTasteParser.ErrorMsg(nr: Integer): string;
const
  MaxErr = 36;
  Errors: array [0 .. MaxErr] of string = (
    {0} 'EOF expected',
    {1} 'ident expected',
    {2} 'number expected',
    {3} '''+'' expected',
    {4} '''-'' expected',
    {5} '"true" expected',
    {6} '"false" expected',
    {7} '''*'' expected',
    {8} '''/'' expected',
    {9} '"procedure" expected',
    {10} '''('' expected',
    {11} ''')'' expected',
    {12} '''{'' expected',
    {13} '''}'' expected',
    {14} '''='' expected',
    {15} '''<'' expected',
    {16} '''>'' expected',
    {17} '":=" expected',
    {18} ''';'' expected',
    {19} '"if" expected',
    {20} '"then" expected',
    {21} '"else" expected',
    {22} '"while" expected',
    {23} '"read" expected',
    {24} '"write" expected',
    {25} '"program" expected',
    {26} '"Integer" expected',
    {27} '"boolean" expected',
    {28} ''','' expected',
    {29} '??? expected',
    {30} 'invalid AddOp',
    {31} 'invalid RelOp',
    {32} 'invalid Factor',
    {33} 'invalid MulOp',
    {34} 'invalid Stat',
    {35} 'invalid Stat',
    {36} 'invalid typ');
begin
  if nr <= MaxErr then
    Result := Errors[nr]
  else
    Result := 'error ' + IntToStr(nr);
end;

{$EndRegion}

{$Region 'TCocoPartHelper'}

function TCocoPartHelper.GetParser: TTasteParser;
begin
  Result := FParser as TTasteParser;
end;

function TCocoPartHelper.GetScanner: TTasteScanner;
begin
  Result := parser.scanner as TTasteScanner;
end;

function TCocoPartHelper.GetOptions: TOptions;
begin
  Result := parser.options;
end;

function TCocoPartHelper.GetTab: TSymbolTable;
begin
  Result := parser.tab;
end;

function TCocoPartHelper.GetPgen: TCodeGenerator;
begin
  Result := parser.gen;
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

