# NordVPN daemon + CLI, replacing the previously used
# github:connerohnesorge/nordvpn-flake; the package itself is built from the
# official deb in overlays/nordvpn (copied from the local nordvpn-mesh-node
# flake) so it is easy to keep the client version up to date locally.
{ config, lib, pkgs, ... }:
let
  cfg = config.services.nordvpn;
  nordvpnPkg = pkgs.nordvpn;
in
{
  options.services.nordvpn = {
    enable = lib.mkEnableOption "NordVPN service";

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Users added to the nordvpn group so they can talk to the daemon
        socket at /run/nordvpn/nordvpnd.sock without root.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Add NordVPN package to system packages
    environment.systemPackages = [ nordvpnPkg ];

    # The daemon runs as root (it manages wireguard/tun interfaces,
    # iptables and routing via netlink -- a plain system user cannot).
    # The nordvpn group exists so unprivileged users can talk to the
    # CLI socket at /run/nordvpn/nordvpnd.sock (mode 0750 runtime dir).
    users.groups.nordvpn.members = cfg.users;

    # Meshnet needs relaxed reverse-path filtering for nordlynx
    # return traffic, and the nordlynx interface trusted so mesh
    # traffic isn't dropped. Inbound UDP 51820 is optional but helps
    # direct WireGuard paths establish.
    networking.firewall = {
      checkReversePath = false;
      trustedInterfaces = [ "nordlynx" ];
      allowedUDPPorts = [ 51820 ];
    };

    # Belt-and-braces: nordlynx is kernel WireGuard, tun is used for
    # OpenVPN mode / userspace fallback.
    boot.kernelModules = [ "wireguard" "tun" ];

    # The daemon hardcodes /usr/lib/nordvpn as the directory it
    # spawns its helpers (norduserd, nordfileshare, openvpn) from;
    # that path doesn't exist on NixOS, so link it to the package.
    systemd.tmpfiles.rules = [
      "L+ /usr/lib/nordvpn - - - - ${nordvpnPkg}/lib/nordvpn"
    ];

    # Define the systemd service for nordvpnd, mirroring the official
    # unit shipped in the deb (root + Group=nordvpn, NonBlocking,
    # KillMode=process, RuntimeDirectory=nordvpn mode 0750).
    systemd.services.nordvpnd = {
      description = "NordVPN Daemon";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      # Prepended to the NixOS default service PATH (coreutils,
      # findutils, grep, sed, systemd, ...), so ExecStartPre keeps
      # mkdir/ls/cp while the daemon still finds iptables/ip/ps.
      path = [ pkgs.iptables pkgs.iproute2 pkgs.procps ];
      serviceConfig = {
        ExecStart = "${nordvpnPkg}/bin/nordvpnd";
        # Seed /var/lib/nordvpn from the package on first start
        ExecStartPre = pkgs.writeShellScript "nordvpnd-prestart" ''
          mkdir -m 700 -p /var/lib/nordvpn
          if [ -z "$(ls -A /var/lib/nordvpn)" ] && [ -d ${nordvpnPkg}/var/lib/nordvpn ]; then
            cp -r ${nordvpnPkg}/var/lib/nordvpn/* /var/lib/nordvpn
          fi
        '';
        NonBlocking = true;
        KillMode = "process";
        Restart = "on-failure";
        RestartSec = 5;
        RuntimeDirectory = "nordvpn";
        RuntimeDirectoryMode = "0750";
        Group = "nordvpn";
      };
    };
  };
}
