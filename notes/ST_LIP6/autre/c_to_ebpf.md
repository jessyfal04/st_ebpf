`clang -target bpfel -O0 -g -c test.c -o test.o`
`llvm-objdump -d test.o | tee test.dis`

Sans optimisations pour garder toutes nos lignes de code
Avec llvm-objdump on peut afficher transformer le code en .o

Il faut définir une section et la licence GPL :
```c
#define SEC(NAME) __attribute__((section(NAME), used))

  

SEC("xdp")

int xdp_demo(void *ctx)

{

int x = 1;

int y = 1;

return x + y;

}

  

char _license[] SEC("license") = "GPL";
```

Donne :
```
test.o:	file format elf64-bpf

Disassembly of section xdp:

0000000000000000 <xdp_demo>:
       0:	7b 1a f8 ff 00 00 00 00	*(u64 *)(r10 - 0x8) = r1
       1:	b4 01 00 00 01 00 00 00	w1 = 0x1
       2:	63 1a f4 ff 00 00 00 00	*(u32 *)(r10 - 0xc) = w1
       3:	b4 01 00 00 02 00 00 00	w1 = 0x2
       4:	63 1a f0 ff 00 00 00 00	*(u32 *)(r10 - 0x10) = w1
       5:	61 a0 f4 ff 00 00 00 00	w0 = *(u32 *)(r10 - 0xc)
       6:	61 a1 f0 ff 00 00 00 00	w1 = *(u32 *)(r10 - 0x10)
       7:	0c 10 00 00 00 00 00 00	w0 += w1
       8:	95 00 00 00 00 00 00 00	exit
```