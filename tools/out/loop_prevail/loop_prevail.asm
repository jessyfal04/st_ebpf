--FONCTIONS--

foo [bind=GLOBAL, entry=true]
0 : instr(STX(DW,MEM), dst=10, src=1, offset=-8, imm=0) ~ 
8 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ 
16 : instr(STX(W,MEM), dst=10, src=1, offset=-16, imm=0) ~ 
24 : instr(ALU64(K,MOV), dst=2, src=0, offset=0, imm=0) ~ 
32 : instr(STX(DW,MEM), dst=10, src=2, offset=-24, imm=0) ~ 
40 : instr(STX(DW,MEM), dst=10, src=2, offset=-32, imm=0) ~ 
48 : instr(STX(DW,MEM), dst=10, src=2, offset=-40, imm=0) ~ 
56 : instr(STX(DW,MEM), dst=10, src=2, offset=-48, imm=0) ~ 
64 : instr(STX(DW,MEM), dst=10, src=2, offset=-56, imm=0) ~ 
72 : instr(STX(W,MEM), dst=10, src=1, offset=-12, imm=0) ~ 
80 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(88)
88 : instr(LDX(W,MEM), dst=1, src=10, offset=-12, imm=0) ~ 
96 : instr(ALU64(K,LSH), dst=1, src=0, offset=0, imm=32) ~ 
104 : instr(ALU64(K,ARSH), dst=1, src=0, offset=0, imm=32) ~ 
112 : instr(JMP(K,JGT), dst=1, src=0, offset=24, imm=39) ~ goto_dest(312)
120 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(128)
128 : instr(LDX(DW,MEM), dst=2, src=10, offset=-8, imm=0) ~ 
136 : instr(LDX(DW,MEM), dst=1, src=2, offset=0, imm=0) ~ 
144 : instr(LDX(W,MEM), dst=3, src=10, offset=-12, imm=0) ~ 
152 : instr(ALU64(K,LSH), dst=3, src=0, offset=0, imm=32) ~ 
160 : instr(ALU64(K,ARSH), dst=3, src=0, offset=0, imm=32) ~ 
168 : instr(ALU64(X,ADD), dst=1, src=3, offset=0, imm=0) ~ 
176 : instr(LDX(DW,MEM), dst=2, src=2, offset=8, imm=0) ~ 
184 : instr(JMP(X,JLT), dst=1, src=2, offset=2, imm=0) ~ goto_dest(208)
192 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(200)
200 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=13, imm=0) ~ goto_dest(312)
208 : instr(LDX(W,MEM), dst=1, src=10, offset=-12, imm=0) ~ 
216 : instr(ALU64(K,LSH), dst=1, src=0, offset=0, imm=32) ~ 
224 : instr(ALU64(K,ARSH), dst=1, src=0, offset=0, imm=32) ~ 
232 : instr(ALU64(X,MOV), dst=2, src=10, offset=0, imm=0) ~ 
240 : instr(ALU64(K,ADD), dst=2, src=0, offset=0, imm=-56) ~ 
248 : instr(ALU64(X,ADD), dst=2, src=1, offset=0, imm=0) ~ 
256 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=1) ~ 
264 : instr(STX(B,MEM), dst=2, src=1, offset=0, imm=0) ~ 
272 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(280)
280 : instr(LDX(W,MEM), dst=1, src=10, offset=-12, imm=0) ~ 
288 : instr(ALU(K,ADD), dst=1, src=0, offset=0, imm=1) ~ 
296 : instr(STX(W,MEM), dst=10, src=1, offset=-12, imm=0) ~ 
304 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=-28, imm=0) ~ goto_dest(88)
312 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ 
320 : instr(STX(W,MEM), dst=10, src=1, offset=-12, imm=0) ~ 
328 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(336)
336 : instr(LDX(W,MEM), dst=1, src=10, offset=-12, imm=0) ~ 
344 : instr(ALU64(K,LSH), dst=1, src=0, offset=0, imm=32) ~ 
352 : instr(ALU64(K,ARSH), dst=1, src=0, offset=0, imm=32) ~ 
360 : instr(JMP(K,JGT), dst=1, src=0, offset=17, imm=39) ~ goto_dest(504)
368 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(376)
376 : instr(LDX(W,MEM), dst=1, src=10, offset=-12, imm=0) ~ 
384 : instr(ALU(X,MOV), dst=2, src=1, offset=0, imm=0) ~ 
392 : instr(ALU64(K,LSH), dst=2, src=0, offset=0, imm=32) ~ 
400 : instr(ALU64(K,ARSH), dst=2, src=0, offset=0, imm=32) ~ 
408 : instr(ALU64(X,MOV), dst=1, src=10, offset=0, imm=0) ~ 
416 : instr(ALU64(K,ADD), dst=1, src=0, offset=0, imm=-56) ~ 
424 : instr(ALU64(X,ADD), dst=1, src=2, offset=0, imm=0) ~ 
432 : instr(LDX(B,MEM), dst=2, src=1, offset=0, imm=0) ~ 
440 : instr(LDX(W,MEM), dst=1, src=10, offset=-16, imm=0) ~ 
448 : instr(ALU(X,ADD), dst=1, src=2, offset=0, imm=0) ~ 
456 : instr(STX(W,MEM), dst=10, src=1, offset=-16, imm=0) ~ 
464 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(472)
472 : instr(LDX(W,MEM), dst=1, src=10, offset=-12, imm=0) ~ 
480 : instr(ALU(K,ADD), dst=1, src=0, offset=0, imm=1) ~ 
488 : instr(STX(W,MEM), dst=10, src=1, offset=-12, imm=0) ~ 
496 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=-21, imm=0) ~ goto_dest(336)
504 : instr(LDX(W,MEM), dst=0, src=10, offset=-16, imm=0) ~ 
512 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 

