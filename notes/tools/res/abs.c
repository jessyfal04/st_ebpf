#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

static int my_abs(int v) {
	if (v < 0) return -v;
	return v;
}

SEC("xdp")
int xdp_demo(void *ctx)
{
	int x = -2;
	int y = 2;
	
	if (my_abs(x) != my_abs(y))
		return XDP_ABORTED;

	return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
