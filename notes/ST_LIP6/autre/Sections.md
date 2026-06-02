# Articles

Dans [[Rapport_PSTL-eBPF.pdf]] ils vont extraire sectionName ; rodata mais j'ai l'impression que leur string sont en lecture seule
Dans [[static_analysis.pdf]], ils font une abstraction
Dans [[automatic_synthesis.pdf]] ils ne font que l'opérateur

# Décodage
## sectionName : code
- Mode TEXT non nul
- Notre code exécutable

```c
SEC("xdp")

int xdp_demo(void *ctx)
{
	int x = 1;
	int y = 2;
	return x + y;
}
```

```ebpf
       0:	7b 1a f8 ff 00 00 00 00	*(u64 *)(r10 - 0x8) = r1
       1:	b4 01 00 00 01 00 00 00	w1 = 0x1
;   int x = 1;
       2:	63 1a f4 ff 00 00 00 00	*(u32 *)(r10 - 0xc) = w1
       3:	b4 01 00 00 02 00 00 00	w1 = 0x2
;   int y = 2;
       4:	63 1a f0 ff 00 00 00 00	*(u32 *)(r10 - 0x10) = w1
;   return x + y;
       5:	61 a0 f4 ff 00 00 00 00	w0 = *(u32 *)(r10 - 0xc)
       6:	61 a1 f0 ff 00 00 00 00	w1 = *(u32 *)(r10 - 0x10)
       7:	0c 10 00 00 00 00 00 00	w0 += w1
       8:	95 00 00 00 00 00 00 00	exit
       
 7b 1a f8 ff 00 00 00 00
 b4 01 00 00 01 00 00 00
 63 1a f4 ff 00 00 00 00
 b4 01 00 00 02 00 00 00
 63 1a f0 ff 00 00 00 00
 61 a0 f4 ff 00 00 00 00
 61 a1 f0 ff 00 00 00 00
 0c 10 00 00 00 00 00 00
 95 00 00 00 00 00 00 00

```


## DATA .rodata en lecture seule / constantes
Chaîne  
```c
bpf_printk("%s", chaine);
bpf_printk("Hello World from direct\n");
```

```shell
  6 .rodata                0000001c 0000000000000000 DATA

   %   s  \0   H   e   l   l   o       W   o   r   l   d       f
   r   o   m       d   i   r   e   c   t  \n  \0
```

Entier
```c
  const int z = 2  // .rodata
```

```
 002  \0  \0  \0
```
## DATA .rodata.strX String en mémoire
Chaîne dans une variable dans .rodata.str1.1
```c
char* chaine = "Hello World\n";
```

```shell
  5 .rodata.str1.1         00000019 0000000000000000 DATA
   H   e   l   l   o       W   o   r   l   d       f   r   o   m
       c   h   a   i   n   e  \n  \0

```


## DATA .data Entier en mémoire
```c
int y = 1;        // .data
```

Dans .data
```
 001  \0  \0  \0
```

## BSS Entier non initialisé ou à 0
```c
int x = 0;
```

Dans BSS (Block Started by Symbol).

## Relocation
https://www.kernel.org/doc/html/v6.0/bpf/llvm_reloc.html#different-relocation-types

```shell
llvm-readelf -r ./out/string/string.o
Relocation section '.relxdp' at offset 0xaf8 contains 3 entries:
    Offset             Info             Type               Symbol's Value  Symbol's Name
0000000000000008  0000000500000001 R_BPF_64_64            0000000000000000 .rodata.str1.1
0000000000000028  0000000600000001 R_BPF_64_64            0000000000000000 .rodata
0000000000000050  0000000600000001 R_BPF_64_64            0000000000000000 .rodata
```
Entre autres.
C'est présent dans le fichier .relX.
```
 08 00 00 00 00 00 00 00 01 00 00 00 05 00 00 00
 28 00 00 00 00 00 00 00 01 00 00 00 06 00 00 00
 50 00 00 00 00 00 00 00 01 00 00 00 06 00 00 00
```

Donc dans 
```
       1:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 = 0x0 ll
                0000000000000008:  R_BPF_64_64  .rodata.str1.1
       3:       7b 1a f0 ff 00 00 00 00 *(u64 *)(r10 - 0x10) = r1
       4:       79 a3 f0 ff 00 00 00 00 r3 = *(u64 *)(r10 - 0x10)
       5:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 = 0x0 ll
                0000000000000028:  R_BPF_64_64  .rodata
```

A la ligne 1 0x0 correspont à l'offset 0 dans .rodata.str1.1
A la ligne 5 0x0 correspont à l'offeset 0 dans .rodata 

Il utilise .symtab pour pouvoir avoir les infos des symboles.

llvm-readelf -r ./out/string/string.o
Permet d'obtenir toutes les relocations, ducoup on a juste besoin de cibler .rel$sectioName
```
yepssy@yep:~/Nextcloud/STL/ST_LIP6/notes/tools$ llvm-readelf -r ./out/string/string.o

Relocation section '.relxdp' at offset 0xaf8 contains 3 entries:
    Offset             Info             Type               Symbol's Value  Symbol's Name
0000000000000008  0000000500000001 R_BPF_64_64            0000000000000000 .rodata.str1.1
0000000000000028  0000000600000001 R_BPF_64_64            0000000000000000 .rodata
0000000000000050  0000000600000001 R_BPF_64_64            0000000000000000 .rodata
```

Ou bien llvm-objdump
```
OFFSET           TYPE                     VALUE
0000000000000008 R_BPF_64_64              .rodata.str1.1
0000000000000028 R_BPF_64_64              .rodata
0000000000000050 R_BPF_64_64              .rodata
```
## Symboles
```
0000000000000000 0000000000000004 D _license
0000000000000004 0000000000000004 D res
0000000000000000 0000000000000004 B x
0000000000000000 0000000000000138 T xdp_demo
0000000000000004 0000000000000009 r xdp_demo.____fmt
000000000000000d 0000000000000009 r xdp_demo.____fmt.1
0000000000000000 0000000000000004 D y
0000000000000000 0000000000000004 R z
```

  - y est dans .data avec un offset de 0, et une taille de 4
  - res est aussi dans .data taille 4, mais offset 4
  
## .maps
TODO
## license
Sert à indiquer la licence du programme, 

```c
char _license[] SEC("license") = "GPL";
char LICENSE[] SEC("license") = "Dual BSD/GPL";
```

```shell
   G   P   L  \0
```

GPL = GNU General Public License