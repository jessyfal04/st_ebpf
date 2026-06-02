#### Code-Octet
EBPF est souvent lu en code-octets, il serait judieux de faire le parseur dessus.

> ([[Rapport_PSTL-eBPF.pdf#page=4&selection=14,6,34,8&color=note|Rapport_PSTL-eBPF, p.4]])
>  Or, MOPSA ne peut pas lire les programmes eBPF, ils sont en code-octet. Étendre MOPSA pour supporter directement eBPF serait possible, mais assez complexe

#### Type d'erreurs que MOPSA peut détecter

> [!PDF|note] [[Rapport_PSTL-eBPF.pdf#page=5&selection=56,43,70,26&color=note|Rapport_PSTL-eBPF, p.5]]
> Les différents types d’erreurs que MOPSA est capable de vérifier sont les erreurs d'exécution (débordements dans la mémoire, opérations arithmétiques ou de pointeur non valides, accès à la mémoire non valides, doubles libérations de mémoire), les échecs d'assertion et les échecs de conditions préalables pour les appels à la bibliothèque C (arguments non valides, formats non valides, ...).

#### Ressources
Ils ont utilisé PREVAIL et le vérificateur C
> ([[Rapport_PSTL-eBPF.pdf#page=5&selection=144,58,148,28&color=note|Rapport_PSTL-eBPF, p.5]])
> projet PREVAIL et le vérificateur du code eBPF du noyau

> ([[Rapport_PSTL-eBPF.pdf#page=6&selection=14,19,14,57&color=note|Rapport_PSTL-eBPF, p.6]])
> ibliothèque libbpf et libbpf-bootstrap

#### Génération de codes
libbpf peut permettre de générer des codes ELF

#### Strings
[[Rapport_PSTL-eBPF.pdf#page=9&selection=34,0,34,34&color=yellow|Rapport_PSTL-eBPF, p.9]]
Ils font une manip pour récupérer les strings

#### Outils 

> ([[Rapport_PSTL-eBPF.pdf#page=7&selection=51,19,51,30&color=note|Rapport_PSTL-eBPF, p.7]])
> ebpf-disasm

ebpf-disasm semble permettre de dé-assembler de l'ebpf


> ([[Rapport_PSTL-eBPF.pdf#page=7&selection=57,48,57,55&color=note|Rapport_PSTL-eBPF, p.7]])
> bpftool

pour afficher des programmes ebpf après chargement en mémoire
