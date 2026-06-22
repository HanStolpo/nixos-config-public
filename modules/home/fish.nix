{ pkgs, ... }: {

  programs.fish = {
    enable = true;

    # Plugins (fisher, base16-fish, fzf)
    plugins = [
      {
        name = "fisher";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "fisher";
          rev = "4.4.4";
          sha256 = "sha256-e8gIaVbuUzTwKtuMPNXBT5STeddYqQegduWBtURLT3M=";
        };
      }
      {
        name = "base16-fish";
        src = pkgs.fetchFromGitHub {
          owner = "tomyun";
          repo = "base16-fish";
          rev = "2f6dd97";
          sha256 = "sha256-PebymhVYbL8trDVVXxCvZgc0S5VxI7I1Hv4RMSquTpA=";
        };
      }
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "fzf";
          rev = "24f4739fc1dffafcc0da3ccfbbd14d9c7d79c7f6";
          sha256 = "sha256-0rnd8oJzLw8x/U7OLqoOMQpK81gRc7DTxZRSHxN9YlM=";
        };
      }
    ];

    # Custom functions
    functions = {
      # ch-just-complete = {
      #   description = "Load just completions when CH_ROOT is set";
      #   onVariable = "CH_ROOT PATH";
      #   body = ''
      #     if test -n "$CH_ROOT" && which just 2>/dev/null 1>/dev/null
      #       echo >&2 "loading just completions"
      #       just --completions fish | source
      #     end
      #   '';
      # };
    };

    interactiveShellInit = ''
      # nix-your-shell integration
      if command -q nix-your-shell
        nix-your-shell fish | source
      end

      # atuin integration
      if command -q atuin
        atuin init fish | source
      end

      # wtp (git worktree management) shell integration
      if command -q wtp
        wtp shell-init fish | source
      end

      # Load base16 theme if set
      # Export base16_theme so child processes (like neovim) can see it
      # Universal variables are not automatically exported to child processes
      if set -q base16_theme
        set -gx base16_theme $base16_theme
        base16-$base16_theme
      end

      # FZF configuration
      set -q FZF_TMUX_HEIGHT; or set -U FZF_TMUX_HEIGHT "40%"
      set -q FZF_DEFAULT_OPTS; or set -U FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT"
      set -q FZF_LEGACY_KEYBINDINGS; or set -U FZF_LEGACY_KEYBINDINGS 1
      set -q FZF_DISABLE_KEYBINDINGS; or set -U FZF_DISABLE_KEYBINDINGS 0
      set -q FZF_PREVIEW_FILE_CMD; or set -U FZF_PREVIEW_FILE_CMD "head -n 10"
      set -q FZF_PREVIEW_DIR_CMD; or set -U FZF_PREVIEW_DIR_CMD "ls"
    '';
  };

  programs.starship.enableFishIntegration = true;
}
