open Format
open Instruction
open Info
open Fonctions
open Table

(* Instructions *)
let sep_cma fmt () = fprintf fmt ", "
let sep_brk fmt () = fprintf fmt "\n"
let pp_lst_cma p = pp_print_list ~pp_sep:sep_cma p
let pp_lst_brk p = pp_print_list ~pp_sep:sep_brk p

let pp_size fmt = function
  | W -> fprintf fmt "W"
  | H -> fprintf fmt "H"
  | B -> fprintf fmt "B"
  | DW -> fprintf fmt "DW"

let pp_atomic_op fmt = function
  | ADD_ATOMIC -> fprintf fmt "ADD"
  | OR_ATOMIC -> fprintf fmt "OR"
  | AND_ATOMIC -> fprintf fmt "AND"
  | XOR_ATOMIC -> fprintf fmt "XOR"
  | XCHG -> fprintf fmt "XCHG"
  | CMPXCHG -> fprintf fmt "CMPXCHG"

let pp_atomic_flag fmt = function
  | NO_FETCH -> fprintf fmt "NO_FETCH"
  | WITH_FETCH -> fprintf fmt "WITH_FETCH"

let pp_mode fmt = function
  | IMM -> fprintf fmt "IMM"
  | ABS -> fprintf fmt "ABS"
  | IND -> fprintf fmt "IND"
  | MEM -> fprintf fmt "MEM"
  | MEMSX -> fprintf fmt "MEMSX"
  | ATOMIC (op, flag) ->
      fprintf fmt "ATOMIC(%a,%a)" pp_atomic_op op pp_atomic_flag flag

let pp_byte_swap fmt = function
  | LE_BS -> fprintf fmt "LE"
  | BE_BS -> fprintf fmt "BE"
  | RESERVED_BS -> fprintf fmt "RESERVED"

let pp_ja_type fmt = function
  | OFFSET_JA -> fprintf fmt "OFFSET_JA"
  | IMM_JA -> fprintf fmt "IMM_JA"

let pp_source fmt = function K -> fprintf fmt "K" | X -> fprintf fmt "X"

let pp_code_alu fmt = function
  | ADD -> fprintf fmt "ADD"
  | SUB -> fprintf fmt "SUB"
  | MUL -> fprintf fmt "MUL"
  | DIV -> fprintf fmt "DIV"
  | SDIV -> fprintf fmt "SDIV"
  | OR -> fprintf fmt "OR"
  | AND -> fprintf fmt "AND"
  | LSH -> fprintf fmt "LSH"
  | RSH -> fprintf fmt "RSH"
  | NEG -> fprintf fmt "NEG"
  | MOD -> fprintf fmt "MOD"
  | SMOD -> fprintf fmt "SMOD"
  | XOR -> fprintf fmt "XOR"
  | MOV -> fprintf fmt "MOV"
  | MOVSX n -> fprintf fmt "MOVSX(%d)" n
  | ARSH -> fprintf fmt "ARSH"
  | END bs -> fprintf fmt "END(%a)" pp_byte_swap bs

let pp_call_from fmt = function
  | STATIC_ID -> fprintf fmt "STATIC_ID"
  | CALL_IMM -> fprintf fmt "CALL_IMM"
  | BTF_ID -> fprintf fmt "BTF_ID"

let pp_reloc_type fmt = function
  | R_BPF_64_64 -> fprintf fmt "R_BPF_64_64"
  | R_BPF_64_32 -> fprintf fmt "R_BPF_64_32"
  | OTHER_RELOC s -> fprintf fmt "%s" s

let pp_code_jmp fmt = function
  | JA t -> fprintf fmt "JA(%a)" pp_ja_type t
  | JEQ -> fprintf fmt "JEQ"
  | JGT -> fprintf fmt "JGT"
  | JGE -> fprintf fmt "JGE"
  | JSET -> fprintf fmt "JSET"
  | JNE -> fprintf fmt "JNE"
  | JSGT -> fprintf fmt "JSGT"
  | JSGE -> fprintf fmt "JSGE"
  | CALL call_from -> fprintf fmt "CALL(%a)" pp_call_from call_from
  | EXIT -> fprintf fmt "EXIT"
  | JLT -> fprintf fmt "JLT"
  | JLE -> fprintf fmt "JLE"
  | JSLT -> fprintf fmt "JSLT"
  | JSLE -> fprintf fmt "JSLE"

