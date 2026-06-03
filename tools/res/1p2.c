#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

SEC("xdp")
int xdp_demo(void *ctx)
{
  int x = 1;
  int y = 2;
  return x + y;
}

char _license[] SEC("license") = "GPL";
