type section = { idx : int; name : string; size : int64; typ : string }
type symbol_ndx = SECTION_NDX of int | OTHER_NDX of string
type reloc_type = R_BPF_64_64 | R_BPF_64_32 | OTHER_RELOC of string

type symbol = {
  value : int64;
  size : int;
  typ : string;
  bind : string;
  ndx : symbol_ndx;
  name : string;
}

type attr = string * string
type btf_child = {
  idx : int;
  kind : string;
  name : string;
  attrs : attr list;
}
type btf = {
  id : int;
  kind : string;
  name : string;
  attrs : attr list;
  children : btf_child list;
}

type reloc = { offset : int64; reloc_typ : reloc_type; value : string }
type data_kind = INIT_DATA | ZERO_BSS | RODATA
type data_region = {
  section_name : string;
  bytes : bytes;
  size : int;
  kind : data_kind;
}
type section_table = (int, section) Hashtbl.t
type symbol_table = (string, symbol) Hashtbl.t
type reloc_table = (int64, reloc) Hashtbl.t
type btf_table = (int, btf) Hashtbl.t
type data_region_table = (string, data_region) Hashtbl.t
type context = {
  basename : string;
  symbols : symbol_table;
  sections : section_table;
  btf : btf_table;
  relocs : reloc_table option;
  data_regions : data_region_table;
}

let parse_hex_int s = Int64.of_string ("0x" ^ s)

let remove_cma s =
  let len = String.length s in
  if len > 0 && s.[len - 1] = ',' then String.sub s 0 (len - 1) else s

let parse_attrs attrs =
  String.split_on_char ' ' (String.concat "\t" attrs)
    |> List.filter (fun s -> s <> "")
    |> List.map (fun attr ->
      match String.split_on_char '=' attr with
      | [ key; value ] -> (key, remove_cma value)
      | _ -> failwith "Invalid load_btf (attr)")

let parse_reloc_type typ =
  match typ with
  | "R_BPF_64_64" -> R_BPF_64_64
  | "R_BPF_64_32" -> R_BPF_64_32
  | other -> OTHER_RELOC other

let parse_symbol_ndx ndx =
  match int_of_string_opt ndx with
  | Some idx -> SECTION_NDX idx
  | None -> OTHER_NDX ndx

let load_tsv ic ~parse_row ~add =
  let rec read tbl =
    let row = parse_row (input_line ic |> String.split_on_char '\t') in
    add tbl row;
    read tbl
  in
  let tbl = Hashtbl.create 16 in
  try
    ignore (input_line ic);
    read tbl
  with End_of_file -> tbl

let load_sections ic : section_table =
  let parse_row = function
    | idx :: name :: size :: kind :: _ ->
        let idx = int_of_string idx in
        { idx; name; size = parse_hex_int size; typ = kind }
    | _ -> failwith "Invalid load_sections"
  in
  let add (tbl : section_table) (section : section) = Hashtbl.replace tbl section.idx section in
  load_tsv ic ~parse_row ~add

let load_symbols ic : symbol_table =
  let parse_row = function
    | value :: size :: typ :: bind :: ndx :: name :: _ ->
        {
          value = parse_hex_int value;
          size = int_of_string size;
          typ = typ;
          bind = bind;
          ndx = parse_symbol_ndx ndx;
          name = name;
        }
    | _ -> failwith "Invalid load_symbols"
  in
  let add (tbl : symbol_table) (symbol : symbol) = Hashtbl.replace tbl symbol.name symbol in
  load_tsv ic ~parse_row ~add

let load_relocs ic : reloc_table =
  let parse_row = function
    | offset :: typ :: value :: _ ->
        {
          offset = parse_hex_int offset;
          reloc_typ = parse_reloc_type typ;
          value;
        }
    | _ -> failwith "Invalid load_relocs"
  in
  let add (tbl : reloc_table) (reloc : reloc) = Hashtbl.replace tbl reloc.offset reloc in
  load_tsv ic ~parse_row ~add

