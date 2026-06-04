(* FONCTIONS *)
(* int(01111011) 0 3 -> int(011) *)
let lsb_bits_of_number number offset size =
  let bits = number lsr offset in
  bits land ((1 lsl size) - 1)

(* 7b1af8ff00000000 0 8 -> int(7b) *)
let byte_of_line line byte_index =
  int_of_string ("0x" ^ String.sub line (byte_index * 2) 2)

(* 7b1af8ff00000000 2 16 -> int signed(fff8) *)
let parse16 line byte_index =
  let lo = byte_of_line line byte_index in
  let hi = byte_of_line line (byte_index + 1) in
  let v = lo lor (hi lsl 8) in
  (v lsl 16) asr 16

(* 7b1af8ff00000000 4 32 -> int32 *)
let parse32 line byte_index =
  let b0 = Int32.of_int (byte_of_line line byte_index) in
  let b1 = Int32.shift_left (Int32.of_int (byte_of_line line (byte_index + 1))) 8 in
  let b2 = Int32.shift_left (Int32.of_int (byte_of_line line (byte_index + 2))) 16 in
  let b3 = Int32.shift_left (Int32.of_int (byte_of_line line (byte_index + 3))) 24 in
  Int32.logor b0 (Int32.logor b1 (Int32.logor b2 b3))

(* TYPES *)
(* The size modifier *)
type size =
| W (** word = 4B *)
| H (** half word = 2B *)
| B (** byte *)
| DW (* double word = 8B *)

(* The mode modifier *)
type mode =
| IMM (* 64-bit immediate instructions *)
| ABS (* legacy BPF packet access (absolute) *)
| IND (* legacy BPF packet access (indirect) *)
| MEM (* regular load and store operations *)
| MEMSX (* sign-extension load operations *)
| ATOMIC (* atomic operations *)

type source =
| K (* use 32-bit 'imm' value as source operand *)
| X (* use 'src_reg' register value as source operand *)

(* The code field for ALU instructions *)
type code_alu =
| ADD   (* dst += src *)
| SUB   (* dst -= src *)
| MUL   (* dst *= src *)
| DIV   (* dst = (src != 0) ? (dst / src) : 0 *)
| OR    (* dst |= src *)
| AND   (* dst &= src *)
| LSH   (* dst <<= (src & mask) *)
| RSH   (* dst >>= (src & mask) *)
| NEG   (* dst = -dst *)
| MOD   (* dst = (src != 0) ? (dst % src) : dst *)
| XOR   (* dst ^= src *)
| MOV   (* dst = src *)
| ARSH  (* sign extending shift right *)
| END   (* byte swap operations *)

(* The code field for jump instructions *)
type code_jmp =
| JA   (* PC += offset, {JA, K, JMP} | PC += imm, {JA, K, JMP32} only ; src_reg = 0 *)
| JEQ  (* PC += offset if dst == src *)
| JGT  (* PC += offset if dst > src, unsigned *)
| JGE  (* PC += offset if dst >= src, unsigned *)
| JSET (* PC += offset if dst & src *)
| JNE  (* PC += offset if dst != src *)
| JSGT (* PC += offset if dst > src, signed *)
| JSGE (* PC += offset if dst >= src, signed *)
| CALL (* src_reg = 0,1,2 -> call helper function by static ID, call PC += imm, call helper function by BTF ID *)
| EXIT (* return *)
| JLT  (* C += offset if dst < src, unsigned *)
| JLE  (* PC += offset if dst <= src, unsigned *)
| JSLT (* PC += offset if dst < src, signed *)
| JSLE (* PC += offset if dst <= src, signed *)

(* Instruction kind and operands *)
type opcode =
| LD of size * mode (*non-standard load operations*)
| LDX of size * mode (*load into register operations*)
| ST of size * mode (*store from immediate operations*)
| STX of size * mode (*store from register operations*)
| ALU of source * code_alu(*32-bit arithmetic operations*)
| JMP of source * code_jmp (*64-bit jump operations*)
| JMP32 of source * code_jmp (*32-bit jump operations*)
| ALU64 of source * code_alu (*64-bit arithmetic operations*)

type dst_reg = int (*destination register number (0-10)*)
type src_reg = int (*the source register number (0-10), except where otherwise specified (64-bit immediate instructions reuse this field for other purposes)*)
type offset = int (*signed integer offset used with pointer arithmetic*)
type imm = int32 (*signed integer immediate value*)
type instr = opcode * dst_reg * src_reg * offset * imm

