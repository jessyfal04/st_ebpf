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
  if v land 0x8000 <> 0 then v - 0x10000 else v

(* 7b1af8ff00000000 4 32 -> int32 *)
let parse32 line byte_index =
  let b0 = Int32.of_int (byte_of_line line byte_index) in
  let b1 =
    Int32.shift_left (Int32.of_int (byte_of_line line (byte_index + 1))) 8
  in
  let b2 =
    Int32.shift_left (Int32.of_int (byte_of_line line (byte_index + 2))) 16
  in
  let b3 =
    Int32.shift_left (Int32.of_int (byte_of_line line (byte_index + 3))) 24
  in
  Int32.logor b0 (Int32.logor b1 (Int32.logor b2 b3))

let i32_to_i64 x = Int64.logand (Int64.of_int32 x) 0xffffffffL

let parse64 imm next_imm =
  Int64.logor (i32_to_i64 imm) (Int64.shift_left (i32_to_i64 next_imm) 32)

(* TYPES *)
(* The size modifier *)
type size =
  | W  (** word = 4B *)
  | H  (** half word = 2B *)
  | B  (** byte = 1B *)
  | DW (* double word = 8B *)

type atomic_op =
  | ADD_ATOMIC
  | OR_ATOMIC
  | AND_ATOMIC
  | XOR_ATOMIC (*atomic add / or / and / xor *)
  | XCHG (* atomic exchange *)
  | CMPXCHG (* atomic compare and exchange *)

type atomic_flag = NO_FETCH | WITH_FETCH (* modifier: return old value *)

(* The mode modifier *)
type mode =
  | IMM (* 64-bit immediate instructions *)
  | ABS (* legacy BPF packet access (absolute) *)
  | IND (* legacy BPF packet access (indirect) *)
  | MEM (* regular load and store operations *)
  | MEMSX (* sign-extension load operations *)
  | ATOMIC of atomic_op * atomic_flag (* atomic operations *)

type source =
  | K (* use 32-bit 'imm' value as source operand *)
  | X (* use 'src' register value as source operand *)

type byte_swap = LE_BS | BE_BS | RESERVED_BS

(* The code field for ALU instructions *)
type code_alu =
  | ADD (* dst += src *)
  | SUB (* dst -= src *)
  | MUL (* dst *= src *)
  | DIV (* dst = (src != 0) ? (dst / src) : 0 *)
  | SDIV (* dst = (src != 0) ? (dst s/ src) : 0 *)
  | OR (* dst |= src *)
  | AND (* dst &= src *)
  | LSH (* dst <<= (src & mask) *)
  | RSH (* dst >>= (src & mask) *)
  | NEG (* dst = -dst *)
  | MOD (* dst = (src != 0) ? (dst % src) : dst *)
  | SMOD (* dst = (src != 0) ? (dst s% src) : dst *)
  | XOR (* dst ^= src *)
  | MOV (* dst = src *)
  | MOVSX of int (* dst = (s8,s16,s32)src *)
  | ARSH (* sign extending shift right *)
  | END of byte_swap (* byte swap operations *)

type call_from = STATIC_ID | CALL_IMM | BTF_ID
type ja_type = OFFSET_JA | IMM_JA

(* The code field for jump instructions *)
type code_jmp =
  | JA of ja_type
    (* PC += offset, {JA, K, JMP} | PC += imm, {JA, K, JMP32} only ; src = 0 *)
  | JEQ (* PC += offset if dst == src *)
  | JGT (* PC += offset if dst > src, unsigned *)
  | JGE (* PC += offset if dst >= src, unsigned *)
  | JSET (* PC += offset if dst & src *)
  | JNE (* PC += offset if dst != src *)
  | JSGT (* PC += offset if dst > src, signed *)
  | JSGE (* PC += offset if dst >= src, signed *)
  | CALL of call_from
    (* src = 0,1,2 -> call helper function by static ID, call PC += imm, call helper function by BTF ID *)
  | EXIT (* return *)
  | JLT (* C += offset if dst < src, unsigned *)
  | JLE (* PC += offset if dst <= src, unsigned *)
  | JSLT (* PC += offset if dst < src, signed *)
  | JSLE (* PC += offset if dst <= src, signed *)

(* Instruction kind and operands *)
type opcode =
  | LD of size * mode (*non-standard load operations*)
  | LDX of size * mode (*load into register operations*)
  | ST of size * mode (*store from immediate operations*)
  | STX of size * mode (*store from register operations*)
  | ALU of source * code_alu (*32-bit arithmetic operations*)
  | JMP of source * code_jmp (*64-bit jump operations*)
  | JMP32 of source * code_jmp (*32-bit jump operations*)
  | ALU64 of source * code_alu (*64-bit arithmetic operations*)

