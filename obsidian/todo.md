# Opérations

- Prendre le chemin vers le dossier plutôt
- Filtrer les DW avec 64, donner un argument supplémentaire
- Ensuite dedans 

- Continuer la partie sur les différences avec les autres projets
- Lire article avec opérations formelles

- A quoi sert la variable ctx context ? 'r1'
- Parsing : 
	- Opérations signés et spéciales avec une certaine valeur de registre
		- https://www.rfc-editor.org/rfc/rfc9669.html#section-4.1-15
	- Byte Swap ...


# Question
- S'occuper des types, des maps (BPF_MAP_TYPE_ARRAY / BPF_MAP_TYPE_HASH) avec .BPF car quand je change le type c'est ici que ça change.
![[Pasted image 20260603102954.png]]
	et des tableaux ou juste considérer que ce sont des cases avec des valeurs ?

- Pourquoi les maps font 20 octet à chaque fois ? C'est la struct ? Les données sont dans le noyaux ? Comment les représenter?
```
0000000000000020 32 4 array_of_maps
0000000000000000 32 4 inner_map
```

- Plus tard, il y a quelque chose de spécial à faire / à détecter pour :
	- les pointeurs des maps?
	- les divisions par zéro ? 
	- les programmes privilégiés ? , c'est mentionné dans l'article "Simple and Precise Static Analysis"
# Next
- Lire thèse qui explique MOPSA
- Créateur d'AST
- Voir ce qu'on peut réutiliser de C
- Model. noyau linux pour intéractions avec lui
- Quel warning ; quel alarmes pour ebpf ?