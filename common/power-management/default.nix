{ config, pkgs, ... }:
{
  imports = [ ./suspend-prevent ];

  environment.systemPackages = with pkgs; [
    powerstat # Laptop power measuring tool
    powertop # Analyze power consumption on Intel-based laptops
  ];

  services = {
    suspend-prevent.enable = true;
    upower.enable = true;
    acpid.enable = false;
  };
  powerManagement.enable = true;

  # suspend after idel seconds
  # https://bbs.archlinux.org/viewtopic.php?id=208091
  services.logind.extraConfig =
    ''
      IdleAction=suspend
      IdleActionSec=1200
    '';
}
