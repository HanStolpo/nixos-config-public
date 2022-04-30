{ config, lib, pkgs, ... }:
let kernel = pkgs.linuxPackages_latest;
in

{
  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";
  #time.timeZone = "Europe/London";
  #time.timeZone = "Africa/Johannesburg";
  #time.timeZone = "America/Los_Angeles";
  hanstolpo = {
    shell.enable = true;
    terminal.enable = true;
    users.enable = true;
    desktop.enable = true;
    physical.enable = true;
    dev-services.enable = true;
  };

  boot.kernelPackages = kernel;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" "bbswitch" ];

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/307695aa-384f-4216-8df2-08e79e8cb0a5";

  swapDevices =
    [{ device = "/dev/disk/by-uuid/c00dd2af-d284-4ada-87f5-12e97f5b1afe"; }];

  nix.maxJobs = lib.mkDefault 8;

  fileSystems = {
    "/" =
      {
        device = "/dev/disk/by-uuid/ce98892c-adf9-4913-89fb-9ccf4db23388";
        fsType = "ext4";
      };
    "/boot" =
      {
        device = "/dev/disk/by-uuid/E321-3515";
        fsType = "vfat";
      };

  } //
  builtins.mapAttrs
    (
      k: _: {
        mountPoint = "/mnt/network/${k}";
        device = "//100.66.194.67/${k}";
        fsType = "cifs";
        noCheck = true;
        neededForBoot = false;
        options = [
          "noauto"
          "rw"
          "user"
          "users"
          "credentials=/home/handre/dev/ch-stuff/ucam-credentials-2"
          "setuids"
          "uid=1000"
          "gid=100"
        ];
      }
    )
    {
      "I8export" = { };
      "I8hotfolder" = { };
      "ch-i8-uploaded" = { };
      "ch-temp" = { };
    } //
  {
    windows = {
      mountPoint = "/mnt/windows";
      device = "/dev/disk/by-uuid/DCEA6B53EA6B28CA";
      fsType = "ntfs";
      noCheck = true;
      neededForBoot = false;
      options = [
        "auto"
        "defaults"
        "uid=1000"
        "gid=100"
        "umask=022"
      ];
    };
  };
  security.wrappers = {
    mnt-cifs = {
      source = "${pkgs.cifs-utils.out}/bin/mount.cifs";
      owner = "nobody";
      group = "nogroup";
    };
  };

  environment.variables."SSL_CERT_FILE" = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

  nix.buildCores = 6;

  boot.extraModulePackages = [ kernel.bbswitch ];
  boot.extraModprobeConfig =
    ''
      options bbswitch load_state=0
    '';

  # Some kernel param options come from https://wiki.archlinux.org/index.php/ASUS_Zenbook_Pro_UX501
  boot.kernelParams =
    [
      # to get bbswitch not hang on startup
      "acpi_osi=!"
      "acpi_osi=\"Windows 2009\""
      # prevent random locks apparently
      "i915.enable_execlists=0"
    ];

  boot.loader.generationsDir.copyKernels = true;


  services.xserver.videoDrivers = [ "intel" "modesetting" ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  hardware.enableRedistributableFirmware = true; # for wifi driver
  hardware.cpu.intel.updateMicrocode = true;

  # hardware.bumblebee.enable = true;
  # hardware.bumblebee.driver = "nvidia";
  # hardware.bumblebee.connectDisplay = true;

  hardware.bluetooth.enable = true;


  ## Dell 27" monitor is about 600 by 340 mm, 16:9 aspect ratio
  ## dpi approx 162.56 target dpi 1.5 * 96 = 144
  ## target width 677 mm so 676 by 380
  #services.xserver.monitorSection = ''
  #DisplaySize 676 380
  #'';
  # Graphics card driver
  #services.xserver.monitorSection = ''
  #DisplaySize 344 194
  #'';
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ];
  hardware.opengl.extraPackages32 = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ];

  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = false;
  services.xserver.libinput.touchpad.disableWhileTyping = true;
  #services.xserver.dpi = 180;
  services.xserver.dpi = 162;
  ##services.xserver.dpi = 122;
  #hardware.opengl.driSupport32Bit = false;
  services.xserver.exportConfiguration = true;
  services.xserver.useGlamor = true;
  #services.xserver.deviceSection =
  #'' Option       "TearFree" "true"
  #'';
  services.xserver.deviceSection =
    ''
      Option      "AccelMethod" "sna"
        Option       "TearFree" "true"
    '';

  environment.systemPackages = with pkgs; [
    wpa_supplicant_gui
    kernel.bbswitch
    microcodeIntel
    blueman
    arc-theme
    gtk-engine-murrine
    gtk_engines
    hicolor-icon-theme
    gnome3.adwaita-icon-theme
    gnome3.gnome-boxes
    spice
    #win-spice
    breeze-icons
    wally-cli
    xloadimage
    v4l-utils
    guvcview
    proot
    evince # gnome pdf viewer
    qemu_kvm
    libvirt
    virt-manager
    jitsi-meet-electron
    signal-desktop

    pavucontrol
    #pasystray
    #pulseaudioFull
  ];

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # hardware = {
  #   pulseaudio = {
  #     enable = true;
  #     systemWide = false;
  #     package = pkgs.pulseaudioFull;
  #   };
  # };


  # hybrid sleep on power off button
  services.logind.extraConfig = ''
    HandlePowerKey=hibernate
    HandleLidSwitchDocked=ignore
    HandleLidSwitchExternalPower=ignore
  '';



  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "handre-nixos-laptop"; # Define your hostname.
    wireless = {
      interfaces = [ "wlp3s0" ];
      enable = true; # Enables wireless support via wpa_supplicant.
      userControlled.enable = true;
      # networkd seems to give some errors and useNetworkd has this warning 'Whether we should use networkd as the network configuration backend or the legacy script based system. Note that this option is experimental, enable at your own risk.'
      # useNetworkd = true;
    };
    nameservers = [ "127.0.0.1" "8.8.8.8" "192.168.100.1" ];
    hosts = {
      "10.2.99.3" = [
        "qa-1-remote-dev-1"
        "api.qa-1.remote-dev-1.circuithub.com"
        "qa-1.remote-dev-1.circuithub.com"
        "api.qa-1.remote-dev-1.circuithub.co"
        "qa-1.remote-dev-1.circuithub.co"
      ];
      "10.2.99.2" = [ "handre-remote-dev-1" ];
      "10.2.0.99" = [ "remote-dev-1" ];
      "10.2.0.2" = [ "hydra.circuithub.com" "deploy.circuithub.com" ];
      "10.2.0.7" = [ "ucamco.circuithub" ];
      "192.168.1.1" = [ "router.asus.com" ];
    };

    enableIPv6 = true;
  };

  services.dnsmasq = {
    enable = true;
    servers = [ "8.8.8.8" "8.8.8.4" "192.168.1.1" "192.168.100.1" "100.100.100.100" ];
    extraConfig = ''
      server=/picofactory/192.168.100.1
      server=/circuithub.com.beta.tailscale.net/100.100.100.100
    '';
  };

  #Select internationalisation properties.
  i18n = {
    #consoleFont = "Lat2-Terminus16";
    defaultLocale = "en_ZA.UTF-8";
  };

  console = {
    useXkbConfig = true;
    packages = [ pkgs.terminus_font ];
    font = "latarcyrheb-sun32";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  #system.stateVersion = "17.03";
  system.stateVersion = "17.03";
  #system.nixos.stateVersion = "18.09";

  services.journald.rateLimitBurst = -1;

  # mouse-proxy test to succeed
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0666"
    KERNEL=="event*", MODE="0666"
  '';



  fonts.fontconfig.antialias = true;
  fonts.fontconfig.hinting.enable = true;

  services.udev.packages = [

    (
      pkgs.writeTextFile {
        name = "wally-udev";
        text = ''
          # Teensy rules for the Ergodox EZ
          ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
          ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
          SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
          KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

          # STM32 rules for the Moonlander and Planck EZ
          SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", \
          MODE:="0666", \
          SYMLINK+="stm32_dfu"
        '';
        executable = false;
        destination = "/etc/udev/rules.d/50-wally.rules";
      }
    )
    (
      pkgs.writeTextFile {
        name = "oryx-udev";
        text = ''
          # Rule for the Moonlander
          SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
          # Rule for the Ergodox EZ
          SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
          # Rule for the Planck EZ
          SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"
        '';
        executable = false;
        destination = "/etc/udev/rules.d/50-oryx.rules";
      }
    )

  ];
}
