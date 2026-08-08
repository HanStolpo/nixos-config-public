{ lib, inputs, hanstolpo, ... }:
{
  imports = [
    inputs.cosmic-manager.homeManagerModules.cosmic-manager
  ];

  # Declarative COSMIC configuration via cosmic-manager
  # https://heitoraugustoln.github.io/cosmic-manager/
  # settings are applied by cosmic-ctl on home-manager activation as regular
  # RON files under ~/.config/cosmic/, so runtime tweaks via the GUI still
  # work but declared keys get rewritten on the next rebuild.
  wayland.desktopManager.cosmic = {
    enable = true;

    compositor = {
      # tile windows by default; PerWorkspace means new workspaces start
      # tiled but tiling can still be toggled per workspace
      autotile = true;
      autotile_behavior = {
        __type = "enum";
        variant = "PerWorkspace";
      };

      # 10 pinned (persistent) workspaces. cosmic-comp creates every pinned
      # workspace from config on the first output it brings up, so the output
      # match below only decides where they migrate when more monitors appear.
      pinned_workspaces = map
        (i: {
          output = {
            name = "eDP-1"; # the laptop panel connector name
            edid = {
              __type = "optional";
              value = null;
            };
          };
          tiling_enabled = true;
          id = {
            __type = "optional";
            value = "pinned-workspace-${toString i}";
          };
          name = {
            __type = "optional";
            value = null;
          };
        })
        (lib.range 1 10);
    };

    # declaring panels replaces the whole panel list, so the default top
    # Panel has to be declared alongside the Dock we actually configure.
    # keys we do not set fall back to cosmic-panel's compiled-in defaults.
    panels = [
      {
        name = "Panel";
        margin = 0;
      }
      {
        # the Dock is the bar holding the app launcher / app list buttons
        name = "Dock";
        margin = 0;
        autohide = {
          __type = "optional";
          value = {
            wait_time = 500; # ms without pointer focus before hiding
            transition_time = 200; # ms for the hide/show animation
            handle_size = 2; # px grab handle left visible when hidden
          };
        };
      }
    ];

    # custom shortcuts are written to the `custom` map only, so all the
    # COSMIC default shortcuts stay in place; a custom binding on the same
    # keys overrides the default one (Super+T normally spawns cosmic-term)
    shortcuts = [
      {
        description = {
          __type = "optional";
          value = "Open Alacritty";
        };
        key = "Super+T";
        action = {
          __type = "enum";
          variant = "Spawn";
          value = [ "alacritty" ];
        };
      }
    ];

    # rotate through the wallpapers in the repository wallpaper directory
    wallpapers = lib.mkIf (hanstolpo.cosmic.wallpaperDirectory != "") [
      {
        output = "all";
        source = {
          __type = "enum";
          variant = "Path";
          value = [ hanstolpo.cosmic.wallpaperDirectory ];
        };
        filter_by_theme = false;
        filter_method = {
          __type = "enum";
          variant = "Lanczos";
        };
        scaling_mode = {
          __type = "enum";
          variant = "Zoom";
        };
        sampling_method = {
          __type = "enum";
          variant = "Random";
        };
        rotation_frequency = 3600; # change wallpaper every hour
      }
    ];
  };
}
