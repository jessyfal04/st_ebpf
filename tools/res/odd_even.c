#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

// odd and even mutually recursive functions
int odd(int v);
int even(int v);

int odd(int v) {
	if (v == 0) return 0;
	return even(v - 1);
}

int even(int v) {
	if (v == 0) return 1;
	return odd(v - 1);
}

SEC("xdp")
int xdp_demo(void *ctx)
{
	int x = 2;
	
	if (odd(x) != 0)
		return XDP_ABORTED;

	if (even(x) != 1)
		return XDP_ABORTED;

	return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
