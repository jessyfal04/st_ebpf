--DATA REGIONS--
license          size=4    init

--FONCTIONS--

xdp_demo [bind=GLOBAL, entry=true]
0 : instr(STX(DW,MEM), dst=10, src=1, offset=-16, imm=0) ~ 
8 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=2) ~ 
16 : instr(STX(W,MEM), dst=10, src=1, offset=-20, imm=0) ~ 
24 : instr(LDX(W,MEM), dst=1, src=10, offset=-20, imm=0) ~ 
32 : instr(JMP(K,CALL(CALL_IMM)), dst=0, src=1, offset=0, imm=-1) ~ call_dest(odd,0)
40 : instr(JMP32(K,JEQ), dst=0, src=0, offset=4, imm=0) ~ goto_dest(80)
48 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(56)
56 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ 
64 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
72 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=10, imm=0) ~ goto_dest(160)
80 : instr(LDX(W,MEM), dst=1, src=10, offset=-20, imm=0) ~ 
88 : instr(JMP(K,CALL(CALL_IMM)), dst=0, src=1, offset=0, imm=-1) ~ call_dest(even,112)
96 : instr(JMP32(K,JEQ), dst=0, src=0, offset=4, imm=1) ~ goto_dest(136)
104 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(112)
112 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ 
120 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
128 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=3, imm=0) ~ goto_dest(160)
136 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=2) ~ 
144 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
152 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(160)
160 : instr(LDX(W,MEM), dst=0, src=10, offset=-4, imm=0) ~ 
168 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 

even [bind=GLOBAL, entry=false]
112 : instr(STX(W,MEM), dst=10, src=1, offset=-8, imm=0) ~ 
120 : instr(LDX(W,MEM), dst=1, src=10, offset=-8, imm=0) ~ 
128 : instr(JMP32(K,JNE), dst=1, src=0, offset=4, imm=0) ~ goto_dest(168)
136 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(144)
144 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=1) ~ 
152 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
160 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=5, imm=0) ~ goto_dest(208)
168 : instr(LDX(W,MEM), dst=1, src=10, offset=-8, imm=0) ~ 
176 : instr(ALU(K,ADD), dst=1, src=0, offset=0, imm=-1) ~ 
184 : instr(JMP(K,CALL(CALL_IMM)), dst=0, src=1, offset=0, imm=-1) ~ call_dest(odd,0)
192 : instr(STX(W,MEM), dst=10, src=0, offset=-4, imm=0) ~ 
200 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(208)
208 : instr(LDX(W,MEM), dst=0, src=10, offset=-4, imm=0) ~ 
216 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 

odd [bind=GLOBAL, entry=false]
0 : instr(STX(W,MEM), dst=10, src=1, offset=-8, imm=0) ~ 
8 : instr(LDX(W,MEM), dst=1, src=10, offset=-8, imm=0) ~ 
16 : instr(JMP32(K,JNE), dst=1, src=0, offset=4, imm=0) ~ goto_dest(56)
24 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(32)
32 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ 
40 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
48 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=5, imm=0) ~ goto_dest(96)
56 : instr(LDX(W,MEM), dst=1, src=10, offset=-8, imm=0) ~ 
64 : instr(ALU(K,ADD), dst=1, src=0, offset=0, imm=-1) ~ 
72 : instr(JMP(K,CALL(CALL_IMM)), dst=0, src=1, offset=0, imm=-1) ~ call_dest(even,112)
80 : instr(STX(W,MEM), dst=10, src=0, offset=-4, imm=0) ~ 
88 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(96)
96 : instr(LDX(W,MEM), dst=0, src=10, offset=-4, imm=0) ~ 
104 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 

--PSEUDO-CODE--

xdp_demo [bind=GLOBAL, entry=true]
0 : *(u64 *)(r10 - 16) = r1
8 : r1 = 2
16 : *(u32 *)(r10 - 20) = r1
24 : r1 = *(u32 *)(r10 - 20)
32 : call odd @0
40 : if (u64)r0 == (u64)0 goto 80
48 : goto 56
56 : r1 = 0
64 : *(u32 *)(r10 - 4) = r1
72 : goto 160
80 : r1 = *(u32 *)(r10 - 20)
88 : call even @112
96 : if (u64)r0 == (u64)1 goto 136
104 : goto 112
112 : r1 = 0
120 : *(u32 *)(r10 - 4) = r1
128 : goto 160
136 : r1 = 2
144 : *(u32 *)(r10 - 4) = r1
152 : goto 160
160 : r0 = *(u32 *)(r10 - 4)
168 : return

even [bind=GLOBAL, entry=false]
112 : *(u32 *)(r10 - 8) = r1
120 : r1 = *(u32 *)(r10 - 8)
128 : if (u64)r1 != (u64)0 goto 168
136 : goto 144
144 : r1 = 1
152 : *(u32 *)(r10 - 4) = r1
160 : goto 208
168 : r1 = *(u32 *)(r10 - 8)
176 : r1 += -1
184 : call odd @0
192 : *(u32 *)(r10 - 4) = r0
200 : goto 208
208 : r0 = *(u32 *)(r10 - 4)
216 : return

odd [bind=GLOBAL, entry=false]
0 : *(u32 *)(r10 - 8) = r1
8 : r1 = *(u32 *)(r10 - 8)
16 : if (u64)r1 != (u64)0 goto 56
24 : goto 32
32 : r1 = 0
40 : *(u32 *)(r10 - 4) = r1
48 : goto 96
56 : r1 = *(u32 *)(r10 - 8)
64 : r1 += -1
72 : call even @112
80 : *(u32 *)(r10 - 4) = r0
88 : goto 96
96 : r0 = *(u32 *)(r10 - 4)
104 : return
