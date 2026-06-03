#!/usr/bin/env bash
if [ "$#" -ne 1 ]; then
    echo "usage: $0 <prog.o>" >&2
    exit 1
fi

obj=$1

# On crée un dossier pour stocker les extractions
basename=$(basename "$obj" .o)

# Sous-dossiers résurssivement
for dir in sections symb code reloc data; do
    mkdir -p "out/$basename/$dir"
done

# Listage des SECTION présentes
readelf -S $obj --wide > "out/$basename/sections/_sections_readelf.txt"
llvm-objdump -h "$obj" > "out/$basename/sections/_sections_llvm-objdump.txt"
{
    printf "IDX\tNAME\tSIZE\tVMA\tTYPE\n"
    llvm-objdump -h "$obj" |
    awk '
        /^[[:space:]]*[0-9]+[[:space:]]+/ {
            print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5
        }
    '
} > "out/$basename/sections/${basename}_sections.tsv"

# Extrait la section de CODE (type TEXT) et non vides, et de leurs sections si non vide
llvm-objdump -h "$obj" |
awk '$5 == "TEXT" && $3 != "00000000" { print $2 }' |

while read -r section; do
    safe_section=${section//\//_}
    name="${basename}_${safe_section}"

    llvm-objcopy --dump-section "$section=out/$basename/code/$name.bin" "$obj" /dev/null #binaire
    od --address-radix n --format x1 --output-duplicates --width 8 "out/$basename/code/$name.bin" > "out/$basename/code/$name.hex" #hexadecimal
    llvm-objdump -dSr --full-leading-addr --section="$section" "$obj" > "out/$basename/code/$name.txt" #code humain

    echo "Section $name extraite."

    # Extraction des RELOCATIONS (.rel)depuis la section TEXT courante, si elle existe
    rel_section=".rel${section}"
    llvm-objdump -h "$obj" |
    awk -v rel="$rel_section" '$2 == rel && $3 != "00000000" { print $2 }' |
    while read -r rel_section; do
        name_reloc="${basename}_${safe_section}_reloc"

        llvm-objdump -r --section=$rel_section "$obj" |
        awk '
            /^OFFSET[[:space:]]+TYPE[[:space:]]+VALUE$/ { print "OFFSET\tTYPE\tVALUE"; next }
            /^[0-9a-f]+[[:space:]]+R_/ { printf "%s\t%s\t%s\n", $1, $2, $3; next }
        ' > "out/$basename/reloc/${name_reloc}.tsv"

        echo "Section ${name_reloc}.tsv extraite."
    done

done

# Extraction DATA (licence et .rodata, .data, .bss)
llvm-objdump -h "$obj" |
awk '$5 == "DATA" && $3 != "00000000" { print $2 }' |

while read -r section; do
    safe_section=${section//\//_}
    name="${basename}_${safe_section}"

    llvm-objcopy --dump-section "$section=out/$basename/data/${name}.bin" "$obj" /dev/null
    od --address-radix n --format c --output-duplicates  "out/$basename/data/${name}.bin" > "out/$basename/data/${name}.txt"
    
    echo "Section $name extraite."
done

# Extraction des SYMBOLES
{
    printf "VALUE\tSIZE\tTYPE\tNAME\n"
    llvm-nm -S --defined-only "$obj" | awk 'NF >= 4 { print $1 "\t" $2 "\t" $3 "\t" $4 }'
} > "out/$basename/symb/${basename}_symb.tsv"
echo "Symboles extraits."

{
    printf "VALUE\tSIZE\tNDX\tNAME\n"
    llvm-readelf -s --wide "$obj" |
    awk '
        /^[[:space:]]*[0-9]+:/ {
            print $2 "\t" $3 "\t" $7 "\t" $8
        }
    '
} > "out/$basename/symb/${basename}_symbSec.tsv"
echo "Symboles avec section extraits."

# Extraction des types (.BTF)



