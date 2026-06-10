open Format
open Instruction
open Info
open Fonctions

let sep_cma fmt () = fprintf fmt ", "
let sep_brk fmt () = fprintf fmt "\n"
let pp_lst_cma p = pp_print_list ~pp_sep:sep_cma p
let pp_lst_brk p = pp_print_list ~pp_sep:sep_brk p

let size_name = function
  | W -> "u32"
  | H -> "u16"
  | B -> "u8"
  | DW -> "u64"

let signed_size_name = function
  | W -> "s32"
  | H -> "s16"
  | B -> "s8"
  | DW -> "s64"

let reg_name reg = Printf.sprintf "r%d" reg

let signed_suffix_int offset =
  if offset < 0 then Printf.sprintf " - %d" (-offset)
  else Printf.sprintf " + %d" offset

let signed_suffix_int32 imm =
  if imm < 0l then Printf.sprintf " - %ld" (Int32.neg imm)
  else Printf.sprintf " + %ld" imm

let pp_offset64 offset =
  if offset = 0L then ""
  else if offset < 0L then Printf.sprintf " - %Ld" (Int64.neg offset)
  else Printf.sprintf " + %Ld" offset

let source_operand source src_reg imm =
  match source with
  | K -> Int32.to_string imm
  | X -> reg_name src_reg

let atomic_name = function
  | ADD_ATOMIC -> "atomic_add"
  | OR_ATOMIC -> "atomic_or"
  | AND_ATOMIC -> "atomic_and"
  | XOR_ATOMIC -> "atomic_xor"
  | XCHG -> "atomic_xchg"
  | CMPXCHG -> "atomic_cmpxchg"

let rec find_info f = function
  | [] -> None
  | x :: xs -> (
      match f x with
      | Some v -> Some v
      | None -> find_info f xs)

let call_dest infos =
  find_info (function CALL_DEST (name, target) -> Some (name, target) | _ -> None) infos

let call_name infos =
  match call_dest infos with
  | Some (name, _) -> Some name
  | None ->
      find_info (function BPF_FUNC name -> Some name | _ -> None) infos

let goto_dest infos = find_info (function GOTO_DEST line -> Some line | _ -> None) infos

let load_dest infos =
  find_info (function LOAD_DEST (target, offset) -> Some (target, offset) | _ -> None) infos

let rec pp_struct_member fmt = function
  | name, _, typ -> fprintf fmt "%s:%a" name pp_typ typ

and pp_datasec_entry fmt = function
  | name, _, _, typ -> fprintf fmt "%s:%a" name pp_typ typ

and pp_typ fmt = function
  | ARRAY (t, n) -> fprintf fmt "array_%d(%a)" n pp_typ t
  | PTR t -> fprintf fmt "ptr(%a)" pp_typ t
  | INT size -> fprintf fmt "int_%d" size
  | STRUCT (_s, _l, members) ->
      fprintf fmt "struct([%a])" (pp_lst_cma pp_struct_member) members
  | DATASEC (name, entry) ->
      fprintf fmt "datasec(%s,%a)" name pp_datasec_entry entry
  | OTHER s -> fprintf fmt "other(%s)" s
  | ELF -> fprintf fmt "elf"

let type_suffix infos =
  let rec aux acc = function
    | [] -> List.rev acc
    | TYP typ :: rest -> aux (Printf.sprintf "<%s>" (Format.asprintf "%a" pp_typ typ) :: acc) rest
    | _ :: rest -> aux acc rest
  in
  match aux [] infos with
  | [] -> ""
  | ts -> " " ^ String.concat " " ts

let pp_mem_addr reg offset =
  Printf.sprintf "%s%s" (reg_name reg) (signed_suffix_int offset)

let pp_packet_addr imm =
  Printf.sprintf "packet%s" (signed_suffix_int32 imm)

let pp_packet_indirect src_reg imm =
  Printf.sprintf "packet + %s%s" (reg_name src_reg) (signed_suffix_int32 imm)

let pp_mem_load size dst src offset signed =
  let ty = if signed then signed_size_name size else size_name size in
  Printf.sprintf "%s = *(%s *)(%s)" (reg_name dst) ty (pp_mem_addr src offset)

let pp_mem_store size dst offset value =
  Printf.sprintf "*(%s *)(%s) = %s" (size_name size) (pp_mem_addr dst offset) value

let pp_atomic size dst offset src flag op =
  let ptr = Printf.sprintf "*(%s *)(%s)" (size_name size) (pp_mem_addr dst offset) in
  let call = Printf.sprintf "%s(%s, %s)" (atomic_name op) ptr (reg_name src) in
  match flag with
  | NO_FETCH -> call
  | WITH_FETCH -> Printf.sprintf "%s = %s" (reg_name dst) call

