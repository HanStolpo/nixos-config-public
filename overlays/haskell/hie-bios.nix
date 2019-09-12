{ mkDerivation, base, base16-bytestring, bytestring, containers
, cryptohash-sha1, deepseq, directory, extra, file-embed, filepath
, ghc, process, stdenv, temporary, text, time, transformers
, unix-compat, unordered-containers, vector, yaml
}:
mkDerivation {
  pname = "hie-bios";
  version = "0.1.1";
  sha256 = "57d020df2f4b930e617ffd77421c47b885c83ec81d22707cc1afe02502c43985";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base base16-bytestring bytestring containers cryptohash-sha1
    deepseq directory extra file-embed filepath ghc process temporary
    text time transformers unix-compat unordered-containers vector yaml
  ];
  executableHaskellDepends = [ base directory filepath ghc ];
  homepage = "https://github.com/mpickering/hie-bios";
  description = "Set up a GHC API session";
  license = stdenv.lib.licenses.bsd3;
}
