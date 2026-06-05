open Instruction
open Info

let tsv_to_hashtbl ic =
  let tbl = Hashtbl.create 16 in
  try
    while true do
      match String.split_on_char '\t' (input_line ic) with
      | off :: typ :: value :: _ ->
          Hashtbl.replace tbl off (typ, value)
      | _ -> ()
    done
  with End_of_file ->
    tbl

let () =
  (* On récupère le dossier depuis l'argument *)
  let dir = Sys.argv.(1) in

  (* Obtenir les noms de codes*)
  let code_basenames = 
    (Sys.readdir (dir ^ "/code"))
    |> Array.to_list
    |> List.filter (fun x -> Filename.extension x = ".hex")
    |> List.map (fun x -> Filename.chop_suffix x ".hex") in

  (* On ouvre les .hex et on parse les lignes *)
  let code_files = List.map (open_in) (
    List.map (fun x -> dir ^ "/code/" ^ x ^ ".hex"
  ) code_basenames) in

  (* Ouvrir les tables reloc de chaque nom et on met en table *)
  let reloc_files =
    List.map (fun x -> dir ^ "/reloc/" ^ x ^ "_reloc.tsv") code_basenames
    |> List.filter_map (fun path -> if Sys.file_exists path then Some (open_in path) else None)
  in
  let _reloc_tables = List.map tsv_to_hashtbl reloc_files in

  (* Ouvrir la table des symboles et la table des sections *)
  let symb_file = open_in (dir ^ "/symb.tsv") in
  let _symb_table = tsv_to_hashtbl symb_file in

  let section_file = open_in (dir ^ "/sections.tsv") in
  let _section_table = tsv_to_hashtbl section_file in

  let code_lines = List.map parse_lines code_files in
  let code_infos = List.map parse_infos code_lines in
  
  (* Affichage ! *)
  print_endline "--CODES--";
  let pairs = List.combine code_basenames code_infos in
  List.iter
    (fun (fichier, res) ->
       print_endline ("\n" ^ fichier);
       Pp.pp_res res)
    pairs;
  

  (* On ferme les .hex *)
  List.iter close_in code_files;
  List.iter close_in reloc_files;
  close_in symb_file;
  close_in section_file
