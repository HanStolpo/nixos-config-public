{ config, pkgs, ... }:
{
  services = {
    chrony.enable = false;
    ntp.enable = false;
    openntpd.enable = false;
    timesyncd.enable = true;
    timesyncd.servers =
    [ "0.pool.ntp.org" "1.pool.ntp.org"
      "za.pool.ntp.org"
      "0.nixos.pool.ntp.org" "1.nixos.pool.ntp.org" "2.nixos.pool.ntp.org" "3.nixos.pool.ntp.org" # default ones
      "131.107.13.100" # time-nw.nist.gov - static one to get around DNS broken on startup
    ];
  };
}
