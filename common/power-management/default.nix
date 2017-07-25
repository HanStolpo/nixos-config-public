{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
     powerstat # Laptop power measuring tool
     powertop # Analyze power consumption on Intel-based laptops
  ];

  services = {
    upower.enable = false;
    acpid.enable = false;
  };
  powerManagement.enable = true;
}
