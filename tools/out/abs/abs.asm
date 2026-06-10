--FONCTIONS--

xdp_demo [bind=GLOBAL, entry=true]
0 : instr(STX(DW,MEM), dst=10, src=1, offset=-16, imm=0) ~ 
8 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=-2) ~ 
16 : instr(STX(W,MEM), dst=10, src=1, offset=-20, imm=0) ~ 
24 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=2) ~ 
32 : instr(STX(W,MEM), dst=10, src=1, offset=-24, imm=0) ~ 
40 : instr(LDX(W,MEM), dst=1, src=10, offset=-20, imm=0) ~ 
48 : instr(JMP(K,CALL(CALL_IMM)), dst=0, src=1, offset=0, imm=-1) ~ call_dest(my_abs,0)
56 : instr(STX(W,MEM), dst=10, src=0, offset=-32, imm=0) ~ 
64 : instr(LDX(W,MEM), dst=1, src=10, offset=-24, imm=0) ~ 
72 : instr(JMP(K,CALL(CALL_IMM)), dst=0, src=1, offset=0, imm=-1) ~ call_dest(my_abs,0)
80 : instr(ALU(X,MOV), dst=1, src=0, offset=0, imm=0) ~ 
88 : instr(LDX(W,MEM), dst=0, src=10, offset=-32, imm=0) ~ 
96 : instr(JMP32(X,JEQ), dst=0, src=1, offset=4, imm=0) ~ goto_dest(136)
104 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(112)
112 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ 
120 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
128 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=12, imm=0) ~ goto_dest(232)
136 : instr(LDX(W,MEM), dst=1, src=10, offset=-20, imm=0) ~ 
144 : instr(LDX(W,MEM), dst=2, src=10, offset=-24, imm=0) ~ 
152 : instr(JMP(K,CALL(CALL_IMM)), dst=0, src=1, offset=0, imm=12) ~ call_dest(my_min,104)
160 : instr(LDX(W,MEM), dst=1, src=10, offset=-20, imm=0) ~ 
168 : instr(JMP32(X,JEQ), dst=0, src=1, offset=4, imm=0) ~ goto_dest(208)
176 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(184)
184 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ 
192 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
200 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=3, imm=0) ~ goto_dest(232)
208 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=2) ~ 
216 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
224 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(232)
232 : instr(LDX(W,MEM), dst=0, src=10, offset=-4, imm=0) ~ 
240 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 

my_abs [bind=LOCAL, entry=false]
0 : instr(STX(W,MEM), dst=10, src=1, offset=-8, imm=0) ~ 
8 : instr(LDX(W,MEM), dst=1, src=10, offset=-8, imm=0) ~ 
16 : instr(JMP32(K,JSGT), dst=1, src=0, offset=5, imm=-1) ~ goto_dest(64)
24 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(32)
32 : instr(LDX(W,MEM), dst=1, src=10, offset=-8, imm=0) ~ 
40 : instr(ALU(K,NEG), dst=1, src=0, offset=0, imm=0) ~ 
48 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
56 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=3, imm=0) ~ goto_dest(88)
64 : instr(LDX(W,MEM), dst=1, src=10, offset=-8, imm=0) ~ 
72 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
80 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(88)
88 : instr(LDX(W,MEM), dst=0, src=10, offset=-4, imm=0) ~ 
96 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 

my_min [bind=LOCAL, entry=false]
104 : instr(STX(W,MEM), dst=10, src=1, offset=-8, imm=0) ~ 
112 : instr(STX(W,MEM), dst=10, src=2, offset=-12, imm=0) ~ 
120 : instr(LDX(W,MEM), dst=1, src=10, offset=-8, imm=0) ~ 
128 : instr(LDX(W,MEM), dst=2, src=10, offset=-12, imm=0) ~ 
136 : instr(JMP32(X,JSGE), dst=1, src=2, offset=4, imm=0) ~ goto_dest(176)
144 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(152)
152 : instr(LDX(W,MEM), dst=1, src=10, offset=-8, imm=0) ~ 
160 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
168 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=3, imm=0) ~ goto_dest(200)
176 : instr(LDX(W,MEM), dst=1, src=10, offset=-12, imm=0) ~ 
184 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
192 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(200)
200 : instr(LDX(W,MEM), dst=0, src=10, offset=-4, imm=0) ~ 
208 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 

--PSEUDO-CODE--

xdp_demo [bind=GLOBAL, entry=true]
0 : *(u64 *)(r10 - 16) = r1
8 : r1 = -2
16 : *(u32 *)(r10 - 20) = r1
24 : r1 = 2
32 : *(u32 *)(r10 - 24) = r1
40 : r1 = *(u32 *)(r10 - 20)
48 : call my_abs @0
56 : *(u32 *)(r10 - 32) = r0
64 : r1 = *(u32 *)(r10 - 24)
72 : call my_abs @0
80 : r1 = r0
88 : r0 = *(u32 *)(r10 - 32)
96 : if (u64)r0 == (u64)r1 goto 136
104 : goto 112
112 : r1 = 0
120 : *(u32 *)(r10 - 4) = r1
128 : goto 232
136 : r1 = *(u32 *)(r10 - 20)
144 : r2 = *(u32 *)(r10 - 24)
152 : call my_min @104
160 : r1 = *(u32 *)(r10 - 20)
168 : if (u64)r0 == (u64)r1 goto 208
176 : goto 184
184 : r1 = 0
192 : *(u32 *)(r10 - 4) = r1
200 : goto 232
208 : r1 = 2
216 : *(u32 *)(r10 - 4) = r1
224 : goto 232
232 : r0 = *(u32 *)(r10 - 4)
240 : return

my_abs [bind=LOCAL, entry=false]
0 : *(u32 *)(r10 - 8) = r1
8 : r1 = *(u32 *)(r10 - 8)
16 : if (s64)r1 > (s64)-1 goto 64
24 : goto 32
32 : r1 = *(u32 *)(r10 - 8)
40 : r1 = -r1
48 : *(u32 *)(r10 - 4) = r1
56 : goto 88
64 : r1 = *(u32 *)(r10 - 8)
72 : *(u32 *)(r10 - 4) = r1
80 : goto 88
88 : r0 = *(u32 *)(r10 - 4)
96 : return

my_min [bind=LOCAL, entry=false]
104 : *(u32 *)(r10 - 8) = r1
112 : *(u32 *)(r10 - 12) = r2
120 : r1 = *(u32 *)(r10 - 8)
128 : r2 = *(u32 *)(r10 - 12)
136 : if (s64)r1 >= (s64)r2 goto 176
144 : goto 152
152 : r1 = *(u32 *)(r10 - 8)
160 : *(u32 *)(r10 - 4) = r1
168 : goto 200
176 : r1 = *(u32 *)(r10 - 12)
184 : *(u32 *)(r10 - 4) = r1
192 : goto 200
200 : r0 = *(u32 *)(r10 - 4)
208 : return
