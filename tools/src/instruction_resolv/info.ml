open Instruction
open Table

let bpf_func_names =
  [|
    "unspec";
    "map_lookup_elem";
    "map_update_elem";
    "map_delete_elem";
    "probe_read";
    "ktime_get_ns";
    "trace_printk";
    "get_prandom_u32";
    "get_smp_processor_id";
    "skb_store_bytes";
    "l3_csum_replace";
    "l4_csum_replace";
    "tail_call";
    "clone_redirect";
    "get_current_pid_tgid";
    "get_current_uid_gid";
    "get_current_comm";
    "get_cgroup_classid";
    "skb_vlan_push";
    "skb_vlan_pop";
    "skb_get_tunnel_key";
    "skb_set_tunnel_key";
    "perf_event_read";
    "redirect";
    "get_route_realm";
    "perf_event_output";
    "skb_load_bytes";
    "get_stackid";
    "csum_diff";
    "skb_get_tunnel_opt";
    "skb_set_tunnel_opt";
    "skb_change_proto";
    "skb_change_type";
    "skb_under_cgroup";
    "get_hash_recalc";
    "get_current_task";
    "probe_write_user";
    "current_task_under_cgroup";
    "skb_change_tail";
    "skb_pull_data";
    "csum_update";
    "set_hash_invalid";
    "get_numa_node_id";
    "skb_change_head";
    "xdp_adjust_head";
    "probe_read_str";
    "get_socket_cookie";
    "get_socket_uid";
    "set_hash";
    "setsockopt";
    "skb_adjust_room";
    "redirect_map";
    "sk_redirect_map";
    "sock_map_update";
    "xdp_adjust_meta";
    "perf_event_read_value";
    "perf_prog_read_value";
    "getsockopt";
    "override_return";
    "sock_ops_cb_flags_set";
    "msg_redirect_map";
    "msg_apply_bytes";
    "msg_cork_bytes";
    "msg_pull_data";
    "bind";
    "xdp_adjust_tail";
    "skb_get_xfrm_state";
    "get_stack";
    "skb_load_bytes_relative";
    "fib_lookup";
    "sock_hash_update";
    "msg_redirect_hash";
    "sk_redirect_hash";
    "lwt_push_encap";
    "lwt_seg6_store_bytes";
    "lwt_seg6_adjust_srh";
    "lwt_seg6_action";
    "rc_repeat";
    "rc_keydown";
    "skb_cgroup_id";
    "get_current_cgroup_id";
    "get_local_storage";
    "sk_select_reuseport";
    "skb_ancestor_cgroup_id";
    "sk_lookup_tcp";
    "sk_lookup_udp";
    "sk_release";
    "map_push_elem";
    "map_pop_elem";
    "map_peek_elem";
    "msg_push_data";
    "msg_pop_data";
    "rc_pointer_rel";
    "spin_lock";
    "spin_unlock";
    "sk_fullsock";
    "tcp_sock";
    "skb_ecn_set_ce";
    "get_listener_sock";
    "skc_lookup_tcp";
    "tcp_check_syncookie";
    "sysctl_get_name";
    "sysctl_get_current_value";
    "sysctl_get_new_value";
    "sysctl_set_new_value";
    "strtol";
    "strtoul";
    "sk_storage_get";
    "sk_storage_delete";
    "send_signal";
    "tcp_gen_syncookie";
    "skb_output";
    "probe_read_user";
    "probe_read_kernel";
    "probe_read_user_str";
    "probe_read_kernel_str";
    "tcp_send_ack";
    "send_signal_thread";
    "jiffies64";
    "read_branch_records";
    "get_ns_current_pid_tgid";
    "xdp_output";
    "get_netns_cookie";
    "get_current_ancestor_cgroup_id";
    "sk_assign";
    "ktime_get_boot_ns";
    "seq_printf";
    "seq_write";
    "sk_cgroup_id";
    "sk_ancestor_cgroup_id";
    "ringbuf_output";
    "ringbuf_reserve";
    "ringbuf_submit";
    "ringbuf_discard";
    "ringbuf_query";
    "csum_level";
    "skc_to_tcp6_sock";
    "skc_to_tcp_sock";
    "skc_to_tcp_timewait_sock";
    "skc_to_tcp_request_sock";
    "skc_to_udp6_sock";
    "get_task_stack";
    "load_hdr_opt";
    "store_hdr_opt";
    "reserve_hdr_opt";
    "inode_storage_get";
    "inode_storage_delete";
    "d_path";
    "copy_from_user";
    "snprintf_btf";
    "seq_printf_btf";
    "skb_cgroup_classid";
    "redirect_neigh";
    "per_cpu_ptr";
    "this_cpu_ptr";
    "redirect_peer";
    "task_storage_get";
    "task_storage_delete";
    "get_current_task_btf";
    "bprm_opts_set";
    "ktime_get_coarse_ns";
    "ima_inode_hash";
    "sock_from_file";
    "check_mtu";
    "for_each_map_elem";
    "snprintf";
    "sys_bpf";
    "btf_find_by_name_kind";
    "sys_close";
    "timer_init";
    "timer_set_callback";
    "timer_start";
    "timer_cancel";
    "get_func_ip";
    "get_attach_cookie";
    "task_pt_regs";
    "get_branch_snapshot";
    "trace_vprintk";
    "skc_to_unix_sock";
    "kallsyms_lookup_name";
    "find_vma";
    "loop";
    "strncmp";
    "get_func_arg";
    "get_func_ret";
    "get_func_arg_cnt";
    "get_retval";
    "set_retval";
    "xdp_get_buff_len";
    "xdp_load_bytes";
    "xdp_store_bytes";
    "copy_from_user_task";
    "skb_set_tstamp";
    "ima_file_hash";
    "kptr_xchg";
    "map_lookup_percpu_elem";
    "skc_to_mptcp_sock";
    "dynptr_from_mem";
    "ringbuf_reserve_dynptr";
    "ringbuf_submit_dynptr";
    "ringbuf_discard_dynptr";
    "dynptr_read";
    "dynptr_write";
    "dynptr_data";
    "tcp_raw_gen_syncookie_ipv4";
    "tcp_raw_gen_syncookie_ipv6";
    "tcp_raw_check_syncookie_ipv4";
    "tcp_raw_check_syncookie_ipv6";
    "ktime_get_tai_ns";
    "user_ringbuf_drain";
    "cgrp_storage_get";
    "cgrp_storage_delete";
  |]

