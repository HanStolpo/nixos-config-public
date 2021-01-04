{ pkgs, ... }: {
  boot.isContainer = true;

  # Network configuration.
  networking.useDHCP = false;
  networking.firewall.allowedTCPPorts = [ 80 ];

  # Enable a web server.
  services.httpd = {
    enable = true;
    adminAddr = "morty@example.org";
  };

  hanstolpo = {
    shell.enable = true;
    terminal.enable = true;
    users.enable = true;
    desktop.enable = true;
  };
}
