#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

SEC("xdp")
int sum_15(void *ctx)
{
	int sum = 0;
  	for (int i = 0; i < 15; i++) {
		sum += i;
  	}
	
	bpf_printk("sum: %d\n", sum);
  	return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
