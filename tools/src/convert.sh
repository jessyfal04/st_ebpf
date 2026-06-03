if [ "$#" -ne 1 ]; then
    echo "usage: $0 <prog.c>" >&2
    exit 1
fi

c=$1

basename=$(basename "$c" .c)
mkdir -p "out/$basename"

clang -target bpfel -O0 -g \
    -I/usr/include/x86_64-linux-gnu \
    -I../other/bpftool/src/libbpf/include \
    -c "$c" -o "res/$basename.o"
# llvm-objdump -dSr out/$basename/$basename.o > out/$basename/$basename.dis
