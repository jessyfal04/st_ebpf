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

type reloc = { offset : int64; reloc_typ : reloc_type; value : string }
type section_table = (int, section) Hashtbl.t
type symbol_table = (string, symbol) Hashtbl.t
type reloc_table = (int64, reloc) Hashtbl.t
type context = {
  basename : string;
  symbols : symbol_table;
  sections : section_table;
  relocs : reloc_table option;
}

let parse_hex_int s = Int64.of_string ("0x" ^ s)

let parse_reloc_type typ =
  match typ with
  | "R_BPF_64_64" -> R_BPF_64_64
  | "R_BPF_64_32" -> R_BPF_64_32
  | other -> OTHER_RELOC other

let parse_symbol_ndx ndx =
  match int_of_string_opt ndx with
  | Some idx -> SECTION_NDX idx
  | None -> OTHER_NDX ndx

let load_tsv ic ~create ~parse_row ~add =
  let rec read tbl =
    let row = parse_row (input_line ic |> String.split_on_char '\t') in
    add tbl row;
    read tbl
  in
  let tbl = create () in
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
  let add tbl section = Hashtbl.replace tbl section.idx section in
  load_tsv ic ~create:(fun () -> Hashtbl.create 16) ~parse_row ~add

let load_symbols ic : symbol_table =
  let parse_row = function
    | value :: size :: typ :: bind :: ndx :: name :: _ ->
        {
          value = parse_hex_int value;
          size = int_of_string size;
          typ;
          bind;
          ndx = parse_symbol_ndx ndx;
          name;
        }
    | _ -> failwith "Invalid load_symbols"
  in
  let add tbl symbol = Hashtbl.replace tbl symbol.name symbol in
  load_tsv ic ~create:(fun () -> Hashtbl.create 16) ~parse_row ~add

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
  let add tbl reloc = Hashtbl.replace tbl reloc.offset reloc in
  load_tsv ic ~create:(fun () -> Hashtbl.create 16) ~parse_row ~add

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
