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

--PSEUDO-CODE--

xdp_demo [bind=GLOBAL, entry=true]
0 : *(u64 *)(r10 - 16) = r1
8 : r1 = &.bss <int_4>
24 : r2 = *(u32 *)(r1 + 0)
32 : r1 = &.data <int_4>
48 : r1 = *(u32 *)(r1 + 0)
56 : r2 += r1
64 : r1 = &.bss + 4 <int_4>
80 : r3 = *(u32 *)(r1 + 0)
88 : r2 += r3
96 : r2 += 2
104 : *(u32 *)(r1 + 0) = r2
112 : r2 = &.rodata.str1.1 <elf>
128 : *(u64 *)(r10 - 24) = r2
136 : r1 = *(u32 *)(r1 + 0)
144 : if (u64)r1 != (u64)42 goto 232
152 : goto 160
160 : r3 = *(u64 *)(r10 - 24)
168 : r1 = &.rodata + 4 <datasec(.rodata,xdp_demo.____fmt:array_9(int_1))>
184 : r2 = 9
192 : call trace_printk
200 : *(u64 *)(r10 - 32) = r0
208 : r1 = 0
216 : *(u32 *)(r10 - 4) = r1
224 : goto 304
232 : r3 = *(u64 *)(r10 - 24)
240 : r1 = &.rodata + 13 <datasec(.rodata,xdp_demo.____fmt.1:array_9(int_1))>
256 : r2 = 9
264 : call trace_printk
272 : *(u64 *)(r10 - 40) = r0
280 : r1 = 2
288 : *(u32 *)(r10 - 4) = r1
296 : goto 304
304 : r0 = *(u32 *)(r10 - 4)
312 : return
