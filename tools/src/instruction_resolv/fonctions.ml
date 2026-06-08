open Table

type fonction = {
  name : string;
  section_name : string;
  offset : int64;
  size : int;
  bind : string;
  is_entry : bool;
  code : Info.line_info list;
}

type context = {
  symbols : symbol_table;
  sections : section_table;
}

let section_name_of_idx ctx section_idx =
  match Hashtbl.find_opt ctx.sections section_idx with
  | Some section -> section.name
  | None -> failwith "Invalid section_name_of_idx"

let safe_section_name section_name =
  String.map (fun c -> if c = '/' then '_' else c) section_name

let in_function_range pc offset size =
  let pc = Int64.of_int pc in
  let end_offset = Int64.add offset (Int64.of_int size) in
  pc >= offset && pc < end_offset

let part_lines lines offset size =
  List.filter
    (fun ((pc, _), _) -> in_function_range pc offset size)
    lines

let extract_code texts section_name offset size =
  let section_name = safe_section_name section_name in
  match List.assoc_opt section_name texts with
  | Some lines ->
      let code = part_lines lines offset size in
      code
  | None -> failwith "Invalid extract_function (section_name)"

let get_functions ctx texts =
  Hashtbl.fold
    (fun _ (symbol : symbol) acc ->
      match symbol.ndx with
      | SECTION_NDX section_idx when symbol.typ = "FUNC" ->
          let section_name = section_name_of_idx ctx section_idx in
          let offset = symbol.value in
          let size = symbol.size in
          {
            name = symbol.name;
            section_name = section_name;
            offset = offset;
            size = size;
            bind = symbol.bind;
            is_entry = section_name <> ".text";
            code = extract_code texts section_name offset size;
          }
          :: acc
      | _ -> acc)
    ctx.symbols []

let extract_functions texts ctx =
  let functions = get_functions ctx texts in
  functions
