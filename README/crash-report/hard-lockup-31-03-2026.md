# Hard Lockup Crash Report - 31 March 2026

## Summary

On the evening of 31 March 2026, the system (TUXEDO Aura 15 Gen2, kernel 6.12.76 NixOS) suffered a hard freeze requiring a forced power shutdown. The root cause was a kernel spinlock deadlock in the CPU scheduler, triggered during PostgreSQL session creation, with an Intel WiFi firmware crash as the likely initial destabiliser.

## Timeline

- **19:09:13** - Intel WiFi (iwlwifi) firmware crash with NMI interrupts
- **19:09:20** - First hard lockup detected on CPU 4 (PostgreSQL wrapper process)
- **19:10:33** - Second hard lockup on CPU 7 (another PostgreSQL wrapper)
- **19:11:46** - Third hard lockup on CPU 9
- **19:12:59** - Fourth hard lockup on CPU 3
- **19:14:12** - Fifth hard lockup on CPU 5
- System became completely unresponsive; forced power off required

## Root Cause Analysis

### Primary: Scheduler spinlock deadlock

Every hard lockup followed the same pattern: a PostgreSQL wrapper process called `setsid()`, which entered `sched_autogroup_create_attach()` -> `online_fair_sched_group()`, tried to acquire a CPU run-queue spinlock, and deadlocked spinning in `native_queued_spin_lock_slowpath`. The RCU grace-period kthread on CPU 12 was also stuck on the same lock, unable to make progress.

### Initial trigger: iwlwifi firmware crash

The WiFi firmware crashed with `NMI_INTERRUPT_UNKNOWN` and `NMI_INTERRUPT_HOST` 7 seconds before the first hard lockup. The NMI may have interrupted a CPU while it held the run-queue lock, and the interrupt handler path then deadlocked trying to re-acquire it.

### Contributing factors

- **ZFS out-of-tree module** (`zfs(PO)`) - known to interact with kernel lock ordering in ways upstream Linux doesn't expect
- **Tuxedo out-of-tree modules** (`tuxedo_io`, `tuxedo_keyboard`, `clevo_acpi`, `clevo_wmi`) - additional out-of-tree code that could affect lock ordering
- **Kernel 6.12.76** - relatively new kernel; scheduler spinlock bugs have been reported in the 6.12.x series

## Relevant Log Excerpts

### iwlwifi firmware crash (19:09:13)

```
Mar 31 19:09:13 handre-tuxedo-laptop kernel: iwlwifi 0000:03:00.0: Loaded firmware version: 77.f39cc7f9.0 cc-a0-77.ucode
Mar 31 19:09:13 handre-tuxedo-laptop kernel: iwlwifi 0000:03:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN
Mar 31 19:09:13 handre-tuxedo-laptop kernel: iwlwifi 0000:03:00.0: 0x20000066 | NMI_INTERRUPT_HOST
Mar 31 19:09:13 handre-tuxedo-laptop kernel: iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
Mar 31 19:09:13 handre-tuxedo-laptop kernel: iwlwifi 0000:03:00.0: Transport status: 0x0000004A, valid: 7
Mar 31 19:09:13 handre-tuxedo-laptop kernel: ieee80211 phy0: Hardware restart was requested
```

### First hard lockup - CPU 4 (19:09:20)

```
Mar 31 19:09:20 handre-tuxedo-laptop kernel: watchdog: Watchdog detected hard LOCKUP on cpu 4
Mar 31 19:09:20 handre-tuxedo-laptop kernel: CPU: 4 UID: 71 PID: 3764717 Comm: .postgres-wrapp Tainted: P        W  O       6.12.76 #1-NixOS
Mar 31 19:09:20 handre-tuxedo-laptop kernel: Tainted: [P]=PROPRIETARY_MODULE, [W]=WARN, [O]=OOT_MODULE
Mar 31 19:09:20 handre-tuxedo-laptop kernel: Hardware name: TUXEDO TUXEDO Aura 15 Gen2/NL5xNU, BIOS 1.07.30RTR2 03/13/2025
Mar 31 19:09:20 handre-tuxedo-laptop kernel: RIP: 0010:native_queued_spin_lock_slowpath+0x272/0x2a0
Mar 31 19:09:20 handre-tuxedo-laptop kernel: Call Trace:
Mar 31 19:09:20 handre-tuxedo-laptop kernel:  <TASK>
Mar 31 19:09:20 handre-tuxedo-laptop kernel:  _raw_spin_lock+0x29/0x30
Mar 31 19:09:20 handre-tuxedo-laptop kernel:  raw_spin_rq_lock_nested+0x1c/0x80
Mar 31 19:09:20 handre-tuxedo-laptop kernel:  online_fair_sched_group+0x4b/0x170
Mar 31 19:09:20 handre-tuxedo-laptop kernel:  sched_autogroup_create_attach+0xe9/0x1c0
Mar 31 19:09:20 handre-tuxedo-laptop kernel:  ksys_setsid+0xe8/0x110
Mar 31 19:09:20 handre-tuxedo-laptop kernel:  __do_sys_setsid+0xe/0x20
Mar 31 19:09:20 handre-tuxedo-laptop kernel:  do_syscall_64+0xb7/0x200
Mar 31 19:09:20 handre-tuxedo-laptop kernel:  entry_SYSCALL_64_after_hwframe+0x77/0x7f
Mar 31 19:09:20 handre-tuxedo-laptop kernel:  </TASK>
```