type wide_type =
  | INTEGER (* dst = (next_imm << 32) | imm, integer, integer *)
  | MAP_BY_FD (* dst = map_by_fd(imm), map fd, map *)
  | MAP_VAL_FD
    (* dst = map_val(map_by_fd(imm)) + next_imm, map fd, data adress *)
  | VAR_ADDR (* dst = var_addr(imm), variable id, data address *)
  | CODE_ADDR (* dst = code_addr(imm), integer, code address *)
  | MAP_BY_IDX (* dst = map_by_idx(imm), map index, map *)
  | MAP_VAL_IDX
(* dst = map_val(map_by_idx(imm)) + next_imm, map index, data address*)

type imm32 = int32 (*signed integer immediate value*)
type imm64 = int64

type instr =
  | BASIC of opcode * int * int * int * imm32
  | WIDE of opcode * wide_type * int * int * int * imm64

type line = int * instr

(* REVOLVERS *)
let register_resolver reg =
  if 0 <= reg && reg <= 10 then reg else failwith "Invalid register"

(* For load and store instructions (LD, LDX, ST, and STX), the 8-bit opcode field is divided as follows *)
let size_resolver opcode : size =
  match lsb_bits_of_number opcode 3 2 with
  | 0 -> W
  | 1 -> H
  | 2 -> B
  | 3 -> DW
  | _ -> failwith "Invalid opcode_size"

let atomic_resolver imm : atomic_op =
  match Int32.to_int (Int32.logand imm 0xfel) with
  | 0x00 -> ADD_ATOMIC
  | 0x40 -> OR_ATOMIC
  | 0x50 -> AND_ATOMIC
  | 0xa0 -> XOR_ATOMIC
  | 0xe0 -> XCHG
  | 0xf0 -> CMPXCHG
  | _ -> failwith "Invalid atomic_resolver"

let atomic_flag_resolver imm : atomic_flag =
  match Int32.logand imm 0x01l with
  | 0l -> NO_FETCH
  | 1l -> WITH_FETCH
  | _ -> failwith "Invalid atomic_flag_resolver"

let mode_resolver opcode imm : mode =
  match lsb_bits_of_number opcode 5 3 with
  | 0 -> IMM
  | 1 -> ABS
  | 2 -> IND
  | 3 -> MEM
  | 4 -> MEMSX
  | 6 -> ATOMIC (atomic_resolver imm, atomic_flag_resolver imm)
  | _ -> failwith "Invalid opcode_mode"

(* the source operand location, which unless otherwise specified is one of *)
let source_resolver opcode : source =
  match lsb_bits_of_number opcode 3 1 with
  | 0 -> K
  | 1 -> X
  | _ -> failwith "Invalid opcode_source"

let byte_swap_resolver is_alu64 opcode : byte_swap =
  let bit1bs = lsb_bits_of_number opcode 3 1 in
  match (is_alu64, bit1bs) with
  | false, 0 -> LE_BS
  | false, 1 -> BE_BS
  | true, 0 -> RESERVED_BS
  | _ -> failwith "Invalid byte_swap_resolver"

(* ALU uses 32-bit wide operands while ALU64 uses 64-bit wide operands for otherwise identical operations *)
let code_alu_resolver opcode offset imm is_alu64 : code_alu =
  let source = source_resolver opcode in
  let movsx_offsets = if is_alu64 then [ 8; 16; 32 ] else [ 8; 16 ] in
  match (lsb_bits_of_number opcode 4 4, offset) with
  | 0x0, 0 -> ADD
  | 0x1, 0 -> SUB
  | 0x2, 0 -> MUL
  | 0x3, 0 -> DIV
  | 0x3, 1 -> SDIV
  | 0x4, 0 -> OR
  | 0x5, 0 -> AND
  | 0x6, 0 -> LSH
  | 0x7, 0 -> RSH
  | 0x8, 0 when source = K ->
      NEG
      (*The NEG instruction is only defined when the source bit is clear (K).*)
  | 0x9, 0 -> MOD
  | 0x9, 1 -> SMOD
  | 0xa, 0 -> XOR
  | 0xb, 0 -> MOV
  | 0xb, s when source = X && List.mem s movsx_offsets ->
      MOVSX s (* MOVSX is only defined for register source operands (X). *)
  | 0xc, 0 -> ARSH
  | 0xd, 0 when List.mem (Int32.to_int imm) [ 16; 32; 64 ] ->
      END (byte_swap_resolver is_alu64 opcode)
  | _ -> failwith "Invalid code_alu"

(* The 'code' field encodes the jump operation *)
let code_jmp_resolver opcode src is_jmp32 : code_jmp =
  let source = source_resolver opcode in
  match (lsb_bits_of_number opcode 4 4, src) with
  | 0x0, _ when is_jmp32 = false -> JA OFFSET_JA
  | 0x0, _ when is_jmp32 = true -> JA IMM_JA
  | 0x1, _ -> JEQ
  | 0x2, _ -> JGT
  | 0x3, _ -> JGE
  | 0x4, _ -> JSET
  | 0x5, _ -> JNE
  | 0x6, _ -> JSGT
  | 0x7, _ -> JSGE
  | 0x8, 0 when source = K && is_jmp32 = false -> CALL STATIC_ID
  | 0x8, 1 when source = K && is_jmp32 = false -> CALL CALL_IMM
  | 0x8, 2 when source = K && is_jmp32 = false -> CALL BTF_ID
  | 0x9, 0 -> EXIT
  | 0xa, _ -> JLT
  | 0xb, _ -> JLE
  | 0xc, _ -> JSLT
  | 0xd, _ -> JSLE
  | _ -> failwith "Invalid code_jmp"

