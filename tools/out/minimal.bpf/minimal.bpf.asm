--CODES--

minimal.bpf_tp_syscalls_sys_enter_write
0 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=14) ~ info(get_current_pid_tgid)
8 : instr(ALU64(K,RSH), dst=0, src=0, offset=0, imm=32) ~ ¤
16 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ ¤
32 : instr(LDX(W,MEM), dst=1, src=1, offset=0, imm=0) ~ ¤
40 : instr(JMP32(X,JNE), dst=1, src=0, offset=5, imm=0) ~ ¤
48 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ ¤
64 : instr(ALU(K,MOV), dst=2, src=0, offset=0, imm=28) ~ ¤
72 : instr(ALU(X,MOV), dst=3, src=0, offset=0, imm=0) ~ ¤
80 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=6) ~ info(trace_printk)
88 : instr(ALU(K,MOV), dst=0, src=0, offset=0, imm=0) ~ ¤
96 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ ¤
