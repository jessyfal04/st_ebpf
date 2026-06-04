--CODES--

./out/minimal.bpf/code/minimal.bpf_tp_syscalls_sys_enter_write.hex
instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0)
instr(ALU(K,MOV), dst=0, src=0, offset=0, imm=0)
instr(JMP(K,CALL), dst=0, src=0, offset=0, imm=6)
instr(ALU(X,MOV), dst=3, src=0, offset=0, imm=0)
instr(ALU(K,MOV), dst=2, src=0, offset=0, imm=28)
instr(LD(W,IMM), dst=0, src=0, offset=0, imm=0)
instr(LD(DW,IMM), dst=1, src=0, offset=0, imm=0)
instr(JMP32(X,JNE), dst=1, src=0, offset=5, imm=0)
instr(LDX(W,MEM), dst=1, src=1, offset=0, imm=0)
instr(LD(W,IMM), dst=0, src=0, offset=0, imm=0)
instr(LD(DW,IMM), dst=1, src=0, offset=0, imm=0)
instr(ALU64(K,RSH), dst=0, src=0, offset=0, imm=32)
instr(JMP(K,CALL), dst=0, src=0, offset=0, imm=14)
