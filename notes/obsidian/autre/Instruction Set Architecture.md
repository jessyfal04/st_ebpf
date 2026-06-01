# BPF Instruction Set Architecture
https://www.rfc-editor.org/rfc/rfc9669.html
src/linux/include/uapi/linux/bpf_common.h
src/linux/include/uapi/linux/bpf.h

# eBPFPL (eBPF Programming Language) :
cmd ::= w := E | w :=sz *p | *p :=sz x
      | assume(B) | w := shared K

E   ::= K | x | x + y | x − y

B   ::= x = y | x != y | x <= y