(* REVOLVERS *)
(* For load and store instructions (LD, LDX, ST, and STX), the 8-bit opcode field is divided as follows *)
let size_resolver opcode : size =
  match lsb_bits_of_number opcode 3 2 with
  | 0 -> W
  | 1 -> H
  | 2 -> B
  | 3 -> DW
  | _ -> failwith "Invalid opcode_size"

let mode_resolver opcode : mode =
  match lsb_bits_of_number opcode 5 3 with
  | 0 -> IMM
  | 1 -> ABS
  | 2 -> IND
  | 3 -> MEM
  | 4 -> MEMSX
  | 5 -> ATOMIC
  | _ -> failwith "Invalid opcode_mode"

(* the source operand location, which unless otherwise specified is one of *)
let source_resolver opcode : source =
  match lsb_bits_of_number opcode 3 1 with
  | 0 -> K
  | 1 -> X
  | _ -> failwith "Invalid opcode_source"

(* ALU uses 32-bit wide operands while ALU64 uses 64-bit wide operands for otherwise identical operations *)
let code_alu_resolver opcode : code_alu =
  match lsb_bits_of_number opcode 4 4 with
  | 0x0 -> ADD
  | 0x1 -> SUB
  | 0x2 -> MUL
  | 0x3 -> DIV
  | 0x4 -> OR
  | 0x5 -> AND
  | 0x6 -> LSH
  | 0x7 -> RSH
  | 0x8 -> NEG
  | 0x9 -> MOD
  | 0xa -> XOR
  | 0xb -> MOV
  | 0xc -> ARSH
  | 0xd -> END
  | _ -> failwith "Invalid code_alu"

(* The 'code' field encodes the jump operation *)
let code_jmp_resolver opcode : code_jmp =
  match lsb_bits_of_number opcode 4 4 with
  | 0x0 -> JA
  | 0x1 -> JEQ
  | 0x2 -> JGT
  | 0x3 -> JGE
  | 0x4 -> JSET
  | 0x5 -> JNE
  | 0x6 -> JSGT
  | 0x7 -> JSGE
  | 0x8 -> CALL
  | 0x9 -> EXIT
  | 0xa -> JLT
  | 0xb -> JLE
  | 0xc -> JSLT
  | 0xd -> JSLE
  | _ -> failwith "Invalid code_jmp"

(* The three least significant bits of the 'opcode' field store the instruction class *)
let opcode_resolver opcode : opcode =
  match lsb_bits_of_number opcode 0 3 with
  | 0 -> LD (size_resolver opcode, mode_resolver opcode)
  | 1 -> LDX (size_resolver opcode, mode_resolver opcode)
  | 2 -> ST (size_resolver opcode, mode_resolver opcode)
  | 3 -> STX (size_resolver opcode, mode_resolver opcode)
  | 4 -> ALU (source_resolver opcode, code_alu_resolver opcode)
  | 5 -> JMP (source_resolver opcode, code_jmp_resolver opcode)
  | 6 -> JMP32 (source_resolver opcode, code_jmp_resolver opcode)
  | 7 -> ALU64 (source_resolver opcode, code_alu_resolver opcode)
  | _ -> failwith "Invalid opcode_resolver"

(* Parse une ligne *)
let parse_line line : instr =
  (* Récupérer le opcode 16 *)
  let opcode = opcode_resolver (byte_of_line line 0) in
  
  (* 8 bits reg : 4 bits dst_reg + 4 bits src_reg *)
  let reg_byte = byte_of_line line 1 in
  let dst_reg = lsb_bits_of_number reg_byte 0 4 in
  let src_reg = lsb_bits_of_number reg_byte 4 4 in
  (* 16 bits offset *)
  let offset = parse16 line 2 in
  (* 32 bits : imm *)
  let imm = parse32 line 4 in
  (opcode, dst_reg, src_reg, offset, imm)

(* Traiter chaque ligne de 8 octects *)
let rec parse_lines acc text =
  try
    let line = input_line text in
    
    (* TODO Vérifier ICI que la ligne n'aurait pas besoin d'un double MOT *)

    let instr = parse_line line in

    parse_lines (instr :: acc) text
  with End_of_file ->
    acc
