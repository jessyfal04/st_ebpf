#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

SEC("xdp")
int xdp_demo(void *ctx)
{
  unsigned int x = 1;
  unsigned int y = 0;
  return x / y;
}

int main(int argc, char **argv)
{
  (void)argc;
  (void)argv;
  xdp_demo(NULL);
  return 0;
}

char _license[] SEC("license") = "GPL";
