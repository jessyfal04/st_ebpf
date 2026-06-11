--DATA REGIONS--
license          size=4    init

--FONCTIONS--

xdp_demo [bind=GLOBAL, entry=true]
0 : instr(STX(DW,MEM), dst=10, src=1, offset=-8, imm=0) ~ 
8 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=1) ~ 
16 : instr(STX(W,MEM), dst=10, src=1, offset=-12, imm=0) ~ 
24 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ 
32 : instr(STX(W,MEM), dst=10, src=1, offset=-16, imm=0) ~ 
40 : instr(LDX(W,MEM), dst=0, src=10, offset=-12, imm=0) ~ 
48 : instr(LDX(W,MEM), dst=1, src=10, offset=-16, imm=0) ~ 
56 : instr(ALU(X,DIV), dst=0, src=1, offset=0, imm=0) ~ 
64 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 

main [bind=GLOBAL, entry=false]
0 : instr(ALU(K,MOV), dst=3, src=0, offset=0, imm=0) ~ 
8 : instr(STX(W,MEM), dst=10, src=3, offset=-24, imm=0) ~ 
16 : instr(STX(W,MEM), dst=10, src=3, offset=-4, imm=0) ~ 
24 : instr(STX(W,MEM), dst=10, src=1, offset=-8, imm=0) ~ 
32 : instr(STX(DW,MEM), dst=10, src=2, offset=-16, imm=0) ~ 
40 : instr(ALU64(K,MOV), dst=1, src=0, offset=0, imm=0) ~ 
48 : instr(JMP(K,CALL(CALL_IMM)), dst=0, src=1, offset=0, imm=-1) ~ call_dest(xdp_demo,0)
56 : instr(LDX(W,MEM), dst=0, src=10, offset=-24, imm=0) ~ 
64 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 

--PSEUDO-CODE--

xdp_demo [bind=GLOBAL, entry=true]
0 : *(u64 *)(r10 - 8) = r1
8 : r1 = 1
16 : *(u32 *)(r10 - 12) = r1
24 : r1 = 0
32 : *(u32 *)(r10 - 16) = r1
40 : r0 = *(u32 *)(r10 - 12)
48 : r1 = *(u32 *)(r10 - 16)
56 : r0 /= r1
64 : return

main [bind=GLOBAL, entry=false]
0 : r3 = 0
8 : *(u32 *)(r10 - 24) = r3
16 : *(u32 *)(r10 - 4) = r3
24 : *(u32 *)(r10 - 8) = r1
32 : *(u64 *)(r10 - 16) = r2
40 : r1 = 0
48 : call xdp_demo @0
56 : r0 = *(u32 *)(r10 - 24)
64 : return
