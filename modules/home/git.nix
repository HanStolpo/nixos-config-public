{ pkgs, ... }: {
  imports = [ ./git-base.nix ];

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableSshSupport = true;
    grabKeyboardAndMouse = true;
  };

  programs.gpg.enable = true;

  programs.git = {
    signing = {
      key = "1814F5E3689A67C0!";
      signByDefault = true;
    };

    settings = {
      user.signingKey = "1814F5E3689A67C0!";
      commit = {
        gpgsign = true;
      };
    };
  };
}
