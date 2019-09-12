# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
   kernelV = pkgs.linuxPackages;
   #kernelV = pkgs.linuxPackages_4_9;
   #kernelV = pkgs.linuxPackages_latest;
in
{

  # Include custom packages and override
  nixpkgs.overlays = [(import ./overlays)];
  imports =
    [ # Include the results of the hardware scan.
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
    ] ++
    (if builtins.pathExists ./secret/networking/wireless/networks
    then [./secret/networking/wireless/networks]
    else [])  ++
    (if builtins.pathExists ./secret/nix
    then [./secret/nix]
    else []) ++
    (if builtins.pathExists ./secret/vpn/hanstolpo.me-wg
    then [./secret/vpn/hanstolpo.me-wg]
    else []) ++
    # (if builtins.pathExists ./secret/vpn/picofactory
    # then [./secret/vpn/picofactory]
    # else []) ++
    (if builtins.pathExists ./secret/vpn/picofactory-wg
    then [./secret/vpn/picofactory-wg]
    else [])
    ;

  nix.buildCores = 6;
  nixpkgs.config.allowUnfree = true;

  services.teamviewer.enable = false;


  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";
  #time.timeZone = "Europe/London";
  #time.timeZone = "Africa/Johannesburg";

  boot.kernelPackages = kernelV;
  boot.extraModulePackages = [kernelV.bbswitch /*kernelV.exfat-nofuse*/ ];
  boot.kernelModules = ["bbswitch"];
  boot.extraModprobeConfig =
  ''
    options bbswitch load_state=0
  '';

  # Some kernel param options come from https://wiki.archlinux.org/index.php/ASUS_Zenbook_Pro_UX501
  boot.kernelParams =
    [ "acpi_osi=! acpi_osi=\"Windows 2009\"" # to get bbswitch not hang on startup
    # "acpi_osi= acpi_backlight=native" # this would be to get the backlight keys to work apparently but does not work with the bumblebee fix above
      "i915.enable_execlists=0" # prevent random locks apparently
    ];

  boot.loader.generationsDir.copyKernels = true;


  services.xserver.videoDrivers = ["intel" "modesetting"];
  boot.blacklistedKernelModules = ["nouveau"];

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
  hardware.opengl.extraPackages = with pkgs; [vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl];
  hardware.opengl.extraPackages32 = with pkgs; [vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl];
  hardware.opengl.s3tcSupport = true;

  services.xserver.libinput.enable = true;
  services.xserver.libinput.naturalScrolling = true;
  #services.xserver.dpi = 180;
  services.xserver.dpi = 162;
  #services.xserver.dpi = 102;
  #hardware.opengl.driSupport32Bit = false;
  services.xserver.exportConfiguration = true;
  #services.xserver.useGlamor = true;
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
   ];

  # hybrid sleep on power off button
  services.logind.extraConfig = ''
    HandlePowerKey=hibernate
  '';

  # Show the manual on virtual console 8 :
  services.nixosManual.showManual = true;

  swapDevices = [
   {label = "swap";}
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.wireless.interfaces = ["wlp3s0"];

  #Select internationalisation properties.
  i18n = {
    #consoleFont = "Lat2-Terminus16";
    consoleFont = "latarcyrheb-sun32";
    defaultLocale = "en_ZA.UTF-8";
    consolePackages = [pkgs.terminus_font];
    consoleUseXkbConfig = true;
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

  nix.useSandbox = false;
}
