# BPF Instruction Set Architecture
https://www.rfc-editor.org/rfc/rfc9669.html
https://www.kernel.org/doc/html/v6.3/bpf/instruction-set.html
src/linux/include/uapi/linux/bpf_common.h
src/linux/include/uapi/linux/bpf.h

# Plus simple
https://github.com/iovisor/bpf-docs/blob/master/eBPF.md

Sinon pour :
`|0xb4|mov32 dst, imm|dst = imm|`

Il faudrait combiner :
- `|BPF_ALU|0x04|32-bit arithmetic operations| (#define BPF_ALU 0x04)`
- `|BPF_MOV|0xb0|dst = src| (#define BPF_MOV 0xb0)`

# eBPFPL (eBPF Programming Language)
> [!PDF|note] [[static_analysis.pdf#page=6&selection=4,0,94,1&color=note|paper_ebpf, p.6]]
> cmd ::= w := E | w :=sz ∗ p | ∗p :=sz x | assume(B) | w := shared K 
> E ::= K | x | x+y | x−y
>  B ::= x = y | x , y | x ≤ y

# 32 & 64
Certaines opérations sont en 32 bits et d'autres en 64 bits
[[Rapport_PSTL-eBPF.pdf#page=20&selection=22,26,22,43&color=note|Rapport_PSTL-eBPF, p.20]]

Dans l'ancien projet PSTL, ils avaient décidé de tt convertir en 64 bits, il faudra peut être faire en sorte de traiter ces fonctions séparément dans l'AST. Peut être que certains octets sont ignorés ... TODO

# Appels de fonctions
`BPF_FUNC_MAPPER` de `bpf.h` est utilisé il contient une map de toutes les fonctions code -> fonction
```c
bpf_printk("%s Nope\n", chaine);
-> 13:	85 00 00 00 06 00 00 00	call 0x6
-> FN(trace_printk, 6, ##ctx)
```

```c
bpf_get_current_pid_tgid()
-> 0:	85 00 00 00 0e 00 00 00	call 0xe
-> FN(get_current_pid_tgid, 14, ##ctx)		\
```