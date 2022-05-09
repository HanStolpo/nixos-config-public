{ config, lib, pkgs, ... }:

with lib;
let

  cfg = config.hanstolpo.physical;
in
{
  options = {
    hanstolpo.physical = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      xorg.xinit # for startx when messing around with extra displays or playing with xmonad
      xorg.xbacklight # control backlight of screen
      xorg.xdpyinfo # display DPI info
      simple-scan # Simple scanning utility
      physlock
      usbutils # Tools for working with USB devices, such as lsusb
      smartmontools # Tools for monitoring the health of hard drives - smartctl etc
      pciutils # A collection of programs for inspecting and manipulating configuration of PCI devices
      lshw # Provide detailed information on the hardware configuration of the machine
      hwinfo # Hardware detection tool from openSUSE
      sysfsutils # These are a set of utilites built upon sysfs, a new virtual filesystem in Linux kernel versions 2.5+ that exposes a system's device tree.
      sshfsFuse # FUSE-based filesystem that allows remote filesystems to be mounted over SSH
      linuxPackages.cpupower # Tool to examine and tune power saving features
      lm_sensors # Tools for reading hardware sensors
      hddtemp # Tool for displaying hard disk temperature

      # file system support
      exfat # user space support for exfat file system
      ntfs3g # FUSE-based NTFS driver with full write support
      hfsprogs # mount mac drives better
      cifs-utils # Tools for managing Linux CIFS client filesystems
      nfs-utils # This package contains various Linux user-space Network File System (NFS) utilities, including RPC `mount' and `nfs' daemons.

      mesa_noglu # An open source implementation of OpenGL
      mesa_drivers # An open source implementation of OpenGL
      # glmark2 # OpenGL (ES) 2.0 benchmark
      glxinfo # info about opengl implementation
      libinput # Handles input devices in Wayland compositors and provides a generic X.Org input drivelibinputr

      powerstat # Laptop power measuring tool
      powertop # Analyze power consumption on Intel-based laptops

      udisks2 # mount removable drives as user in /run/media/username/drivename
      usermount # automounter that works with udisks2
      udevil # user space mounting program
    ];

    services = {
      upower.enable = true;
      acpid.enable = false;
    };
    powerManagement.enable = true;

    # suspend after idel seconds
    # https://bbs.archlinux.org/viewtopic.php?id=208091
    services.logind.extraConfig =
      ''
        IdleAction=suspend
        IdleActionSec=1200
      '';

    services = {
      printing = {
        enable = true;
        drivers = [ pkgs.gutenprint pkgs.hplip pkgs.splix ];
      };
    };

    hardware = {
      sane = {
        enable = true;
        netConf = "192.168.178.220";
      };
    };

    services.physlock = {
      lockOn.hibernate = false;
      lockOn.suspend = true;
    };


    virtualisation.libvirtd.enable = true;

    networking.firewall = {
      enable = true;
      allowPing = true;
      checkReversePath = false;


      allowedTCPPorts = [
        #samba
        445
        139
        # google chat / hanouts http://mikedikson.com/2013/01/google-talk-firewall-ports
        443
        5269 # XMPP federation
        9001 # wassembly TPSPOOl redirect port
        8612 # sane printing
      ];
      allowedUDPPorts = [
        #samba
        137
        138
        8612 # sane printing
      ];
      allowedTCPPortRanges = [
        # google chat / hanouts http://mikedikson.com/2013/01/google-talk-firewall-ports
        { from = 19302; to = 19309; }
        { from = 5222; to = 5224; } # XMPP xlient
      ];
      allowedUDPPortRanges = [
        # google chat / hanouts http://mikedikson.com/2013/01/google-talk-firewall-ports
        { from = 19302; to = 19309; }
      ];
    };

    services.chrony.enable = false;
    services.ntp.enable = false;
    services.openntpd.enable = false;
    services.timesyncd.enable = true;
    services.timesyncd.servers =
      [
        "0.pool.ntp.org"
        "1.pool.ntp.org"
        "za.pool.ntp.org"
        "0.nixos.pool.ntp.org"
        "1.nixos.pool.ntp.org"
        "2.nixos.pool.ntp.org"
        "3.nixos.pool.ntp.org" # default ones
        "131.107.13.100" # time-nw.nist.gov - static one to get around DNS broken on startup
      ];

    # allow udisks2 to work for no privileged
    # mount using `udisksctl mount --block-device /dev/sda1`
    security.polkit.extraConfig =
      ''
        polkit.addRule(function(action, subject) {
            var YES = polkit.Result.YES;
            var permission = {
              // only required for udisks1:
              "org.freedesktop.udisks.filesystem-mount": YES,
              "org.freedesktop.udisks.filesystem-mount-system-internal": YES,
              "org.freedesktop.udisks.luks-unlock": YES,
              "org.freedesktop.udisks.drive-eject": YES,
              "org.freedesktop.udisks.drive-detach": YES,
              // only required for udisks2:
              "org.freedesktop.udisks2.filesystem-mount": YES,
              "org.freedesktop.udisks2.filesystem-mount-system": YES,
              "org.freedesktop.udisks2.encrypted-unlock": YES,
              "org.freedesktop.udisks2.eject-media": YES,
              "org.freedesktop.udisks2.power-off-drive": YES,
              // required for udisks2 if using udiskie from another seat (e.g. systemd):
              "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
              "org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
              "org.freedesktop.udisks2.eject-media-other-seat": YES,
              "org.freedesktop.udisks2.power-off-drive-other-seat": YES
            };
            if (subject.isInGroup("users")) {
              return permission[action.id];
            }
          });
      '';
  };

}
