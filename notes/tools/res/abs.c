#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

static int my_abs(int v) {
	if (v < 0) return -v;
	return v;
}

static int my_min(int a, int b) {
	if (a < b) return a;
	return b;
}

SEC("xdp")
int xdp_demo(void *ctx)
{
	int x = -2;
	int y = 2;
	
	if (my_abs(x) != my_abs(y))
		return XDP_ABORTED;

	if (my_min(x, y) != x)
		return XDP_ABORTED;

	return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
