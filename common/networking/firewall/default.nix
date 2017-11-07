{ config, pkgs, ... }:
{
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
          #NFS ?
          80
          #samba
          445 139
          # google chat / hanouts http://mikedikson.com/2013/01/google-talk-firewall-ports
          443
          5269 # XMPP federation
          9001 # wassembly TPSPOOl redirect port
          53 # DNS
          19000 # used by expo client app on local network to get code
          19001 # used by expo client app on local network to get code
    ];
    allowedUDPPorts = [
          # NFS ?
          5353
          #samba
          137 138
          53 # DNS
    ];
    allowedTCPPortRanges = [
          # google chat / hanouts http://mikedikson.com/2013/01/google-talk-firewall-ports
          {from = 19302; to = 19309;}
          {from = 5222; to = 5224;} # XMPP xlient
    ];
    allowedUDPPortRanges = [
          # google chat / hanouts http://mikedikson.com/2013/01/google-talk-firewall-ports
          {from = 19302; to = 19309;}
    ];
  };
}
