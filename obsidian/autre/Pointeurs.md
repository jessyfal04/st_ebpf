Quand une fonction attends des adresses il faut mettre les valeurs dans la stack puis passer du envoyer l'adresse décalée par rapport à r10.
```c
      0:	b4 01 00 00 2a 00 00 00	w1 = 0x2a
; 	bpf_map_update_elem(&map, &(__u32){0}, &(__u32){42}, BPF_ANY);
       1:	63 1a f8 ff 00 00 00 00	*(u32 *)(r10 - 0x8) = w1
       2:	b4 06 00 00 00 00 00 00	w6 = 0x0
       3:	63 6a fc ff 00 00 00 00	*(u32 *)(r10 - 0x4) = w6
       4:	bf a2 00 00 00 00 00 00	r2 = r10
       5:	07 02 00 00 fc ff ff ff	r2 += -0x4
       6:	bf a3 00 00 00 00 00 00	r3 = r10
       7:	07 03 00 00 f8 ff ff ff	r3 += -0x8
       8:	18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00	r1 = 0x0 ll
		0000000000000040:  R_BPF_64_64	map
      10:	b7 04 00 00 00 00 00 00	r4 = 0x0
      11:	85 00 00 00 02 00 00 00	call 0x2
```
