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
