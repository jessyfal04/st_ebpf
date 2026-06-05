--CODES--

xyz_xdp
0 : instr(STX(DW,MEM), dst=10, src=1, offset=-16, imm=0) ~ ¤
8 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ ¤
24 : instr(LDX(W,MEM), dst=1, src=1, offset=0, imm=0) ~ ¤
32 : instr64(LD(DW,IMM), INTEGER, dst=2, src=0, offset=0, imm=0ll) ~ ¤
48 : instr(LDX(W,MEM), dst=2, src=2, offset=0, imm=0) ~ ¤
56 : instr(ALU(X,ADD), dst=1, src=2, offset=0, imm=0) ~ ¤
64 : instr(ALU(K,ADD), dst=1, src=0, offset=0, imm=2) ~ ¤
72 : instr(STX(W,MEM), dst=10, src=1, offset=-20, imm=0) ~ ¤
80 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ ¤
96 : instr(STX(DW,MEM), dst=10, src=1, offset=-32, imm=0) ~ ¤
104 : instr(LDX(W,MEM), dst=1, src=10, offset=-20, imm=0) ~ ¤
112 : instr64(LD(DW,IMM), INTEGER, dst=2, src=0, offset=0, imm=0ll) ~ ¤
128 : instr(LDX(W,MEM), dst=2, src=2, offset=0, imm=0) ~ ¤
136 : instr(JMP32(X,JNE), dst=1, src=2, offset=10, imm=0) ~ ¤
144 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ ¤
152 : instr(LDX(DW,MEM), dst=3, src=10, offset=-32, imm=0) ~ ¤
160 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=4ll) ~ ¤
176 : instr(ALU(K,MOV), dst=2, src=0, offset=0, imm=9) ~ ¤
184 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=6) ~ info(trace_printk)
192 : instr(STX(DW,MEM), dst=10, src=0, offset=-40, imm=0) ~ ¤
200 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ ¤
208 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ ¤
216 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=9, imm=0) ~ ¤
224 : instr(LDX(DW,MEM), dst=3, src=10, offset=-32, imm=0) ~ ¤
232 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=13ll) ~ ¤
248 : instr(ALU(K,MOV), dst=2, src=0, offset=0, imm=9) ~ ¤
256 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=6) ~ info(trace_printk)
264 : instr(STX(DW,MEM), dst=10, src=0, offset=-48, imm=0) ~ ¤
272 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=2) ~ ¤
280 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ ¤
288 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ ¤
296 : instr(LDX(W,MEM), dst=0, src=10, offset=-4, imm=0) ~ ¤
304 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ ¤
