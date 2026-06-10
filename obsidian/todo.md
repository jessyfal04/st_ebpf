# Next
- Info GOTO
- Recalculer n de lignes fonctions OU mettre que le n de ligne de base sans offset pour les appels de fonction sans relocation

- Analysiser les bts enfant (datasec et struct)
- Récupérer de la /data intéressante

- **Print en mode beau!

- Faire une passe finale pour les rejets
- Lire le git d'Erwan pour apprendre eBPF!

# Questions
- Il faut récupérer les /data dans notre représentation Ocaml? Comment les modéliser ? Une région avec un nb d'élément / des offset ? en utilisant DATASEC ?
- Dans MOPSA comment sont gérés les GOTO?
- On a besoin de garder en mémoire call_dest(odd,**N**) le N de call_dest?

# Later
- Lire thèse qui explique MOPSA
- Créateur d'AST
- Voir ce qu'on peut réutiliser de C
- Model. noyau linux pour intéractions avec lui
- Quel warning ; quel alarmes pour ebpf ? 
	- offset/taille, pb de région, div 0 et tt, instruction spéciales
	- goto en dehors d'une fonction?