--FONCTIONS--

xdp_demo [bind=GLOBAL, entry=true]
0 : instr(STX(DW,MEM), dst=10, src=1, offset=-16, imm=0) ~ ¤
8 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=2) ~ ¤
16 : instr(STX(W,MEM), dst=10, src=1, offset=-20, imm=0) ~ ¤
24 : instr(LDX(W,MEM), dst=1, src=10, offset=-20, imm=0) ~ ¤
32 : instr(JMP(K,CALL(CALL_IMM)), dst=0, src=1, offset=0, imm=-1) ~ call_dest(odd,0)
40 : instr(JMP32(K,JEQ), dst=0, src=0, offset=4, imm=0) ~ ¤
48 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ ¤
56 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ ¤
64 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ ¤
72 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=10, imm=0) ~ ¤
80 : instr(LDX(W,MEM), dst=1, src=10, offset=-20, imm=0) ~ ¤
88 : instr(JMP(K,CALL(CALL_IMM)), dst=0, src=1, offset=0, imm=13) ~ call_dest(even,0)
96 : instr(JMP32(K,JEQ), dst=0, src=0, offset=4, imm=1) ~ ¤
104 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ ¤
112 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ ¤
120 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ ¤
128 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=3, imm=0) ~ ¤
136 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=2) ~ ¤
144 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ ¤
152 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ ¤
160 : instr(LDX(W,MEM), dst=0, src=10, offset=-4, imm=0) ~ ¤
168 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ ¤
