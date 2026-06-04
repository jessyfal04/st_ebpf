https://docs.ebpf.io/linux/helper-function/bpf_map_update_elem/

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

Pattern quand on fait des appel avec adresses
```c
       9:	bf a2 00 00 00 00 00 00	r2 = r10
      10:	07 02 00 00 ec ff ff ff	r2 += -0x14
```

# Arguments
Il y a max 5 arguments qui sont préparés dans r1 ~ r5.
