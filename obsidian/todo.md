# Next
- Analysiser les bts enfant (datasec et struct)
	- ~~Extraction~~
	- ~~Import dans table.ml~~
	- Modifier le type parsing de DATASEC et de STRUCT en prenant en compte les enfants dans parse_btf
- Récupérer de la /data intéressante
	- représenter en région avec offset
	- calculer lors des load de sections le vrai symbol chargé depuis DATASEC

- **Print en mode beau!

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