# general home-manager configuration not moved out into
{ pkgs, ... }: {

    programs.bash.enable = true;
    programs.bash.initExtra = ''
      eval "$(direnv hook bash)"
    '';

    programs.atuin = {
      enable = true;
      settings = {
      };
    };
    programs.starship.enable = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    services.gnome-keyring.enable = true;

    programs.alacritty.enable = true;

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
    };

    gtk = {
      enable = true;
      gtk2.enable = true;
      gtk3.enable = true;

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "lavender";
        };
      };
    };

    qt = {
      enable = true;
    };
}
