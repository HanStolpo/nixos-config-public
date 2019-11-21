{ config, pkgs, ... }:
let
  chShellInit = ''
    export CH_SHELL_DEV=true
    export CH_SHELL_WRAP_ELM_FORMAT=true
  '';
  base16Shell = pkgs.fetchFromGitHub {
    owner = "chriskempson";
    repo = "base16-shell";
    rev = "cd19a7bc5c57e5dccc95f1493a2a0ff3b15f4499";
    sha256 = "01rc78c0fng3p2lray5hz23n8irgcvmq7s5d7mwl9pb8ajclhfw2";
  };
  base16ShellInit = ''
    # Base16 Shell
    BASE16_SHELL="${base16Shell}/"
    [ -n "$PS1" ] && \
        [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
            eval "$("$BASE16_SHELL/profile_helper.sh")"

    # dispaly UTF-8 in less
    export LESSCHARSET=utf-8
  '';
  powerLineGoOptions = ''
    -cwd-max-dir-size 10 \
    -modules 'root,cwd,perms,nix-shell,jobs,exit,git,time' \
    -priority 'root,cwd,perms,nix-shell,exit,time,git' \
    -newline \
    -theme '${./power-line-go-theme.json}' \
    -mode 'patched' \
  '';
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" ];
    };
    interactiveShellInit = ''
      ${chShellInit}

      (cd $HOME; rm .autojump; ln -s ${pkgs.autojump} .autojump)

      set -o ignoreeof # stop ctrl-d from killing the shell
      export EDITOR='nvim'
      # when entering from nix-shell bash add the PATHS to tools in _PATH
      if [ -n "$_PATH" ]; then
        if [ -z "$__PATH" ]; then
          export __PATH=$PATH
          export PATH=$_PATH:$PATH
        fi
      fi
      alias level="echo $SHLVL"


      # setup direnv
      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"


      ${base16ShellInit}

      # dispaly UTF-8 in less
      export LESSCHARSET=utf-8
    '';
    promptInit = ''

      function powerline_precmd() {
          PS1="$(${pkgs.powerline-go}/bin/powerline-go -error $? \
            -shell zsh \
            ${powerLineGoOptions}
            )"
      }

      function install_powerline_precmd() {
        for s in "$${precmd_functions[@]}"; do
          if [ "$s" = "powerline_precmd" ]; then
            return
          fi
        done
        precmd_functions+=(powerline_precmd)
      }

      if [ "$TERM" != "linux" ]; then
          install_powerline_precmd
      fi
    '';
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "autojump"
        "cabal"
        "gnu-utils"
        "man"
        "shrink-path"
        "colored-man-pages"
      ];
    };
  };
  programs.bash = {
    enableCompletion = true;
    promptInit = ''
      function _update_ps1() {
          PS1="$(${pkgs.powerline-go}/bin/powerline-go -error $? \
            ${powerLineGoOptions}
          )"
      }

      if [ "$TERM" != "linux" ] && [ -f "${pkgs.powerline-go}/bin/powerline-go" ]; then
          PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
      fi
    '';
    interactiveShellInit = ''
      ${chShellInit}

      # setup direnv
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"

      ${base16ShellInit}
    '';
  };
}
