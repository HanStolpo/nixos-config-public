# Terminal-only home-manager configuration: shells, prompt, history, direnv.
# Safe to use on a headless / remotely accessed machine; the desktop bits live
# in general.nix which imports this.
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
    programs.starship = {
      enable = true;
      # Same file modules/shell.nix points STARSHIP_CONFIG at on NixOS hosts,
      # so standalone (remote) and NixOS hosts get the identical two-line prompt.
      settings = builtins.fromTOML (builtins.readFile ../shell/starship.toml);
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
}
