#!/bin/sh
# Boot-time (re)activation of the remote home-manager profile from this flake.
#
# Intended for a non-NixOS dev machine with a persistent /nix and $HOME where a
# per-developer script runs on every boot. It is idempotent and cheap when the
# configuration has not changed, and brings a fresh machine to the configured
# state on first boot without a manual step.
#
# Run as the developer user, not root (e.g. `runuser -u dev -- sh this.sh`).
#
# Settings (override via environment):
#   HM_FLAKE_REF  flake reference. Pin a commit for fully offline, reproducible
#                 boots: github:hanstolpo/nixos-config-public/<rev>. A branch
#                 reference instead costs one GitHub API call per boot and
#                 re-evaluates only when the branch moved.
#   HM_CONFIG     name under homeConfigurations (the remote user, e.g. dev).
#   HM_LOG        log file.
set -eu

HM_FLAKE_REF="${HM_FLAKE_REF:-github:hanstolpo/nixos-config-public}"
HM_CONFIG="${HM_CONFIG:-dev}"
HM_LOG="${HM_LOG:-$HOME/.cache/remote-home-boot.log}"

mkdir -p "$(dirname "$HM_LOG")"
exec >>"$HM_LOG" 2>&1
echo "== $(date -Is) remote-home-boot: $HM_FLAKE_REF#$HM_CONFIG"

# boot scripts usually run without the login environment; make nix available
for p in /nix/var/nix/profiles/default/etc/profile.d/nix.sh \
         "$HOME/.nix-profile/etc/profile.d/nix.sh"; do
  if [ -r "$p" ]; then . "$p"; break; fi
done
command -v nix >/dev/null || { echo "nix not found on PATH"; exit 1; }

# current generation, if any (new nix puts user profiles under XDG_STATE_HOME,
# older single-user installs under /nix/var/nix/profiles/per-user)
current=""
for link in "${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/home-manager" \
            "/nix/var/nix/profiles/per-user/$USER/home-manager"; do
  if [ -e "$link" ]; then current=$(readlink -f "$link"); break; fi
done

# Resolve the wanted generation. With an unchanged locked flake this is served
# from the evaluation cache and the already-present store path, so no download
# and no module evaluation happen. If the network is down but a generation is
# already active, keep it and exit quietly.
if ! wanted=$(nix build --no-link --print-out-paths \
      "$HM_FLAKE_REF#homeConfigurations.$HM_CONFIG.activationPackage"); then
  if [ -n "$current" ]; then
    echo "could not resolve/build the configuration; keeping $current"
    exit 0
  fi
  echo "could not build the configuration and no generation is active"
  exit 1
fi

if [ "$wanted" = "$current" ]; then
  echo "already active: $current"
  exit 0
fi

# First activation on a machine image: existing dotfiles (.bashrc, .profile,
# .gitconfig, ...) would make home-manager refuse to clobber them; move them
# aside instead, like `home-manager switch -b backup`.
export HOME_MANAGER_BACKUP_EXT="${HOME_MANAGER_BACKUP_EXT:-backup}"

echo "activating $wanted"
"$wanted/activate"
echo "done"
