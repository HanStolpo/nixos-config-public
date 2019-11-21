{ mkDerivation
, base
, binary
, bytestring
, Cabal
, cabal-helper
, containers
, deepseq
, directory
, djinn-ghc
, extra
, fclabels
, fetchgit
, filepath
, fingertree
, ghc
, ghc-boot
, ghc-paths
, ghc-syb-utils
, haskell-src-exts
, hlint
, monad-control
, monad-journal
, mtl
, old-time
, optparse-applicative
, pipes
, process
, safe
, semigroups
, split
, stdenv
, syb
, template-haskell
, temporary
, text
, time
, transformers
, transformers-base
}:
mkDerivation {
  pname = "ghc-mod-core";
  version = "5.9.0.0";
  src = import ./ghc-mod-src.nix { inherit fetchgit; };
  postUnpack = "sourceRoot+=/core; echo source root reset to $sourceRoot";
  setupHaskellDepends = [
    base
    Cabal
    containers
    directory
    filepath
    process
    template-haskell
    transformers
  ];
  libraryHaskellDepends = [
    base
    binary
    bytestring
    cabal-helper
    containers
    deepseq
    directory
    djinn-ghc
    extra
    fclabels
    filepath
    fingertree
    ghc
    ghc-boot
    ghc-paths
    ghc-syb-utils
    haskell-src-exts
    hlint
    monad-control
    monad-journal
    mtl
    old-time
    optparse-applicative
    pipes
    process
    safe
    semigroups
    split
    syb
    template-haskell
    temporary
    text
    time
    transformers
    transformers-base
  ];
  homepage = "https://github.com/DanielG/ghc-mod";
  description = "Happy Haskell Hacking";
  license = stdenv.lib.licenses.agpl3;
}
