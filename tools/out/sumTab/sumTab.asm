--FONCTIONS--

xdp_demo [bind=GLOBAL, entry=true]
0 : instr(STX(DW,MEM), dst=10, src=1, offset=-8, imm=0) ~ 
8 : instr64(LD(DW,IMM), INTEGER, dst=2, src=0, offset=0, imm=0ll) ~ load_dest(.data,0), typ(array_3(int_4))
24 : instr(LDX(W,MEM), dst=1, src=2, offset=0, imm=0) ~ 
32 : instr(LDX(W,MEM), dst=3, src=2, offset=4, imm=0) ~ 
40 : instr(ALU(X,ADD), dst=1, src=3, offset=0, imm=0) ~ 
48 : instr(LDX(W,MEM), dst=2, src=2, offset=8, imm=0) ~ 
56 : instr(ALU(X,ADD), dst=1, src=2, offset=0, imm=0) ~ 
64 : instr(STX(W,MEM), dst=10, src=1, offset=-12, imm=0) ~ 
72 : instr(LDX(W,MEM), dst=3, src=10, offset=-12, imm=0) ~ 
80 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_dest(.rodata,0), typ(datasec(.rodata,xdp_demo.____fmt:array_9(int_1)))
96 : instr(ALU(K,MOV), dst=2, src=0, offset=0, imm=9) ~ 
104 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=6) ~ call_bpf(trace_printk)
112 : instr(STX(DW,MEM), dst=10, src=0, offset=-24, imm=0) ~ 
120 : instr(ALU(K,MOV), dst=0, src=0, offset=0, imm=2) ~ 
128 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 
