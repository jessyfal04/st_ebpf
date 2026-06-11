--DATA REGIONS--
.maps            size=64   init

--FONCTIONS--

func [bind=GLOBAL, entry=false]
0 : instr(STX(DW,MEM), dst=10, src=1, offset=-16, imm=0) ~ 
8 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=1) ~ 
16 : instr(STX(W,MEM), dst=10, src=1, offset=-20, imm=0) ~ 
24 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_typ(.maps+32, typ=struct([type:ptr(array_12(int_4)), max_entries:ptr(array_1(int_4)), key:ptr(int_4), values:array_0(ptr(struct([type:ptr(array_2(int_4)), key:ptr(int_4), value:ptr(int_4), max_entries:ptr(array_1(int_4))])))]))
40 : instr(ALU64(X,MOV), dst=2, src=10, offset=0, imm=0) ~ 
48 : instr(ALU64(K,ADD), dst=2, src=0, offset=0, imm=-20) ~ 
56 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=1) ~ call_bpf(map_lookup_elem)
64 : instr(STX(DW,MEM), dst=10, src=0, offset=-32, imm=0) ~ 
72 : instr(LDX(DW,MEM), dst=1, src=10, offset=-32, imm=0) ~ 
80 : instr(JMP(K,JEQ), dst=1, src=0, offset=23, imm=0) ~ goto_dest(272)
88 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(96)
96 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=2) ~ 
104 : instr(STX(W,MEM), dst=10, src=1, offset=-36, imm=0) ~ 
112 : instr(LDX(DW,MEM), dst=1, src=10, offset=-32, imm=0) ~ 
120 : instr(ALU64(X,MOV), dst=2, src=10, offset=0, imm=0) ~ 
128 : instr(ALU64(K,ADD), dst=2, src=0, offset=0, imm=-36) ~ 
136 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=1) ~ call_bpf(map_lookup_elem)
144 : instr(STX(DW,MEM), dst=10, src=0, offset=-48, imm=0) ~ 
152 : instr(LDX(DW,MEM), dst=1, src=10, offset=-48, imm=0) ~ 
160 : instr(JMP(K,JEQ), dst=1, src=0, offset=4, imm=0) ~ goto_dest(200)
168 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(176)
176 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ 
184 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
192 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=12, imm=0) ~ goto_dest(296)
200 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_typ(.maps+0, typ=struct([type:ptr(array_2(int_4)), key:ptr(int_4), value:ptr(int_4), max_entries:ptr(array_1(int_4))]))
216 : instr(ALU64(X,MOV), dst=2, src=10, offset=0, imm=0) ~ 
224 : instr(ALU64(K,ADD), dst=2, src=0, offset=0, imm=-36) ~ 
232 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=1) ~ call_bpf(map_lookup_elem)
240 : instr(STX(DW,MEM), dst=10, src=0, offset=-48, imm=0) ~ 
248 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ 
256 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
264 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=3, imm=0) ~ goto_dest(296)
272 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ 
280 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
288 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(296)
296 : instr(LDX(W,MEM), dst=0, src=10, offset=-4, imm=0) ~ 
304 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 

--PSEUDO-CODE--

func [bind=GLOBAL, entry=false]
0 : *(u64 *)(r10 - 16) = r1
8 : r1 = 1
16 : *(u32 *)(r10 - 20) = r1
24 : r1 = load_typ(.maps+32, typ=struct([type:ptr(array_12(int_4)), max_entries:ptr(array_1(int_4)), key:ptr(int_4), values:array_0(ptr(struct([type:ptr(array_2(int_4)), key:ptr(int_4), value:ptr(int_4), max_entries:ptr(array_1(int_4))])))]))
40 : r2 = r10
48 : r2 += -20
56 : call map_lookup_elem
64 : *(u64 *)(r10 - 32) = r0
72 : r1 = *(u64 *)(r10 - 32)
80 : if (u32)r1 == (u32)0 goto 272
88 : goto 96
96 : r1 = 2
104 : *(u32 *)(r10 - 36) = r1
112 : r1 = *(u64 *)(r10 - 32)
120 : r2 = r10
128 : r2 += -36
136 : call map_lookup_elem
144 : *(u64 *)(r10 - 48) = r0
152 : r1 = *(u64 *)(r10 - 48)
160 : if (u32)r1 == (u32)0 goto 200
168 : goto 176
176 : r1 = 0
184 : *(u32 *)(r10 - 4) = r1
192 : goto 296
200 : r1 = load_typ(.maps+0, typ=struct([type:ptr(array_2(int_4)), key:ptr(int_4), value:ptr(int_4), max_entries:ptr(array_1(int_4))]))
216 : r2 = r10
224 : r2 += -36
232 : call map_lookup_elem
240 : *(u64 *)(r10 - 48) = r0
248 : r1 = 0
256 : *(u32 *)(r10 - 4) = r1
264 : goto 296
272 : r1 = 0
280 : *(u32 *)(r10 - 4) = r1
288 : goto 296
296 : r0 = *(u32 *)(r10 - 4)
304 : return