let pp_alu width source op dst src imm =
  let dst = reg_name dst in
  let operand = source_operand source src imm in
  let signed_operand = if width then "(s64)" else "(s32)" in
  match op with
  | ADD -> Printf.sprintf "%s += %s" dst operand
  | SUB -> Printf.sprintf "%s -= %s" dst operand
  | MUL -> Printf.sprintf "%s *= %s" dst operand
  | DIV -> Printf.sprintf "%s /= %s" dst operand
  | SDIV -> Printf.sprintf "%s s/= %s" dst operand
  | OR -> Printf.sprintf "%s |= %s" dst operand
  | AND -> Printf.sprintf "%s &= %s" dst operand
  | LSH -> Printf.sprintf "%s <<= %s" dst operand
  | RSH -> Printf.sprintf "%s >>= %s" dst operand
  | NEG -> Printf.sprintf "%s = -%s" dst dst
  | MOD -> Printf.sprintf "%s %%= %s" dst operand
  | SMOD -> Printf.sprintf "%s s%%= %s" dst operand
  | XOR -> Printf.sprintf "%s ^= %s" dst operand
  | MOV -> Printf.sprintf "%s = %s" dst operand
  | MOVSX n ->
      Printf.sprintf "%s = (%s)(%s)%s" dst signed_operand
        (signed_size_name (if n = 8 then B else if n = 16 then H else W))
        (reg_name src)
  | ARSH -> Printf.sprintf "%s s>>= %s" dst operand
  | END bs ->
      let bits = Int32.to_int imm in
      let name =
        match bs with
        | LE_BS -> "le"
        | BE_BS -> "be"
        | RESERVED_BS -> "bswap"
      in
      Printf.sprintf "%s = %s%d(%s)" dst name bits dst

let pp_jump_target infos fallback =
  match goto_dest infos with
  | Some line -> Printf.sprintf "goto %d" line
  | None -> fallback

let pp_jump infos width source code dst src offset imm =
  let signed_cast = if width then "(s64)" else "(s32)" in
  let unsigned_cast = if width then "(u64)" else "(u32)" in
  let operand = source_operand source src imm in
  let rel_target = pp_jump_target infos (Printf.sprintf "goto %+d" offset) in
  match code with
  | JA OFFSET_JA -> rel_target
  | JA IMM_JA ->
      pp_jump_target infos (Printf.sprintf "goto %s" (Int32.to_string imm))
  | CALL STATIC_ID -> (
      match call_name infos with
      | Some name -> Printf.sprintf "call %s" name
      | None -> Printf.sprintf "call %s" (Int32.to_string imm))
  | CALL CALL_IMM -> (
      match call_dest infos with
      | Some (name, target) when target >= 0L ->
          Printf.sprintf "call %s @%Ld" name target
      | Some (name, _) -> Printf.sprintf "call %s" name
      | None -> (
          match call_name infos with
          | Some name -> Printf.sprintf "call %s" name
          | None -> Printf.sprintf "call %s" (Int32.to_string imm)))
  | CALL BTF_ID -> Printf.sprintf "call btf[%s]" (Int32.to_string imm)
  | EXIT -> "return"
  | JEQ ->
      Printf.sprintf "if %s%s == %s%s %s" unsigned_cast (reg_name dst)
        unsigned_cast operand rel_target
  | JGT ->
      Printf.sprintf "if %s%s > %s%s %s" unsigned_cast (reg_name dst)
        unsigned_cast operand rel_target
  | JGE ->
      Printf.sprintf "if %s%s >= %s%s %s" unsigned_cast (reg_name dst)
        unsigned_cast operand rel_target
  | JSET ->
      Printf.sprintf "if (%s%s & %s%s) != 0 %s" unsigned_cast (reg_name dst)
        unsigned_cast operand rel_target
  | JNE ->
      Printf.sprintf "if %s%s != %s%s %s" unsigned_cast (reg_name dst)
        unsigned_cast operand rel_target
  | JSGT ->
      Printf.sprintf "if %s%s > %s%s %s" signed_cast (reg_name dst)
        signed_cast operand rel_target
  | JSGE ->
      Printf.sprintf "if %s%s >= %s%s %s" signed_cast (reg_name dst)
        signed_cast operand rel_target
  | JLT ->
      Printf.sprintf "if %s%s < %s%s %s" unsigned_cast (reg_name dst)
        unsigned_cast operand rel_target
  | JLE ->
      Printf.sprintf "if %s%s <= %s%s %s" unsigned_cast (reg_name dst)
        unsigned_cast operand rel_target
  | JSLT ->
      Printf.sprintf "if %s%s < %s%s %s" signed_cast (reg_name dst)
        signed_cast operand rel_target
  | JSLE ->
      Printf.sprintf "if %s%s <= %s%s %s" signed_cast (reg_name dst)
        signed_cast operand rel_target

