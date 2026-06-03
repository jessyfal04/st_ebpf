# Décodeur
- Types
	- Infos de types des structures et des maps
	- ebpf elf map type section ".BTF" ? Où sont les types ?
- Comprendre les instruction - faire un arbre de décision pour chaque instr ?
	- Ajouter des programmes qui 
		- testent des boucles
		- testent 

# Question
- Chargement binaire -1 ?
- S'occuper des types, des maps et des tableaux ou juste considérer que ce sont des cases avec des valeurs ?
- Il y a qqch de spécial à faire ppur :
	- les pointeurs ?
	- les divisions par zéro ? 
	- les programmes privilégiés ?
# Next
- Lire thèse qui explique MOPSA
- Mini Parser : 
	- Tenter de parser qq les opcodes de ebpf depuis le code-octet
- Créateur d'AST
- Voir ce qu'on peut réutiliser de C
- Model. noyau linux pour intéractions avec lui
- Quel warning ; quel alarmes pour ebpf ?



- Il y a plusieurs types de MAP, peut être qu'il y  en a des "spéciales"