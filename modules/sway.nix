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

  # bash script to let dbus know about important env variables and
  # propogate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
  dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
  systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
  systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
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
        alacritty                  # gpu accelerated terminal
        sway
        dbus-sway-environment
        configure-gtk
        wayland
        glib                       # gsettings
        dracula-theme              # gtk theme
        gnome3.adwaita-icon-theme  # default gnome cursors
        swaylock
        swayidle
        grim                       # screenshot functionality
        slurp                      # screenshot functionality
        wl-clipboard               # wl-copy and wl-paste for copy/paste from stdin / stdout
        bemenu                     # wayland clone of dmenu
        mako                       # notification system developed by swaywm maintainer
        pkgs-unstable.way-displays # autorandr like management of display outputs connected to wayland compositor
        waybar                     #
        zathura # document viewer
        cinnamon.nemo    # file manager
        nomacs # image viewer
        mpv # video player
        xdg-desktop-portal-wlr
    ];

    services.pipewire.wireplumber.enable = false;

    services.pipewire.media-session.enable = true;

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
      wrapperFeatures.gtk = true;
    };

    environment.variables = {
        # what the deprecated option xdg.portal.gtkUsePortal did
        # Sets environment variable GTK_USE_PORTAL to 1. This is
        # needed for packages ran outside Flatpak to respect and
        # use XDG Desktop Portals. For example, you'd need to set
        # this for non-flatpak Firefox to use native filechoosers.
        "GTK_USE_PORTAL" = 1;
        # https://wiki.archlinux.org/title/firefox#Wayland
        "MOZ_ENABLE_WAYLAND" = "1";
        # since 22.05 https://nixos.org/manual/nixos/unstable/release-notes.html
        # If you are using Wayland you can choose to use the Ozone Wayland support
        # in Chrome and several Electron apps by setting the environment variable
        # NIXOS_OZONE_WL=1 (for example via environment.sessionVariables.NIXOS_OZONE_WL = "1").
        # This is not enabled by default because Ozone Wayland is still under heavy development
        # and behavior is not always flawless. Furthermore, not all Electron apps use the latest
        # Electron versions. #
        "NIXOS_OZONE_WL" = "1";
        # these are from here https://man.sr.ht/~kennylevinsen/greetd/#how-to-set-xdg_session_typewayland
        "XDG_SESSION_TYPE"            = "wayland";
        "XDG_SESSION_DESKTOP"         = "sway";
        "XDG_CURRENT_DESKTOP"         = "sway";
        "CLUTTER_BACKEND"             = "wayland";
        "QT_QPA_PLATFORM"             = "wayland-egl";
        "ECORE_EVAS_ENGINE"           = "wayland-egl";
        "ELM_ENGINE"                  = "wayland_egl";
        "SDL_VIDEODRIVER"             = "wayland";
        "_JAVA_AWT_WM_NONREPARENTING" = "1";
        "NO_AT_BRIDGE"                = "1";
    };

    environment.etc = {
      "sway/config".source = "${cfg.pathToSwayConfigFile}";
      "way-displays/cfg.yaml".source = "${cfg.pathToWayDisplaysConfigFile}";
      "xdg/waybar/config".source = "${cfg.pathToWaybarConfigFile}";
    };

    services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
        };
      };
    };
  };
}
