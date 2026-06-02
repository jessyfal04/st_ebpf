  So 0000000000000000 0000000000000068 t my_abs means:

  - function starts at offset 0x0 in the .text/code section
  - size is 0x68 bytes
  - it is a static helper, not a global function

- section headers show:
      - section index 5 is .maps
      - type DATA
  - symbol table shows:
      - map has Ndx = 5
      - so map lives in section 5, i.e. .maps

