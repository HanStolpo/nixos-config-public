{ config, lib, pkgs, modulesPath, ... }:
let kernel = pkgs.linuxPackages_latest;
in

{

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  hanstolpo.users.enable = true;
  hanstolpo.users.SSHLogin = true;

  services.physlock.enable = false;

  nixpkgs.config.permittedInsecurePackages = [
    "python2.7-pyjwt-1.7.1"
  ];

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";
  #time.timeZone = "Europe/London";
  #time.timeZone = "Africa/Johannesburg";
  #time.timeZone = "America/Los_Angeles";

  hanstolpo = {
    shell.enable = true;
    terminal.enable = true;
    #users.enable = true;
    desktop.enable = true;
    physical.enable = true;
    dev-services.enable = false;
  };

  nix.maxJobs = lib.mkDefault 8;
  nix.buildCores = 6;

  environment.variables."SSL_CERT_FILE" = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

  environment.systemPackages = with pkgs; [
    wpa_supplicant_gui
    blueman
    arc-theme
    gtk-engine-murrine
    gtk_engines
    hicolor-icon-theme
    gnome3.adwaita-icon-theme
    gnome3.gnome-boxes
    spice
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
  ];

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.kernelPackages = kernel;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [  ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [];

  # Use the systemd-boot EFI boot loader.
  boot.loader.generationsDir.copyKernels = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1aff7ddd-37c1-4379-8487-eb2de56465fa";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."crypted".device = "/dev/disk/by-uuid/920eb5ec-e62f-415c-aefd-26a9cc7f3762";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C7A9-3E53";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/9673d6ae-51cd-4da5-8883-99ffdf606f72"; }
    ];

  networking.useDHCP = true;

  hardware.enableRedistributableFirmware = true; # for wifi driver
  hardware.cpu.amd.updateMicrocode = true;
  hardware.bluetooth.enable = true;


  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = false;
  services.xserver.libinput.touchpad.disableWhileTyping = true;
  services.xserver.dpi = 102; # 15" FHD
  # services.xserver.dpi = 144; # 15" FHD
  services.xserver.exportConfiguration = true;
  services.xserver.useGlamor = true;


  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # hybrid sleep on power off button
  services.logind.extraConfig = ''
    HandlePowerKey=hibernate
    HandleLidSwitchDocked=ignore
    HandleLidSwitchExternalPower=ignore
  '';


  networking = {
    hostName = "handre-tuxedo-laptop"; # Define your hostname.
    wireless = {
      #interfaces = [ "wlp3s0" ];
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
  system.stateVersion = "22.05";

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
