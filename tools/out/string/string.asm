--CODES--

./out/string/code/string_xdp.hex
0 : instr(STX(DW,MEM), dst=10, src=1, offset=-8, imm=0)
8 : instr64(LD(DW,IMM), dst=1, src=0, offset=0, imm=0ll)
24 : instr(STX(DW,MEM), dst=10, src=1, offset=-16, imm=0)
32 : instr(LDX(DW,MEM), dst=3, src=10, offset=-16, imm=0)
40 : instr64(LD(DW,IMM), dst=1, src=0, offset=0, imm=0ll)
56 : instr(ALU(K,MOV), dst=2, src=0, offset=0, imm=3)
64 : instr(JMP(K,CALL), dst=0, src=0, offset=0, imm=6)
72 : instr(STX(DW,MEM), dst=10, src=0, offset=-24, imm=0)
80 : instr64(LD(DW,IMM), dst=1, src=0, offset=0, imm=3ll)
96 : instr(ALU(K,MOV), dst=2, src=0, offset=0, imm=25)
104 : instr(JMP(K,CALL), dst=0, src=0, offset=0, imm=6)
112 : instr(STX(DW,MEM), dst=10, src=0, offset=-32, imm=0)
120 : instr(ALU(K,MOV), dst=0, src=0, offset=0, imm=2)
128 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0)
