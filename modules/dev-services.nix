{ config, lib, pkgs, ... }:
with lib;
let cfg = config.hanstolpo.dev-services;
in
{
  options = with types; {
    hanstolpo.dev-services = {
      enable = mkOption {
        type = bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {

    networking.firewall.interfaces.virbr0.allowedTCPPorts = [ 139 445 ];
    networking.firewall.interfaces.virbr0.allowedUDPPorts = [ 137 138 ];
    services = {
      redis.servers."".enable = true;

      rabbitmq.enable = true;
      # rabbitmq.config = ''
      #   ## To listen on a specific interface, provide an IP address with port.
      #   ## For example, to listen only on localhost for both IPv4 and IPv6:
      #   ##
      #   IPv4
      #   listeners.tcp.local    = 127.0.0.1:5672
      #   IPv6
      #   listeners.tcp.local_v6 = ::1:5672

      #   ## Set the max permissible number of channels per connection.
      #   ## 0 means "no limit".
      #   ##
      #   channel_max = 128
      # '';
      rabbitmq.config = ''
        [
          {rabbit, [
              {tcp_listeners, [{"127.0.0.1", 5672},
                               {"::1",       5672}]},
              {channel_max, 0}
            ]
          }
        ].
      '';

      postgresql = {
        enable = true;
        package = pkgs.postgresql_15;
        dataDir = "/var/lib/postgresql/11";
        enableTCPIP = true;
        # still need to add login to roles
        # https://stackoverflow.com/questions/35254786/postgresql-role-is-not-permitted-to-log-in
        # pgcli -U postgres
        # alter role "circuithub" with login;
        # alter role "handre" with login;
        authentication = pkgs.lib.mkForce
          ''
            local   all             all                                     trust
            host    all             all             127.0.0.1/32            trust
            host    all             all             ::1/128                 trust
          '';
      };

      samba = {
        enable = true;
        configText = ''
          [global]
          map to guest = Bad User
          guest ok = true
          guest only = true
          [vagrant]
          path = /home/handre/temp
          force user = root

          read only = false
          create mask = 0644
          directory mask = 0755
          hosts allow = 192.168.122.30
        '';
      };
    };

  };

}
