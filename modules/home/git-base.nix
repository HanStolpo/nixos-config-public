# Git identity and basic settings shared between the desktop configuration
# (git.nix, which adds gpg signing) and the remote profile (remote.nix).
{ ... }: {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Handré Stolp";
        email = "HanStolpo@gmail.com";
      };
      core = {
        excludesFile = "~/.gitignore";
      };
    };
  };
}
