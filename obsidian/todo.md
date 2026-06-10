# Next
- Analysiser les bts enfant (datasec et struct)
- Récupérer de la /data intéressante
	- représenter en région avec offset
	- calculer lors des load de sections le vrai symbol chargé depuis DATASEC

- **Print en mode beau!

- Faire une passe finale pour les rejets
- Lire le git d'Erwan pour apprendre eBPF!

# Questions
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