open Instruction
open Info
open Fonctions
open Table

type text = { code : line list; reloc : reloc_table option }

let get_code_basenames dir =
  Sys.readdir (dir ^ "/code")
  |> Array.to_list
  |> List.filter (fun x -> Filename.extension x = ".hex")
  |> List.map (fun x -> Filename.chop_suffix x ".hex")

let auto_in_file path f =
  let ic = open_in path in
  let res = f ic in
  close_in ic;
  res

let load_text dir basename : text =
  let code_path = dir ^ "/code/" ^ basename ^ ".hex" in
  let code = auto_in_file code_path parse_lines in

  let reloc_path = dir ^ "/reloc/" ^ basename ^ "_reloc.tsv" in
  let reloc =
    if Sys.file_exists reloc_path then
      Some (auto_in_file reloc_path load_relocs)
    else None
  in
  { code; reloc }

let () =
  (* On récupère le dossier depuis l'argument *)
  let dir = Sys.argv.(1) in

  (* Obtenir les noms des sections de codes *)
  let basenames = get_code_basenames dir in

  (* Obtenir les texts (lignes de code + relocations)*)
  let texts =
    List.map (fun basename -> (basename, load_text dir basename)) basenames
  in

  (* Ouvrir la table des symboles et la table des sections *)
  let symb_table = auto_in_file (dir ^ "/symb.tsv") load_symbols in
  let section_table = auto_in_file (dir ^ "/sections.tsv") load_sections in

  let ctx =
    {
      basename = "";
      symbols = symb_table;
      sections = section_table;
      relocs = None;
    }
  in

  let texts_infos =
    List.map
      (fun (filename, text) ->
        let ctx =
          {
            ctx with
            basename = filename;
            relocs = text.reloc;
          }
        in
        (filename, parse_infos ctx text.code))
      texts
  in

  let fonctions =
    extract_functions texts_infos ctx
  in

  (* Affichage ! *)
  print_endline "--FONCTIONS--";
  List.iter
    (fun fonction ->
      print_endline "";
      Format.printf "%a@." Pp.pp_fonction fonction)
    fonctions
