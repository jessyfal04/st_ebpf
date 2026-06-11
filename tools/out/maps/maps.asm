--DATA REGIONS--
.maps            size=32   init
license          size=4    init

--FONCTIONS--

xdp_demo [bind=GLOBAL, entry=true]
0 : instr(STX(DW,MEM), dst=10, src=1, offset=-16, imm=0) ~ 
8 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ 
16 : instr(STX(W,MEM), dst=10, src=1, offset=-56, imm=0) ~ 
24 : instr(STX(W,MEM), dst=10, src=1, offset=-20, imm=0) ~ 
32 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=42) ~ 
40 : instr(STX(W,MEM), dst=10, src=1, offset=-24, imm=0) ~ 
48 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_typ(.maps+0, typ=struct([type:ptr(array_23(int_4)), key:ptr(int_4), value:ptr(int_4), max_entries:ptr(array_2(int_4))]))
64 : instr(STX(DW,MEM), dst=10, src=1, offset=-48, imm=0) ~ 
72 : instr(ALU64(X,MOV), dst=2, src=10, offset=0, imm=0) ~ 
80 : instr(ALU64(K,ADD), dst=2, src=0, offset=0, imm=-20) ~ 
88 : instr(ALU64(X,MOV), dst=3, src=10, offset=0, imm=0) ~ 
96 : instr(ALU64(K,ADD), dst=3, src=0, offset=0, imm=-24) ~ 
104 : instr(ALU64(K,MOV), dst=4, src=0, offset=0, imm=0) ~ 
112 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=2) ~ call_bpf(map_update_elem)
120 : instr(LDX(W,MEM), dst=2, src=10, offset=-56, imm=0) ~ 
128 : instr(LDX(DW,MEM), dst=1, src=10, offset=-48, imm=0) ~ 
136 : instr(STX(W,MEM), dst=10, src=2, offset=-28, imm=0) ~ 
144 : instr(ALU64(X,MOV), dst=2, src=10, offset=0, imm=0) ~ 
152 : instr(ALU64(K,ADD), dst=2, src=0, offset=0, imm=-28) ~ 
160 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=1) ~ call_bpf(map_lookup_elem)
168 : instr(STX(DW,MEM), dst=10, src=0, offset=-40, imm=0) ~ 
176 : instr(LDX(DW,MEM), dst=1, src=10, offset=-40, imm=0) ~ 
184 : instr(JMP(K,JEQ), dst=1, src=0, offset=5, imm=0) ~ goto_dest(232)
192 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(200)
200 : instr(LDX(DW,MEM), dst=1, src=10, offset=-40, imm=0) ~ 
208 : instr(LDX(W,MEM), dst=1, src=1, offset=0, imm=0) ~ 
216 : instr(JMP32(K,JEQ), dst=1, src=0, offset=4, imm=42) ~ goto_dest(256)
224 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(232)
232 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ 
240 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
248 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=3, imm=0) ~ goto_dest(280)
256 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=2) ~ 
264 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
272 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(280)
280 : instr(LDX(W,MEM), dst=0, src=10, offset=-4, imm=0) ~ 
288 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 

--PSEUDO-CODE--

xdp_demo [bind=GLOBAL, entry=true]
0 : *(u64 *)(r10 - 16) = r1
8 : r1 = 0
16 : *(u32 *)(r10 - 56) = r1
24 : *(u32 *)(r10 - 20) = r1
32 : r1 = 42
40 : *(u32 *)(r10 - 24) = r1
48 : r1 = load_typ(.maps+0, typ=struct([type:ptr(array_23(int_4)), key:ptr(int_4), value:ptr(int_4), max_entries:ptr(array_2(int_4))]))
64 : *(u64 *)(r10 - 48) = r1
72 : r2 = r10
80 : r2 += -20
88 : r3 = r10
96 : r3 += -24
104 : r4 = 0
112 : call map_update_elem
120 : r2 = *(u32 *)(r10 - 56)
128 : r1 = *(u64 *)(r10 - 48)
136 : *(u32 *)(r10 - 28) = r2
144 : r2 = r10
152 : r2 += -28
160 : call map_lookup_elem
168 : *(u64 *)(r10 - 40) = r0
176 : r1 = *(u64 *)(r10 - 40)
184 : if (u32)r1 == (u32)0 goto 232
192 : goto 200
200 : r1 = *(u64 *)(r10 - 40)
208 : r1 = *(u32 *)(r1 + 0)
216 : if (u64)r1 == (u64)42 goto 256
224 : goto 232
232 : r1 = 0
240 : *(u32 *)(r10 - 4) = r1
248 : goto 280
256 : r1 = 2
264 : *(u32 *)(r10 - 4) = r1
272 : goto 280
280 : r0 = *(u32 *)(r10 - 4)
288 : return