type typ =
| ARRAY of typ * int
| PTR of typ
| INT of int
| STRUCT of int * int
| OTHER of string
| ELF
| DATASEC

type info =
| BPF_FUNC of string 
| CALL_DEST of string * int64 
| LOAD_DEST of string * int64 
| GOTO_DEST of int
| TYP of typ

type line_info = line * info list

let resolve_call_bpf_func imm =
  let id = Int32.to_int imm in
  if 0 <= id && id < Array.length bpf_func_names then
    BPF_FUNC bpf_func_names.(id)
  else failwith "Invalid resolve_call_bpf_func"

let func_call_dest ctx section_idx target_offset =
  match func_at_offset ctx section_idx target_offset with
  | Some func -> CALL_DEST (func.name, target_offset)
  | None -> failwith "Invalid resolve_call_dest (no FUNC found)"

let resolve_call_reloc ctx reloc imm =
  if reloc.reloc_typ = R_BPF_64_32 then
    (* formula : target_offset = (imm + 1) * 8 *)
    let target_offset = Int64.mul (Int64.add (Int64.of_int32 imm) 1L) 8L in
    match Hashtbl.find_opt ctx.symbols reloc.value with
    | Some symbol ->
        if symbol.typ = "FUNC" then
          CALL_DEST (symbol.name, target_offset)
        else
          let section_idx = section_idx_of_symbol symbol in
          func_call_dest ctx section_idx target_offset
    | None -> failwith "Invalid resolve_call_reloc (symbol)"
  else failwith "Invalid resolve_call_reloc (reloc_typ)"

