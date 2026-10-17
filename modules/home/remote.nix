# Home-manager profile for a terminal-only, remotely accessed machine that is
# not NixOS (e.g. a cloud dev box where nix is installed for an unprivileged
# user). Pulls in the terminal pieces of this configuration and replaces the
# few things the NixOS modules (shell.nix, terminal.nix) normally provide at
# the system level.
#
# Expected to be used through `lib.mkRemoteHome` in flake.nix, or imported as
# `homeManagerModules.remote` with home.username / home.homeDirectory set by
# the consumer.
{ config, lib, pkgs, ... }:
let
  cfg = config.hanstolpo.remote;
in
{
  imports = [
    ./terminal.nix
    ./fish.nix
    ./nvim.nix
    ./git-base.nix
  ];

  options.hanstolpo.remote = {
    manageNix = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Write a user-level nix.conf (~/.config/nix/nix.conf) that enables
        flakes and let home-manager provide the nix package. Leave off when
        the machine already has nix configured.
      '';
    };

    execFish = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Without privileges the login shell cannot be changed with chsh, so
        make interactive bash sessions hand over to fish instead.
      '';
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional packages to install in the remote profile.";
    };
  };

  config = {
    # on non-NixOS: fix up XDG dirs, source the nix profile, etc.
    targets.genericLinux.enable = true;

    nix = lib.mkIf cfg.manageNix {
      package = pkgs.nix;
      settings.experimental-features = [ "nix-command" "flakes" ];
    };

    # cut the big plugins and runtime tools
    hanstolpo.nvim.minimal = lib.mkDefault true;

    home.sessionVariables = {
      EDITOR = "nvim";
      # neovim probes the terminal for speed at startup and warns when the
      # link is slow; the ssh round trip always trips it, so skip the probe
      NVIM_NOTTYFAST = "1";
    };

    # what modules/shell.nix does at the NixOS level
    programs.fish.interactiveShellInit = lib.mkAfter ''
      function fish_user_key_bindings
        # emacs bindings in insert mode, vi bindings take precedence on conflict
        fish_default_key_bindings -M insert
        fish_vi_key_bindings --no-erase insert
      end
    '';

    programs.bash.initExtra = lib.mkIf cfg.execFish (lib.mkAfter ''
      # hand interactive sessions over to fish (login shell cannot be changed
      # without privileges); skipped for `bash -c ...` and when already in fish
      if [[ $- == *i* && -z "$IN_FISH" && -z "$BASH_EXECUTION_STRING" ]]; then
        IN_FISH=1 exec ${pkgs.fish}/bin/fish
      fi
    '');

    # tmux: the settings from dotfiles/tmux.conf plus OSC 52 passthrough so a
    # yank in neovim inside tmux still reaches the local terminal's clipboard
    programs.tmux = {
      enable = true;
      mouse = true;
      keyMode = "vi";
      terminal = "tmux-256color";
      escapeTime = 10;
      focusEvents = true;
      extraConfig = ''
        # Let applications write the clipboard via OSC 52, and pass the
        # escape sequence through to the outer terminal.
        set -s set-clipboard on
        set -g allow-passthrough on

        # https://blog.testdouble.com/posts/2016-11-18-reconciling-tmux-and-ssh-agent-forwarding/
        # Remove SSH_AUTH_SOCK so tmux does not reset it to the stale socket of
        # the ssh connection that originally started the session; the symlink
        # is refreshed on every login by ~/.ssh/rc.
        set -g update-environment "DISPLAY SSH_ASKPASS SSH_AGENT_PID SSH_CONNECTION WINDOWID XAUTHORITY"
        setenv -g SSH_AUTH_SOCK $HOME/.ssh/ssh_auth_sock
      '';
    };

    # Keep ~/.ssh/ssh_auth_sock pointing at the current forwarded agent socket
    # (see the tmux config above).
    home.file.".ssh/rc" = {
      executable = true;
      text = ''
        #!/bin/sh
        if test "$SSH_AUTH_SOCK"; then
          ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
        fi
      '';
    };

    # the subset of modules/terminal.nix and shell.nix that makes sense remotely
    home.packages = with pkgs; [
      ripgrep
      fd
      fzf
      bat
      htop
      btop
      jq
      tree
      file
      unzip
      gh
      git-branchless
      watchexec
      tealdeer
      httpie
      xan
      moreutils
      nix-your-shell
      wtp
      silver-searcher  # ag, used by ack-vim
    ] ++ cfg.extraPackages;
  };
}
