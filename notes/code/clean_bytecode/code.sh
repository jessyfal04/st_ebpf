
llvm-objdump -d "$1" | awk '
/^[[:space:]]+[0-9]+:/ {
    out = ""
    for (i = 2; i <= NF; i++) {
        if ($i ~ /^[0-9a-f][0-9a-f]$/) {
            out = out (out == "" ? "" : " ") $i
        } else {
            break
        }
    }
    if (out != "") {
        print out
    }
}'