let pp_wide_type fmt = function
  | INTEGER -> fprintf fmt "INTEGER"
  | MAP_BY_FD -> fprintf fmt "MAP_BY_FD"
  | MAP_VAL_FD -> fprintf fmt "MAP_VAL_FD"
  | VAR_ADDR -> fprintf fmt "VAR_ADDR"
  | CODE_ADDR -> fprintf fmt "CODE_ADDR"
  | MAP_BY_IDX -> fprintf fmt "MAP_BY_IDX"
  | MAP_VAL_IDX -> fprintf fmt "MAP_VAL_IDX"

let pp_opcode fmt = function
  | LD (s, m) -> fprintf fmt "LD(%a,%a)" pp_size s pp_mode m
  | LDX (s, m) -> fprintf fmt "LDX(%a,%a)" pp_size s pp_mode m
  | ST (s, m) -> fprintf fmt "ST(%a,%a)" pp_size s pp_mode m
  | STX (s, m) -> fprintf fmt "STX(%a,%a)" pp_size s pp_mode m
  | ALU (src, op) -> fprintf fmt "ALU(%a,%a)" pp_source src pp_code_alu op
  | JMP (src, op) -> fprintf fmt "JMP(%a,%a)" pp_source src pp_code_jmp op
  | JMP32 (src, op) -> fprintf fmt "JMP32(%a,%a)" pp_source src pp_code_jmp op
  | ALU64 (src, op) -> fprintf fmt "ALU64(%a,%a)" pp_source src pp_code_alu op

let pp_instr fmt = function
  | BASIC (opcode, dst_reg, src_reg, offset, imm) ->
      fprintf fmt "instr(%a, dst=%d, src=%d, offset=%d, imm=%ld)" pp_opcode
        opcode dst_reg src_reg offset imm
  | WIDE (opcode, wide_type, dst_reg, src_reg, offset, imm) ->
      fprintf fmt "instr64(%a, %a, dst=%d, src=%d, offset=%d, imm=%Ldll)"
        pp_opcode opcode pp_wide_type wide_type dst_reg src_reg offset imm

let pp_line fmt (n, instr) = fprintf fmt "%d : %a" n pp_instr instr

let rec pp_typ fmt = function
  | ARRAY (t, n) -> fprintf fmt "array(%a, l.%d)" pp_typ t n
  | PTR t -> fprintf fmt "ptr(%a)" pp_typ t
  | INT size -> fprintf fmt "int(m.%d)" size
  | STRUCT (s, l) -> fprintf fmt "struct(s.%d, v.%d)" s l
  | DATASEC -> fprintf fmt "datasec"
  | OTHER s -> fprintf fmt "other(%s)" s
  | ELF -> fprintf fmt "elf"

let rec pp_info fmt = function
  | BPF_FUNC s -> fprintf fmt "call_bpf(%s)" s
  | CALL_DEST (target, value) ->
      fprintf fmt "call_dest(%s,%Ld)" target value
  | LOAD_DEST (target, value) ->
      fprintf fmt "load_dest(%s,%Ld)" target value
  | TYP typ -> fprintf fmt "typ(%a)" pp_typ typ
and pp_infos fmt infos = pp_lst_cma pp_info fmt infos

let rec pp_lineInfo fmt (line, infos) =
  fprintf fmt "%a ~ %a" pp_line line pp_infos infos
and pp_lineInfos fmt li = pp_lst_brk pp_lineInfo fmt li

let pp_fonction fmt (fonction : fonction) =
  fprintf fmt "%s [bind=%s, entry=%b]@.%a" fonction.name fonction.bind fonction.is_entry pp_lineInfos fonction.code
