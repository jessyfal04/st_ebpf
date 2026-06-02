#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

int x = 0;
int y = 1;
const int z = 2;
int res = 42;

SEC("xdp")
int xdp_demo(void *ctx)
{
	int sum = x + y + z;

	char *chaine = "Calcul : \n";

	if (sum == res) {
		bpf_printk("%s Nope\n", chaine);
		return XDP_ABORTED;
	}

	bpf_printk("%s Nice\n", chaine);
	return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
