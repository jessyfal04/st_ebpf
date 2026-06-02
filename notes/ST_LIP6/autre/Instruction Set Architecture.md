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


