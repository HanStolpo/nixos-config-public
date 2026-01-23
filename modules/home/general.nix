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

    programs.neovide.enable = true;

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

    # MIME type associations
    #
    # To find available .desktop file names on your system:
    # System-wide packages
    # ls /run/current-system/sw/share/applications

    # # User packages
    # ls ~/.nix-profile/share/applications

    # You can also check what MIME type a file has with:
    # xdg-mime query filetype /path/to/file

    # The configuration creates/manages ~/.config/mimeapps.list which the XDG system uses to determine default applications.
    # See: https://wiki.nixos.org/wiki/Default_applications
    # See: https://mynixos.com/home-manager/option/xdg.mimeApps.defaultApplications
    # See: https://github.com/nix-community/home-manager/blob/master/modules/misc/xdg-mime-apps.nix
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        # Images
        "image/png"  = "imv.desktop";
        "image/jpeg" = "imv.desktop";
        "image/gif"  = "imv.desktop";
        "image/webp" = "imv.desktop";
        "image/bmp"  = "imv.desktop";
        "image/tiff" = "imv.desktop";
        "image/svg+xml" = "imv.desktop";

        # PDF files
        "application/pdf" = "org.gnome.Evince.desktop";

        # Web browser associations
        "text/html"              = "firefox.desktop";
        "x-scheme-handler/http"  = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";

        # Text files
        "text/plain" = "neovide.desktop";
      };
      associations.removed = {
        "image/png"     = ["google-chrome.desktop" "gimp.desktop"];
        "image/jpeg"    = ["google-chrome.desktop" "gimp.desktop"];
        "image/gif"     = ["google-chrome.desktop" "gimp.desktop"];
        "image/webp"    = ["google-chrome.desktop" "gimp.desktop"];
        "image/bmp"     = ["google-chrome.desktop" "gimp.desktop"];
        "image/tiff"    = ["google-chrome.desktop" "gimp.desktop"];
        "image/svg+xml" = ["google-chrome.desktop" "gimp.desktop"];
      };
    };

    # Custom desktop entries
    # Creates .desktop files in ~/.local/share/applications/
    xdg.desktopEntries = {
      firefox-profile-selector = {
        name = "Firefox Profile Selector";
        genericName = "Web Browser";
        exec = "firefox --ProfileManager";
        icon = "firefox";
        terminal = false;
        categories = [ "Network" "WebBrowser" ];
        comment = "Launch Firefox with profile selector";
      };
    };
}
