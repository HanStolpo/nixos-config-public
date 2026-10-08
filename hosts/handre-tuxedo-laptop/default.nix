{ config, lib, pkgs, modulesPath, ... }:
let
  # Using latest kernel (6.19.7) to avoid scheduler spinlock bugs in 6.12.x
  # See README/crash-report/hard-lockup-31-03-2026.md
  # switching from 6.19 latest to earlier 6.18 for better compatibility with niri and the display etc.
  kernel = pkgs.linuxPackages_7_2; # pkgs.linuxPackages_6_18;
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

        services.tailscale.enable = true;

        services.nordvpn = {
          enable = true;
          users = [ "handre" ];  # Users to add to nordvpn group
        };

        # allow cross compiling aarch64
        boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
        # nixpkgs.crossSystem = {
        #   system = "aarch64-linux";
        # };


        hanstolpo = {

          users = {
            enable = true;
            SSHLogin = enableSSH;
          };

          xmonad.enable = false;


          sway = {
            enable = false;
            pathToSwayConfigFile = "/home/handre/nixos-config-public/dotfiles/config/sway/config";
            pathToWayDisplaysConfigFile = "/home/handre/nixos-config-public/dotfiles/config/way-displays/cfg.yaml";
            pathToWaybarConfigFile = "/home/handre/nixos-config-public/dotfiles/config/waybar/config";
            autoLoginUser = "handre";
          };

          # Enable to try out the COSMIC desktop environment;
          # this automatically disables niri + noctalia below.
          cosmic = {
            enable = true;
            autoLoginUser = "handre";
            wallpaperDirectory = "/home/handre/nixos-config-public/wallpapers";
          };

          niri = {
            enable = !config.hanstolpo.cosmic.enable;
            autoLoginUser = "handre";
          };

          shell.enable = true;
          terminal.enable = true;
          desktop.enable = true;
          physical.enable = true;
          dev-services.enable = false;
          battery-management.enable = false;
          noctalia = {
              enable = !config.hanstolpo.cosmic.enable;
              wallpaperDirectory = "/home/handre/nixos-config-public/wallpapers";
              avatarImage = "/home/handre/nixos-config-public/profile-pics/robot-hare-Gemini_Generated_Image_a98ub6a98ub6a98u.png";
          };
          nvim.enable = true;
          home-manager = {
            enable = true;
            users = [ "handre" ];
          };

          kmonad = {
            enable = true;
            keyboards = {
              laptop-keyboard = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
              ms-ergonomic-keyboard = "/dev/input/by-id/usb-Microsoft_Microsoft®_2.4GHz_Transceiver_v9.0-event-kbd";
              knesis-mwave = "/dev/input/by-id/usb-Kinesis_Corporation_mWave_43CD3C41FE6BA0B3-if02-event-kbd";
              perrix = {
                device = "/dev/input/by-id/usb-MOSART_Semi._PERIDUO-606-event-kbd";
              };
              ergonomic-bt-keyboard = {
                device = "/dev/input/by-id/bluetooth-ergonomic-keyboard-event-kbd";
                noComposeKeyRCtrlAsRAlt = true;
                leftArrowAsCtrl = true;
              };
            };
          };
        };

        services.usbmuxd.enable = true;
        services.gvfs.enable = true;

        # for logitech unified wireless receiver to allow managing devices
        hardware.logitech.wireless = {
          enable = true; # manage devices via cli tool ltunify
          enableGraphical = true; # manage devices via graphical too solaar
        };

        virtualisation.docker.enable = true;


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


        nix.settings.max-jobs = lib.mkDefault 12;
        nix.settings.cores = 12;

        environment.variables."SSL_CERT_FILE" = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

        environment.systemPackages = with pkgs; [
          wpa_supplicant_gui
          blueman
          arc-theme
          gtk-engine-murrine
          gtk_engines
          hicolor-icon-theme
          pkgs.adwaita-icon-theme
          papirus-icon-theme
          gnome-boxes
          spice
          #kdePackages.breeze-icons # depends on qtwebengine-5.15.19
          wally-cli
          v4l-utils
          guvcview
          proot
          evince # gnome pdf viewer
          qemu_kvm
          libvirt
          virt-manager
          #jitsi-meet-electron
          signal-desktop
          pavucontrol
          # xournalpp # note taking software with PDF annotation support
          wdisplays
          wf-recorder
          slurp
          wtp
          #pkgs-unstable.davinci-resolve

          # opencl https://nixos.wiki/wiki/AMD_GPU#OpenCL
          rocmPackages.clr.icd
          clinfo
        ];

        boot.tmp.cleanOnBoot = true;
        boot.kernelPackages = kernel;
        boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules =
          [
            "kvm-amd"
            "lm92"
            "k10temp"
            "zenpower"
            "tuxedo_keyboard"
            "uinput"
            "amdgpu"
          ];
        boot.extraModulePackages = with kernel; [ pkgs.pkgs-unstable.linuxPackages_7_2.zenpower tuxedo-keyboard ];
        boot.kernelParams = [
          # https://www.tuxedocomputers.com/en/Infos/Help-Support/Help-for-my-device/TUXEDO-Book-XC-series/TUXEDO-Book-XC17-Gen11/Keyboard-not-working-properly.tuxedo
          "i8042.reset"
          "i8042.nomux"
          "i8042.nopnp"
          "i8042.noloop"
          # https://nixos.wiki/wiki/AMD_GPU
          # card is a Radeon Graphics 512SP so GCN 5.1 architecture
          # GPU Generation     | Series                | Architecture | HIP Support          | Ray Tracing | AI Acceleration | Vulkan Support
          # GCN 5th Gen (Vega) | Radeon RX Vega Series | GCN 5.0      | Yes (up to ROCm 5.6) | No          | No              | Vulkan 1.1
          # so no need for the cik_support bits below
          # "radeon.cik_support=0"
          # "amdgpu.cik_support=1"

          # ZFS tuning for 64GB RAM + heavy compilation
          "zfs.zfs_arc_max=17179869184"
          # Disable scheduler autogroup to avoid spinlock deadlock
          # See README/crash-report/hard-lockup-31-03-2026.md
          #"noautogroup"
          # Workarounds for s2idle resume black screen (amdgpu)
          # See README/crash-report/s2idle-resume-failure-01-04-2026.md
          #"amdgpu.dcdebugmask=0x10" # disable PSR (Panel Self Refresh)
          #"amdgpu.runpm=0" # disable amdgpu runtime power management
          #"pm_debug_messages" # verbose PM logging for diagnosing suspend/resume
          #"no_console_suspend" # keep console alive during suspend/resume
        ];
        boot.extraModprobeConfig = ''
          options zfs zfs_arc_meta_limit=8589934592
        '';
        hardware.tuxedo-drivers.enable = true;
        hardware.tuxedo-rs.enable = true;
        hardware.tuxedo-rs.tailor-gui.enable = true;

        # https://nixos.wiki/wiki/AMD_GPU
        systemd.tmpfiles.rules = [
          "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
        ];

        # Use the systemd-boot EFI boot loader.
        boot.loader.generationsDir.copyKernels = true;
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.supportedFilesystems = ["zfs"];
        boot.zfs = {
          devNodes = "/dev/disk/by-partlabel";
          forceImportRoot = false;
          requestEncryptionCredentials = true;
        };


      fileSystems = {
        "/" = {
          device = "tank/system/root";
          fsType = "zfs";
        };

        "/boot" = {
          device = "/dev/disk/by-partlabel/BOOT";
          fsType = "vfat";
          options = [ "X-mount.mkdir" "iocharset=iso8859-1" ];
        };

        "/nix" = {
          device = "tank/system/nix";
          fsType = "zfs";
        };

        "/var" = {
          device = "tank/system/var";
          fsType = "zfs";
        };

        "/var/lib" = {
          device = "tank/system/var/lib";
          fsType = "zfs";
        };

        "/var/lib/restic" = {
          device = "tank/system/var/lib/restic";
          fsType = "zfs";
        };

        "/home" = {
          device = "tank/home";
          fsType = "zfs";
        };

        "/home/handre" = {
          device = "tank/home/handre";
          fsType = "zfs";
        };

        "/home/handre/code" = {
          device = "tank/home/handre/code";
          fsType = "zfs";
        };

        "/home/handre/code/circuithub" = {
          device = "tank/home/handre/code/circuithub";
          fsType = "zfs";
        };

        "/home/handre/code/circuithub/master" = {
          device = "tank/home/handre/code/circuithub/master";
          fsType = "zfs";
        };

        "/home/handre/code/circuithub/master/.git" = {
          device = "tank/home/handre/code/circuithub/master/.git";
          fsType = "zfs";
        };

      };

        # Snapshots and maintenance
        services.zfs.autoSnapshot = {
          enable = true;
          frequent = 4;
          hourly = 24;
          daily = 7;
          weekly = 4;
          monthly = 12;
        };
        services.zfs.autoScrub = {
          enable = true;
          interval = "weekly";
        };

        # Allow user to manage ZFS
        security.sudo.enable = true;

        # fileSystems = {
        #   "/" =
        #     {
        #       device = "/dev/disk/by-uuid/1aff7ddd-37c1-4379-8487-eb2de56465fa";
        #       fsType = "ext4";
        #     };
        #   "/boot" =
        #     {
        #       device = "/dev/disk/by-uuid/C7A9-3E53";
        #       fsType = "vfat";
        #     };
        # };

        # boot.initrd.luks.devices."crypted".device = "/dev/disk/by-uuid/920eb5ec-e62f-415c-aefd-26a9cc7f3762";

        # swapDevices =
        #   [{ device = "/dev/disk/by-uuid/9673d6ae-51cd-4da5-8883-99ffdf606f72"; }];

        # noctalia and cosmic both use NetworkManager which manages DHCP and
        # wpa_supplicant itself (the NetworkManager module forces useDHCP = false
        # and wireless.enable = true, so these definitions have to agree with it)
        networking.useDHCP = !(config.hanstolpo.noctalia.enable || config.hanstolpo.cosmic.enable);

        hardware.enableRedistributableFirmware = true; # for wifi driver
        hardware.cpu.amd.updateMicrocode = true;
        hardware.bluetooth.enable = true;
        services.blueman.enable = true;


        hardware.graphics = {
          enable = true;
          enable32Bit = true;
          # I guess for video acceleration support
          extraPackages32 = with pkgs.pkgsi686Linux; [ 
            libva
          ];
          extraPackages = with pkgs;
            [
              libva
            ];
        };

        security.rtkit.enable = true;

        # hybrid sleep on power off button
        services.logind.settings.Login = {
          HandlePowerKey = "hibernate";
          HandleLidSwitchDocked = "ignore";
          # keep running with the lid closed whenever on external power, even
          # with no external monitor: "docked" requires >1 connected display,
          # and monitors that power off (DPMS / standby) can drop off the
          # connector, which would otherwise re-trigger the suspend action
          HandleLidSwitchExternalPower = "ignore";
          HandleLidSwitch = "suspend";
          LidSwitchIgnoreInhibited = "yes";
          PowerKeyIgnoreInhibited = "yes";
          SuspendKeyIgnoreInhibited = "yes";
          HibernateKeyIgnoreInhibited = "yes";
        };
        # some info about sleep conf here 
        # https://www.reddit.com/r/systemd/comments/mlwouv/comment/gto2dmt/?utm_source=share&utm_medium=web2x&context=3
        # https://www.kernel.org/doc/html/latest/admin-guide/pm/sleep-states.html
        # https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#System_does_not_power_off_when_hibernating
        # SuspendMode= and HibernateState= removed — no longer supported by systemd
        # See README/crash-report/s2idle-resume-failure-01-04-2026.md
        systemd.sleep.settings.Sleep = {
          HibernateDelaySec = "1h";
          SuspendState = "mem";
          HibernateMode = "platform";
          AllowHybridSleep = "no";
          AllowSuspendThenHibernate = "no";
        };

        networking = {
          hostId = "ce1223f3";
          hostName = "handre-tuxedo-laptop"; # Define your hostname.
          wireless = {
            #interfaces = [ "wlp3s0" ];
            enable = config.hanstolpo.noctalia.enable || config.hanstolpo.cosmic.enable; # Enables wireless support via wpa_supplicant.
            userControlled = true;
            # networkd seems to give some errors and useNetworkd has this warning 'Whether we should use networkd as the network configuration backend or the legacy script based system. Note that this option is experimental, enable at your own risk.'
            # useNetworkd = true;
          };
          nameservers = [
              # https://quad9.net/asus/safe/
              "9.9.9.9"
              "149.112.112.112"

              # # google dns
              # "8.8.8.8"
              # "8.8.8.4"
          ];
          hosts = {
            "192.168.1.1" = [ "router.asus.com" ];
          };

          enableIPv6 = true;
        };

        # We want to use networkd to manage container networking automatically but use networkmanager for laptop wifi / lan networking
        networking.networkmanager.unmanaged = [ "interface-name:vz-*" "interface-name:ve-*" ];
        systemd.network.enable = true;                    # turn networkd on
        networking.useNetworkd = false;                   # but don't let it manage everything
        systemd.network.wait-online.enable = false;      # networkd only manages container interfaces; NetworkManager handles real connectivity
        services.resolved = {
          enable = true;
          settings.Resolve = {
            DNSSEC = "allow-downgrade";
            Domains = [ "~." ];
          };
        };
        # enable NAT so that nspawn containers can access outside world with bridge networking managed by networkd
        # NAT as before
        networking.nat = {
          enable = true;
          internalInterfaces = [ "vz-dev" ];
          externalInterface = "wlp0s20f3";
        };

        services.dnsmasq.enable = false;

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
            # disable wake on LAN which takes laptop out of sleep immediately
            # https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Instantaneous_wakeups_from_suspend
            pkgs.writeTextFile {
              name = "avoid-i2c-wakeup";
              text = ''
                KERNEL=="i2c-ELAN0415:00", SUBSYSTEM=="i2c", ATTR{power/wakeup}="disabled"
              '';
              executable = false;
              destination = "/etc/udev/rules.d/99-avoid-i2c-wakeup.rules";
            }
          )

          (
            # Create stable symlink for Bluetooth Ergonomic Keyboard and manage kmonad service
            pkgs.writeTextFile {
              name = "bluetooth-ergonomic-keyboard";
              text = ''
                # Create stable symlink for the keyboard
                SUBSYSTEM=="input", ATTRS{uniq}=="45:28:60:00:01:8f", KERNEL=="event*", SYMLINK+="input/by-id/bluetooth-ergonomic-keyboard-event-kbd"
                # Restart kmonad service when keyboard connects
                SUBSYSTEM=="input", ATTRS{uniq}=="45:28:60:00:01:8f", KERNEL=="event*", ACTION=="add", RUN+="${pkgs.systemd}/bin/systemctl restart kmonad-ergonomic-bt-keyboard.service"
                # Stop kmonad service when keyboard disconnects
                SUBSYSTEM=="input", ATTRS{uniq}=="45:28:60:00:01:8f", KERNEL=="event*", ACTION=="remove", RUN+="${pkgs.systemd}/bin/systemctl stop kmonad-ergonomic-bt-keyboard.service"
              '';
              executable = false;
              destination = "/etc/udev/rules.d/99-bluetooth-ergonomic-keyboard.rules";
            }
          )

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
            # Enable USB keyboard to wake system from suspend
            #
            # References:
            # - https://wiki.archlinux.org/title/Power_management/Wakeup_triggers
            # - https://www.makeuseof.com/wake-your-linux-pc-from-suspend-using-usb-devices/
            #
            # Debug commands:
            # - List USB devices:
            #     lsusb
            # - Check wakeup status:
            #     for f in /sys/bus/usb/devices/*/power/wakeup; do echo "$f: $(cat $f)"; done
            # - Find device path by vendor:
            #     grep -l "29ea" /sys/bus/usb/devices/*/idVendor
            # - Manually enable device for wakeup replacing X-X.X.X.X from the find device command above:
            #     echo enabled | sudo tee /sys/bus/usb/devices/X-X.X.X/power/wakeup
            # - Check ACPI wakeup sources:
            #     cat /proc/acpi/wakeup
            # - Manually enable wakeup for testing:
            #     for dev in /sys/bus/usb/devices/*/idVendor; do
            #       if [ "$(cat $dev)" = "29ea" ]; then
            #         echo enabled | sudo tee "$(dirname $dev)/power/wakeup"
            #       fi
            #     done
            pkgs.writeTextFile {
              name = "usb-keyboard-wakeup";
              text = ''
                # Kinesis mWave keyboard (29ea:1001)
                ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="29ea", ATTR{idProduct}=="1001", ATTR{power/wakeup}="enabled"
              '';
              executable = false;
              destination = "/etc/udev/rules.d/90-usb-keyboard-wakeup.rules";
            }
          )

          (
            # Restart kmonad service when Kinesis mWave keyboard connects/disconnects
            pkgs.writeTextFile {
              name = "kinesis-mwave-kmonad";
              text = ''
                # Restart kmonad service when Kinesis keyboard connects
                SUBSYSTEM=="input", ATTRS{idVendor}=="29ea", ATTRS{idProduct}=="1001", KERNEL=="event*", ACTION=="add", RUN+="${pkgs.systemd}/bin/systemctl restart kmonad-knesis-mwave.service"
                # Stop kmonad service when Kinesis keyboard disconnects
                SUBSYSTEM=="input", ATTRS{idVendor}=="29ea", ATTRS{idProduct}=="1001", KERNEL=="event*", ACTION=="remove", RUN+="${pkgs.systemd}/bin/systemctl stop kmonad-knesis-mwave.service"
              '';
              executable = false;
              destination = "/etc/udev/rules.d/99-kinesis-mwave-kmonad.rules";
            }
          )

        ];


        # The NixOS release to be compatible with for stateful data such as databases.
        system.stateVersion = "22.05";
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

