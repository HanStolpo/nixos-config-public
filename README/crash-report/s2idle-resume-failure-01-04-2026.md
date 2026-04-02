# s2idle Resume Failure (Black Screen) - 1 April 2026

## Summary

On the evening of 1 April 2026, the system (TUXEDO Aura 15 Gen2, kernel 6.19.10 NixOS) failed to resume after suspending via lid close. Power was restored on lid open (fans, LEDs), but the screen remained black and the system was completely unresponsive, requiring a forced power shutdown.

## Timeline

- **18:48:35** - User triggered suspend via lid close (`HandleLidSwitch = "suspend"`)
- **18:48:35** - systemd-logind warns: `SuspendMode=` and `HibernateState=` options are removed and ignored
- **18:48:35** - Pre-sleep actions completed successfully
- **18:48:35** - `systemd-sleep` freezes `user.slice` successfully
- **18:48:35** - Kernel: `Bluetooth: hci0: SCO packet for unknown connection handle 257`
- **18:48:35** - Kernel: `PM: suspend entry (s2idle)`
- **--- journal ends ---** No resume logs recorded
- User opened lid, power restored but screen stayed black; forced power off required

## Root Cause Analysis

### Primary: amdgpu driver failed to resume display from s2idle

The journal ends immediately after `PM: suspend entry (s2idle)` with zero resume-side logs. This means the kernel never reached the point of logging resume activity, indicating a failure very early in the hardware resume sequence — before userspace or most kernel subsystems were restored.

On AMD APU laptops using s2idle, the amdgpu driver is responsible for reinitialising the display controller and panel on resume. This is a well-known failure mode: the system resumes electrically (CPU, fans, peripherals power up) but the display pipeline fails to come back, leaving a black screen with no way to interact with the system.

Common sub-causes include:
- **PSR (Panel Self Refresh)** bugs in the amdgpu display core, where the panel remains in self-refresh mode after resume
- **Runtime PM race conditions** in amdgpu where the GPU power state is not correctly restored
- **Display core (DC) firmware handshake failures** during s2idle resume

### Why S3 deep sleep is not available

The system's BIOS/firmware only exposes s2idle — `cat /sys/power/mem_sleep` shows `[s2idle]` with no `deep` option. This is common on modern AMD laptops where the vendor implements only "Modern Standby" (Microsoft's s0ix equivalent) and removes S3 from the ACPI tables. There is no way to force S3 without a BIOS update from TUXEDO that re-enables it.

### Why hibernate is not a viable alternative

Hibernate (suspend-to-disk) is not an option for this system for two reasons:

1. **No swap configured** — Hibernate requires a swap partition or swapfile to write the memory image to. This system has no swap.

