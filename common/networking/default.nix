{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs;[
    dnsutils # gives nslookup and dig (and dns server enabled through services.bind.enable)
    autossh # keep ssh tunnels open
    arp-scan
    ssvnc
  ];
  networking = {
    # networkmanager = {
    #   enable = true;
    #   dns = true;
    #   insertNameservers = ["8.8.8.8" "8.8.8.4"];
    # };
    #nameservers = ["192.168.100.1" "8.8.8.8" "8.8.8.4" "192.168.1.1"];
    nameservers = ["127.0.0.1" "8.8.8.8" "192.168.100.1"];
    extraHosts =
      ''
        127.0.0.1 circuithub.test
        127.0.0.1 projects.circuithub.test
        127.0.0.1 api.circuithub.test
        127.0.0.1 reactor.circuithub.test
        127.0.0.1 rob-o-vm.picofactory
      '';
  };
  #enableIPv6 = false;
  #dnsSingleRequest = true;
  services.dnsmasq = {
    enable = true;
    servers = ["8.8.8.8" "8.8.8.4" "192.168.1.1" "192.168.100.1"];
    extraConfig = ''
      server=/picofactory/192.168.100.1
    '';
  };
}
