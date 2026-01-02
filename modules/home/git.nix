{ pkgs, ... }: {
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-tty;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableSshSupport = true;
    grabKeyboardAndMouse = true;
  };

  programs.gpg.enable = true;

  programs.git = {
    enable = true;

    signing = {
      key = "1814F5E3689A67C0!";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Handré Stolp";
        email = "HanStolpo@gmail.com";
        signingKey = "1814F5E3689A67C0!";
      };
      commit = {
        gpgsign = true;
      };
      core = {
        excludesFile = "~/.gitignore";
      };
    };
  };
}
