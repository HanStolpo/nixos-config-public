{ pkgs, inputs, ... }:
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
  # configure options
  programs.noctalia-shell = {
    enable = true;
    settings = {
      # configure noctalia here
      bar = {
        density = "default";
        position = "top";
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "Launcher";
            }
            {
              id = "ControlCenter";
              useDistroLogo = true;
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
              hideUnoccupied = true;
              id = "Workspace";
            }
            { id = "ActiveWindow";
            }
          ];
          right = [
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
            {
              id = "Tray";
              drawerEnabled = false;
            }
            {
              id = "NotificationHistory";
            }
          ];
        };
      };

      #colorSchemes.predefinedScheme = "Monochrome";

      sessionMenu = {
        enableCountDown = false;
        # powerOptions = [
        #   {action = "lock"; enable = true;}
        #   {action = "suspend"; enable = true;}
        #   {action = "reboot"; enable = true;}
        #   {action = "shutdown"; enable = true;}
        #   {action = "hibernate"; enable = false;}
        #   {action = "logout"; enable = false;}
        # ];
      };

      general = {
        #avatarImage = "/home/drfoobar/.face";
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
