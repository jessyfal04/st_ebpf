# Clean de-asm
- Voir si on peut avoir un déassembleur clean ! et + simple ! 
https://github.com/libbpf/bpftool
Pour pouvoir avoir + de features

Pour pouvoir avoir le bytecode clean et prêt à être parsé, on peut utiliser une combinaison de llvm-objdump et awk pour filtrer les lignes. Je regarde s'il y a pas d'autre outil + simple que ce tour de passe-passe.
Ou sinon faudrait skip avec le parseur mais jsp si on peut ~~
# Mini Parseur
- Tenter de parser qq les opcodes de ebpf depuis le code-octet

# Next
- Comprendre les sections / structure ELF 
- Commencer par le parser? loader ?
- Lire thèse qui explique MOPSA
- créateur d'ast
- grammaire ebpf
- voir ce qu'on peut réutiliser de c
- model. noyau linux pour intéractions avec lui
- Quel warning ; quel alarmes pour ebpf ?