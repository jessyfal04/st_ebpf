--DATA REGIONS--
.rodata          size=9    rodata
license          size=4    init

--FONCTIONS--

sum_15 [bind=GLOBAL, entry=true]
0 : instr(STX(DW,MEM), dst=10, src=1, offset=-8, imm=0) ~ 
8 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ 
16 : instr(STX(W,MEM), dst=10, src=1, offset=-12, imm=0) ~ 
24 : instr(STX(W,MEM), dst=10, src=1, offset=-16, imm=0) ~ 
32 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(40)
40 : instr(LDX(W,MEM), dst=1, src=10, offset=-16, imm=0) ~ 
48 : instr(JMP32(K,JSGT), dst=1, src=0, offset=10, imm=14) ~ goto_dest(136)
56 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(64)
64 : instr(LDX(W,MEM), dst=2, src=10, offset=-16, imm=0) ~ 
72 : instr(LDX(W,MEM), dst=1, src=10, offset=-12, imm=0) ~ 
80 : instr(ALU(X,ADD), dst=1, src=2, offset=0, imm=0) ~ 
88 : instr(STX(W,MEM), dst=10, src=1, offset=-12, imm=0) ~ 
96 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(104)
104 : instr(LDX(W,MEM), dst=1, src=10, offset=-16, imm=0) ~ 
112 : instr(ALU(K,ADD), dst=1, src=0, offset=0, imm=1) ~ 
120 : instr(STX(W,MEM), dst=10, src=1, offset=-16, imm=0) ~ 
128 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=-12, imm=0) ~ goto_dest(40)
136 : instr(LDX(W,MEM), dst=3, src=10, offset=-12, imm=0) ~ 
144 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_typ(.rodata+0, typ=array_9(int_1))
160 : instr(ALU(K,MOV), dst=2, src=0, offset=0, imm=9) ~ 
168 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=6) ~ call_bpf(trace_printk)
176 : instr(STX(DW,MEM), dst=10, src=0, offset=-24, imm=0) ~ 
184 : instr(ALU(K,MOV), dst=0, src=0, offset=0, imm=2) ~ 
192 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 

--PSEUDO-CODE--

sum_15 [bind=GLOBAL, entry=true]
0 : *(u64 *)(r10 - 8) = r1
8 : r1 = 0
16 : *(u32 *)(r10 - 12) = r1
24 : *(u32 *)(r10 - 16) = r1
32 : goto 40
40 : r1 = *(u32 *)(r10 - 16)
48 : if (s64)r1 > (s64)14 goto 136
56 : goto 64
64 : r2 = *(u32 *)(r10 - 16)
72 : r1 = *(u32 *)(r10 - 12)
80 : r1 += r2
88 : *(u32 *)(r10 - 12) = r1
96 : goto 104
104 : r1 = *(u32 *)(r10 - 16)
112 : r1 += 1
120 : *(u32 *)(r10 - 16) = r1
128 : goto 40
136 : r3 = *(u32 *)(r10 - 12)
144 : r1 = load_typ(.rodata+0, typ=array_9(int_1))
160 : r2 = 9
168 : call trace_printk
176 : *(u64 *)(r10 - 24) = r0
184 : r0 = 2
192 : return