--PSEUDO-CODE--

foo [bind=GLOBAL, entry=true]
0 : *(u64 *)(r10 - 8) = r1
8 : r1 = 0
16 : *(u32 *)(r10 - 16) = r1
24 : r2 = 0
32 : *(u64 *)(r10 - 24) = r2
40 : *(u64 *)(r10 - 32) = r2
48 : *(u64 *)(r10 - 40) = r2
56 : *(u64 *)(r10 - 48) = r2
64 : *(u64 *)(r10 - 56) = r2
72 : *(u32 *)(r10 - 12) = r1
80 : goto 88
88 : r1 = *(u32 *)(r10 - 12)
96 : r1 <<= 32
104 : r1 s>>= 32
112 : if (u32)r1 > (u32)39 goto 312
120 : goto 128
128 : r2 = *(u64 *)(r10 - 8)
136 : r1 = *(u64 *)(r2 + 0)
144 : r3 = *(u32 *)(r10 - 12)
152 : r3 <<= 32
160 : r3 s>>= 32
168 : r1 += r3
176 : r2 = *(u64 *)(r2 + 8)
184 : if (u32)r1 < (u32)r2 goto 208
192 : goto 200
200 : goto 312
208 : r1 = *(u32 *)(r10 - 12)
216 : r1 <<= 32
224 : r1 s>>= 32
232 : r2 = r10
240 : r2 += -56
248 : r2 += r1
256 : r1 = 1
264 : *(u8 *)(r2 + 0) = r1
272 : goto 280
280 : r1 = *(u32 *)(r10 - 12)
288 : r1 += 1
296 : *(u32 *)(r10 - 12) = r1
304 : goto 88
312 : r1 = 0
320 : *(u32 *)(r10 - 12) = r1
328 : goto 336
336 : r1 = *(u32 *)(r10 - 12)
344 : r1 <<= 32
352 : r1 s>>= 32
360 : if (u32)r1 > (u32)39 goto 504
368 : goto 376
376 : r1 = *(u32 *)(r10 - 12)
384 : r2 = r1
392 : r2 <<= 32
400 : r2 s>>= 32
408 : r1 = r10
416 : r1 += -56
424 : r1 += r2
432 : r2 = *(u8 *)(r1 + 0)
440 : r1 = *(u32 *)(r10 - 16)
448 : r1 += r2
456 : *(u32 *)(r10 - 16) = r1
464 : goto 472
472 : r1 = *(u32 *)(r10 - 12)
480 : r1 += 1
488 : *(u32 *)(r10 - 12) = r1
496 : goto 336
504 : r0 = *(u32 *)(r10 - 16)
512 : return
