{ mkDerivation, aeson, ansi-terminal, base, bytestring, cmdargs
, containers, cpphs, data-default, directory, extra, file-embed
, filepath, filepattern, ghc-lib-parser, ghc-lib-parser-ex
, hscolour, process, refact, stdenv, text, transformers, uniplate
, unordered-containers, utf8-string, vector, yaml
}:
mkDerivation {
  pname = "hlint";
  version = "3.1.4";
  sha256 = "bbe132ae5e2a7428e6c5a53bbb224809163996d024bb260aebc66d6637b050f3";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson ansi-terminal base bytestring cmdargs containers cpphs
    data-default directory extra file-embed filepath filepattern
    ghc-lib-parser ghc-lib-parser-ex hscolour process refact text
    transformers uniplate unordered-containers utf8-string vector yaml
  ];
  executableHaskellDepends = [ base ];
  homepage = "https://github.com/ndmitchell/hlint#readme";
  description = "Source code suggestions";
  license = stdenv.lib.licenses.bsd3;
}
