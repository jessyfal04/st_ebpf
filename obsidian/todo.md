# Next
- Faire une passe finale pour les rejets
- Lire le git d'Erwan pour apprendre eBPF!

# Questions
- .rodata.str1.1 est dans section et région mais pas dans btf
- Parser la datasec .maps différemment pour avoir assez d'infos sur les maps

```
Size 2
48 : r1 = load_typ(.maps+0, typ=struct([type:ptr(array_1(int_4)), key:ptr(int_4), value:ptr(int_4), max_entries:ptr(**array_2**(int_4))]))

Size 1
48 : r1 = load_typ(.maps+0, typ=struct([type:ptr(array_1(int_4)), key:ptr(int_4), value:ptr(int_4), max_entries:ptr(**array_1**(int_4))]))
-
48 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_typ(.maps+0, typ=struct([type:ptr(**array_23**(int_4)), key:ptr(int_4), value:ptr(int_4), max_entries:ptr(array_2(int_4))]))

BPF_MAP_TYPE_HASH
48 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_typ(.maps+0, typ=struct([type:ptr(**array_1**(int_4)), key:ptr(int_4), value:ptr(int_4), max_entries:ptr(array_2(int_4))]))
```
- Il faut calculer d'autres choses?

# Later
- Lire thèse qui explique MOPSA
- Créateur d'AST
- Voir ce qu'on peut réutiliser de C
- Model. noyau linux pour intéractions avec lui
- Quel warning ; quel alarmes pour ebpf ? 
	- offset/taille, pb de région, div 0 et tt, instruction spéciales
	- goto en dehors d'une fonction?