let opcode_resolver_checked opcode imm : opcode =
  let classCode = lsb_bits_of_number opcode 0 3 in
  let size = size_resolver opcode in
  let mode = mode_resolver opcode imm in

  match (classCode, mode, size) with
  | 1, m, s when not (m = MEMSX && not (s = B || s = H || s = W)) ->
      LDX (size, mode)
  | 3, m, s
    when not
           ((match m with ATOMIC _ -> true | _ -> false)
           && not (s = W || s = DW)) ->
      STX (size, mode)
  | _ -> failwith "Invalid opcode_resolver_ldst"

(* The three least significant bits of the 'opcode' field store the instruction class *)
let opcode_resolver opcode src offset imm : opcode =
  match lsb_bits_of_number opcode 0 3 with
  | 0 -> LD (size_resolver opcode, mode_resolver opcode imm)
  | 2 -> ST (size_resolver opcode, mode_resolver opcode imm)
  | 1 | 3 -> opcode_resolver_checked opcode imm
  | 4 -> ALU (source_resolver opcode, code_alu_resolver opcode offset imm false)
  | 5 -> JMP (source_resolver opcode, code_jmp_resolver opcode src false)
  | 6 -> JMP32 (source_resolver opcode, code_jmp_resolver opcode src true)
  | 7 -> ALU64 (source_resolver opcode, code_alu_resolver opcode offset imm true)
  | _ -> failwith "Invalid opcode_resolver"

(* The following table defines a set of {IMM, DW, LD} instructions with opcode subtypes in the 'src_reg' field, using new terms such as "map" defined further below:*)
let wide_type_resolver src : wide_type =
  match src with
  | 0x0 -> INTEGER
  | 0x1 -> MAP_BY_FD
  | 0x2 -> MAP_VAL_FD
  | 0x3 -> VAR_ADDR
  | 0x4 -> CODE_ADDR
  | 0x5 -> MAP_BY_IDX
  | 0x6 -> MAP_VAL_IDX
  | _ -> failwith "Invalid wide_type_resolver"

(* Parse une ligne *)
let rec parse_line32 line : instr =
  (* opcode 16 + 8 bits reg : 4 bits dst + 4 bits src *)
  let opcode = byte_of_line line 0 in

  let reg_byte = byte_of_line line 1 in
  let dst = register_resolver (lsb_bits_of_number reg_byte 0 4) in
  let src = register_resolver (lsb_bits_of_number reg_byte 4 4) in
  (* 16 bits offset *)
  let offset = parse16 line 2 in
  (* 32 bits : imm *)
  let imm = parse32 line 4 in

  let r_opcode = opcode_resolver opcode src offset imm in
  BASIC (r_opcode, dst, src, offset, imm)

and parse_line64 prev_instr next_line : instr =
  match (prev_instr, parse_line32 next_line) with
  (* imm + reserved : unused, set to zero + next_imm: second signed integer immediate value *)
  | ( BASIC (LD (DW, IMM), dst, src, off, imm),
      BASIC (LD (W, IMM), 0, 0, 0, next_imm) ) ->
      let wide_type = wide_type_resolver src in
      WIDE (LD (DW, IMM), wide_type, dst, 0, off, parse64 imm next_imm)
  | _ -> failwith "parse_line64"

(* {IMM, DW, LD} cas spécial 64-bit Immediate Instructions *)
let check64imm (instr : instr) : bool =
  match instr with BASIC (LD (DW, IMM), _, _, _, _) -> true | _ -> false

(* Traiter chaque ligne de 8 octects *)
let rec get_instrs acc text : instr list =
  try
    let line = input_line text in
    let instr = parse_line32 line in

    (* Verifier si la ligne a besoin d'un 64 bits*)
    let instrChecked64 =
      if check64imm instr then
        let line64 =
          try input_line text with End_of_file -> failwith "Missing line64"
        in
        parse_line64 instr line64
      else instr
    in

    get_instrs (instrChecked64 :: acc) text
  with End_of_file -> List.rev acc

let rec get_pcLines instrs offset acc : line list =
  match instrs with
  | (BASIC _ as i) :: l -> get_pcLines l (offset + 8) ((offset, i) :: acc)
  | (WIDE _ as i) :: l -> get_pcLines l (offset + 16) ((offset, i) :: acc)
  | [] -> List.rev acc

let parse_lines text =
  let instrs = get_instrs [] text in
  let lines = get_pcLines instrs 0 [] in
  lines
