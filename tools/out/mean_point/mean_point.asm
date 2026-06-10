--FONCTIONS--

xdp_demo [bind=GLOBAL, entry=true]
0 : instr(STX(DW,MEM), dst=10, src=1, offset=-8, imm=0) ~ 
8 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=-20) ~ 
16 : instr(STX(W,MEM), dst=10, src=1, offset=-16, imm=0) ~ 
24 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=50) ~ 
32 : instr(STX(W,MEM), dst=10, src=1, offset=-12, imm=0) ~ 
40 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_dest(.data,0), typ(struct(s.8, v.2))
56 : instr(LDX(W,MEM), dst=2, src=1, offset=0, imm=0) ~ 
64 : instr(LDX(W,MEM), dst=3, src=10, offset=-16, imm=0) ~ 
72 : instr(ALU(X,ADD), dst=2, src=3, offset=0, imm=0) ~ 
80 : instr(ALU(X,MOV), dst=3, src=2, offset=0, imm=0) ~ 
88 : instr(ALU(K,RSH), dst=3, src=0, offset=0, imm=31) ~ 
96 : instr(ALU(X,ADD), dst=2, src=3, offset=0, imm=0) ~ 
104 : instr(ALU(K,ARSH), dst=2, src=0, offset=0, imm=1) ~ 
112 : instr(STX(W,MEM), dst=10, src=2, offset=-20, imm=0) ~ 
120 : instr(LDX(W,MEM), dst=1, src=1, offset=4, imm=0) ~ 
128 : instr(LDX(W,MEM), dst=2, src=10, offset=-12, imm=0) ~ 
136 : instr(ALU(X,ADD), dst=1, src=2, offset=0, imm=0) ~ 
144 : instr(ALU(X,MOV), dst=2, src=1, offset=0, imm=0) ~ 
152 : instr(ALU(K,RSH), dst=2, src=0, offset=0, imm=31) ~ 
160 : instr(ALU(X,ADD), dst=1, src=2, offset=0, imm=0) ~ 
168 : instr(ALU(K,ARSH), dst=1, src=0, offset=0, imm=1) ~ 
176 : instr(STX(W,MEM), dst=10, src=1, offset=-24, imm=0) ~ 
184 : instr(LDX(W,MEM), dst=3, src=10, offset=-20, imm=0) ~ 
192 : instr(LDX(W,MEM), dst=4, src=10, offset=-24, imm=0) ~ 
200 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_dest(.rodata,0), typ(datasec)
216 : instr(ALU(K,MOV), dst=2, src=0, offset=0, imm=18) ~ 
224 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=6) ~ call_bpf(trace_printk)
232 : instr(STX(DW,MEM), dst=10, src=0, offset=-32, imm=0) ~ 
240 : instr(ALU(K,MOV), dst=0, src=0, offset=0, imm=2) ~ 
248 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 
