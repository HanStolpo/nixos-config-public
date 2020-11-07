{ config, pkgs, ... }:
let
  pgcli_custom =
    (
      import
        (
          pkgs.fetchFromGitHub
            {
              owner = "NixOS";
              repo = "nixpkgs";
              rev = "6018464c49dc60b1779f10a714974dcb4eb21c30";
              sha256 = "1fq9zarsanislnsn9vrn4k852qk1ygckxqdzf1iywgsbp2a5hkn1";
            }
        )
        { }
    ).pythonPackages.pgcli;
in
{
  environment.systemPackages =
    with pkgs;
    [
      pgcli
      postgresql
    ];

  services = {

    postgresql = {
      enable = true;
      package = pkgs.postgresql_11;
      dataDir = "/var/lib/postgresql/11";
      enableTCPIP = true;
      # still need to add login to roles
      # https://stackoverflow.com/questions/35254786/postgresql-role-is-not-permitted-to-log-in
      # pgcli -U postgres
      # alter role "circuithub" with login;
      # alter role "handre" with login;
      ensureUsers = [
        {
          name = "handre";
          ensurePermissions = {
            "all tables in schema public" = "all privileges";
          };
        }
      ];
      authentication = pkgs.lib.mkForce
        ''
          local   all             all                                     trust
          host    all             all             127.0.0.1/32            trust
          host    all             all             ::1/128                 trust
        '';
    };

  };
}
