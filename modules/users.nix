{ config, lib, pkgs, ... }:

with lib;
let

  cfg = config.hanstolpo.users;
in
{
  options = {
    hanstolpo.users = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      useInitialPWD = mkOption {
        type = types.bool;
        default = true;
      };
      SSHLogin = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable (
    mkMerge
      [
        {
          # Define a user account.
          # Don't forget to set a password with ‘passwd’.
          users.users.handre =
            {
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
                "qemu-libvirtd"
                "kvm"
                "plugdev"
                "input"
                "uinput"
                "docker"
                "pipewire"
                "usbmux"
                "disk"
              ];
              #shell = "${pkgs.zsh}/bin/fish";
            };

          security.sudo = {
            enable = true;
            wheelNeedsPassword = true;
          };
        }
        (mkIf cfg.useInitialPWD {
          users.users.handre.initialPassword = "handre";
        })
        (mkIf cfg.SSHLogin {
          users.users.handre = {
            openssh.authorizedKeys.keys =
              [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFRpVBxuUK1Wf0v5uEc5LDIsUpxkC1j21GHYbC1ilWyH86be3KrD+jFo72lPP70CAzmMhp8djIwuKiqgQUbGN2Phore3+hlVeYPokejojTsehfJ1NAiHruii9h/rWII3Tm/00twkZUcGX2kk5/winle1SqCrFSIXF8zgDgPjD2gRWe9ThH5gDzLXQjBB++aubxlOZXAnRsoOO7kq+w5jLaZoSp8dNvMdE/ySspYL/Elmczx85McNUJCrkVGjfX0U8EZxF7OPsf+yc8vcAe2cBptB7YaWKPpIbse/osu5pCwTtrmYGBonOJ9J/ow5tT9WJePUGCCFfmtTWmTWIlTahF HanStolpo@gmail.com" ];
          };
        })
      ]);
}
