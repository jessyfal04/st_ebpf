#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

struct point {
	int x;
	int y;
};

struct point p1 = {
	.x = 1,
	.y = 2,
};

SEC("xdp")
int xdp_demo(void *ctx)
{
	struct point p2;
	p2.x = -20;
	p2.y = 50;

	int mx = (p1.x + p2.x)/2;
	int my = (p1.y + p2.y)/2;

	bpf_printk("Resultat : %d, %d", mx, my);
	return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
