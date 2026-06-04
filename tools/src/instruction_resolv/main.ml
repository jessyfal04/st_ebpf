open Instruction

let () =
  (* On récupère le dossier depuis l'argument *)
  let dir = Sys.argv.(1) in

  (* Pour chaque code .hex dans le dossier *)
  let code_list = 
    (Sys.readdir (dir ^ "/code"))
    |> Array.to_list
    |> List.filter (fun x -> Filename.extension x = ".hex")
    |> List.map (fun x -> dir ^ "/code/" ^ x) in

  (* On ouvre le TEXT .hex *)
  let code_file = List.map (open_in) code_list in

  (* On parse les lignes et on affiche *)
  let code_instrs = List.map (parse_lines []) code_file in

  (* On ferme les fichier *)
  let _ = List.map close_in code_file in

  (* Print fichier (code_list) + ast (code_instrs) *)
  print_endline "--CODES--";
  let pairs = List.combine code_list code_instrs in
  List.iter
    (fun (fichier, instrs) ->
       print_endline ("\n" ^ fichier);
       Pp.pp_text instrs)
    pairs
  