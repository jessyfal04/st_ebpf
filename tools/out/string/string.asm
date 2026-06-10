--FONCTIONS--

xdp_demo [bind=GLOBAL, entry=true]
0 : instr(STX(DW,MEM), dst=10, src=1, offset=-8, imm=0) ~ 
8 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_dest(.rodata.str1.1,0), typ(elf)
24 : instr(STX(DW,MEM), dst=10, src=1, offset=-16, imm=0) ~ 
32 : instr(LDX(DW,MEM), dst=3, src=10, offset=-16, imm=0) ~ 
40 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_dest(.rodata,0), typ(datasec)
56 : instr(ALU(K,MOV), dst=2, src=0, offset=0, imm=3) ~ 
64 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=6) ~ call_bpf(trace_printk)
72 : instr(STX(DW,MEM), dst=10, src=0, offset=-24, imm=0) ~ 
80 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=3ll) ~ load_dest(.rodata,0), typ(datasec)
96 : instr(ALU(K,MOV), dst=2, src=0, offset=0, imm=25) ~ 
104 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=6) ~ call_bpf(trace_printk)
112 : instr(STX(DW,MEM), dst=10, src=0, offset=-32, imm=0) ~ 
120 : instr(ALU(K,MOV), dst=0, src=0, offset=0, imm=2) ~ 
128 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 
