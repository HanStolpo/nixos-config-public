{ mkDerivation, base, base16-bytestring, bytestring, containers
, cryptohash-sha1, deepseq, directory, extra, file-embed, filepath
, ghc, process, stdenv, temporary, text, time, transformers
, unix-compat, unordered-containers, vector, yaml
}:
mkDerivation {
  pname = "hie-bios";
  version = "0.2.0";
  sha256 = "d5fe70c1dee54bdbf06f84f692fd49e5e12f9926bd88c7ce71c4f909786e206b";
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
