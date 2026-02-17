{ pkgs, inputs, hanstolpo, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];


  programs.quickshell = {
    # we want to include configuration for quickshell
    # so that the `qs` commands can work.
    enable = true;
    # noctalia runs as a service
    systemd.enable = false;
    # below is so that it can find the configurations for noctalia
    activeConfig = "noctalia-shell";
    configs = {
      default = "${pkgs.noctalia-shell}/share/noctalia-shell";
      noctalia-shell = "${pkgs.noctalia-shell}/share/noctalia-shell";
    };
  };

  programs.noctalia-shell = {
    enable = true;

    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        screen-recorder = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        screenshot = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        tailscale = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        unicode-picker = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        simple-notes = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 2;
    };

    settings = {

      wallpaper = {
        enable = true;
        overviewEnable = true;
        directory = hanstolpo.noctalia.wallpaperDirectory;
        fillMode = "fit";
        automationEnabled = true;
        randomEnable = true;
        randomIntervalSec = 1800;
      };

      appLauncher = {
        useApp2Unit = true;
      };

      bar = {
        density = "default";
        position = "top";
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = false;
            }
            {
              id = "Launcher";
            }
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "MediaMini";
            }
          ];
          center = [
            {
              id = "Workspace";
              characterCount = 10;
              colorizeIcons = false;
              enableScrollWheel = true;
              followFocusedScreen = true;
              groupedBorderOpacity = 1;
              hideUnoccupied = true;
              iconScale = 0.8;
              labelMode = "name";
              showApplications = false;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1;
            }
            { id = "ActiveWindow";
            }
          ];
          right = [
            { id = "simple-notes";
            }
            { id = "unicode-picker";
            }
            { id = "screen-shot";
            }
            { id = "screen-recorder";
            }
            { id = "SystemMonitor";
            }
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 30;
            }
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
            { id = "tailscale";
            }
            {
              id = "Tray";
              drawerEnabled = false;
              hidePassive = true;
            }
            {
              id = "NotificationHistory";
            }
          ];
        };
      };

      #colorSchemes.predefinedScheme = "Monochrome";

      sessionMenu = {
        enableCountdown = false;
        powerOptions = [
          {action = "lock"; enabled = true;}
          {action = "suspend"; enabled = true;}
          {action = "reboot"; enabled = true;}
          {action = "shutdown"; enabled = true;}
          {action = "hibernate"; enabled = false;}
          {action = "logout"; enabled = false;}
        ];
      };

      notifications = {
        enableMediaToast = true;
        saveToHistory = {
          low = false;
          normal = true;
          critical = true;
        };
      };

      general = {
        avatarImage = hanstolpo.noctalia.avatarImage;
        radiusRatio = 0.2;
      };
      location = {
        monthBeforeDay = false;
        name = "Amsterdam, Netherlands";
      };
    };
    # this may also be a string or a path to a JSON file,
    # but in this case must include *all* settings.
  };
}
