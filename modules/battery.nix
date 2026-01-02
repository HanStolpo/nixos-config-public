{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hanstolpo.battery-management;
in
{
  options = {
    hanstolpo.battery-management = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable battery-based power profile and brightness management for noctalia";
      };

      batteryDevice = mkOption {
        type = types.str;
        default = "BAT0";
        description = "The battery device name in /sys/class/power_supply/";
      };

      lowBatteryThreshold = mkOption {
        type = types.int;
        default = 25;
        description = "Battery percentage threshold for switching to power save mode";
      };

      onBattery = {
        powerProfile = mkOption {
          type = types.str;
          default = "balanced";
          description = "Power profile to use when on battery";
        };

        brightnessPercent = mkOption {
          type = types.int;
          default = 75;
          description = "Screen brightness percentage when on battery";
        };
      };

      onAC = {
        powerProfile = mkOption {
          type = types.str;
          default = "performance";
          description = "Power profile to use when on AC power";
        };

        brightnessPercent = mkOption {
          type = types.int;
          default = 100;
          description = "Screen brightness percentage when on AC power";
        };
      };

      lowBattery = {
        powerProfile = mkOption {
          type = types.str;
          default = "save";
          description = "Power profile to use when battery is low";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    # udev rule to trigger power profile switching on AC power change
    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ACTION=="change", TAG+="systemd", ENV{SYSTEMD_WANTS}="battery-power-profile.service"
    '';

    # Battery-based power profile switching for noctalia
    systemd.services.battery-power-profile = {
      description = "Set noctalia power profile based on battery state";
      script = ''
        status=$(cat /sys/class/power_supply/${cfg.batteryDevice}/status)
        echo "battery status changed to $status"

        # Find the active graphical session user
        session=$(loginctl list-sessions --no-legend | awk 'NR==1 {print $1}')
        if [ -z "$session" ]; then
          echo "No active session found"
          exit 0
        fi
        user=$(loginctl show-session "$session" -p Name --value)
        uid=$(loginctl show-session "$session" -p User --value)

        export HOME="/home/$user"
        export XDG_RUNTIME_DIR="/run/user/$uid"
        export XDG_CONFIG_HOME="/home/$user/.config"

        echo "Running as user $user (uid $uid)"

        case "$status" in
          Discharging)
            echo "setting power profile to ${cfg.onBattery.powerProfile}"
            runuser -u "$user" -- ${pkgs.quickshell}/bin/qs -c noctalia-shell ipc call powerProfile set "${cfg.onBattery.powerProfile}"
            echo "setting brightness to ${toString cfg.onBattery.brightnessPercent}%"
            brightnessctl --class=backlight set ${toString cfg.onBattery.brightnessPercent}%
            ;;
          Charging|Full|"Not charging")
            echo "setting power profile to ${cfg.onAC.powerProfile}"
            runuser -u "$user" -- ${pkgs.quickshell}/bin/qs -c noctalia-shell ipc call powerProfile set "${cfg.onAC.powerProfile}"
            echo "setting brightness to ${toString cfg.onAC.brightnessPercent}%"
            brightnessctl --class=backlight set ${toString cfg.onAC.brightnessPercent}%
            # Clear low battery flag when AC is connected
            rm -f /run/battery-low-power-triggered
            ;;
        esac
      '';
      path = [ pkgs.util-linux pkgs.systemd pkgs.gawk pkgs.brightnessctl ];
      serviceConfig.Type = "oneshot";
    };

    # Low battery power saving - triggered by timer, only once per discharge cycle
    systemd.services.battery-low-check = {
      description = "Check for low battery and switch to power save mode";
      script = ''
        status=$(cat /sys/class/power_supply/${cfg.batteryDevice}/status)
        capacity=$(cat /sys/class/power_supply/${cfg.batteryDevice}/capacity)

        # Only act if discharging and below threshold
        if [ "$status" != "Discharging" ]; then
          exit 0
        fi

        if [ "$capacity" -ge ${toString cfg.lowBatteryThreshold} ]; then
          exit 0
        fi

        # Check if already triggered this discharge cycle
        if [ -f /run/battery-low-power-triggered ]; then
          exit 0
        fi

        echo "Battery at $capacity% - switching to power save mode"

        # Find the active session user
        session=$(loginctl list-sessions --no-legend | awk 'NR==1 {print $1}')
        if [ -z "$session" ]; then
          echo "No active session found"
          exit 0
        fi
        user=$(loginctl show-session "$session" -p Name --value)
        uid=$(loginctl show-session "$session" -p User --value)

        export HOME="/home/$user"
        export XDG_RUNTIME_DIR="/run/user/$uid"
        export XDG_CONFIG_HOME="/home/$user/.config"

        runuser -u "$user" -- ${pkgs.quickshell}/bin/qs -c noctalia-shell ipc call powerProfile set "${cfg.lowBattery.powerProfile}"

        # Mark as triggered so we don't keep setting it
        touch /run/battery-low-power-triggered
      '';
      path = [ pkgs.util-linux pkgs.systemd pkgs.gawk ];
      serviceConfig.Type = "oneshot";
    };

    systemd.timers.battery-low-check = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2min";
        OnUnitActiveSec = "2min";
      };
    };
  };
}
