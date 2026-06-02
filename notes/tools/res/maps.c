#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

struct {
	__uint(type, BPF_MAP_TYPE_HASH);
	__type(key, __u32);
	__type(value, __u32);
	__uint(max_entries, 1);
} map SEC(".maps");

SEC("xdp")
int xdp_demo(void *ctx)
{
	bpf_map_update_elem(&map, &(__u32){0}, &(__u32){42}, BPF_ANY);
	__u32 key = 0;
	__u32 *value = bpf_map_lookup_elem(&map, &key);

	if (value == NULL || *value != 42)
		return XDP_ABORTED;

	return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
