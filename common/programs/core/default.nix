{ config, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    # nix related
    nix # nix package manager
    nix-prefetch-scripts # Collection of all the nix-prefetch-* scripts which may be used to obtain source hashes
    patchelf # A small utility to modify the dynamic linker and RPATH of ELF executables
    nix-du # Visualise which gc-roots to delete to free some space in your nix store
    nix-index # Quickly locate nix packages with specific files

    # file system support
    exfat # user space support for exfat file system
    ntfs3g # FUSE-based NTFS driver with full write support
    hfsprogs # mount mac drives better

    # shells / terminals
    zsh # The Z shell
    bashInteractive # GNU Bourne-Again Shell, the de facto standard shell on Linux (for interactive use)
    termite # vi like terminal easy to customize
    xclip # terminal clipboard support
    #python36Packages.powerline # powerline for zsh 
    powerline-go

    # Utilities
    wget # Tool for retrieving files using HTTP, HTTPS, and FTP
    sudo # A command to run commands as root
    manpages # / man-pages : Linux development manual pages
    iptables # A program to configure the Linux IP packet filtering ruleset
    zlib # Lossless data-compression library
    psmisc # A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
    file # A program that shows the type of files
    xorg.xdpyinfo # display DPI info
    atool # Archive command line helper
    hddtemp # Tool for displaying hard disk temperature
    linuxPackages.cpupower # Tool to examine and tune power saving features
    lm_sensors # Tools for reading hardware sensors
    p7zip # A port of the 7-zip archiver
    rsync # A fast incremental file transfer utility
    sshfsFuse # FUSE-based filesystem that allows remote filesystems to be mounted over SSH
    unzip # An extraction utility for archives compressed in .zip format
    gnupg # Modern (2.1) release of the GNU Privacy Guard, a GPL OpenPGP implementation
    utillinux # for dmesg, kill,...
    htop # An interactive process viewer for Linux
    traceroute # Tracks the route taken by packets over an IP network
    which # get location of executable
    usbutils # Tools for working with USB devices, such as lsusb
    smartmontools # Tools for monitoring the health of hard drives - smartctl etc
    pciutils # A collection of programs for inspecting and manipulating configuration of PCI devices
    lshw # Provide detailed information on the hardware configuration of the machine
    hwinfo # Hardware detection tool from openSUSE
    sysfsutils # These are a set of utilites built upon sysfs, a new virtual filesystem in Linux kernel versions 2.5+ that exposes a system's device tree.
    tldr # examples of bash commands

    #socat # allow concatenating sockets together

    # source control for configs etc
    gitAndTools.gitFull # git source control
    gitAndTools.gitRemoteGcrypt # encrypted git remotes

    inotify-tools

    zip
    unrar

    tree # print directory trees

    gnome3.nautilus # the gnome file manager

    testdisk # rescue the disk or undelete files

  ];
}
