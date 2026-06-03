0000000000000000 <xdp_demo>:
; {
       0:	7b 1a f8 ff 00 00 00 00	*(u64 *)(r10 - 0x8) = r1

;   char *chaine = "Hello World from chaine\n";
**r1 = 64 bits + adresse vers l'offset 0 de rodata.str**
       1:	18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00	r1 = 0x0 ll
**on stocke l'adresse en mémoire**
       3:	7b 1a f0 ff 00 00 00 00	*(u64 *)(r10 - 0x10) = r1

;   bpf_printk("%s", chaine);
**r3 = ptr vers la chaine char**
       4:	79 a3 f0 ff 00 00 00 00	r3 = *(u64 *)(r10 - 0x10)
**r1 = ptr vers le début le format "%s"**
       5:	18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00	r1 = 0x0 ll
**w2 = vue 32 bits de r2 + taille = 3**
       7:	b4 02 00 00 03 00 00 00	w2 = 0x3
**appel?**
       8:	85 00 00 00 06 00 00 00	call 0x6
       9:	7b 0a e8 ff 00 00 00 00	*(u64 *)(r10 - 0x18) = r0


;   bpf_printk("Hello World from direct\n");
**r1 = ptr vers le début de la chaine directe**
      10:	18 01 00 00 03 00 00 00 00 00 00 00 00 00 00 00	r1 = 0x3 ll
**w2 = taille**
      12:	b4 02 00 00 19 00 00 00	w2 = 0x19
      13:	85 00 00 00 06 00 00 00	call 0x6
      14:	7b 0a e0 ff 00 00 00 00	*(u64 *)(r10 - 0x20) = r0

**Partie pour return**
      15:	b4 00 00 00 02 00 00 00	w0 = 0x2
;   return XDP_PASS;
      16:	95 00 00 00 00 00 00 00	exit