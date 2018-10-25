{ mkDerivation, base, stdenv, unix }:
mkDerivation {
  pname = "unix-compat";
  version = "0.4.3.1";
  sha256 = "72801d5a654a6e108c153f412ebd54c37fb445643770e0b97701a59e109f7e27";
  revision = "2";
  editedCabalFile = "0b5jicn8nm53yxxzwlvfcv4xp5rrqp98x5wwqh234wn9x44z54d2";
  libraryHaskellDepends = [ base unix ];
  homepage = "http://github.com/jystic/unix-compat";
  description = "Portable POSIX-compatibility layer";
  license = stdenv.lib.licenses.bsd3;
}
