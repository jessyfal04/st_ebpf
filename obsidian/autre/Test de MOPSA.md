# Installation
opam exec -- dune build --profile release -p mopsa
make install

# Test en C
- On a ajouté un main qui appelle la section xdp. Ce main fait juste le strict minimum.

```c
int main(int argc, char **argv)
{
  (void)argc;
  (void)argv;
  xdp_demo(NULL);
  return 0;
}

// 1p2 :
SEC("xdp")
int xdp_demo(void *ctx)
{
  int x = 1;
  int y = 2;
  return x + y;
}

// 1d0 :
SEC("xdp")
int xdp_demo(void *ctx)
{
  unsigned int x = 1;
  unsigned int y = 0;
  return x / y;
}
```

## Test de 1p2 mais avec C

```shell
yepssy@yep:~/Nextcloud/STL/ST_LIP6/tools$ mopsa-c .//res/1p2.c
Analysis terminated successfully
✔ No alarm
Analysis time: 0.082s
Checks summary: 4 total, ✔ 4 safe (selectivity: 100.00%)
  Invalid memory access: 1 total, ✔ 1 safe
  Integer overflow: 1 total, ✔ 1 safe
  Incorrect number of arguments: 2 total, ✔ 2 safe
```

## Test de 1d0 mais avec C
```shell
yepssy@yep:~/Nextcloud/STL/ST_LIP6/tools$ mopsa-c ./res/1d0.c
Analysis terminated successfully
Analysis time: 0.080s

✗ Check #3:
./res/1d0.c: In function 'xdp_demo':
./res/1d0.c:9.9-14: error: Division by zero
  
  9:   return x / y;
              ^^^^^ 
  denominator 'y' may be null
  Callstack:
        from ./res/1d0.c:16.2-16: xdp_demo
        from ./res/1d0.c:12.4-8: main

Checks summary: 6 total, ✔ 5 safe, ✗ 1 error (selectivity: 83.34%)
  Invalid memory access: 1 total, ✔ 1 safe
  Division by zero: 1 total, ✗ 1 error
  Integer overflow: 2 total, ✔ 2 safe
  Incorrect number of arguments: 2 total, ✔ 2 safe
```
