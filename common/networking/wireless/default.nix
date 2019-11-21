{ config, pkgs, ... }:
{
  networking.wireless =
    {
      enable = true; # Enables wireless support via wpa_supplicant.
      userControlled.enable = true;
      # networkd seems to give some errors and useNetworkd has this warning 'Whether we should use networkd as the network configuration backend or the legacy script based system. Note that this option is experimental, enable at your own risk.'
      # useNetworkd = true;
    };
  # commented out due to above comment
  # systemd.network.enable = true;
}
