open Format
open Instruction

let sep_cma fmt () = fprintf fmt ", "
let sep_brk fmt () = fprintf fmt "\n"


let pp_lst_cma p = pp_print_list ~pp_sep:sep_cma p

let pp_lst_brk p = pp_print_list ~pp_sep:sep_brk p

let pp_size fmt = function
  | W -> fprintf fmt "W"
  | H -> fprintf fmt "H"
  | B -> fprintf fmt "B"
  | DW -> fprintf fmt "DW"

let pp_mode fmt = function
  | IMM -> fprintf fmt "IMM"
  | ABS -> fprintf fmt "ABS"
  | IND -> fprintf fmt "IND"
  | MEM -> fprintf fmt "MEM"
  | MEMSX -> fprintf fmt "MEMSX"
  | ATOMIC -> fprintf fmt "ATOMIC"

let pp_source fmt = function
  | K -> fprintf fmt "K"
  | X -> fprintf fmt "X"

let pp_code_alu fmt = function
  | ADD -> fprintf fmt "ADD"
  | SUB -> fprintf fmt "SUB"
  | MUL -> fprintf fmt "MUL"
  | DIV -> fprintf fmt "DIV"
  | OR -> fprintf fmt "OR"
  | AND -> fprintf fmt "AND"
  | LSH -> fprintf fmt "LSH"
  | RSH -> fprintf fmt "RSH"
  | NEG -> fprintf fmt "NEG"
  | MOD -> fprintf fmt "MOD"
  | XOR -> fprintf fmt "XOR"
  | MOV -> fprintf fmt "MOV"
  | ARSH -> fprintf fmt "ARSH"
  | END -> fprintf fmt "END"

let pp_code_jmp fmt = function
  | JA -> fprintf fmt "JA"
  | JEQ -> fprintf fmt "JEQ"
  | JGT -> fprintf fmt "JGT"
  | JGE -> fprintf fmt "JGE"
  | JSET -> fprintf fmt "JSET"
  | JNE -> fprintf fmt "JNE"
  | JSGT -> fprintf fmt "JSGT"
  | JSGE -> fprintf fmt "JSGE"
  | CALL -> fprintf fmt "CALL"
  | EXIT -> fprintf fmt "EXIT"
  | JLT -> fprintf fmt "JLT"
  | JLE -> fprintf fmt "JLE"
  | JSLT -> fprintf fmt "JSLT"
  | JSLE -> fprintf fmt "JSLE"

let pp_opcode fmt = function
  | LD (s, m) -> fprintf fmt "LD(%a,%a)" pp_size s pp_mode m
  | LDX (s, m) -> fprintf fmt "LDX(%a,%a)" pp_size s pp_mode m
  | ST (s, m) -> fprintf fmt "ST(%a,%a)" pp_size s pp_mode m
  | STX (s, m) -> fprintf fmt "STX(%a,%a)" pp_size s pp_mode m
  | ALU (src, op) -> fprintf fmt "ALU(%a,%a)" pp_source src pp_code_alu op
  | JMP (src, op) -> fprintf fmt "JMP(%a,%a)" pp_source src pp_code_jmp op
  | JMP32 (src, op) -> fprintf fmt "JMP32(%a,%a)" pp_source src pp_code_jmp op
  | ALU64 (src, op) -> fprintf fmt "ALU64(%a,%a)" pp_source src pp_code_alu op

let rec pp_instr fmt (opcode, dst_reg, src_reg, offset, imm) =
  fprintf fmt "instr(%a, dst=%d, src=%d, offset=%d, imm=%ld)"
    pp_opcode opcode dst_reg src_reg offset imm
and pp_instrs fmt ins = pp_lst_brk pp_instr fmt ins

let pp_text instrs =
  printf "%a@." pp_instrs instrs
