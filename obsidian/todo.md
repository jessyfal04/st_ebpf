# Next
- Faire une passe finale pour les rejets
- Lire le git d'Erwan pour apprendre eBPF!




- Intégration dans MOPSA 
	- Philosophie :
		- Petit à petit (qq op)
		- Programme Simples au début (1p2)
		- Référence avec la thèse [[thesis_monat.pdf]]
	- Ajouter le parseur (src/mopsa-analyzer/parsers/universal) ; réutiliser le CFG universal
	- Ajouter le ast.ml / frontend.ml (src/mopsa-analyzer/analyzer/languages/cfg/ast.ml)
	- Ajouter le .config (src/mopsa-analyzer/share/mopsa/configs/cfg/default.json)
	- Ajouter les itérateurs sauf si CFG ? Et les domaines pour les nouvelles instructions.
# Questions
- .rodata.str1.1 est dans section et région mais pas dans btf
- Parser la datasec .maps différemment pour avoir assez d'infos sur les maps

```
Size 2
48 : r1 = load_typ(.maps+0, typ=struct([type:ptr(array_1(int_4)), key:ptr(int_4), value:ptr(int_4), max_entries:ptr(**array_2**(int_4))]))

Size 1
48 : r1 = load_typ(.maps+0, typ=struct([type:ptr(array_1(int_4)), key:ptr(int_4), value:ptr(int_4), max_entries:ptr(**array_1**(int_4))]))
-
Type : via enum bpf_map_type
BPF_MAP_TYPE_STACK
48 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_typ(.maps+0, typ=struct([type:ptr(**array_23**(int_4)), key:ptr(int_4), value:ptr(int_4), max_entries:ptr(array_2(int_4))]))

BPF_MAP_TYPE_HASH
48 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_typ(.maps+0, typ=struct([type:ptr(**array_1**(int_4)), key:ptr(int_4), value:ptr(int_4), max_entries:ptr(array_2(int_4))]))
```
- Il faut calculer d'autres choses?
- Comment enboiter ça dans MOPSA? Il y a des transformation à faire?

# Later
- Lire thèse qui explique MOPSA
- Créateur d'AST
- Voir ce qu'on peut réutiliser de C
- Model. noyau linux pour intéractions avec lui
- Quel warning ; quel alarmes pour ebpf ? 
	- offset/taille, pb de région, div 0 et tt, instruction spéciales
	- goto en dehors d'une fonction?