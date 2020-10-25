{ mkDerivation
, base
, bifunctors
, containers
, deque
, extra
, free
, hspec
, microlens
, microlens-th
, mtl
, multistate
, pretty
, stdenv
, transformers
, unsafe
, void
}:
mkDerivation {
  pname = "butcher";
  version = "1.3.3.2";
  sha256 = "1d0f8e8e498b012c4a859671eebf34a6e965e8ed99b3c90d3aad1d8898c40f1b";
  libraryHaskellDepends = [
    base
    bifunctors
    containers
    deque
    extra
    free
    microlens
    microlens-th
    mtl
    multistate
    pretty
    transformers
    unsafe
    void
  ];
  testHaskellDepends = [
    base
    containers
    deque
    extra
    free
    hspec
    microlens
    microlens-th
    mtl
    multistate
    pretty
    transformers
    unsafe
  ];
  homepage = "https://github.com/lspitzner/butcher/";
  description = "Chops a command or program invocation into digestable pieces";
  license = stdenv.lib.licenses.bsd3;
}
