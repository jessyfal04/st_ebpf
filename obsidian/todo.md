
- Reloc R_BPF_64_64 / 32 via reloc -> symbSec -> section -> formule dans info
- Print en mode beau
- Faire une passe finale pour les rejets ? 

- Séparation des .text et calcul des goto ! 
- Lire les nouveaux articles & maybe un peu de thèse ce WE
# Question
- A quoi sert la variable ctx context ? 'r1'
- ![[Pasted image 20260603102954.png]] S'occuper des types, des maps (BPF_MAP_TYPE_ARRAY / BPF_MAP_TYPE_HASH) avec .BPF car quand je change le type c'est ici que ça change.
![[Pasted image 20260603102954.png]]
	et des tableaux ou juste considérer que ce sont des cases avec des valeurs ?

- Pourquoi les maps font 20 octet à chaque fois ? C'est la struct ? Les données sont dans le noyaux ? Comment les représenter?
```
0000000000000020 32 4 array_of_maps
0000000000000000 32 4 inner_map
```
# Next
- Lire thèse qui explique MOPSA
- Créateur d'AST
- Voir ce qu'on peut réutiliser de C
- Model. noyau linux pour intéractions avec lui
- Quel warning ; quel alarmes pour ebpf ? (div 0 et tt, instruction spéciales)