2. **ZFS root filesystem is incompatible with hibernate** — Even if swap were added on a separate non-ZFS block device, hibernation with ZFS pools is dangerous. The core problem: on resume, the initrd imports ZFS pools *before* checking for a hibernation image. This means ZFS sees the pool state as it is on disk, not as it was in memory at hibernate time, causing state divergence that can lead to data corruption. NixOS disables hibernate by default on ZFS systems (`boot.zfs.allowHibernation` defaults to `false`).

   Relevant references:
   - [NixOS/nixpkgs #106093](https://github.com/NixOS/nixpkgs/issues/106093) — ZFS + suspend-to-disk corruption
   - [OpenZFS #12842](https://github.com/openzfs/zfs/issues/12842) — make hibernation more robust (still open)
   - [NixOS/nixpkgs PR #208037](https://github.com/NixOS/nixpkgs/pull/208037) — attempted mitigation by reordering boot sequence (not a full fix)
   - [NixOS Wiki - ZFS](https://wiki.nixos.org/wiki/ZFS)

### Contributing factors

- **Deprecated sleep.conf options** — `SuspendMode=` and `HibernateState=` in `systemd.sleep.extraConfig` are being ignored by systemd, generating warnings at every suspend. The intended sleep configuration is not fully applied.
- **Bluetooth not fully quiesced** — A stray `SCO packet for unknown connection handle` was logged immediately before suspend entry, suggesting the Bluetooth stack wasn't cleanly shut down.
- **Out-of-tree modules** — ZFS, tuxedo_io, tuxedo_keyboard, clevo_acpi, clevo_wmi, and zenpower all participate in the suspend/resume path and increase the surface area for failures.

## Relevant Log Excerpts

### Deprecated sleep.conf warnings

```
Apr 01 18:48:35 systemd-logind[1845]: /etc/systemd/sleep.conf:3: Support for option SuspendMode= has been removed and it is ignored
Apr 01 18:48:35 systemd-logind[1845]: /etc/systemd/sleep.conf:6: Support for option HibernateState= has been removed and it is ignored
```

### Suspend sequence (final journal entries)

```
Apr 01 18:48:35 systemd-logind[1845]: The system will suspend now!
Apr 01 18:48:35 tailord[2011]:  INFO tailord::suspend: Suspended, sleeping until wake up.
Apr 01 18:48:35 ModemManager[3085]: <msg> [sleep-monitor-systemd] system is about to suspend
Apr 01 18:48:35 systemd[1]: Starting Pre-Sleep Actions...
Apr 01 18:48:35 systemd[1]: Finished Pre-Sleep Actions.
Apr 01 18:48:35 systemd[1]: Reached target Sleep.
Apr 01 18:48:35 systemd[1]: Starting System Suspend...
Apr 01 18:48:35 systemd-sleep[657873]: Successfully froze unit 'user.slice'.
Apr 01 18:48:35 systemd-sleep[657873]: Performing sleep operation 'suspend'...
Apr 01 18:48:35 kernel: Bluetooth: hci0: SCO packet for unknown connection handle 257
Apr 01 18:48:35 kernel: PM: suspend entry (s2idle)
--- END OF JOURNAL ---
```

## Mitigation Applied

The following kernel parameters are added to `boot.kernelParams` in `hosts/handre-tuxedo-laptop/default.nix`:

### 1. Disable amdgpu Panel Self Refresh (PSR)

```nix
"amdgpu.dcdebugmask=0x10"
```

PSR allows the display panel to refresh from a local framebuffer cache without GPU involvement. On s2idle resume, the panel can get stuck in self-refresh mode, resulting in a black screen even though the GPU is otherwise functional. Disabling PSR forces the GPU to actively drive every frame, which is slightly less power-efficient but avoids this class of resume bugs.

### 2. Disable amdgpu runtime power management

```nix
"amdgpu.runpm=0"
```

Runtime PM allows the GPU to power down subsystems during idle periods and s2idle. On resume, the power-up sequencing can race with display initialisation. Disabling it keeps the GPU fully powered, eliminating these race conditions at the cost of marginally higher idle power consumption.

### 3. Enable PM debug logging

```nix
"pm_debug_messages"
"no_console_suspend"
```

These enable verbose kernel power management logging and keep the console alive during suspend/resume. If the black screen recurrence happens again, the journal should now contain detailed information about exactly which device or driver failed during resume. These can be removed once the issue is confirmed resolved.

### 4. Clean up deprecated sleep.conf options

Removed `SuspendMode=` and `HibernateState=` from `systemd.sleep.extraConfig` as they are no longer supported by systemd and generate warnings on every suspend.

## Further Recommendations

1. **Monitor for recurrence** — With PSR and runtime PM disabled, the next suspend/resume cycle should succeed. If the black screen still occurs, the PM debug logs will point to the specific driver or device that hangs.
2. **Check TUXEDO BIOS updates** — A BIOS update might improve s2idle reliability or potentially re-enable S3 deep sleep.
3. **Report to TUXEDO** — If the issue persists, report it to TUXEDO support referencing the Aura 15 Gen2 and s2idle resume failure with amdgpu.
4. **Remove debug params once stable** — After confirming several successful suspend/resume cycles, remove `pm_debug_messages` and `no_console_suspend` to reduce log noise.

## System Information

- **Machine**: TUXEDO Aura 15 Gen2 (NL5xNU)
- **BIOS**: 1.07.30RTR2 (2025-03-13)
- **Kernel**: 6.19.10 #1-NixOS
- **CPU**: AMD (16 logical cores)
- **GPU**: AMD APU (amdgpu driver)
- **Suspend method**: s2idle (only option; S3 not exposed by BIOS)
- **Swap**: None configured
- **Filesystem**: ZFS root
- **Out-of-tree modules**: zfs, zenpower, tuxedo_io, tuxedo_keyboard, clevo_acpi, clevo_wmi, tuxedo_compatibility_check
- **Full logs**: `boot-kernal-logs.txt` (captured via `sudo journalctl -b-1 -ex`)
