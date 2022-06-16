{ config, lib, pkgs, modulesPath, ... }:
let kernel = pkgs.linuxPackages_latest;
    dpi = 122;
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
    dev-services.enable = true;
  };

  nix.maxJobs = lib.mkDefault 12;
  nix.buildCores = 12;

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
  boot.kernelModules = [ "kvm-amd" "lm92" ];
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
  services.xserver.dpi = dpi;
  services.xserver.exportConfiguration = true;
  services.xserver.useGlamor = true;

  services.autorandr.enable = true;
  services.autorandr.profiles.home_desk = {
    fingerprint = {
      eDP = 
        "00ffffffffffff0009e5470700000000121b0104a5221378021bbba658559d260e4f55000000010101010101010101010101010101019c3b803671383c403020360058c21000001afd2d800e713828403020360058c21000001a000000fe00424f452043510a202020202020000000fe004e5631353646484d2d4e36310a0030";
      DisplayPort-1 =
        "00ffffffffffff0010acbd405358314115190104a53c22783aee95a3544c99260f5054a54b00d100d1c0b300a94081808100714f01014dd000a0f0703e803020350055502100001a000000ff00563757503935354d413158530a000000fc0044454c4c205032373135510a20000000fd001d4b1f8c36010a202020202020016b02031df150101f200514041312110302161507060123091f0783010000a36600a0f0701f803020350055502100001a565e00a0a0a029503020350055502100001a023a801871382d40582c450055502100001e011d007251d01e206e28550055502100001e000000000000000000000000000000000000000000000000000013";
    };
    config = {
      DisplayPort-0.enable = false;
      DisplayPort-1  = {
        enable = true;
        crtc = 0;
        mode = "3840x2160";
        position = "0x0";
        primary = true;
        rate = "60.00";
        dpi = dpi;
      };
      eDP = {
          crtc = 1;
          mode = "1920x1080";
          position = "3840x0";
          rate = "60.03";
          #scale = {x = 2; y = 2;};
          dpi = dpi;
      };
    };
  };


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
