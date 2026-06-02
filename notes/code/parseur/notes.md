little endian !!

## MOV 64
- Ligne :
7b 1a f8 ff 00 00 00 00	*(u64 *)(r10 - 0x8) = r1

- opcode :
7b = *(u64 *)(dst + offset) = src / stxdw [dst+off], src
x3 = STX (store from register operations)

+-+-+-+-+-+-+-+-+
|mode |sz |class|
+-+-+-+-+-+-+-+-+
+ 3 << 3 = 0b00011000 = 0x18 = sz DW (double word (8 bytes))
+ 3 << 5 0x60 = mode MEM (regular load and store operations)

- register :
1a -> 1 src + a dst
1 = r1
a = r10

- offset (signed integer offset used with pointer arithmetic) :
f8 ff -> -8
 mais on doit verif si c'est plus grand que la moitié (0x8000) on part de la fin (0x10000) :
```ocaml
let offset =
  let x = 0xfff8 in
  if x >= 0x8000 then x - 0x10000 else x
;;
```

- immediate
00 00 00 00 pas besoin ici !

## MOV 32
- Ligne :
b4 01 00 00 02 00 00 00	w1 = 0x2

- opcode :
b4 = mov32 dst, imm
x4 -> 32-bit arithmetic operations
+ bx -> MOV (dst = src)

- register :
01 -> 0 src + 1 dst
0 = X
1 = r1

- offset :
00 00 -> 0

- immediate
02 00 00 00 -> 2
