(* Copyright (c) 1998, 2020 Томск, Шаймарданов Марат Шаймуратович *)
unit Oz.Cocor.Compiler;

interface

uses
  System.Classes, System.SysUtils, Oz.Cocor.Scanner, Oz.Cocor.Parser;

type

  TCompiler = class
  private
    FParser: TcrParser;
  public
    constructor Create(const src: string; lst: TStrings);
    destructor Destroy; override;
    procedure Compile;
    // Returns TRUE if no errors have been recorded while parsing
    function Ok: Boolean;
    property parser: TcrParser read FParser;
  end;

implementation

{ TCompiler }

constructor TCompiler.Create(const src: string; lst: TStrings);
begin
  inherited Create;
  FParser := TcrParser.Create(TcrScanner.Create(src), lst);
end;

destructor TCompiler.Destroy;
begin
  FParser.Free;
  inherited;
end;

procedure TCompiler.Compile;
begin
  try
    parser.Parse;
  except
    on e: Exception do
    begin
      parser.SemErr(e.Message);
    end;
  end;
end;

function TCompiler.Ok: Boolean;
begin
  Result := parser.errors.Count = 0;
end;

end.