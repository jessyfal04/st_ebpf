open Instruction

let () =
  (* On récupère depuis l'argument *)
  let chemin = Sys.argv.(1) in

  (* On ouvre le TEXT .hex *)
  let text = open_in chemin in

  (* On parse les lignes et on affiche *)
  parse_lines text Pp.print_instr;

  (* On ferme le fichier *)
  close_in text
