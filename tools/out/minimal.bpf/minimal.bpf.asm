--FONCTIONS--

handle_tp [bind=GLOBAL, entry=true]
0 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=14) ~ call_bpf(get_current_pid_tgid)
8 : instr(ALU64(K,RSH), dst=0, src=0, offset=0, imm=32) ~ 
16 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_dest(.bss,0), typ(int_4)
32 : instr(LDX(W,MEM), dst=1, src=1, offset=0, imm=0) ~ 
40 : instr(JMP32(X,JNE), dst=1, src=0, offset=5, imm=0) ~ goto_dest(88)
48 : instr64(LD(DW,IMM), INTEGER, dst=1, src=0, offset=0, imm=0ll) ~ load_dest(.rodata,0), typ(datasec(.rodata,handle_tp.____fmt:array_28(int_1)))
64 : instr(ALU(K,MOV), dst=2, src=0, offset=0, imm=28) ~ 
72 : instr(ALU(X,MOV), dst=3, src=0, offset=0, imm=0) ~ 
80 : instr(JMP(K,CALL(STATIC_ID)), dst=0, src=0, offset=0, imm=6) ~ call_bpf(trace_printk)
88 : instr(ALU(K,MOV), dst=0, src=0, offset=0, imm=0) ~ 
96 : instr(JMP(K,EXIT), dst=0, src=0, offset=0, imm=0) ~ 

--PSEUDO-CODE--

handle_tp [bind=GLOBAL, entry=true]
0 : call get_current_pid_tgid
8 : r0 >>= 32
16 : r1 = &.bss <int_4>
32 : r1 = *(u32 *)(r1 + 0)
40 : if (u64)r1 != (u64)r0 goto 88
48 : r1 = &.rodata <datasec(.rodata,handle_tp.____fmt:array_28(int_1))>
64 : r2 = 28
72 : r3 = r0
80 : call trace_printk
88 : r0 = 0
96 : return
