# Next





```
Étape 1 — charger les bytes des sections DATA
type data_region = {
  section_name : string;
  bytes : bytes;
  size : int;
}
Dans context : data_regions : (string, data_region) Hashtbl.t
Suivre les DATA de sections.tsv

Affichage des différentes régions (que les infos).

2. Créer LOAD_TYP
LOAD_DEST  = où ça pointe physiquement
TYP        = ce que c’est symboliquement / BTF
On veut FUSIONNER le load et le type ! Avec une info liée au région
type load_typ = {  
region : string; (* ".data", ".rodata", ".maps", ... *)  
offset : int64; (* offset physique dans la région *)  
typ : typ; (* info BTF symbolique *)  
}
type info =  
| BPF_FUNC of string  
| CALL_DEST of string * int64  
| GOTO_DEST of int  
| LOAD_TYP of load_typ
```


. bss et .rodata-str.N
- Faire une passe finale pour les rejets
- Lire le git d'Erwan pour apprendre eBPF!

# Questions

# Later
- Lire thèse qui explique MOPSA
- Créateur d'AST
- Voir ce qu'on peut réutiliser de C
- Model. noyau linux pour intéractions avec lui
- Quel warning ; quel alarmes pour ebpf ? 
	- offset/taille, pb de région, div 0 et tt, instruction spéciales
	- goto en dehors d'une fonction?