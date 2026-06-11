#!/usr/bin/env bash
if [ "$#" -ne 1 ]; then
    echo "usage: $0 <prog.o>" >&2
    exit 1
fi

obj=$1

# On crée un dossier pour stocker les extractions
basename=$(basename "$obj" .o)

# Sous-dossiers résurssivement
for dir in code reloc data tsv; do
    mkdir -p "out/$basename/$dir"
done

# Listage des SECTION présentes
# readelf -S $obj --wide > "out/$basename/sections/_sections_readelf.txt"
# llvm-objdump -h "$obj" > "out/$basename/sections/_sections_llvm-objdump.txt"
llvm-objdump -h "$obj" > "out/$basename/tsv/sections.txt"
{
    printf "IDX\tNAME\tSIZE\tTYPE\n"
    llvm-objdump -h "$obj" |
    awk '
        /^[[:space:]]*[0-9]+[[:space:]]+/ {
            print $1 "\t" $2 "\t" $3 "\t" $5
        }
    '
} > "out/$basename/tsv/sections.tsv"

# Extrait la section de CODE (type TEXT) et non vides, et de leurs sections si non vide
llvm-objdump -h "$obj" |
awk '$5 == "TEXT" && $3 != "00000000" { print $2 }' |

while read -r section; do
    safe_section=${section//\//_}
    name="${safe_section}"

    llvm-objcopy --dump-section "$section=out/$basename/code/$name.bin" "$obj" /dev/null #binaire
    od --address-radix n --format x1 --output-duplicates --width 8 "out/$basename/code/$name.bin" | tr -d ' ' > "out/$basename/code/$name.hex" #hexadecimal
    llvm-objdump -dSr --full-leading-addr --section="$section" "$obj" > "out/$basename/code/$name.txt" #code humain

    echo "Section $name extraite."

    # Extraction des RELOCATIONS (.rel)depuis la section TEXT courante, si elle existe
    rel_section=".rel${section}"
    llvm-objdump -h "$obj" |
    awk -v rel="$rel_section" '$2 == rel && $3 != "00000000" { print $2 }' |
    while read -r rel_section; do
        name_reloc="${safe_section}_reloc"

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

    llvm-objcopy --dump-section "$section=out/$basename/data/${safe_section}.bin" "$obj" /dev/null
    od --address-radix n --format c --output-duplicates  "out/$basename/data/${safe_section}.bin" > "out/$basename/data/${safe_section}.txt"
    
    echo "Section $name extraite."
done

# Extraction des SYMBOLES
# {
#     printf "VALUE\tSIZE\tTYPE\tNAME\n"
#     llvm-nm -S --defined-only "$obj" | awk 'NF >= 4 { print $1 "\t" $2 "\t" $3 "\t" $4 }'
# } > "out/$basename/symb/${basename}_symb.tsv"
# echo "Symboles extraits."
llvm-readelf -s --wide "$obj" > "out/$basename/tsv/symb.txt"
{
    printf "VALUE\tSIZE\tTYPE\tBIND\tNDX\tNAME\n"
    llvm-readelf -s --wide "$obj" |
    awk '
        /^[[:space:]]*[0-9]+:/ {
            print $2 "\t" $3 "\t" $4 "\t" $5 "\t" $7 "\t" $8
        }
    '
} > "out/$basename/tsv/symb.tsv"
echo "Symboles avec section extraits."

# Extraction des types (.BTF) - IA TSV
bpftool btf dump file $obj > "out/$basename/tsv/btf.txt"
bpftool btf dump file "$obj" format raw | 
awk '
BEGIN {
    OFS = "\t"
    print "ID", "PARENT_ID", "IDX", "KIND", "NAME", "ATTRS"
}

function trim(s) {
    sub(/^[[:space:]]+/, "", s)
    sub(/[[:space:]]+$/, "", s)
    return s
}

function qname(s,    q) {
    q = sprintf("%c", 39)
    if (match(s, q "[^" q "]*" q))
        return substr(s, RSTART + 1, RLENGTH - 2)
    return ""
}

function emit_struct_child(parent_id, idx, raw,    name, attrs, q) {
    name = qname(raw)
    attrs = raw
    q = sprintf("%c", 39)
    sub("^[[:space:]]*" q "[^" q "]+" q "[[:space:]]+", "", attrs)
    print -1, parent_id, idx, "MEMBER", name, trim(attrs)
}

function emit_datasec_child(parent_id, idx, raw,    attrs, name, q) {
    attrs = raw
    name = qname(raw)
    sub(/^[[:space:]]+/, "", attrs)
    q = sprintf("%c", 39)
    sub("[[:space:]]*\\(VAR[[:space:]]+" q "[^" q "]+" q "\\)$", "", attrs)
    print -1, parent_id, idx, "DATASEC_ENTRY", name, trim(attrs)
}

/^\[[0-9]+\]/ {
    raw = $0

    id = raw
    sub(/^\[/, "", id)
    sub(/\].*$/, "", id)

    rest = raw
    sub(/^\[[0-9]+\][[:space:]]+/, "", rest)

    kind = rest
    sub(/[[:space:]].*$/, "", kind)

    name = qname(rest)

    attrs = rest
    sub(/^[A-Z_]+[[:space:]]+/, "", attrs)

    q = sprintf("%c", 39)
    sub(q "[^" q "]*" q "[[:space:]]*", "", attrs)

    cur_id = id
    cur_kind = kind
    child_idx = 0

    print id, -1, -1, kind, name, trim(attrs)
    next
}

/^[[:space:]]+/ {
    if (cur_kind == "STRUCT") {
        emit_struct_child(cur_id, child_idx, $0)
        child_idx++
    } else if (cur_kind == "DATASEC") {
        emit_datasec_child(cur_id, child_idx, $0)
        child_idx++
    }
    next
}
' > "out/$basename/tsv/btf.tsv"
