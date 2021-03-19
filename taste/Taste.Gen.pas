unit Taste.Gen;

interface

uses
  System.SysUtils;

type

  // opcodes
  TOp = (
    ADD, SUB, MUL, opDIV, EQU, LSS, GTR, NEG,
    LOAD, LOADG, STO, STOG, opCONST,
    CALL, RET, ENTER, LEAVE, JMP, FJMP, READ, WRITE);

  TCodeGenerator = class
  const
    opcode: array [TOp] of string = (
      'ADD  ', 'SUB  ', 'MUL  ', 'DIV  ', 'EQU  ', 'LSS  ', 'GTR  ', 'NEG  ',
      'LOAD ', 'LOADG', 'STO  ', 'STOG ', 'CONST', 'CALL ', 'RET  ', 'ENTER',
      'LEAVE', 'JMP  ', 'FJMP ', 'READ ', 'WRITE');
  private
    function Next: Integer;
    function Next2: Integer;
    function Int(b: Boolean): Integer;
  public
    // address of first instruction of main program
    progStart: Integer;
    // program counter
    pc: Integer;
    code: TBytes;
    // data for Interpret
    globals: TArray<Integer>;
    stack: TArray<Integer>;
    // top of stack
    sp: Integer;
    // base pointer
    bp: Integer;
    constructor Create;
    // code generation methods
    procedure Put(x: Integer);
    procedure Emit(op: TOp); overload;
    procedure Emit(op: TOp; val: Integer); overload;
    procedure Patch(adr, val: Integer);
    procedure Decode;
    // interpreter methods
    procedure Interpret(data: string);
  end;

implementation

constructor TCodeGenerator.Create;
begin
  inherited;
  SetLength(code, 3000);
  SetLength(globals, 100);
  SetLength(stack, 100);
  pc := 1;
  progStart := -1;
end;

procedure TCodeGenerator.Put(x: Integer);
begin
  code[pc] := byte(x);
  Inc(pc);
end;

procedure TCodeGenerator.Emit(op: TOp);
begin
  Put(Integer(op));
end;

procedure TCodeGenerator.Emit(op: TOp; val: Integer);
begin
  Emit(op);
  Put(val shr 8);
  Put(val);
end;

procedure TCodeGenerator.Patch(adr, val: Integer);
begin
  code[adr] := byte(val shr 8);
  code[adr + 1] := byte(val);
end;

procedure TCodeGenerator.Decode;
var
  code: TOp;
  maxPc: Integer;
  s: string;
begin
  maxPc := pc;
  pc := 1;
  while pc < maxPc do
  begin
    code := TOp(Next);
    s := Format('%d:3 : %d', [pc - 1, opcode[code]]);
    System.Write(s);
    case code of
      TOp.LOAD, TOp.LOADG, TOp.opCONST, TOp.STO, TOp.STOG,
      TOp.CALL, TOp.ENTER, TOp.JMP, TOp.FJMP:
        Writeln(Next2);
      TOp.ADD, TOp.SUB, TOp.MUL, TOp.opDIV, TOp.NEG,
      TOp.EQU, TOp.LSS, TOp.GTR, TOp.RET, TOp.LEAVE,
      TOp.READ, TOp.WRITE:
        Writeln;
    end;
  end;
end;

function TCodeGenerator.Next: Integer;
begin
  Result := code[pc];
  Inc(pc);
end;

function TCodeGenerator.Next2: Integer;
begin
  Integer x,y;
  x = (sbyte)code[pc++]; y = code[pc++];
  Result :=  (x << 8) + y;
end;

function TCodeGenerator.Int(b: Boolean): Integer;
begin
  if b then
    Result := 1
  else
    Result := 0;
end;

procedure TCodeGenerator.Push(Integer val);
begin
  stack[sp++] = val;
end;

Integer TCodeGenerator.Pop;
begin
  Result :=  stack[--sp];
end;

Integer TCodeGenerator.ReadInt(FileStream s);
begin
  Integer ch, sign;
  do beginch = s.ReadByte();end; while (!(ch >= '0' && ch <= '9' || ch == '-'));
  if (ch == '-') beginsign = -1; ch = s.ReadByte();end; else sign = 1;
  Integer n = 0;
  while (ch >= '0' && ch <= '9') begin
    n = 10 * n + (ch - '0');
    ch = s.ReadByte();
  end;
  Result :=  n * sign;
end;

procedure TCodeGenerator.Interpret(data: string);
begin
  Integer val;
  try begin
    FileStream s = new FileStream(data, FileMode.Open);
    Console.WriteLine();
    pc = progStart; stack[0] = 0; sp = 1; bp = 0;
    for (;;) begin
      switch ((TOp)Next()) begin
        case TOp.CONST: Push(Next2()); break;
        case TOp.LOAD:  Push(stack[bp+Next2()]); break;
        case TOp.LOADG: Push(globals[Next2()]); break;
        case TOp.STO:   stack[bp+Next2()] = Pop(); break;
        case TOp.STOG:  globals[Next2()] = Pop(); break;
        case TOp.ADD:   Push(Pop()+Pop()); break;
        case TOp.SUB:   Push(-Pop()+Pop()); break;
        case TOp.DIV:   val = Pop(); Push(Pop()/val); break;
        case TOp.MUL:   Push(Pop()*Pop()); break;
        case TOp.NEG:   Push(-Pop()); break;
        case TOp.EQU:   Push(Int(Pop()==Pop())); break;
        case TOp.LSS:   Push(Int(Pop()>Pop())); break;
        case TOp.GTR:   Push(Int(Pop()<Pop())); break;
        case TOp.JMP:   pc = Next2(); break;
        case TOp.FJMP:  val = Next2(); if (Pop()==0) pc = val; break;
        case TOp.READ:  val = ReadInt(s); Push(val); break;
        case TOp.WRITE: Console.WriteLine(Pop()); break;
        case TOp.CALL:  Push(pc+2); pc = Next2(); break;
        case TOp.RET:
           pc = Pop();
          if (pc == 0) Result := ; break;
        case TOp.ENTER: Push(bp); bp = sp; sp = sp + Next2(); break;
        case TOp.LEAVE: sp = bp; bp = Pop(); break;
        default:    throw new Exception('illegal opcode');
      end;
    end;
  end; catch (IOException) begin
    Console.WriteLine('--- Error accessing file begin0end;', data);
    System.Environment.Exit(0);
  end;
end;

end;

