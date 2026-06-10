--FONCTIONS--

xdp_demo [bind=GLOBAL, entry=true]
0 : instr(STX(DW,MEM), dst=10, src=1, offset=-16, imm=0) ~ 
8 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_dest(.bss,0), typ(int_4)
24 : instr(LDX(W,MEM), dst=2, src=1, offset=0, imm=0) ~ 
32 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_dest(.data,0), typ(int_4)
48 : instr(LDX(W,MEM), dst=1, src=1, offset=0, imm=0) ~ 
56 : instr(ALU(X,ADD), dst=2, src=1, offset=0, imm=0) ~ 
64 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_dest(.bss,4), typ(int_4)
80 : instr(LDX(W,MEM), dst=3, src=1, offset=0, imm=0) ~ 
88 : instr(ALU(X,ADD), dst=2, src=3, offset=0, imm=0) ~ 
96 : instr(ALU(K,ADD), dst=2, src=0, offset=0, imm=2) ~ 
104 : instr(STX(W,MEM), dst=1, src=2, offset=0, imm=0) ~ 
112 : instr64(LD(DW,IMM), INTEGER, dst=2, src=0, offset=0, imm=0ll) ~ load_dest(.rodata.str1.1,0), typ(elf)
128 : instr(STX(DW,MEM), dst=10, src=2, offset=-24, imm=0) ~ 
136 : instr(LDX(W,MEM), dst=1, src=1, offset=0, imm=0) ~ 
144 : instr(JMP32(K,JNE), dst=1, src=0, offset=10, imm=42) ~ goto_dest(232)
152 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(160)
160 : instr(LDX(DW,MEM), dst=3, src=10, offset=-24, imm=0) ~ 
168 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=4ll) ~ load_dest(.rodata,4), typ(datasec(.rodata,xdp_demo.____fmt:array_9(int_1)))
184 : instr(ALU(K,MOV), dst=2, src=0, offset=0, imm=9) ~ 
192 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=6) ~ call_bpf(trace_printk)
200 : instr(STX(DW,MEM), dst=10, src=0, offset=-32, imm=0) ~ 
208 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ 
216 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
224 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=9, imm=0) ~ goto_dest(304)
232 : instr(LDX(DW,MEM), dst=3, src=10, offset=-24, imm=0) ~ 
240 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=13ll) ~ load_dest(.rodata,13), typ(datasec(.rodata,xdp_demo.____fmt.1:array_9(int_1)))
256 : instr(ALU(K,MOV), dst=2, src=0, offset=0, imm=9) ~ 
264 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=6) ~ call_bpf(trace_printk)
272 : instr(STX(DW,MEM), dst=10, src=0, offset=-40, imm=0) ~ 
280 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=2) ~ 
288 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ 
296 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ goto_dest(304)
304 : instr(LDX(W,MEM), dst=0, src=10, offset=-4, imm=0) ~ 
312 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 
