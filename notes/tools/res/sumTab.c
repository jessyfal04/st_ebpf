#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

#define taille 4
int tab[taille] = { 1, 2, 3, 4 };

SEC("xdp")
int xdp_demo(void *ctx)
{
	int sum = 0;
	for (int i = 0; i < taille; i++) {
		int sum = tab[i];
	}

	bpf_printk("Resultat : %d", sum);

	return XDP_ABORTED;
}

char _license[] SEC("license") = "GPL";
