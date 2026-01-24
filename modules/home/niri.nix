{ pkgs, inputs, ... }:
{
  stylix.targets.niri.enable = true;

  home.sessionVariables = {
  # Fix for some Java AWT applications (e.g. Android Studio),
  # use this if they aren't displayed properly:
  _JAVA_AWT_WM_NONREPARENTING = "1";

  # https://wiki.archlinux.org/title/firefox#Wayland
  MOZ_ENABLE_WAYLAND = "1";
  };

  # configure options
  programs.niri = {
    settings = {
      # Input configuration
      input = {
        workspace-auto-back-and-forth = true;

        warp-mouse-to-focus.enable = true;

        focus-follows-mouse = {
            enable = true;
            # never scroll the screen to have mouse follow focus
            max-scroll-amount="0%";
        };

        keyboard = {
          xkb = {
            #layout = "us";
            #variant = "intl";
            #model = "pc101";
          };
          numlock = true;
        };

        touchpad = {
          tap = true;
          natural-scroll = true;
          dwt = true;
        };

        mouse = {
          accel-profile = "flat";
        };

        trackpoint = { };
      };

      layer-rules = [
        {
          matches = [
            {namespace = "^noctalia-wallpaper*";}
          ];
          place-within-backdrop = true;
        }
      ];

      outputs = {
          "Dell Inc. DELL P2715Q V7WP955MA1XS" = {
           scale = 1.25;
          };

          "eDP-1" = {
            position = {x = 0; y = 0;};
          };
      };

      # Layout configuration
      layout = {
        gaps = 16;
        center-focused-column = "never";

        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
        ];

        default-column-width = { proportion = 0.5; };

        focus-ring = {
          enable = true;
          width = 5;
          active.color = "#00ffe8";
          inactive.color = "#a900ff";
        };

        border = {
          enable = false;
        };

        background-color = "transparent";

        #shadow = {
        #  enable = false;
        #  softness = 30;
        #  spread = 5;
        #  offset = {
        #    x = 0;
        #    y = 5;
        #  };
        #  #color = "#0007";
        #};
      };

      # Spawn at startup
      spawn-at-startup = [
        # { argv = ["slack"]; }
        # { argv = ["signal"]; }
        # { argv = ["dropbox"]; }
        # { argv = ["1password"]; }
      ];

      # Screenshot path
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      # Animations (all enabled by default)
      animations = { };

      # Window rules
      window-rules = [
        # Open WezTerm with empty default column width
        {
          matches = [{ app-id = "^org\\.wezfurlong\\.wezterm$"; }];
          default-column-width = { };
        }
        # Firefox Picture-in-Picture opens floating
        {
          matches = [
            {
              app-id = "^firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
        }
        # noctalia recommended
        {
          geometry-corner-radius =
            builtins.listToAttrs
              ( builtins.map
                  (n: {name = n; value = 10.0;})
                  [ "bottom-left"
                    "bottom-right"
                    "top-left"
                    "top-right"
                  ]
              );
          clip-to-geometry = true;
        }
        # chat programs go on chat workspace
        {
            matches = [
              { app-id = "^Slack$"; }
              { app-id = "^signal$"; }
            ];
            open-on-workspace = "chat";
            open-maximized = true;
        }
        # browser
        {
            matches = [
              { app-id = "^firefox$"; }
              { app-id = "^google-chrome$"; }
            ];
            open-on-workspace = "browser";
            open-maximized = true;
        }
      ];

      debug = {
        # Allows notification actions and window activation from Noctalia.
        honor-xdg-activation-with-invalid-serial = {};
      };

      overview = {
        workspace-shadow.enable = false;
      };

      prefer-no-csd = true;

      cursor = {
        hide-when-typing = true;
      };

      switch-events = {
        # Lock screen when lid closes (swayidle handles lock-before-suspend)
        lid-close.action.spawn = ["qs" "-c" "noctalia-shell" "ipc" "call" "lockScreen" "lock"];
      };

      workspaces = {
        chat = {
          open-on-output = "eDP-1";
        };
        dev1 = {
          open-on-output = "Dell Inc. DELL P2715Q V7WP955MA1XS";
        };
        browser = {
          open-on-output = "Dell Inc. DELL P2715Q V7WP955MA1XS";
        };
        dev2 = {
          open-on-output = "Dell Inc. DELL P2715Q V7WP955MA1XS";
        };
      };

     # Keybindings
      binds = {
        # Mod is Super (Logo key)
        # Show hotkey overlay
        "Mod+Shift+Slash".action.show-hotkey-overlay = { };

        # Spawn terminal
        "Mod+T".action.spawn = "alacritty";

        # Spawn application launcher
        "Mod+D" = {
          action.spawn-sh = "qs -c noctalia-shell ipc call launcher toggle";
          hotkey-overlay.title = "launcher";
        };

        # File manager
        "Mod+E".action.spawn = "nautilus";

        # Screen locking (using noctalia-shell)
        # swaylock-effects is configured as fallback in general.nix
        "Mod+Alt+L" = {
          action.spawn-sh = "qs -c noctalia-shell ipc call lockScreen lock";
          hotkey-overlay.title = "lock screen";
          # allow locking again if the lock screen crashes
          allow-when-locked = true;
        };

        # Suspend system (swayidle will lock before suspend via before-sleep event)
        # See: https://wiki.archlinux.org/title/Power_management#Suspend_and_hibernate
        "Mod+Alt+S" = {
          action.spawn = ["systemctl" "suspend"];
          hotkey-overlay.title = "suspend";
        };

        # Allow suspend from lock screen
        "XF86Sleep" = {
          action.spawn = ["systemctl" "suspend"];
          allow-when-locked = true;
        };

        # session menu
        "Mod+S" = {
          action.spawn-sh = "qs -c noctalia-shell ipc call sessionMenu toggle";
          hotkey-overlay.title = "session menu";
        };

        # actually with my current setup exiting niri is never a good idea, better just to reboot.
        # # Session exit
        # "Ctrl+Alt+Delete" = {
        #     # instead of `action.quit = {}`
        #     # otherwise we can exit when in the lock screen which
        #     # automatically logs back in circumventing the lock screen
        #     action.spawn-sh = "niri msg action quit";
        #     allow-when-locked = false;
        # };

        # Power off monitors
        "Mod+Shift+P".action.power-off-monitors = { };

        # Close window
        "Mod+Q" = { action.close-window = {  }; repeat = false;};

        # Open overview
        "Mod+O" = { action.toggle-overview = {  }; repeat = false;};

        # Focus navigation
        "Mod+Left".action.focus-column-left = { };
        "Mod+Down".action.focus-window-down = { };
        "Mod+Up".action.focus-window-up = { };
        "Mod+Right".action.focus-column-right = { };
        "Mod+H".action.focus-column-left = { };
        "Mod+J".action.focus-window-down = { };
        "Mod+K".action.focus-window-up = { };
        "Mod+L".action.focus-column-right = { };

        # Move window
        "Mod+Ctrl+Left".action.move-column-left = { };
        "Mod+Ctrl+Down".action.move-window-down = { };
        "Mod+Ctrl+Up".action.move-window-up = { };
        "Mod+Ctrl+Right".action.move-column-right = { };
        "Mod+Ctrl+H".action.move-column-left = { };
        "Mod+Ctrl+J".action.move-window-down = { };
        "Mod+Ctrl+K".action.move-window-up = { };
        "Mod+Ctrl+L".action.move-column-right = { };

        # Focus first/last column
        "Mod+Home".action.focus-column-first = { };
        "Mod+End".action.focus-column-last = { };
        "Mod+Ctrl+Home".action.move-column-to-first = { };
        "Mod+Ctrl+End".action.move-column-to-last = { };

        # Focus monitor
        "Mod+Shift+H".action.focus-monitor-left = { };
        "Mod+Shift+J".action.focus-monitor-down = { };
        "Mod+Shift+K".action.focus-monitor-up = { };
        "Mod+Shift+L".action.focus-monitor-right = { };

        # Move window to monitor
        "Mod+Ctrl+Shift+Left".action.move-column-to-monitor-left = { };
        "Mod+Ctrl+Shift+Down".action.move-column-to-monitor-down = { };
        "Mod+Ctrl+Shift+Up".action.move-column-to-monitor-up = { };
        "Mod+Ctrl+Shift+Right".action.move-column-to-monitor-right = { };
        "Mod+Ctrl+Shift+H".action.move-column-to-monitor-left = { };
        "Mod+Ctrl+Shift+J".action.move-column-to-monitor-down = { };
        "Mod+Ctrl+Shift+K".action.move-column-to-monitor-up = { };

        # Workspace navigation
        "Mod+Page_Down".action.focus-workspace-down = { };
        "Mod+Page_Up".action.focus-workspace-up = { };
        "Mod+U".action.focus-workspace-down = { };
        "Mod+I".action.focus-workspace-up = { };

        # Move to workspace
        "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = { };
        "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = { };
        "Mod+Ctrl+U".action.move-column-to-workspace-down = { };
        "Mod+Ctrl+I".action.move-column-to-workspace-up = { };

        # Move workspace itself
        "Mod+Shift+Page_Down".action.move-workspace-down = { };
        "Mod+Shift+Page_Up".action.move-workspace-up = { };
        "Mod+Shift+U".action.move-workspace-down = { };
        "Mod+Shift+I".action.move-workspace-up = { };
        #
        "Mod+Shift+Left".action.move-workspace-to-monitor-left = { };
        "Mod+Shift+Down".action.move-workspace-to-monitor-down = { };
        "Mod+Shift+Up".action.move-workspace-to-monitor-up = { };
        "Mod+Shift+Right".action.move-workspace-to-monitor-right = { };

        # Focus specific workspace
        "Mod+1".action.focus-workspace = "chat";
        "Mod+2".action.focus-workspace = "dev1";
        "Mod+3".action.focus-workspace = "browser";
        "Mod+4".action.focus-workspace = "dev2";
        # Same for other hand
        "Mod+7".action.focus-workspace = "chat";
        "Mod+8".action.focus-workspace = "dev1";
        "Mod+9".action.focus-workspace = "browser";
        "Mod+0".action.focus-workspace = "dev2";
        # Focus the previously focussed workspace
        "Mod+B".action.focus-workspace-previous = {};


        # # Move column to specific workspace
        # "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        # "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        # "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        # "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        # "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        # "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        # "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        # "Mod+Ctrl+8".action.move-column-to-workspace = 8;
        # "Mod+Ctrl+9".action.move-column-to-workspace = 9;

        # Consume/expel window from column
        "Mod+BracketLeft".action.consume-or-expel-window-left = { };
        "Mod+BracketRight".action.consume-or-expel-window-right = {};
        "Mod+Comma".action.consume-window-into-column = { };
        "Mod+Period".action.expel-window-from-column = { };

        # Center column
        "Mod+C".action.center-column = { };
        "Mod+Ctrl+C".action.center-visible-columns = { };

        # Column width adjustments
        "Mod+R".action.switch-preset-column-width = { };
        "Mod+Shift+R".action.switch-preset-window-height = { };
        "Mod+Ctrl+R".action.reset-window-height = { };
        "Mod+F".action.maximize-column = { };
        "Mod+Shift+F".action.fullscreen-window = { };
        "Mod+Ctrl+F".action.expand-column-to-available-width = { };

        # Resize with keyboard
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        # Floating windows
        "Mod+V".action.toggle-window-floating = { };
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = { };

        # Tab display mode
        "Mod+Shift+W".action.toggle-column-tabbed-display = { };

        # Screenshots
        "Print".action.screenshot = { };
        "Ctrl+Print".action.screenshot-window = { };
        "Alt+Print".action.screenshot-screen = { };
        # for when we don't have a print screen button kinesis mwave
        "Mod+Y".action.screenshot = { };
        "Mod+Ctrl+Y".action.screenshot-window = { };
        "Mod+Alt+Y".action.screenshot-screen = { };

        # Mouse wheel workspace navigation (with cooldown to prevent fast scrolling)
        "Mod+WheelScrollDown" = { action.focus-workspace-down = { }; cooldown-ms = 150; };
        "Mod+WheelScrollUp" = { action.focus-workspace-up = { }; cooldown-ms = 150; };
        "Mod+Ctrl+WheelScrollDown" = { action.move-column-to-workspace-down = { }; cooldown-ms = 150; };
        "Mod+Ctrl+WheelScrollUp" = { action.move-column-to-workspace-up = { }; cooldown-ms = 150; };

        # Mouse wheel column navigation
        "Mod+WheelScrollRight".action.focus-column-right = { };
        "Mod+WheelScrollLeft".action.focus-column-left = { };
        "Mod+Ctrl+WheelScrollRight".action.move-column-right = { };
        "Mod+Ctrl+WheelScrollLeft".action.move-column-left = { };

        # Shift+wheel for horizontal scrolling (like in most apps)
        "Mod+Shift+WheelScrollDown".action.focus-column-right = { };
        "Mod+Shift+WheelScrollUp".action.focus-column-left = { };
        "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = { };
        "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = { };

        # Toggle keyboard shortcuts inhibit (escape hatch for remote desktop etc)
        "Mod+Escape" = {
          action.toggle-keyboard-shortcuts-inhibit = { };
          allow-inhibiting = false;
        };


        # Media controls (allow-when-locked for use while screen is locked)
        "XF86AudioRaiseVolume" = {
          action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" ];
          allow-when-locked = true;
        };
        "XF86AudioLowerVolume" = {
          action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-" ];
          allow-when-locked = true;
        };
        "XF86AudioMute" = {
          action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
          allow-when-locked = true;
        };
        "XF86AudioMicMute" = {
          action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];
          allow-when-locked = true;
        };

        # Brightness controls
        "XF86MonBrightnessUp" = {
          action.spawn = [ "brightnessctl" "--class=backlight" "set" "+10%" ];
          allow-when-locked = true;
        };
        "XF86MonBrightnessDown" = {
          action.spawn = [ "brightnessctl" "--class=backlight" "set" "10%-" ];
          allow-when-locked = true;
        };
      };
    };
  };
}
