{ config, lib, pkgs, modulesPath, ... }:
let
  kernel = pkgs.linuxPackages;
  enableSSH = false;
  dpi = 122;
  laptopDpi = 96;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config =
    lib.mkMerge [
      {
        services.openssh.enable = enableSSH;

        services.tailscale.enable = false;


        hanstolpo = {

          users = {
            enable = true;
            SSHLogin = enableSSH;
          };

          xmonad.enable = false;


          sway = {
            enable = true;
            pathToSwayConfigFile = "/home/handre/nixos-config-public/dotfiles/config/sway/config";
            pathToWayDisplaysConfigFile = "/home/handre/nixos-config-public/dotfiles/config/way-displays/cfg.yaml";
            pathToWaybarConfigFile = "/home/handre/nixos-config-public/dotfiles/config/waybar/config";
          };

          shell.enable = true;
          terminal.enable = true;
          desktop.enable = true;
          physical.enable = true;
          dev-services.enable = false;
        };

        nixpkgs.config.permittedInsecurePackages = [
          "python-2.7.18.6"
        ];

        # Set your time zone.
        #time.timeZone = "Europe/Amsterdam";
        #time.timeZone = "Europe/London";
        #time.timeZone = "America/Barbados";
        #time.timeZone = "Africa/Johannesburg";
        #time.timeZone = "America/Los_Angeles";
        #time.timeZone = "America/Mexico_City";
        services.automatic-timezoned.enable = true;


        nix.settings.max-jobs = lib.mkDefault 7;
        nix.settings.cores = 7;

        environment.variables."SSL_CERT_FILE" = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

        environment.systemPackages = with pkgs; [
          kmonad
          wpa_supplicant_gui
          blueman
          arc-theme
          gtk-engine-murrine
          gtk_engines
          hicolor-icon-theme
          gnome3.adwaita-icon-theme
          papirus-icon-theme
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
          signal-desktop
          pavucontrol
          wdisplays
          slurp
        ];


        boot.kernelPackages = kernel;
        boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
        boot.kernelModules = [ "kvm-intel" ];
        # Some kernel param options come from https://wiki.archlinux.org/index.php/ASUS_Zenbook_Pro_UX501
        boot.kernelParams =
          [
            # to get bbswitch not hang on startup
            "acpi_osi=!"
            "acpi_osi=\"Windows 2009\""
            # prevent random locks apparently
            "i915.enable_execlists=0"
          ];

        boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/307695aa-384f-4216-8df2-08e79e8cb0a5";

        swapDevices =
          [{ device = "/dev/disk/by-uuid/c00dd2af-d284-4ada-87f5-12e97f5b1afe"; }];

        # Use the systemd-boot EFI boot loader.
        boot.loader.generationsDir.copyKernels = true;
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

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

        }; # //
        # builtins.mapAttrs
        #   (
        #     k: _: {
        #       mountPoint = "/mnt/network/${k}";
        #       device = "//100.66.194.67/${k}";
        #       fsType = "cifs";
        #       noCheck = true;
        #       neededForBoot = false;
        #       options = [
        #         "noauto"
        #         "rw"
        #         "user"
        #         "users"
        #         "credentials=/home/handre/dev/ch-stuff/ucam-credentials-2"
        #         "setuids"
        #         "uid=1000"
        #         "gid=100"
        #       ];
        #     }
        #   )
        #   {
        #     "I8export" = { };
        #     "I8hotfolder" = { };
        #     "ch-i8-uploaded" = { };
        #     "ch-temp" = { };
        #   } //
        # {
        #   windows = {
        #     mountPoint = "/mnt/windows";
        #     device = "/dev/disk/by-uuid/DCEA6B53EA6B28CA";
        #     fsType = "ntfs";
        #     noCheck = true;
        #     neededForBoot = false;
        #     options = [
        #       "auto"
        #       "defaults"
        #       "uid=1000"
        #       "gid=100"
        #       "umask=022"
        #     ];
        #   };
        # };
        # security.wrappers = {
        #   mnt-cifs = {
        #     source = "${pkgs.cifs-utils.out}/bin/mount.cifs";
        #     owner = "nobody";
        #     group = "nogroup";
        #   };
        # };

        networking.useDHCP = true;

        services.xserver.videoDrivers = [ "intel" "modesetting" ];
        boot.blacklistedKernelModules = [ "nouveau" ];

        hardware.enableRedistributableFirmware = true; # for wifi driver
        hardware.cpu.intel.updateMicrocode = true;
        hardware.bluetooth.enable = true;
        services.blueman.enable = true;


        hardware.opengl = {
          enable = true;
          driSupport = true;
          driSupport32Bit = true;
          # I guess for video acceleration support
          extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
          extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ];
        };

        security.rtkit.enable = true;

        # hybrid sleep on power off button
        services.logind.extraConfig = ''
          HandlePowerKey=hibernate
          HandleLidSwitchDocked=ignore
          HandleLidSwitchExternalPower=ignore
        '';


        networking = {
          hostName = "handre-nixos-laptop"; # Define your hostname.
          wireless = {
            interfaces = [ "wlp3s0" ];
            enable = true; # Enables wireless support via wpa_supplicant.
            userControlled.enable = true;
            # networkd seems to give some errors and useNetworkd has this warning 'Whether we should use networkd as the network configuration backend or the legacy script based system. Note that this option is experimental, enable at your own risk.'
            # useNetworkd = true;
          };
          nameservers = [ "127.0.0.1" "8.8.8.8" ];
          hosts = {
            "192.168.1.1" = [ "router.asus.com" ];
          };

          enableIPv6 = true;
        };

        services.dnsmasq = {
          enable = true;
          settings.server =
            [
              "8.8.8.8"
              "8.8.8.4"
              "192.168.1.1"
            ];
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

        services.journald.rateLimitBurst = -1;

        # mouse-proxy test to succeed
        services.udev.extraRules = ''
          KERNEL=="uinput", MODE="0666"
          KERNEL=="event*", MODE="0666"
        '';

        fonts.fontconfig.antialias = true;
        fonts.fontconfig.hinting.enable = true;

        sound.enable = true;

        services.pipewire = {
          enable = true;
          systemWide = true;
          wireplumber.enable = true;
          audio.enable = true;
          alsa.enable = true;
          pulse.enable = true;
          jack.enable = true;
        };

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

        services.kmonad = {
          enable = true;

          # extraArgs = ["--log-level" "debug"];

          keyboards =
            let
              commonKeyboard = {
                defcfg = {
                  enable = true;
                  compose.key = null;
                  fallthrough = true;
                  allowCommands = false;
                };

                config = ''

                (defsrc
                  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
                  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
                  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
                  caps a    s    d    f    g    h    j    k    l    ;    '    ret
                  lsft z    x    c    v    b    n    m    ,    .    /    rsft
                  lctl lmet lalt           spc            ralt cmp rctl
                )

                (defalias
                  inSymL (layer-toggle symbols_l)   ;; perform next key press in symbol layer
                  syl (tap-hold-next-release 250 ; @inSymL)  ;; semi colon on tap, hold for symbol layer

                  inSymR (layer-toggle symbols_r)   ;; perform next key press in symbol layer
                  syr (tap-hold-next-release 250 a @inSymR)  ;; semi colon on tap, hold for symbol layer

                  fctl (tap-hold-next-release 250 f lctl)  ;; f on tap ctrl on hold

                  jctl (tap-hold-next-release 250 j rctl)  ;; j on tap ctrl on hold

                  dsft (tap-hold-next-release 250 d lsft)  ;; d on tap shift on hold

                  ksft (tap-hold-next-release 250 k rsft)  ;; k on tap shift on hold

                  uscr (around sft -) ;; underscore
                )

                (deflayer qwerty
                  _    _    _    _    _    _    _    _    _    _    _    _    _
                  _    _    _    _    _    _    _    _    _    _    _    _    _    _
                  _    _    _    _    _    _    _    _    _    _    _    _    _    _
                bspc @syr   _  @dsft @fctl _    _  @jctl @ksft _  @syl   _    _
                  _    _    _    _    _    _    _    _    _    _    _    _
                  _    _    _              _             ret  lmet  _
                )

                (deflayer symbols_l
                  _    _    _    _    _    _    _    _    _    _    _    _    _
                  _    _    2    3    4    5    _    _    _    _    _    _    _    _
                  _    !    @    {    }    |    _    _    _    _    _    _    _    _
                  _    #    $   \(   \)    `    _    _    _    _    _    _    _
                  _    %    ^    [    ]    ~    _    _    _    _    _    _
                  _    _    _             esc             _    _    _
                )

                (deflayer symbols_r
                  _    _    _    _    _    _   _    _    _    _    _    _    _
                  _    _    _    _    _    _   _    _    _    _    _    _    _    _
                  _    _    _    _    _    _   _    =    -   @uscr +    _    _    _
                  _    _    _    _    _    _ left  down  up  rght  _    _    _
                  _    _    _    _    _    _   _    _    _    _    _    _
                  _    _    _             esc            _    _    _
                )

                '';
              };
              commonKeyboard2 = {
                defcfg = {
                  enable = true;
                  compose.key = null;
                  fallthrough = true;
                  allowCommands = false;
                };

                config = ''

                (defsrc
                  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
                  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
                  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
                  caps a    s    d    f    g    h    j    k    l    ;    '    ret
                  lsft z    x    c    v    b    n    m    ,    .    /    rsft
                  lctl lmet lalt           spc            ralt cmp rctl
                )

                (defalias
                  inSym (layer-toggle symbols)   ;; perform next key press in symbol layer

                  uscr (around sft -) ;; underscore
                )

                (deflayer qwerty
                  _    _    _    _    _    _    _    _    _    _    _    _    _
                  _    _    _    _    _    _    _    _    _    _    _    _    _    _
                  _    _    _    _    _    _    _    _    _    _    _    _    _    _
                bspc   _    _    _    _    _    _    _    _    _    _    _    _
                  _    _    _    _    _    _    _    _    _    _    _    _
                  _    _  @inSym                _          @inSym  ralt  _
                )

                (deflayer symbols
                  _    _    _    _    _    _   _    _    _    _    _    _    _
                  _    _    2    3    4    5   _    _    _    _    _    _    _    _
                  _    !    @    {    }    |   _    =    -   @uscr +    _    _    _
                  _    #    $   \(   \)    ` left  down  up  rght  _    _    _
                  _    %    ^    [    ]    ~   _    _    _    _    _    _
                  _    _    _             esc            _    _    _
                )

                '';
              };

            in
            {
              laptop-keyboard = {
                device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
              } // commonKeyboard2;
              ms-ergonomic-keyboard = {
                device = "/dev/input/by-id/usb-Microsoft_Microsoft®_2.4GHz_Transceiver_v9.0-event-kbd";
              } // commonKeyboard2;
              # zsa_keyboard = {
              #    device = "/dev/input/by-id/usb-ZSA_Technology_Labs_Moonlander_Mark_I-event-kbd";
              # } // commonKeyboard;
            };
        };

        # The NixOS release to be compatible with for stateful data such as databases.
        system.stateVersion = "17.03";
      }

      (lib.mkIf config.hanstolpo.xmonad.enable {
        services.xserver.exportConfiguration = true;

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
            DisplayPort-1 = {
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
              position = "0x0";
              rate = "60.03";
              dpi = dpi;
            };
          };
        };
        services.autorandr.profiles.laptop = {
          fingerprint = {
            eDP =
              "00ffffffffffff0009e5470700000000121b0104a5221378021bbba658559d260e4f55000000010101010101010101010101010101019c3b803671383c403020360058c21000001afd2d800e713828403020360058c21000001a000000fe00424f452043510a202020202020000000fe004e5631353646484d2d4e36310a0030";
          };
          config = {
            DisplayPort-0.enable = false;
            DisplayPort-1.enable = false;
            eDP = {
              crtc = 1;
              mode = "1920x1080";
              position = "0x0";
              rate = "60.03";
              dpi = laptopDpi;
            };
          };
        };
        services.autorandr.hooks.predetect = {
          "wait" = ''
            ${pkgs.coreutils}/bin/sleep 20s
          '';
        };
        services.autorandr.hooks.preswitch = {
          "wait" = ''
            ${pkgs.coreutils}/bin/sleep 10s
          '';
        };
        services.autorandr.hooks.postswitch = {
          "change-dpi" = ''
            case "$AUTORANDR_CURRENT_PROFILE" in
              default)
                DPI=${builtins.toString laptopDpi}
                ;;
              home_desk)
                DPI=${builtins.toString dpi}
                ;;
              laptop)
                DPI=${builtins.toString laptopDpi}
                ;;
              *)
                echo "Unknown profle: $AUTORANDR_CURRENT_PROFILE"
                exit 1
            esac
            echo "Xft.dpi: $DPI" | ${pkgs.xorg.xrdb}/bin/xrdb -merge
          '';
        };
        systemd.services.autorandr = {
          wantedBy = [ "multi-user.target" ];
          after = [ "display-manager.service" ];
        };
      })
    ];
}


