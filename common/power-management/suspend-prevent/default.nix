# prevent suspend on lid close on AC power
# https://nrocco.github.io/2014/06/05/suspend-prevent-systemd.html
{config, lib, pkgs,...}:
  with lib; with pkgs;
let
  suspend-prevent-udev = writeTextFile {
    name = "suspend-preven-udev";
    text = ''
      SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${suspend-prevent}/bin/suspend-prevent battery"
      SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${suspend-prevent}/bin/suspend-prevent ac"
      '';
      executable = false;
      destination = "/etc/udev/rules.d/95-suspend-prevent.rules";
  };
  suspend-prevent = with pkgs; writeScriptBin "suspend-prevent"
  ''
  #!/bin/sh

  SYSTEMCTL=${systemd}/bin/systemctl

  case "$1" in
      battery)
          echo 'Running on battery. Making sure to remove the inhibit lock'
          $SYSTEMCTL stop suspend-prevent.service
          ;;

      ac)
          echo 'Running on AC. Making sure to add the inhibit lock'
          $SYSTEMCTL start suspend-prevent.service
          ;;

      -h|--help|help)
          echo "Usage: $(basename $0) [battery|ac|--forever]"
          exit 1
          ;;

      --forever)
          ${systemd}/bin/systemd-inhibit --what=handle-lid-switch --who=$(id -un $(whoami)) --why="Prevent suspend on lid close when on AC" --mode=block ${bash}/bin/bash -c "while true; do ${coreutils}/bin/sleep 60; done"
          ;;

      *)
          echo 'Automatically detecting power source...'

          if ${coreutils}/bin/cat /sys/class/power_supply/AC0/online | ${coreutils}/bin/grep 0 > /dev/null 2>&1
          then
              $0 battery
          else
              $0 ac
          fi

          exit $?
          ;;
  esac

  exit 0
  '';

  cfg = config.services.suspend-prevent;
in
rec {

  options.services.suspend-prevent = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description =''
        If enabled install the script suspend-prevent and the service
        suspend-prevent.service as well as udev rules enable the rules
        on ac power. suspend-prevent stops suspend when laptop lid is closed.
        '';
    };
  };

  config = {
    environment.systemPackages = mkIf cfg.enable  [
       suspend-prevent
    ];

    systemd.services.suspend-prevent = mkIf cfg.enable {
      enable = true;
      description = "Prevent suspend on lid close when on AC";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${suspend-prevent}/bin/suspend-prevent --forever";
        ExecStop = "${procps}/bin/pkill suspend-prevent";
      };
    };

    # Allos suspend-prevent service to be run by normal users
    # phttps://wiki.archlinux.org/index.php/Polkit#Allow_management_of_individual_systemd_units_by_regular_users
    security.polkit.extraConfig = mkIf cfg.enable
    ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units") {
            if (action.lookup("unit") == "suspend-prevent.service") {
                var verb = action.lookup("verb");
                if (verb == "start" || verb == "stop" || verb == "restart") {
                    return polkit.Result.YES;
                }
            }
        }
    });
    '';
    services.udev.packages = mkIf cfg.enable [ suspend-prevent-udev ];
    # services.udev.extraRules = mkIf cfg.enable
    # ''
    # SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="/usr/local/bin/suspend-prevent battery"
    # SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="/usr/local/bin/suspend-prevent ac"
    # '';
  };

}
