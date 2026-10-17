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
      settings = {
        format = "$directory$git_branch$git_status$nix_shell$character";

        directory = {
          truncation_length = 5;
          truncate_to_repo = false;
        };

        git_branch = {
          format = "[$symbol$branch]($style) ";
        };

        git_status = {
          format = "([$all_status$ahead_behind]($style) )";
        };

        nix_shell = {
          format = "[$symbol$state( \\($name\\))]($style) ";
        };

        # Disable language version modules
        nodejs.disabled = true;
        python.disabled = true;
        rust.disabled = true;
        golang.disabled = true;
        java.disabled = true;
        ruby.disabled = true;
        php.disabled = true;
        dotnet.disabled = true;
        elixir.disabled = true;
        elm.disabled = true;
        erlang.disabled = true;
        haskell.disabled = true;
        julia.disabled = true;
        kotlin.disabled = true;
        lua.disabled = true;
        nim.disabled = true;
        ocaml.disabled = true;
        perl.disabled = true;
        scala.disabled = true;
        swift.disabled = true;
        zig.disabled = true;
        c.disabled = true;
      };
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
}
