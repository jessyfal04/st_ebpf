## Commandes
On peut utiliser `llvm-objdump -d X | tee X.dis` pour avoir le contenu d'un fichier .o

> [!NOTE] Disasm
> **llvm-objdump -d notes/code/ebpf-samples/libbpf-bootstrap/minimal.bpf.o)**
> 
> notes/code/ebpf-samples/libbpf-bootstrap/minimal.bpf.o: file format elf64-bpf
> 
> Disassembly of section tp/syscalls/sys_enter_write:
> 
> 0000000000000000 <handle_tp>:
>        0:       85 00 00 00 0e 00 00 00 call 0xe
>        1:       77 00 00 00 20 00 00 00 r0 >>= 0x20
>        2:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 = 0x0 ll
>        4:       61 11 00 00 00 00 00 00 w1 = *(u32 *)(r1 + 0x0)
>        5:       5e 01 05 00 00 00 00 00 if w1 != w0 goto +0x5 <handle_tp+0x58>
>        6:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 = 0x0 ll
>        8:       b4 02 00 00 1c 00 00 00 w2 = 0x1c
>        9:       bc 03 00 00 00 00 00 00 w3 = w0
>       10:       85 00 00 00 06 00 00 00 call 0x6
>       11:       b4 00 00 00 00 00 00 00 w0 = 0x0
>       12:       95 00 00 00 00 00 00 00 exit

> [!NOTE] Disasm human
>  **llvm-objdump -d --no-show-raw-insn notes/code/c_to_ebpf/test.o**
> 
> 0000000000000000 <xdp_demo>:
>        0:       *(u64 *)(r10 - 0x8) = r1
>        1:       w1 = 0x1
>        2:       *(u32 *)(r10 - 0xc) = w1
>        3:       w1 = 0x2
>        4:       *(u32 *)(r10 - 0x10) = w1
>        5:       w0 = *(u32 *)(r10 - 0xc)
>        6:       w1 = *(u32 *)(r10 - 0x10)
>        7:       w0 += w1
>        8:       exit


> [!NOTE] All sections of obj
> readelf -S notes/code/c_to_ebpf/test.o --wide
> Section Headers:
>   [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al
>   [ 0]                   NULL            0000000000000000 000000 000000 00      0   0  0
>   [ 1] .strtab           STRTAB          0000000000000000 000862 0000d9 00      0   0  1
>   [ 2] .text             PROGBITS        0000000000000000 000040 000000 00  AX  0   0  4
>   [ 3] xdp               PROGBITS        0000000000000000 000040 000048 00  AX  0   0  8
>   [ 4] license           PROGBITS        0000000000000000 000088 000004 00  WA  0   0  1
>   [ 5] .debug_abbrev     PROGBITS        0000000000000000 00008c 000089 00      0   0  1
>   [ 6] .debug_info       PROGBITS        0000000000000000 000115 000079 00      0   0  1
>   [ 7] .rel.debug_info   REL             0000000000000000 000670 000040 10   I 23   6  8
>   [ 8] .debug_str_offsets PROGBITS        0000000000000000 00018e 000034 00      0   0  1
>   [ 9] .rel.debug_str_offsets REL             0000000000000000 0006b0 0000b0 10   I 23   8  8
>   [10] .debug_str        PROGBITS        0000000000000000 0001c2 000093 01  MS  0   0  1
>   [11] .debug_addr       PROGBITS        0000000000000000 000255 000018 00      0   0  1
>   [12] .rel.debug_addr   REL             0000000000000000 000760 000020 10   I 23  11  8
>   [13] .BTF              PROGBITS        0000000000000000 000270 000167 00      0   0  4
>   [14] .rel.BTF          REL             0000000000000000 000780 000010 10   I 23  13  8
>   [15] .BTF.ext          PROGBITS        0000000000000000 0003d8 0000b0 00      0   0  4
>   [16] .rel.BTF.ext      REL             0000000000000000 000790 000080 10   I 23  15  8
>   [17] .debug_frame      PROGBITS        0000000000000000 000488 000028 00      0   0  8
>   [18] .rel.debug_frame  REL             0000000000000000 000810 000020 10   I 23  17  8
>   [19] .debug_line       PROGBITS        0000000000000000 0004b0 000068 00      0   0  1
>   [20] .rel.debug_line   REL             0000000000000000 000830 000030 10   I 23  19  8
>   [21] .debug_line_str   PROGBITS        0000000000000000 000518 000035 01  MS  0   0  1
>   [22] .llvm_addrsig     LLVM_ADDRSIG    0000000000000000 000860 000002 00   E 23   0  1
>   [23] .symtab           SYMTAB          0000000000000000 000550 000120 18      1  10  8
> Key to Flags:
>   W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
>   L (link order), O (extra OS processing required), G (group), T (TLS),
>   C (compressed), x (unknown), o (OS specific), E (exclude),
>   D (mbind), p (processor specific)


## Protocole d'extraction
On doit procéder comme ça :
- On regarde les sections
- On identifie les lignes avec de prog avec TEXT ou AX
- On les extrait si non vide, en binaire, en hex textuel, en mode côte-à-côte
On pourra parser les fichiers dans le format que l'on veut

```bash
├── test
│   ├── sections_llvm-objdump.txt
│   ├── sections_readelf.txt
│   ├── test_xdp.bin
│   ├── test_xdp.hex
│   └── test_xdp.txt
└── test.o
```

