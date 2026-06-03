hex=$1

dune exec src/instruction_resolv/main.exe -- "$hex" > "${hex%.hex}.asm"
