#!/usr/bin/env bash
if [ "$#" -ne 1 ]; then
    echo "usage: $0 <prog.o>" >&2
    exit 1
fi

obj=$1

# On crée un dossier pour stocker les sections extraites
basename=$(basename "$obj" .o)
mkdir -p "$basename"

# On affiche les sections présentes
readelf -S $obj --wide > "$basename/_sections_readelf.txt"
llvm-objdump -h "$obj" > "$basename/_sections_llvm-objdump.txt"

# On extrait le obj et on garde que les sections TEXT non vides
llvm-objdump -h "$obj" |
awk '$5 == "TEXT" && $3 != "00000000" { print $2 }' |

# On lit ligne par ligne chaque section
while read -r section; do
    safe_section=${section//\//_}
    name="${basename}_${safe_section}"
    
    # On extrait le code-octet de la section
    llvm-objcopy --dump-section "$section=$basename/$name.bin" "$obj" /dev/null

    # On convertit en hexadécimal 
    od --address-radix n --format x1 --output-duplicates --width 8 "$basename/$name.bin" > "$basename/$name.hex"

    # On désassemble la section et on stocke le résultat dans un fichier texte
    llvm-objdump -d --section="$section" "$obj" > "$basename/$name.txt"

    echo "Section $name extraite."
done
