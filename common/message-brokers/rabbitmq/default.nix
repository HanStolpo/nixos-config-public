{ config, pkgs, ... }:
{
  services = {
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
  };
}

