#!/usr/bin/env bash
if [ "$#" -ne 1 ]; then
    echo "usage: $0 <prog.o>" >&2
    exit 1
fi

obj=$1

# On crée un dossier pour stocker les sections extraites
basename=$(basename "$obj" .o)
mkdir -p "out/$basename"

# Listage des sections présentes
readelf -S $obj --wide > "out/$basename/_sections_readelf.txt"
llvm-objdump -h "$obj" > "out/$basename/_sections_llvm-objdump.txt"

# Extraction des symboles (en TSV)
{
    printf "VALUE\tSIZE\tTYPE\tNAME\n"
    llvm-nm -S --defined-only "$obj" | awk 'NF >= 4 { print $1 "\t" $2 "\t" $3 "\t" $4 }'
} > "out/$basename/${basename}_symb.tsv"
echo "Symboles extraits."

# Extrait la section de code "sectionName" (type TEXT) et non vide
sectionName=$(llvm-objdump -h "$obj" | awk '$5 == "TEXT" && $3 != "00000000" { print $2; exit }')

safe_sectionName=${sectionName//\//_}
name="${basename}_${safe_sectionName}"

llvm-objcopy --dump-section "$sectionName=out/$basename/$name.bin" "$obj" /dev/null #binaire
od --address-radix n --format x1 --output-duplicates --width 8 "out/$basename/$name.bin" > "out/$basename/$name.hex" #hexadecimal
llvm-objdump -dSr --section="$sectionName" "$obj" > "out/$basename/$name.txt" #code humain

echo "Section $name extraite."

# Extraction DATA (licence et .rodata, .data, .bss)
llvm-objdump -h "$obj" |
awk '$5 == "DATA" && $3 != "00000000" { print $2 }' |

while read -r section; do
    safe_section=${section//\//_}
    name="${basename}_${safe_section}"

    llvm-objcopy --dump-section "$section=out/$basename/${name}.bin" "$obj" /dev/null
    od --address-radix n --format c --output-duplicates  "out/$basename/${name}.bin" > "out/$basename/${name}.txt"
    
    echo "Section $name extraite."
done

# Extraction relocation (.rel$sectionName)
rel_section=".rel${sectionName}"
name_reloc="${basename}_reloc"

llvm-objdump -r --section=$rel_section "$obj" |
awk '
    /^OFFSET[[:space:]]+TYPE[[:space:]]+VALUE$/ { print "OFFSET\tTYPE\tVALUE"; next }
    /^[0-9a-f]+[[:space:]]+R_/ { printf "%s\t%s\t%s\n", $1, $2, $3; next }
' > "out/$basename/${name_reloc}.tsv"
echo "Section ${name_reloc}.tsv extraite."
