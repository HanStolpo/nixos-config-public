# NordVPN CLI client repackaged from the official deb.
# Copied from the local nordvpn-mesh-node flake (originally based on
# https://github.com/m-lourenco0/nordvpn-flake) so the client can be kept
# up to date here: bump `version` and the per-arch sha256 hashes below
# (nix-prefetch-url the new deb URLs to get them).
{ lib
, stdenv
, fetchurl
, dpkg
, patchelf
, makeWrapper
, file
, glibc
, libgcc
, systemd
, iptables
, iproute2
, procps
, libxml2
, zlib
, openssl
, sqlite
, libnl
, libcap_ng
}:

stdenv.mkDerivation rec {
  pname = "nordvpn";
  version = "5.3.0";

  src =
    let
      debs = {
        x86_64-linux = {
          arch = "amd64";
          sha256 = "0d63z0qnfdhqplx3l087svafxjkar4pfsl5rhp1015swlxrfmk9l";
        };
        aarch64-linux = {
          arch = "arm64";
          sha256 = "16996zgn7nqkh2lxfkah06bpjziv6vd64aym88ibz7r8rnx3zz47";
        };
      };
      deb = debs.${stdenv.hostPlatform.system} or
        (throw "nordvpn: no deb for system ${stdenv.hostPlatform.system}");
    in
    fetchurl {
      url = "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/n/nordvpn/nordvpn_${version}_${deb.arch}.deb";
      sha256 = deb.sha256;
    };

  nativeBuildInputs = [ dpkg patchelf makeWrapper file ];

  buildInputs = [
    glibc
    libgcc
    systemd
    iptables
    iproute2
    procps
    libxml2
    zlib
    openssl
    sqlite
    # Needed by the bundled lib/nordvpn/openvpn helper
    libnl
    libcap_ng
  ];

  unpackPhase = "dpkg-deb -x $src .";

  # We set interpreters/RPATHs explicitly below; keep fixupPhase
  # from shrink-rpath'ing away $out/lib/nordvpn (needed for the
  # bundled libtelio/libnorddrop the binaries dlopen at runtime).
  dontPatchELF = true;

  installPhase = ''
    mkdir -p $out/bin $out/lib/nordvpn $out/share
    if [ -d usr/bin ]; then cp -r usr/bin/* $out/bin/; fi
    if [ -d usr/sbin ]; then cp -r usr/sbin/* $out/bin/; fi
    if [ -d usr/lib/nordvpn ]; then cp -r usr/lib/nordvpn/* $out/lib/nordvpn/; fi
    if [ -d usr/share ]; then cp -r usr/share/* $out/share/; fi
    # Seed data for /var/lib/nordvpn (copied on first daemon start)
    if [ -d var/lib/nordvpn ]; then mkdir -p $out/var/lib; cp -r var/lib/nordvpn $out/var/lib/; fi

    rpath="$out/lib/nordvpn:${lib.makeLibraryPath buildInputs}"

    # Patch the CLI/daemon binaries with interpreter + RPATH
    for bin in $out/bin/nordvpn $out/bin/nordvpnd; do
      if [ -f "$bin" ]; then
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$bin"
        patchelf --set-rpath "$rpath" "$bin"
      fi
    done

    # The daemon spawns helper executables from lib/nordvpn
    # (norduserd, nordfileshare, openvpn); patch every ELF there
    # too, setting the interpreter only on executables (the *.so
    # libraries just get the RPATH).
    for f in $out/lib/nordvpn/*; do
      if file -b "$f" | grep -q 'ELF'; then
        if file -b "$f" | grep -Eq 'executable|pie executable'; then
          patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$f"
        fi
        patchelf --set-rpath "$rpath" "$f"
      fi
    done

    # Wrap programs for PATH and LD_LIBRARY_PATH
    wrapProgram $out/bin/nordvpn \
      --prefix PATH : "${lib.makeBinPath [ iptables iproute2 procps ]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"

    wrapProgram $out/bin/nordvpnd \
      --prefix PATH : "${lib.makeBinPath [ iptables iproute2 procps ]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"
  '';

  meta = with lib; {
    description = "NordVPN CLI client";
    homepage = "https://nordvpn.com";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
