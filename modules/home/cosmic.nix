{ lib, pkgs, inputs, hanstolpo, ... }:
let
  # workaround for the broken "copy to clipboard" in xdg-desktop-portal-cosmic
  # (the portal destroys its overlay surfaces in the same command batch as the
  # clipboard write, so the write is dropped): save screenshots to Pictures via
  # the portal UI, then copy the newest one to the clipboard with this script.
  # wl-copy stays alive as clipboard owner via the data control protocol
  # (COSMIC_DATA_CONTROL_ENABLED=1 in cosmic.nix), which reliably works.
  copy-latest-screenshot = pkgs.writeShellScript "copy-latest-screenshot" ''
    dir="''${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
    latest="$(${pkgs.coreutils}/bin/ls -t "$dir" | ${pkgs.coreutils}/bin/head -n1)"
    if [ -n "$latest" ]; then
      ${pkgs.wl-clipboard}/bin/wl-copy --type image/png < "$dir/$latest"
      ${pkgs.libnotify}/bin/notify-send -t 3000 "Screenshot copied to clipboard" "$latest"
    fi
  '';
in
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

      active_hint = true; # outline the focused window
      focus_follows_cursor = true;
      cursor_follows_focus = true;
      descale_xwayland = false;

      input_default = {
        state = {
          __type = "enum";
          variant = "Enabled";
        };
        acceleration = {
          __type = "optional";
          value = {
            profile = {
              __type = "optional";
              value = {
                __type = "enum";
                variant = "Flat";
              };
            };
            speed = 0.448662141139867;
          };
        };
      };

      xkb_config = {
        rules = "";
        model = "pc104";
        layout = "us";
        variant = "";
        options = {
          __type = "optional";
          value = "terminate:ctrl_alt_bksp";
        };
        repeat_delay = 600;
        repeat_rate = 25;
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
        # pin these: cosmic-initial-setup rewrites panel config on first login
        # and its layout preset auto-hides the top Panel; since cosmic-manager
        # only rewrites declared keys, undeclared ones keep the wizard's values
        autohide = {
          __type = "optional";
          value = null; # None = never auto-hide the top panel
        };
        exclusive_zone = true; # reserve space so windows don't cover it
        anchor = {
          __type = "enum";
          variant = "Top";
        };
        anchor_gap = false;
        expand_to_edges = true;
        opacity = 1.0;
        background = {
          __type = "enum";
          variant = "ThemeDefault";
        };
        output = {
          __type = "enum";
          variant = "All";
        };
        size = {
          __type = "enum";
          variant = "S";
        };
        plugins_center = {
          __type = "optional";
          value = [ "com.system76.CosmicAppletTime" ];
        };
        plugins_wings = {
          __type = "optional";
          value = {
            __type = "tuple";
            value = [
              [
                "com.system76.CosmicPanelWorkspacesButton"
                "com.system76.CosmicPanelAppButton"
              ]
              [
                "com.system76.CosmicAppletInputSources"
                "com.system76.CosmicAppletStatusArea"
                "com.system76.CosmicAppletA11y"
                "com.system76.CosmicAppletTiling"
                "com.system76.CosmicAppletAudio"
                "com.system76.CosmicAppletBluetooth"
                "com.system76.CosmicAppletNetwork"
                "com.system76.CosmicAppletBattery"
                "com.system76.CosmicAppletNotifications"
                "com.system76.CosmicAppletPower"
              ]
            ];
          };
        };
      }
      {
        # the Dock is the bar holding the app launcher / app list buttons
        name = "Dock";
        margin = 0;
        exclusive_zone = false; # auto-hiding dock should not reserve space
        autohide = {
          __type = "optional";
          value = {
            wait_time = 500; # ms without pointer focus before hiding
            transition_time = 200; # ms for the hide/show animation
            handle_size = 2; # px grab handle left visible when hidden
          };
        };
        anchor = {
          __type = "enum";
          variant = "Bottom";
        };
        anchor_gap = true;
        expand_to_edges = false;
        opacity = 1.0;
        background = {
          __type = "enum";
          variant = "ThemeDefault";
        };
        output = {
          __type = "enum";
          variant = "All";
        };
        size = {
          __type = "enum";
          variant = "L";
        };
        plugins_center = {
          __type = "optional";
          value = [
            "com.system76.CosmicPanelLauncherButton"
            "com.system76.CosmicPanelWorkspacesButton"
            "com.system76.CosmicPanelAppButton"
            "com.system76.CosmicAppList"
            "com.system76.CosmicAppletMinimize"
          ];
        };
        plugins_wings = {
          __type = "optional";
          value = {
            __type = "tuple";
            value = [
              [ ]
              [ ]
            ];
          };
        };
      }
    ];

    # idle policy is handled by cosmic-idle, which tracks real compositor
    # activity and honors idle-inhibitors (unlike logind's IdleAction, which
    # cannot see Wayland input for greetd tty sessions — see physical.nix)
    idle = {
      screen_off_time = {
        __type = "optional";
        value = 900000; # screen off after 15 min idle
      };
      suspend_on_ac_time = {
        __type = "optional";
        value = 1200000; # suspend after 20 min idle on AC
      };
      suspend_on_battery_time = {
        __type = "optional";
        value = 1200000; # suspend after 20 min idle on battery
      };
    };

    applets = {
      time.settings = {
        military_time = true; # 24-hour clock
        first_day_of_week = 6; # 0 = Monday, 6 = Sunday
      };
      audio.settings = {
        show_media_controls_in_top_panel = false;
      };
    };

    # theme *builder* inputs only; COSMIC derives the full
    # com.system76.CosmicTheme.Dark/v1 tree from these, and the palette /
    # spacing / corner_radii on disk are the stock cosmic-dark values so
    # they are deliberately not pinned here
    appearance.theme = {
      mode = "dark";
      dark = {
        accent = {
          __type = "optional";
          value = {
            red = 0.3882353;
            green = 0.8156863;
            blue = 0.8745098;
          };
        };
        bg_color = {
          __type = "optional";
          value = {
            red = 0.21568628;
            green = 0.16470589;
            blue = 0.16862744;
            alpha = 1.0;
          };
        };
        destructive = {
          __type = "optional";
          value = {
            red = 0.99215686;
            green = 0.6313726;
            blue = 0.627451;
          };
        };
        success = {
          __type = "optional";
          value = {
            red = 0.57254905;
            green = 0.8117647;
            blue = 0.6117647;
          };
        };
        warning = {
          __type = "optional";
          value = {
            red = 0.96862745;
            green = 0.8784314;
            blue = 0.38431373;
          };
        };
        neutral_tint = {
          __type = "optional";
          value = {
            red = 0.46666667;
            green = 0.46666667;
            blue = 0.46666667;
          };
        };
        text_tint = {
          __type = "optional";
          value = {
            red = 0.0;
            green = 0.0;
            blue = 0.0;
          };
        };
      };
    };

    # escape hatch for keys cosmic-manager has no dedicated options for
    configFile = {
      # window rendering settings from COSMIC Settings > Desktop > Appearance
      "com.system76.CosmicComp" = {
        version = 1;
        entries.appearance_settings = {
          clip_floating_windows = true;
          clip_tiled_windows = true;
          shadow_tiled_windows = false;
        };
      };
      # visual panel keys the panels submodule does not expose
      "com.system76.CosmicPanel.Panel" = {
        version = 1;
        entries = {
          padding = 0;
          spacing = 0;
          border_radius = 0;
        };
      };
      "com.system76.CosmicPanel.Dock" = {
        version = 1;
        entries = {
          padding = 4;
          spacing = 0;
          border_radius = 8;
        };
      };
    };

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
      {
        description = {
          __type = "optional";
          value = "Take a screenshot";
        };
        key = "Super+Y";
        action = {
          # same action as the default Print binding, which stays in place
          __type = "enum";
          variant = "System";
          value = [
            {
              __type = "enum";
              variant = "Screenshot";
            }
          ];
        };
      }
      {
        description = {
          __type = "optional";
          value = "Copy latest screenshot to clipboard";
        };
        key = "Super+Shift+Y";
        action = {
          __type = "enum";
          variant = "Spawn";
          value = [ "${copy-latest-screenshot}" ];
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
