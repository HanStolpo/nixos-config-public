{ config, pkgs, ... }:
{

  services.physlock.enable = false;
  #services.physlock.user = "handre";
  services.physlock.lockOn.hibernate = false;
  services.physlock.lockOn.suspend = true;
  #services.physlock.lockOn.extraTargets = ["post-resume.target"];

}
