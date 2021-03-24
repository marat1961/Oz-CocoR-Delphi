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

unit Taste.Tab;

interface

uses
  Oz.Cocor.Utils, Oz.Cocor.Lib;

{$T+}
{$SCOPEDENUMS ON}

type

  // type
  TType = (undef, int, bool);

  // object kind
  TObjKind = (&var, proc, scope);

  // object describing a declared name
  TObj = class
    name: string;     // name of the object
    typ: TType;       // type of the object (undef for proc)
    next: TObj;       // to next object in same scope
    kind: TObjKind;   // variable, proc, scope
    adr: Integer;     // address in memory or start of proc
    level: Integer;   // nesting level; 0=global, 1=local
    locals: TObj;     // scopes: to locally declared objects
    nextAdr: Integer; // scopes: next free address in this scope
  end;

  TSymbolTable = class(TCocoPart)
  var
    curLevel: Integer;  // nesting level of current scope
    undefObj: TObj;     // object node for erroneous symbols
    topScope: TObj;     // topmost procedure scope
  public
    constructor Create(parser: TBaseParser);
    // open a new scope and make it the current scope (topScope)
    procedure OpenScope;
    // close the current scope
    procedure CloseScope;
    // create a new object node in the current scope
    function NewObj(const name: string; kind: TObjKind; typ: TType): TObj;
    // search the name in all open scopes and return its object node
    function Find(const name: string): TObj;
  end;

implementation

uses
  Taste.Parser;

{$T+}
{$SCOPEDENUMS ON}

constructor TSymbolTable.Create(parser: TBaseParser);
begin
  inherited;
  topScope := nil;
  curLevel := -1;
  undefObj := TObj.Create;
  undefObj.name := 'undef';
  undefObj.typ := TType.undef;
  undefObj.kind := TObjKind.&var;
  undefObj.adr := 0;
  undefObj.level := 0;
  undefObj.next := nil;
end;

procedure TSymbolTable.OpenScope;
var
  scop: TObj;
begin
  scop := TObj.Create;
  scop.name := '';
  scop.kind := TObjKind.scope;
  scop.locals := nil;
  scop.nextAdr := 0;
  scop.next := topScope;
  topScope := scop;
  Inc(curLevel);
end;

procedure TSymbolTable.CloseScope;
begin
  topScope := topScope.next;
  Dec(curLevel);
end;

function TSymbolTable.NewObj(const name: string; kind: TObjKind; typ: TType): TObj;
var
  p, last, obj: TObj;
begin
  obj := TObj.Create;
  obj.name := name;
  obj.kind := kind;
  obj.typ := typ;
  obj.level := curLevel;
  p := topScope.locals;
  last := nil;
  while p <> nil do
  begin
    if p.name = name then
      parser.SemErr('name declared twice');
    last := p;
    p := p.next;
  end;
  if last = nil then
    topScope.locals := obj
  else
    last.next := obj;
  if kind = TObjKind.&var then
  begin
    obj.adr := topScope.nextAdr;
    Inc(topScope.nextAdr);
  end;
  Result := obj;
end;

function TSymbolTable.Find(const name: string): TObj;
var
  obj, scope: TObj;
begin
  scope := topScope;
  while scope <> nil do
  begin
    // for all open scopes
    obj := scope.locals;
    while obj <> nil do
    begin
      // for all objects in this scope
      if obj.name = name then exit(obj);
      obj := obj.next;
    end;
    scope := scope.next;
  end;
  parser.SemErr(name + ' is undeclared');
  Result := undefObj;
end;

end.
