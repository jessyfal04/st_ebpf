#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

SEC("xdp")
int xdp_demo(void *ctx)
{
  // String Hello World
  char *chaine = "Hello World from chaine\n";
  bpf_printk("%s", chaine);

  bpf_printk("Hello World from direct\n");
  return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
