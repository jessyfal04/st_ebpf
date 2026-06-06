--CODES--

xdp
0 : instr(STX(DW,MEM), dst=10, src=1, offset=-8, imm=0) ~ ¤
8 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=1) ~ ¤
16 : instr(STX(W,MEM), dst=10, src=1, offset=-12, imm=0) ~ ¤
24 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=2) ~ ¤
32 : instr(STX(W,MEM), dst=10, src=1, offset=-16, imm=0) ~ ¤
40 : instr(LDX(W,MEM), dst=0, src=10, offset=-12, imm=0) ~ ¤
48 : instr(LDX(W,MEM), dst=1, src=10, offset=-16, imm=0) ~ ¤
56 : instr(ALU(X,ADD), dst=0, src=1, offset=0, imm=0) ~ ¤
64 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ ¤
