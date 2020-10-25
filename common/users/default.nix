{ config, pkgs, ... }:
{
  # Define a user account.
  # Don't forget to set a password with ‘passwd’.
  users.extraUsers.handre = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/handre";
    extraGroups = [
      "user"
      "wheel"
      "audio"
      "video"
      "networkmanager"
      "postgres"
      "vboxusers"
      #scanner printer groups
      "lp"
      "scanner"
      "docker"
      "libvirtd"
      "plugdev"
    ];
    initialPassword = "handre";
    shell = "${pkgs.zsh}/bin/zsh";
  };
  users.defaultUserShell = "${pkgs.zsh}/bin/zsh";
  environment.shells = [ "${pkgs.zsh}/bin/zsh" ];
  programs.zsh.enable = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  #security.sudo.extraRules = [
  #{
  #users = [ "handre" ];
  #commands =
  #[
  #{
  #command = "/run/current-system/sw/bin/mount.cifs";
  #}
  #];
  #}
  #];
}
