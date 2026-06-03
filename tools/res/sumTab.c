#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

int tab[3] = { 1, 2, 3 };

SEC("xdp")
int xdp_demo(void *ctx)
{
	int sum = tab[0] + tab[1] + tab[2];
	
	bpf_printk("Res: %d\n", sum);

	return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
