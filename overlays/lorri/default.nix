final: prev:
{
  lorri-custom = final.callPackage
    # copied from https://github.com/target/lorri/blob/66536ab4a503e2c30f948849e9b655ad5c0f0708/release.nix
    # because I could not figure out how to override `cargoSha256`
    (
      { stdenv
      , pkgs
      , fetchFromGitHub
      , rustPlatform
        # Updater script
      , runtimeShell
      , writers
        # Tests
      , nixosTests
        # Apple dependencies
      , CoreServices ? null
      , Security ? null
      }:
      let
        # Run `eval $(nix-build -A lorri.updater)` after updating the revision!
        version = "1.2.0";
        gitRev = "66536ab4a503e2c30f948849e9b655ad5c0f0708";
        sha256 = "08jb2vgbm4s87wnk7q82yc55dd2b8fyn7v8vsarjamwhna2fh7py";
        cargoSha256 = "1d1wvrsr0njs6daiczxf8jfw1xlpv6wk9wlfm4vv0792fnvnhy4y";

      in
      (rustPlatform.buildRustPackage rec {
        pname = "lorri";
        inherit version;

        meta = with stdenv.lib; {
          description = "Your project's nix-env";
          homepage = "https://github.com/target/lorri";
          license = licenses.asl20;
          maintainers = with maintainers; [ grahamc Profpatsch ];
        };

        src = fetchFromGitHub {
          owner = "target";
          repo = pname;
          rev = gitRev;
          inherit sha256;
        };

        inherit cargoSha256;
        doCheck = false;

        BUILD_REV_COUNT = src.revCount or 1;
        RUN_TIME_CLOSURE = pkgs.callPackage ./runtime.nix { };

        nativeBuildInputs = with pkgs; [ rustPackages.rustfmt ];
        buildInputs =
          stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security ];

        # copy the docs to the $man and $doc outputs
        postInstall = ''
          install -Dm644 lorri.1 $man/share/man/man1/lorri.1
          install -Dm644 -t $doc/share/doc/lorri/ \
            README.md \
            CONTRIBUTING.md \
            LICENSE \
            MAINTAINERS.md
          cp -r contrib/ $doc/share/doc/lorri/contrib
        '';

        passthru = {
          updater = writers.writeBash "copy-runtime-nix.sh" ''
            set -euo pipefail
            cp ${src}/nix/runtime.nix ${toString ./runtime.nix}
            cp ${src}/nix/runtime-closure.nix.template ${toString ./runtime-closure.nix.template}
          '';
          tests = {
            nixos = nixosTests.lorri;
          };
        };
      }).overrideAttrs (old: {
        # add man and doc outputs to put our documentation into
        outputs = old.outputs or [ "out" ] ++ [ "man" "doc" ];
      })
    )
    { };
}
# {
# 
#   lorri = final.pkgs-unstable.lorri.overrideDerivation (old: {
#     src = final.fetchFromGitHub {
#       owner = "target";
#       repo = "lorri";
#       rev = "66536ab4a503e2c30f948849e9b655ad5c0f0708";
#       sha256 = "08jb2vgbm4s87wnk7q82yc55dd2b8fyn7v8vsarjamwhna2fh7py";
#     };
#     cargoSha256 = "108l0s19jadqha0vvdrh5gfbsbj8yscivrvrsgs926wcghlsnvm6";
#   });
# 
# }