let resolve_call_no_reloc ctx pc imm =
  (* formula : target_offset = pc + 8 + imm * 8 *)
  let target_offset =
    Int64.add
      (Int64.of_int (pc + 8))
      (Int64.mul (Int64.of_int32 imm) 8L)
  in
  let section_idx = section_idx_of_section_name ctx ctx.basename in
  func_call_dest ctx section_idx target_offset

let btf_attr_int btf key =
  match List.assoc_opt key btf.attrs with
  | Some value -> int_of_string value
  | None -> -1

let rec parse_btf ctx btf_id =
  match Hashtbl.find_opt ctx.btf btf_id with
  | None -> OTHER "IDK"
  | Some btf -> (
      let suite =
        parse_btf ctx (btf_attr_int btf "type_id")
      in
      match btf.kind with
      | "INT" -> INT (btf_attr_int btf "size")
      | "ARRAY" -> ARRAY (parse_btf ctx (btf_attr_int btf "type_id"), btf_attr_int btf "nr_elems")
      | "PTR" -> PTR suite
      | "VAR" | "TYPEDEF" | "CONST" -> suite
      | "DATASEC" -> DATASEC
      | "STRUCT" -> STRUCT ((btf_attr_int btf "size"), (btf_attr_int btf "vlen"))
      | _ -> if btf.name <> "" then OTHER btf.name else OTHER btf.kind)


let resolve_load_reloc ctx reloc =
  if reloc.reloc_typ = R_BPF_64_64 then
    match Hashtbl.find_opt ctx.symbols reloc.value with
    | Some symbol ->
        let ld =
          let section_idx = section_idx_of_symbol symbol in
          let section_name = section_name_of_idx ctx section_idx in
          let symbol_value = symbol.value in
          LOAD_DEST (section_name, symbol_value)
        in

        let typ =
          match btf_of_btf_name_opt ctx symbol.name with
          | Some btf -> [ TYP (parse_btf ctx btf.id) ]
          | None -> [ TYP ELF ]
        in

        ld :: typ
    | None -> failwith "Invalid resolve_load_reloc (symbol)"
  else failwith "Invalid resolve_load_reloc (reloc_typ)"

let resolve_goto_offset pc offset =
  GOTO_DEST (pc + 8 + (offset * 8))

let resolve_goto_imm pc imm =
  GOTO_DEST (pc + 8 + (Int32.to_int imm * 8))

let parse_info ctx (line : line) : line_info =
  match line with
  | pc, BASIC (JMP (_, JA OFFSET_JA), _, _, offset, _) ->
      (line, resolve_goto_offset pc offset :: [])
  | pc, BASIC (JMP32 (_, JA IMM_JA), _, _, _, imm) ->
      (line, resolve_goto_imm pc imm :: [])
  | pc, BASIC (JMP (_, jmp), _, _, offset, _) when is_cond_jump jmp ->
      (line, resolve_goto_offset pc offset :: [])
  | pc, BASIC (JMP32 (_, jmp), _, _, offset, _) when is_cond_jump jmp ->
      (line, resolve_goto_offset pc offset :: [])
  | _, BASIC (JMP (K, CALL STATIC_ID), _, _, _, imm) ->
      (line, resolve_call_bpf_func imm :: [])
  | pc, BASIC (JMP (K, CALL CALL_IMM), _, _, _, imm) -> (
      match reloc_here ctx pc with
      | Some reloc -> (line, resolve_call_reloc ctx reloc imm :: [])
      | None -> (line, resolve_call_no_reloc ctx pc imm :: []))
  | pc, WIDE (LD (DW, IMM), _, _, _, _, _) -> (
      match reloc_here ctx pc with
      | Some reloc -> (line, resolve_load_reloc ctx reloc)
      | None -> (line, []))
  | _ -> (line, [])

let parse_infos ctx (lines : line list) : line_info list =
  List.map (parse_info ctx) lines