# {
#   services.physlock.enable = false;
# 
#   nixpkgs.config.permittedInsecurePackages = [
#     "python2.7-pyjwt-1.7.1"
#   ];
# 
#   # Set your time zone.
#   #time.timeZone = "Europe/Amsterdam";
#   #time.timeZone = "Europe/London";
#   #time.timeZone = "Africa/Johannesburg";
#   #time.timeZone = "America/Los_Angeles";
#   time.timeZone = "America/Mexico_City";
# 
#   hanstolpo = {
#     shell.enable = true;
#     terminal.enable = true;
#     users.enable = true;
#     desktop.enable = true;
#     physical.enable = true;
#     dev-services.enable = true;
#   };
# 
#   boot.kernelPackages = kernel;
#   boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
#   boot.kernelModules = [ "kvm-intel" ];
# 
#   boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/307695aa-384f-4216-8df2-08e79e8cb0a5";
# 
#   swapDevices =
#     [{ device = "/dev/disk/by-uuid/c00dd2af-d284-4ada-87f5-12e97f5b1afe"; }];
# 
#   nix.settings.max-jobs = lib.mkDefault 8;
# 
#   fileSystems = {
#     "/" =
#       {
#         device = "/dev/disk/by-uuid/ce98892c-adf9-4913-89fb-9ccf4db23388";
#         fsType = "ext4";
#       };
#     "/boot" =
#       {
#         device = "/dev/disk/by-uuid/E321-3515";
#         fsType = "vfat";
#       };
# 
#   } //
#   builtins.mapAttrs
#     (
#       k: _: {
#         mountPoint = "/mnt/network/${k}";
#         device = "//100.66.194.67/${k}";
#         fsType = "cifs";
#         noCheck = true;
#         neededForBoot = false;
#         options = [
#           "noauto"
#           "rw"
#           "user"
#           "users"
#           "credentials=/home/handre/dev/ch-stuff/ucam-credentials-2"
#           "setuids"
#           "uid=1000"
#           "gid=100"
#         ];
#       }
#     )
#     {
#       "I8export" = { };
#       "I8hotfolder" = { };
#       "ch-i8-uploaded" = { };
#       "ch-temp" = { };
#     } //
#   {
#     windows = {
#       mountPoint = "/mnt/windows";
#       device = "/dev/disk/by-uuid/DCEA6B53EA6B28CA";
#       fsType = "ntfs";
#       noCheck = true;
#       neededForBoot = false;
#       options = [
#         "auto"
#         "defaults"
#         "uid=1000"
#         "gid=100"
#         "umask=022"
#       ];
#     };
#   };
#   security.wrappers = {
#     mnt-cifs = {
#       source = "${pkgs.cifs-utils.out}/bin/mount.cifs";
#       owner = "nobody";
#       group = "nogroup";
#     };
#   };
# 
#   environment.variables."SSL_CERT_FILE" = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
# 
#   nix.settings.cores = 6;
# 
#   boot.extraModulePackages = [ ];
# 
#   # Some kernel param options come from https://wiki.archlinux.org/index.php/ASUS_Zenbook_Pro_UX501
#   boot.kernelParams =
#     [
#       # to get bbswitch not hang on startup
#       "acpi_osi=!"
#       "acpi_osi=\"Windows 2009\""
#       # prevent random locks apparently
#       "i915.enable_execlists=0"
#     ];
# 
#   boot.loader.generationsDir.copyKernels = true;
# 
# 
#   services.xserver.videoDrivers = [ "intel" "modesetting" ];
#   boot.blacklistedKernelModules = [ "nouveau" ];
# 
#   hardware.enableRedistributableFirmware = true; # for wifi driver
#   hardware.cpu.intel.updateMicrocode = true;
# 
#   # hardware.bumblebee.enable = true;
#   # hardware.bumblebee.driver = "nvidia";
#   # hardware.bumblebee.connectDisplay = true;
# 
#   hardware.bluetooth.enable = true;
# 
# 
#   ## Dell 27" monitor is about 600 by 340 mm, 16:9 aspect ratio
#   ## dpi approx 162.56 target dpi 1.5 * 96 = 144
#   ## target width 677 mm so 676 by 380
#   #services.xserver.monitorSection = ''
#   #DisplaySize 676 380
#   #'';
#   # Graphics card driver
#   #services.xserver.monitorSection = ''
#   #DisplaySize 344 194
#   #'';
#   hardware.opengl.enable = true;
#   hardware.opengl.driSupport = true;
#   hardware.opengl.driSupport32Bit = true;
#   hardware.opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ];
#   hardware.opengl.extraPackages32 = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ];
# 
#   services.xserver.libinput.enable = true;
#   services.xserver.libinput.touchpad.naturalScrolling = false;
#   services.xserver.libinput.touchpad.disableWhileTyping = true;
#   # services.xserver.dpi = 180;
#   # services.xserver.dpi = 162;
#   services.xserver.dpi = 144; # 15" FHD
#   # services.xserver.dpi = 122;
#   #hardware.opengl.driSupport32Bit = false;
#   services.xserver.exportConfiguration = true;
#   #services.xserver.deviceSection =
#   #'' Option       "TearFree" "true"
#   #'';
#   services.xserver.deviceSection =
#     ''
#       Option      "AccelMethod" "sna"
#         Option       "TearFree" "true"
#     '';
# 
#   environment.systemPackages = with pkgs; [
#     wpa_supplicant_gui
#     microcodeIntel
#     blueman
#     arc-theme
#     gtk-engine-murrine
#     gtk_engines
#     hicolor-icon-theme
#     gnome3.adwaita-icon-theme
#     gnome3.gnome-boxes
#     spice
#     #win-spice
#     breeze-icons
#     wally-cli
#     xloadimage
#     v4l-utils
#     guvcview
#     proot
#     evince # gnome pdf viewer
#     qemu_kvm
#     libvirt
#     virt-manager
#     jitsi-meet-electron
#     signal-desktop
# 
#     pavucontrol
#     #pasystray
#     #pulseaudioFull
#   ];
# 
#   security.rtkit.enable = true;
# 
#   services.pipewire = {
#     enable = true;
#     pulse.enable = true;
#   };
# 
#   # hardware = {
#   #   pulseaudio = {
#   #     enable = true;
#   #     systemWide = false;
#   #     package = pkgs.pulseaudioFull;
#   #   };
#   # };
# 
# 
#   # hybrid sleep on power off button
#   services.logind.extraConfig = ''
#     HandlePowerKey=hibernate
#     HandleLidSwitchDocked=ignore
#     HandleLidSwitchExternalPower=ignore
#   '';
# 
# 
# 
#   # Use the systemd-boot EFI boot loader.
#   boot.loader.systemd-boot.enable = true;
#   boot.loader.efi.canTouchEfiVariables = true;
# 
#   networking = {
#     hostName = "handre-nixos-laptop"; # Define your hostname.
#     wireless = {
#       interfaces = [ "wlp3s0" ];
#       enable = true; # Enables wireless support via wpa_supplicant.
#       userControlled.enable = true;
#       # networkd seems to give some errors and useNetworkd has this warning 'Whether we should use networkd as the network configuration backend or the legacy script based system. Note that this option is experimental, enable at your own risk.'
#       # useNetworkd = true;
#     };
#     nameservers = [ "127.0.0.1" "8.8.8.8" "192.168.100.1" ];
#     hosts = {
#       "10.2.99.3" = [
#         "qa-1-remote-dev-1"
#         "api.qa-1.remote-dev-1.circuithub.com"
#         "qa-1.remote-dev-1.circuithub.com"
#         "api.qa-1.remote-dev-1.circuithub.co"
#         "qa-1.remote-dev-1.circuithub.co"
#       ];
#       "10.2.99.2" = [ "handre-remote-dev-1" ];
#       "10.2.0.99" = [ "remote-dev-1" ];
#       "10.2.0.2" = [ "hydra.circuithub.com" "deploy.circuithub.com" ];
#       "10.2.0.7" = [ "ucamco.circuithub" ];
#       "192.168.1.1" = [ "router.asus.com" ];
#       "3.223.189.209" = [ "ec2-3-223-189-209.compute-1.amazonaws.com" ];
#     };
# 
#     enableIPv6 = true;
#   };
# 
#   services.dnsmasq = {
#     enable = true;
#     settings.server =
#       [
#         "8.8.8.8"
#         "8.8.8.4"
#         "192.168.1.1"
#       ];
#   };
# 
#   #Select internationalisation properties.
#   i18n = {
#     #consoleFont = "Lat2-Terminus16";
#     defaultLocale = "en_ZA.UTF-8";
#   };
# 
#   console = {
#     useXkbConfig = true;
#     packages = [ pkgs.terminus_font ];
#     font = "latarcyrheb-sun32";
#   };
# 
#   # The NixOS release to be compatible with for stateful data such as databases.
#   #system.stateVersion = "17.03";
#   system.stateVersion = "17.03";
#   #system.nixos.stateVersion = "18.09";
# 
#   services.journald.rateLimitBurst = -1;
# 
#   # mouse-proxy test to succeed
#   services.udev.extraRules = ''
#     KERNEL=="uinput", MODE="0666"
#     KERNEL=="event*", MODE="0666"
#   '';
# 
# 
# 
#   fonts.fontconfig.antialias = true;
#   fonts.fontconfig.hinting.enable = true;
# 
#   services.udev.packages = [
# 
#     (
#       pkgs.writeTextFile {
#         name = "wally-udev";
#         text = ''
#           # Teensy rules for the Ergodox EZ
#           ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
#           ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
#           SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
#           KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"
# 
#           # STM32 rules for the Moonlander and Planck EZ
#           SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", \
#           MODE:="0666", \
#           SYMLINK+="stm32_dfu"
#         '';
#         executable = false;
#         destination = "/etc/udev/rules.d/50-wally.rules";
#       }
#     )
#     (
#       pkgs.writeTextFile {
#         name = "oryx-udev";
#         text = ''
#           # Rule for the Moonlander
#           SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
#           # Rule for the Ergodox EZ
#           SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
#           # Rule for the Planck EZ
#           SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"
#         '';
#         executable = false;
#         destination = "/etc/udev/rules.d/50-oryx.rules";
#       }
#     )
# 
#   ];
# }
