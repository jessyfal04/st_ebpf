# Next
- **Print en mode beau!**
- Ajouter une info pour les goto
- Faire une passe finale pour les rejets
- Lire le git d'Erwan pour apprendre eBPF!

# Questions
- Il faut récupérer les /data dans notre représentation Ocaml? Comment les modéliser / en région ?
- Extraire les informations BTF, on en a besoin dans MOPSA? Notamment pour les .maps? Et pour savoir quels objets sont présents (et leur type / taille ect...)
- Dans MOPSA comment sont gérés les GOTO?
- On a besoin de garder en mémoire call_dest(odd,**N**) le N de call_dest?
- Recalculer le n° de lignes vu qu'on raisonne par fonction désormais?

# Later
- Lire thèse qui explique MOPSA
- Créateur d'AST
- Voir ce qu'on peut réutiliser de C
- Model. noyau linux pour intéractions avec lui
- Quel warning ; quel alarmes pour ebpf ? 
	- offset/taille, pb de région, div 0 et tt, instruction spéciales
	- goto en dehors d'une fonction?