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

let get_functions ctx =
  Hashtbl.fold
    (fun _ (symbol : symbol) acc ->
      match symbol.ndx with
      | SECTION_NDX section_idx when symbol.typ = "FUNC" ->
          {
            name = symbol.name;
            section_name = section_name_of_idx ctx section_idx;
            offset = symbol.value;
            size = symbol.size;
            bind = symbol.bind;
            is_entry = section_name_of_idx ctx section_idx <> ".text";
            code = [];
          }
          :: acc
      | _ -> acc)
    ctx.symbols []

let compare_function a b =
  compare
    (a.section_name, a.offset, a.size, a.bind, a.name)
    (b.section_name, b.offset, b.size, b.bind, b.name)

let in_function_range pc offset size =
  let pc = Int64.of_int pc in
  let end_offset = Int64.add offset (Int64.of_int size) in
  pc >= offset && pc < end_offset

let part_lines lines offset size =
  List.filter
    (fun ((pc, _), _) -> in_function_range pc offset size)
    lines

let extract_function texts fonction =
  let section_name = safe_section_name fonction.section_name in
  match List.assoc_opt section_name texts with
  | Some lines ->
      let code = part_lines lines fonction.offset fonction.size in
      Some { fonction with code }
  | None -> failwith "Invalid extract_function (section_name)"

let rec extract_functions_rec texts functions acc =
  match functions with
  | [] -> List.rev acc
  | fonction :: rest -> (
      match extract_function texts fonction with
      | Some fonction -> extract_functions_rec texts rest (fonction :: acc)
      | None -> extract_functions_rec texts rest acc)

let extract_functions texts ctx =
  let functions = get_functions ctx in
  let functions = List.sort compare_function functions in
  extract_functions_rec texts functions []
