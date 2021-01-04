# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# override local nix.conf options using `--option`
# e.g. to set the subituters `--option substituters https://cache.nixos.org`
#      to disable subtitution `--option substitute false`
# see https://nixos.org/nix/manual/#name-11

# clear local binary cache issues by doing
# > Shane:  clever from #nixos told me to try doing rm  ~/.cache/nix/binary-cache-v6.sqlite* as root

{ config, pkgs, lib, ... }:
let
  kernelV = pkgs.linuxPackages;
  #kernelV = pkgs.linuxPackages_4_9;
  #kernelV = pkgs.linuxPackages_latest;

in
{

  # Include custom packages and override
  nixpkgs.overlays = [
    (import ./overlays)
  ];
  imports =
    [
      # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      # Include the common configuration
      ./common/power-management
      ./common/databases/postgresql
      ./common/databases/redis
      ./common/users
      ./common/audio
      ./common/network-time
      ./common/security/pki
      ./common/programs/core
      ./common/programs/development
      ./common/programs/internet
      ./common/programs/misc
      ./common/programs/eda
      ./common/fonts
      ./common/mount/userspace
      ./common/virtualisation
      ./common/networking
      ./common/networking/firewall
      ./common/networking/wireless
      ./common/services/nginx
      ./common/services/xserver
      ./common/services/print-scan
      ./common/services/physlock
      ./common/services/keybase
      ./common/message-brokers/rabbitmq
      ./common/shells
    ] ++ (
      if builtins.pathExists ./secret/networking/wireless/networks
      then [ ./secret/networking/wireless/networks ]
      else [ ]
    ) ++ (
      if builtins.pathExists ./secret/nix
      then [ ./secret/nix ]
      else [ ]
    ) ++ (
      if builtins.pathExists ./secret/vpn/hanstolpo.me-wg
      then [ ./secret/vpn/hanstolpo.me-wg ]
      else [ ]
    ) ++ # (if builtins.pathExists ./secret/vpn/picofactory
    # then [./secret/vpn/picofactory]
    # else []) ++
    (
      if builtins.pathExists ./secret/vpn/picofactory-wg
      then [ ./secret/vpn/picofactory-wg ]
      else [ ]
    )
  ;

  fileSystems =
    builtins.mapAttrs
      (
        k: _: {
          mountPoint = "/mnt/network/${k}";
          device = "//10.2.0.7/${k}";
          fsType = "cifs";
          noCheck = true;
          neededForBoot = false;
          options = [
            "noauto"
            "rw"
            "user"
            "users"
            "credentials=/home/handre/dev/ch-stuff/ucam-credentials"
            "setuids"
            #"uid=1000"
            #"gid=100"
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
    };
  };

  environment.variables."SSL_CERT_FILE" = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

  nix.buildCores = 6;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "adobe-reader-9.5.5-1"
  ];

  services.teamviewer.enable = false;


  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";
  #time.timeZone = "Europe/London";
  #time.timeZone = "Africa/Johannesburg";
  #time.timeZone = "America/Los_Angeles";

  boot.kernelPackages = kernelV;
  boot.extraModulePackages = [ kernelV.bbswitch /*kernelV.exfat-nofuse*/ ];
  boot.kernelModules = [ "bbswitch" ];
  boot.extraModprobeConfig =
    ''
      options bbswitch load_state=0
    '';

  # Some kernel param options come from https://wiki.archlinux.org/index.php/ASUS_Zenbook_Pro_UX501
  boot.kernelParams =
    [
      "acpi_osi=! acpi_osi=\"Windows 2009\"" # to get bbswitch not hang on startup
      # "acpi_osi= acpi_backlight=native" # this would be to get the backlight keys to work apparently but does not work with the bumblebee fix above
      "i915.enable_execlists=0" # prevent random locks apparently
    ];

  boot.loader.generationsDir.copyKernels = true;


  services.xserver.videoDrivers = [ "intel" "modesetting" ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  hardware.cpu.intel.updateMicrocode = true;

  hardware.bumblebee.enable = true;
  hardware.bumblebee.driver = "nvidia";
  hardware.bumblebee.connectDisplay = true;

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
  services.xserver.libinput.naturalScrolling = false;
  services.xserver.libinput.disableWhileTyping = true;
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

  networking.hostName = "handre-nixos-laptop"; # Define your hostname.

  environment.systemPackages = with pkgs; [
    wpa_supplicant_gui
    kernelV.bbswitch
    microcodeIntel
    blueman
    arc-theme
    gtk-engine-murrine
    gtk_engines
    hicolor-icon-theme
    gnome3.adwaita-icon-theme
    gnome3.gnome-boxes
    spice
    win-spice
    breeze-icons
    wally-cli
    xloadimage
    v4l-utils
    guvcview
    proot
  ];


  # hybrid sleep on power off button
  services.logind.extraConfig = ''
    HandlePowerKey=hibernate
    HandleLidSwitchDocked=ignore
    HandleLidSwitchExternalPower=ignore
  '';


  swapDevices = [
    { label = "swap"; }
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.wireless.interfaces = [ "wlp3s0" ];

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

  nix.useSandbox = "relaxed";

  fonts.fontconfig.dpi = 162;
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
    (
      pkgs.writeTextFile {
        name = "disable-internal-webcam";
        # disable builtin web cam
        # https://askubuntu.com/questions/1187354/ubuntu-18-04-how-to-disable-built-in-webcam-only-i-e-leave-any-other-attache
        text = ''
          ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="57f6", RUN="${pkgs.bash}/bin/bash -c 'echo 0 >/sys/\$devpath/authorized'"
        '';
        executable = false;
        destination = "/etc/udev/rules.d/40-disable-internal-web-cam.rules";
      }
    )

  ];
}