let read_bytes path =
  let ic = open_in_bin path in
  Fun.protect ~finally:(fun () -> close_in_noerr ic) (fun () ->
      Bytes.of_string (really_input_string ic (in_channel_length ic)))

let data_kind_of_section_name section_name =
  match section_name with
  | ".data" | ".maps" | "license" -> INIT_DATA
  | ".bss" -> ZERO_BSS
  | s when String.starts_with ~prefix:".rodata" s -> RODATA
  | _ -> failwith "Invalid data_kind"

let load_data_regions dir sections : data_region_table =
  let load_region (section : section) =
    let kind = data_kind_of_section_name section.name in
    let size = Int64.to_int section.size in
    let bytes =
      match kind with
      | ZERO_BSS -> Bytes.make size '\000'
      | INIT_DATA | RODATA -> read_bytes (dir ^ "/data/" ^ section.name ^ ".bin")
    in
    (section.name, { section_name = section.name; bytes; size; kind })
  in
  Hashtbl.fold
    (fun _idx (section : section) tbl ->
      match section.typ with
      | "DATA" | "BSS" ->
          let section_name, region = load_region section in
          Hashtbl.replace tbl section_name region;
          tbl
      | _ -> tbl)
    sections (Hashtbl.create 16)

let load_btf ic : btf_table =
  let parse_row = function
    | id :: parent_id :: idx :: kind :: name :: attrs ->
        let id = int_of_string id in
        let parent_id = int_of_string parent_id in
        let idx = int_of_string idx in
        let attrs = parse_attrs attrs in
        (id, parent_id, idx, kind, name, attrs)
    | _ -> failwith "Invalid load_btf"
  in
  let add (tbl : btf_table) (id, parent_id, idx, kind, name, attrs) =
    if parent_id = -1 then
      Hashtbl.replace tbl id { id; kind; name; attrs; children = [] }
    else
      match Hashtbl.find_opt tbl parent_id with
      | Some entry ->
          let child = { idx; kind; name; attrs } in
          Hashtbl.replace tbl parent_id { entry with children = entry.children @ [ child ] }
      | None -> failwith "Invalid load_btf (missing parent)"
  in
  load_tsv ic ~parse_row ~add

(* Helpers *)
let reloc_here ctx pc : reloc option =
  match ctx.relocs with
  | Some relocs -> Hashtbl.find_opt relocs (Int64.of_int pc)
  | None -> None

let section_name_of_idx ctx section_idx =
  match Hashtbl.find_opt ctx.sections section_idx with
  | Some section -> section.name
  | None -> failwith "Invalid section_name_of_idx"

let section_idx_of_symbol symbol =
  match symbol.ndx with
  | SECTION_NDX idx -> idx
  | OTHER_NDX _ -> failwith "Invalid section_idx_of_symbol"

let safe_section_name section_name =
  String.map (fun c -> if c = '/' then '_' else c) section_name

let section_idx_of_section_name ctx section_name =
  match
    Hashtbl.to_seq ctx.sections
    |> Seq.find_map (fun (idx, (section : section)) ->
           if safe_section_name section.name = section_name then Some idx else None)
  with
  | Some idx -> idx
  | None -> failwith "Invalid section_idx_of_section_name"

let func_at_offset ctx section_idx offset =
  Hashtbl.to_seq_values ctx.symbols
  |> Seq.find_map (fun (symbol : symbol) ->
         match symbol.ndx with
         | SECTION_NDX idx
           when idx = section_idx && symbol.typ = "FUNC" && symbol.value = offset ->
             Some symbol
         | _ -> None)

let btf_of_btf_name_opt ctx btf_name =
  Hashtbl.to_seq_values ctx.btf
  |> Seq.find_map (fun (btf : btf) ->
         if btf.name = btf_name then Some btf else None)
