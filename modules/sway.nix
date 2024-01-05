# config derived from the nixos wiki
# https://nixos.wiki/wiki/Sway
#
# some settings copied directly from this persons nixos configuration
# https://github.com/danielbarter/nixos-config/blob/36e173ac251a3380a026c0ccb90c3612a627b761/configuration.nix
#
{ config, lib, pkgs, ... }:

with lib;
let

  cfg = config.hanstolpo.sway;

  # The overlays provide a sway instance wrapped to log to journald
  # we further customize the settings the same way that 'programs.sway'
  # would have done, that is we customize it here instead of there.
  swayCustom = pkgs.swayJournald.override {
    withBaseWrapper = true;
    withGtkWrapper = true;
    isNixOS = true;
    enableXWayland = true;
    dbusSupport = true;
    extraSessionCommands = 
      let
        schema = pkgs.gsettings-desktop-schemas;
        schema_datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
    ''
      # GTK:
      # to get gsettings to work (needs pkgs.glib in systemPackages)
      # currently, there is some friction between sway and gtk:
      # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
      # the suggested way to set gtk settings is with gsettings
      # for gsettings to work, we need to tell it where the schemas are
      # using the XDG_DATA_DIR environment variable
      export XDG_DATA_DIRS="${schema_datadir}:$XDG_DATA_DIRS"

      # what the deprecated option xdg.portal.gtkUsePortal did
      # Sets environment variable GTK_USE_PORTAL to 1. This is
      # needed for packages ran outside Flatpak to respect and
      # use XDG Desktop Portals. For example, you'd need to set
      # this for non-flatpak Firefox to use native filechoosers.
      export GTK_USE_PORTAL=1

      # SDL:
      export SDL_VIDEODRIVER=wayland

      # QT (needs qt5.qtwayland in systemPackages):
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"

      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1

      # https://wiki.archlinux.org/title/firefox#Wayland
      export MOZ_ENABLE_WAYLAND=1

      # since 22.05 https://nixos.org/manual/nixos/unstable/release-notes.html
      # If you are using Wayland you can choose to use the Ozone Wayland support
      # in Chrome and several Electron apps by setting the environment variable
      # NIXOS_OZONE_WL=1 (for example via environment.sessionVariables.NIXOS_OZONE_WL = "1").
      # This is not enabled by default because Ozone Wayland is still under heavy development
      # and behavior is not always flawless. Furthermore, not all Electron apps use the latest
      # Electron versions. #
      export NIXOS_OZONE_WL=1

      # these are from here https://man.sr.ht/~kennylevinsen/greetd/#how-to-set-xdg_session_typewayland
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway
      export XDG_CURRENT_DESKTOP=sway
      export CLUTTER_BACKEND=wayland
      export ECORE_EVAS_ENGINE=wayland-egl
      export ELM_ENGINE=wayland_egl
      export NO_AT_BRIDGE=1

      export XDG_SCREENSHOTS_DIR=$HOME/Screenshots
    '';
  };
in
{
  options = {
    hanstolpo.sway = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      pathToSwayConfigFile = mkOption {
        type = types.str;
      };
      pathToWayDisplaysConfigFile = mkOption {
        type = types.str;
      };
      pathToWaybarConfigFile = mkOption {
        type = types.str;
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      haswaynav # customize navigation in sway

      alacritty # gpu accelerated terminal
      swayCustom
      wayland
      glib # gsettings
      gsettings-desktop-schemas
      dracula-theme # gtk theme
      colloid-gtk-theme
      gnome3.adwaita-icon-theme # default gnome cursors
      swaylock
      swayidle
      sway-contrib.grimshot # screenshot functionality
      swayimg
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      fuzzel # fuzzy application launcher for sway
      mako # notification system developed by swaywm maintainer
      way-displays # autorandr like management of display outputs connected to wayland compositor
      waybar #
      zathura # document viewer
      nomacs # image viewer
      xdg-desktop-portal-wlr
      qt5.qtwayland
    ];

    programs.light.enable = true;


    # xdg-desktop-portal works by exposing a series of D-Bus interfaces
    # known as portals under a well-known name
    # (org.freedesktop.portal.Desktop) and object path
    # (/org/freedesktop/portal/desktop).
    # The portal interfaces include APIs for file access, opening URIs,
    # printing and others.
    services.dbus.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      wlr.settings.screencast = {
        #output_name = "HDMI-A-1";
        max_fps = 30;
        #exec_before = "disable_notifications.sh";
        #exec_after = "enable_notifications.sh";
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
      };
      # gtk portal needed to make gtk apps happy
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    # enable sway window manager
    programs.sway = {
      enable = true;
      # all customizations is done via the custom package
      package = swayCustom;
    };

    environment.etc = {
      "sway/config".source = "${cfg.pathToSwayConfigFile}";
      "way-displays/cfg.yaml".source = "${cfg.pathToWayDisplaysConfigFile}";
      "xdg/waybar/config".source = "${cfg.pathToWaybarConfigFile}";
    };

    programs.regreet = {
      enable = true;
      settings = {
        GTK = {
          # Whether to use the dark theme
          application_prefer_dark_theme = true;

          # Cursor theme name
          cursor_theme_name = "Adwaita";

          # Font name and size
          font_name = "SourceCodePro Regular 11";

          # Icon theme name
          icon_theme_name = "Papirus";

          # GTK theme name
          theme_name = "Colloid-Dark";
        };
      };
    };

    services.greetd = {
      enable = true;
      settings = {
        terminal = {
          vt = "7";
        };
        default_session =
          let
            sway_greeter_config = pkgs.writeTextFile {
              name = "sway_greeter_config";
              text = ''
                include /etc/sway/config.d/*
                exec "way-displays 2>&1 | logger -t way-displays"
                exec gsettings set org.gnome.desktop.interface gtk-theme 'Colloid-Dark'
                exec "${pkgs.greetd.regreet}/bin/regreet; swaymsg exit"
                exec swayidle -w timeout 120 'systemctl suspend'
              '';
            };
          in
          {
            # https://github.com/rharish101/ReGreet/issues/34#issue-1808828810
            command = "${pkgs.dbus}/bin/dbus-run-session ${swayCustom}/bin/sway --config ${sway_greeter_config}";
          };
      };
    };
  };
}
