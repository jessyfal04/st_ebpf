dir=$1

basename=$(basename "$dir")

dune exec src/instruction_resolv/main.exe -- "$dir" > "${dir}/${basename}.asm"
