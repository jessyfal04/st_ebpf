# Décodeur
- Types
	- Infos de types des structures et des maps
	- ebpf elf map type section ".BTF" ? Où sont les types ?
- Comprendre les instruction opcode et registres ect... - mini programme qui affiche le code de l'instruction

# Question
- Chargement binaire -1 ?
```
       9:	85 10 00 00 ff ff ff ff	call -0x1
		0000000000000048:  R_BPF_64_32	even
```
Pourquoi pas 0 ?
![[Pasted image 20260603103336.png]]

- S'occuper des types, des maps (BPF_MAP_TYPE_ARRAY / BPF_MAP_TYPE_HASH) avec .BPF car quand je change le type c'est ici que ça change.
![[Pasted image 20260603102954.png]]
	et des tableaux ou juste considérer que ce sont des cases avec des valeurs ?

- Pourquoi les maps font 20 octet à chaque fois ?
```
0000000000000020 32 4 array_of_maps
0000000000000000 32 4 inner_map
```

- Il y a quelque chose de spécial à faire pour :
	- les pointeurs des maps?
	- les divisions par zéro ? 
	- les programmes privilégiés ? , c'est mentionné dans l'article "Simple and Precise Static Analysis"
# Next
- Lire thèse qui explique MOPSA
- Mini Parser : 
	- Tenter de parser qq les opcodes de ebpf depuis le code-octet
- Créateur d'AST
- Voir ce qu'on peut réutiliser de C
- Model. noyau linux pour intéractions avec lui
- Quel warning ; quel alarmes pour ebpf ?