let pp_wide infos wide_type dst imm64 =
  let types = type_suffix infos in
  let base =
    match load_dest infos with
    | Some (target, offset) -> Printf.sprintf "&%s%s" target (pp_offset64 offset)
    | None ->
        match wide_type with
        | INTEGER -> Int64.to_string imm64
        | MAP_BY_FD -> Printf.sprintf "map_by_fd(%Ld)" imm64
        | MAP_VAL_FD -> Printf.sprintf "map_val(map_by_fd(%Ld))" imm64
        | VAR_ADDR -> Printf.sprintf "var_addr(%Ld)" imm64
        | CODE_ADDR -> Printf.sprintf "code_addr(%Ld)" imm64
        | MAP_BY_IDX -> Printf.sprintf "map_by_idx(%Ld)" imm64
        | MAP_VAL_IDX -> Printf.sprintf "map_val(map_by_idx(%Ld))" imm64
  in
  Printf.sprintf "%s = %s%s" (reg_name dst) base types

let pp_instr infos = function
  | BASIC (opcode, dst_reg, src_reg, offset, imm) -> (
      match opcode with
      | LD (size, mode) -> (
          match mode with
          | IMM ->
              Printf.sprintf "%s = %s" (reg_name dst_reg) (Int32.to_string imm)
          | ABS ->
              Printf.sprintf "%s = *(%s *)(%s)" (reg_name dst_reg) (size_name size)
                (pp_packet_addr imm)
          | IND ->
              Printf.sprintf "%s = *(%s *)(%s)" (reg_name dst_reg) (size_name size)
                (pp_packet_indirect src_reg imm)
          | MEM -> pp_mem_load size dst_reg src_reg offset false
          | MEMSX -> pp_mem_load size dst_reg src_reg offset true
          | ATOMIC (op, flag) -> pp_atomic size dst_reg offset src_reg flag op)
      | LDX (size, mode) -> (
          match mode with
          | IMM ->
              Printf.sprintf "%s = %s" (reg_name dst_reg) (Int32.to_string imm)
          | ABS ->
              Printf.sprintf "%s = *(%s *)(%s)" (reg_name dst_reg) (size_name size)
                (pp_packet_addr imm)
          | IND ->
              Printf.sprintf "%s = *(%s *)(%s)" (reg_name dst_reg) (size_name size)
                (pp_packet_indirect src_reg imm)
          | MEM -> pp_mem_load size dst_reg src_reg offset false
          | MEMSX -> pp_mem_load size dst_reg src_reg offset true
          | ATOMIC (op, flag) -> pp_atomic size dst_reg offset src_reg flag op)
      | ST (size, mode) -> (
          match mode with
          | IMM ->
              pp_mem_store size dst_reg offset (Int32.to_string imm)
          | ABS ->
              Printf.sprintf "*(%s *)(%s) = %s" (size_name size)
                (pp_packet_addr imm) (Int32.to_string imm)
          | IND ->
              Printf.sprintf "*(%s *)(%s) = %s" (size_name size)
                (pp_packet_indirect src_reg imm) (Int32.to_string imm)
          | MEM -> pp_mem_store size dst_reg offset (Int32.to_string imm)
          | MEMSX -> pp_mem_store size dst_reg offset (Int32.to_string imm)
          | ATOMIC (op, flag) -> pp_atomic size dst_reg offset src_reg flag op)
      | STX (size, mode) -> (
          match mode with
          | MEM -> pp_mem_store size dst_reg offset (reg_name src_reg)
          | MEMSX -> pp_mem_store size dst_reg offset (reg_name src_reg)
          | ATOMIC (op, flag) -> pp_atomic size dst_reg offset src_reg flag op
          | IMM ->
              pp_mem_store size dst_reg offset (Int32.to_string imm)
          | ABS ->
              Printf.sprintf "*(%s *)(%s) = %s" (size_name size)
                (pp_packet_addr imm) (reg_name src_reg)
          | IND ->
              Printf.sprintf "*(%s *)(%s) = %s" (size_name size)
                (pp_packet_indirect src_reg imm) (reg_name src_reg))
      | ALU (source, op) -> pp_alu false source op dst_reg src_reg imm
      | JMP (source, code) -> pp_jump infos false source code dst_reg src_reg offset imm
      | JMP32 (source, code) ->
          pp_jump infos true source code dst_reg src_reg offset imm
      | ALU64 (source, op) -> pp_alu true source op dst_reg src_reg imm)
  | WIDE (opcode, wide_type, dst_reg, _src_reg, _offset, imm64) -> (
      match opcode with
      | LD (DW, IMM) -> pp_wide infos wide_type dst_reg imm64
      | _ -> failwith "Invalid WIDE instruction in pretty printer")

let pp_lineInfo fmt ((line, instr), infos) =
  fprintf fmt "%d : %s" line (pp_instr infos instr)

let pp_lineInfos fmt li =
  pp_lst_brk pp_lineInfo fmt li

let pp_fonction fmt (fonction : fonction) =
  fprintf fmt "%s [bind=%s, entry=%b]@.%a" fonction.name fonction.bind
    fonction.is_entry pp_lineInfos fonction.code
