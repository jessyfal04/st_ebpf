clang -target bpfel -O0 -g -c test.c -o test.o
llvm-objdump -d test.o | tee test.dis
