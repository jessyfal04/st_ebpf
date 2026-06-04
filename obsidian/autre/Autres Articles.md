Dans [[Rapport_PSTL-eBPF.pdf]] ils vont extraire sectionName ; rodata mais j'ai l'impression que leur string sont en lecture seule


Dans [[static_analysis.pdf]], ils font une abstraction

| PREVAIL        | Décodeur              |
| -------------- | --------------------- |
| region, offset | pointeur ? offset jsp |
| stk            | stack via r10         |
| ctx            | argument              |
| pkt            | data ? jsp            |
| num            | entier direct         |
| inv            | jsp                   |
| shared K       | maps ?                |

Dans [[automatic_synthesis.pdf]] ils ne font que l'opérateur

Dans [[Formal Semantics ebpf ISA.pdf]] surtout de Solana eBPF