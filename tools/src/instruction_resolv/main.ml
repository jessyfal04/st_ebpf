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

  (* On ouvre les .hex *)
  let code_file = List.map (open_in) code_list in

  (* On parse les lignes et on affiche *)
  let code_res = List.map parse_lines code_file in

  (* On ferme les .hex *)
  let _ = List.map close_in code_file in

  (* Print fichier (code_list) + ast (code_instrs) *)
  print_endline "--CODES--";
  let pairs = List.combine code_list code_res in
  List.iter
    (fun (fichier, res) ->
       print_endline ("\n" ^ fichier);
       Pp.pp_res res)
    pairs

