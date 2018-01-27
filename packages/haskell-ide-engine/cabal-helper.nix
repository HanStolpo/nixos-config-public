{ mkDerivation, base, bytestring, Cabal, cabal-install, containers
, directory, exceptions, fetchgit, filepath, ghc-prim, mtl, process
, semigroupoids, stdenv, template-haskell, temporary, transformers
, unix, unix-compat, utf8-string
}:
mkDerivation {
  pname = "cabal-helper";
  version = "0.8.0.0";
  src = fetchgit {
    url = "https://gitlab.com/dxld/cabal-helper.git";
    sha256 = "1a8231as0wdvi0q73ha9lc0qrx23kmcwf910qaicvmdar5p2b15m";
    rev = "4bfc6b916fcc696a5d82e7cd35713d6eabcb0533";
  };
  isLibrary = true;
  isExecutable = true;
  setupHaskellDepends = [ base Cabal directory filepath ];
  libraryHaskellDepends = [
    base Cabal directory filepath ghc-prim mtl process semigroupoids
    transformers unix unix-compat
  ];
  executableHaskellDepends = [
    base bytestring Cabal containers directory exceptions filepath
    ghc-prim mtl process template-haskell temporary transformers unix
    unix-compat utf8-string
  ];
  testHaskellDepends = [
    base bytestring Cabal directory exceptions filepath ghc-prim mtl
    process template-haskell temporary transformers unix unix-compat
    utf8-string
  ];
  testToolDepends = [ cabal-install ];
  doCheck = false;
  description = "Simple interface to some of Cabal's configuration state, mainly used by ghc-mod";
  license = stdenv.lib.licenses.agpl3;
}
