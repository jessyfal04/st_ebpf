--CODES--

xdp
0 : instr(STX(DW,MEM), dst=10, src=1, offset=-16, imm=0) ~ ¤
8 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ ¤
16 : instr(STX(W,MEM), dst=10, src=1, offset=-56, imm=0) ~ ¤
24 : instr(STX(W,MEM), dst=10, src=1, offset=-20, imm=0) ~ ¤
32 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=42) ~ ¤
40 : instr(STX(W,MEM), dst=10, src=1, offset=-24, imm=0) ~ ¤
48 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_dest(.maps,0)
64 : instr(STX(DW,MEM), dst=10, src=1, offset=-48, imm=0) ~ ¤
72 : instr(ALU64(X,MOV), dst=2, src=10, offset=0, imm=0) ~ ¤
80 : instr(ALU64(K,ADD), dst=2, src=0, offset=0, imm=-20) ~ ¤
88 : instr(ALU64(X,MOV), dst=3, src=10, offset=0, imm=0) ~ ¤
96 : instr(ALU64(K,ADD), dst=3, src=0, offset=0, imm=-24) ~ ¤
104 : instr(ALU64(K,MOV), dst=4, src=0, offset=0, imm=0) ~ ¤
112 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=2) ~ call_bpf(map_update_elem)
120 : instr(LDX(W,MEM), dst=2, src=10, offset=-56, imm=0) ~ ¤
128 : instr(LDX(DW,MEM), dst=1, src=10, offset=-48, imm=0) ~ ¤
136 : instr(STX(W,MEM), dst=10, src=2, offset=-28, imm=0) ~ ¤
144 : instr(ALU64(X,MOV), dst=2, src=10, offset=0, imm=0) ~ ¤
152 : instr(ALU64(K,ADD), dst=2, src=0, offset=0, imm=-28) ~ ¤
160 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=1) ~ call_bpf(map_lookup_elem)
168 : instr(STX(DW,MEM), dst=10, src=0, offset=-40, imm=0) ~ ¤
176 : instr(LDX(DW,MEM), dst=1, src=10, offset=-40, imm=0) ~ ¤
184 : instr(JMP(K,JEQ), dst=1, src=0, offset=5, imm=0) ~ ¤
192 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ ¤
200 : instr(LDX(DW,MEM), dst=1, src=10, offset=-40, imm=0) ~ ¤
208 : instr(LDX(W,MEM), dst=1, src=1, offset=0, imm=0) ~ ¤
216 : instr(JMP32(K,JEQ), dst=1, src=0, offset=4, imm=42) ~ ¤
224 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ ¤
232 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=0) ~ ¤
240 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ ¤
248 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=3, imm=0) ~ ¤
256 : instr(ALU(K,MOV), dst=1, src=0, offset=0, imm=2) ~ ¤
264 : instr(STX(W,MEM), dst=10, src=1, offset=-4, imm=0) ~ ¤
272 : instr(JMP(K,JA(OFFSET_JA)), dst=0, src=0, offset=0, imm=0) ~ ¤
280 : instr(LDX(W,MEM), dst=0, src=10, offset=-4, imm=0) ~ ¤
288 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ ¤
