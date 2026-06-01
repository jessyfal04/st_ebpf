#define SEC(NAME) __attribute__((section(NAME), used))

SEC("xdp")
int xdp_demo(void *ctx)
{
  int x = 1;
  int y = 1;
  return x + y;
}

char _license[] SEC("license") = "GPL";