### RCU starvation (CPU 12 stuck on same lock)

```
Mar 31 19:09:20 handre-tuxedo-laptop kernel: rcu: rcu_preempt kthread starved for 166510 jiffies! g24932073 f0x2 RCU_GP_DOING_FQS(6) ->state=0x0 ->cpu=12
Mar 31 19:09:20 handre-tuxedo-laptop kernel: rcu:         Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
Mar 31 19:09:20 handre-tuxedo-laptop kernel: NMI backtrace for cpu 12
Mar 31 19:09:20 handre-tuxedo-laptop kernel: CPU: 12 UID: 0 PID: 19 Comm: rcu_preempt Tainted: P        W  O       6.12.76 #1-NixOS
Mar 31 19:09:20 handre-tuxedo-laptop kernel: RIP: 0010:native_queued_spin_lock_slowpath+0x70/0x2a0
Mar 31 19:09:20 handre-tuxedo-laptop kernel:  _raw_spin_lock+0x29/0x30
Mar 31 19:09:20 handre-tuxedo-laptop kernel:  raw_spin_rq_lock_nested+0x1c/0x80
Mar 31 19:09:20 handre-tuxedo-laptop kernel:  _raw_spin_rq_lock_irqsave+0x17/0x20
Mar 31 19:09:20 handre-tuxedo-laptop kernel:  resched_cpu+0x2a/0x90
Mar 31 19:09:20 handre-tuxedo-laptop kernel:  force_qs_rnp+0x271/0x300
```

### Subsequent hard lockups (same pattern, different CPUs)

```
Mar 31 19:10:33 handre-tuxedo-laptop kernel: watchdog: Watchdog detected hard LOCKUP on cpu 7
Mar 31 19:10:33 handre-tuxedo-laptop kernel: CPU: 7 UID: 71 PID: 3764931 Comm: .postgres-wrapp Tainted: P        W  O       6.12.76 #1-NixOS

Mar 31 19:11:46 handre-tuxedo-laptop kernel: watchdog: Watchdog detected hard LOCKUP on cpu 9
Mar 31 19:11:46 handre-tuxedo-laptop kernel: CPU: 9 UID: 71 PID: 3765148 Comm: .postgres-wrapp Tainted: P        W  O       6.12.76 #1-NixOS

Mar 31 19:12:59 handre-tuxedo-laptop kernel: watchdog: Watchdog detected hard LOCKUP on cpu 3
Mar 31 19:12:59 handre-tuxedo-laptop kernel: CPU: 3 UID: 71 PID: 3765345 Comm: .postgres-wrapp Tainted: P        W  O       6.12.76 #1-NixOS

Mar 31 19:14:12 handre-tuxedo-laptop kernel: watchdog: Watchdog detected hard LOCKUP on cpu 5
```

### Cascading network failure (consequence, not cause)

```
Mar 31 19:09:20 handre-tuxedo-laptop kernel: iwlwifi 0000:03:00.0: Queue 3 is stuck 241 250
Mar 31 19:09:38 handre-tuxedo-laptop tailscaled[3268]: dns udp query: resolving using "2001:4860:4860::8888": network is unreachable
Mar 31 19:09:50 handre-tuxedo-laptop nordvpnd[3280]: connection lost: pingresp not received, disconnecting
Mar 31 19:10:09 handre-tuxedo-laptop postgres[3104]: WARNING: autovacuum worker took too long to start; canceled
```

## Mitigation Applied

### Disabled scheduler autogroup feature

Added `noautogroup` to `boot.kernelParams` in `hosts/handre-tuxedo-laptop/default.nix`.

This disables the kernel's automatic process group scheduling feature, which was directly in the deadlock call path (`sched_autogroup_create_attach`). The autogroup feature is a minor desktop QoL optimisation that groups processes by session for fairer CPU time distribution. Disabling it has negligible impact on normal desktop usage.

## Further Recommendations

1. **Update kernel** - Consider moving to a newer kernel (6.13+) if available in nixpkgs, as 6.12.x has had scheduler-related fixes
2. ~~**Update WiFi firmware**~~ - Investigated on 2026-04-01: the system is running `linux-firmware-20260309` which ships `iwlwifi-cc-a0-77.ucode` — the highest numbered firmware file available for this card. This matches the version loaded at the time of the crash (`77.f39cc7f9.0`). Nixpkgs also has `20260309` as the latest. **No newer firmware is available.** Upstream can be monitored at `git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git` for future `iwlwifi-cc-a0-*` updates.
3. **Monitor ZFS compatibility** - Ensure ZFS module version stays compatible with the running kernel version; ZFS + spinlock contention is a known issue area
4. **Watch for recurrence** - If it happens again even with `noautogroup`, the focus should shift to ZFS or the iwlwifi driver as the lock holder

## System Information

- **Machine**: TUXEDO Aura 15 Gen2 (NL5xNU)
- **BIOS**: 1.07.30RTR2 (2025-03-13)
- **Kernel**: 6.12.76 #1-NixOS
- **CPU**: AMD (16 logical cores)
- **Out-of-tree modules**: zfs, zenpower, tuxedo_io, tuxedo_keyboard, clevo_acpi, clevo_wmi, tuxedo_compatibility_check
- **WiFi**: Intel iwlwifi (firmware 77.f39cc7f9.0, cc-a0-77.ucode)
- **Full logs**: `boot-kernal-logs.txt` (captured via `sudo journalctl -b-1 -ex`)
