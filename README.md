# nixos-config-public
My publicly visible nixos configurations


# Notes

## Dropbox

### Noctalia shell

Dropbox icon was not showing in tray in noctalia shell

running `qs -c noctalia-shell` saw the following warning

```
  WARN scene: QML QQuickImage at qrc:/qt/qml/Quickshell/Widgets/IconImage.qml[59:2]: Cannot open: file:///home/handre/.dropbox-dist/dropbox-lnx.x86_64-239.4.8301/images/dropboxstatus-idle
```

the images were actually located at

```
~/.dropbox-dist/dropbox-lnx.x86_64-239.4.8301/images/hicolor/16x16/status/
```

and not 

```
~/.dropbox-dist/dropbox-lnx.x86_64-239.4.8301/images
```

copy the images over to the parent directory fixed it

## nordvpn

### mesh net

To enable nordvpn mesh net one would

```
nordvpn set mesh on
```

but this fails because it attempts to edit the `/etc/hosts` file which is a symlink
to the read only filesystem in the nix store

to get around it copy the actual file from the nix store to `/etc/hosts` so that
nordvpn can modify it

```
sudo cp /etc/hosts /etc/hosts-s && sudo mv /etc/hosts-s /etc/hosts
```

## Remote (non-NixOS) home-manager profile

The terminal-only parts of the home-manager configuration (fish, starship,
atuin, direnv, neovim, tmux, git identity) can be used standalone on a machine that
is not NixOS, e.g. a remote dev box where nix is installed for an
unprivileged user. See `modules/home/remote.nix`.

Flake outputs:

- `homeManagerModules.{terminal,fish,nvim,git-base,remote}`: importable modules.
- `lib.mkRemoteHome { username, homeDirectory?, system?, modules? }`: builds a
  standalone `homeConfigurations` entry for any user.
- `homeConfigurations.{handre,dev}`: ready-made entries for `/home/handre` and `/home/dev`.

Use directly on the remote machine (first time; afterwards `home-manager` is in the profile):

```sh
nix run github:nix-community/home-manager/release-26.05 -- \
  switch --flake github:hanstolpo/nixos-config-public#dev
```

Or from a consumer flake for a different user:

```nix
{
  inputs.hanstolpo.url = "github:hanstolpo/nixos-config-public";
  outputs = { hanstolpo, ... }: {
    homeConfigurations.alice = hanstolpo.lib.mkRemoteHome {
      username = "alice";
      modules = [{
        hanstolpo.remote.manageNix = true;   # write ~/.config/nix/nix.conf (default false)
        hanstolpo.remote.execFish = false;   # don't exec fish from bash (default true)
        hanstolpo.nvim.minimal = false;      # full neovim plugin set (default true remotely)
      }];
    };
  };
}
```

Pre-build on a builder and push to the cache with
`nix build .#homeConfigurations.dev.activationPackage`.

For a machine with a persistent `/nix` and home directory that runs a
per-developer script on every boot, `scripts/remote-home-boot.sh` activates the
configuration on first boot and is a cheap no-op afterwards. Pin
`HM_FLAKE_REF` to a commit for fully offline, reproducible boots.
