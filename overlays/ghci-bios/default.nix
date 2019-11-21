self: super:
let
  /* helper script to load a file into ghci using the ghci found in the environment and using
     hie-bios found in the environment to get the required flags.

     - called with no arguments just loads a ghci
     - called with arguments
        - first argument is assumed to be a file to load into ghci and for
          which hie-bios should provide flags
        - any other arguments are passed through to ghci
  */
  ghci-bios = super.writeScriptBin "ghci-bios"
    ''
      set +e

      PATH=${self.jq}/bin:${self.findutils}/bin:${self.gnused}/bin:$PATH

      GHCI=$(type -p ghci)
      if [ -z "$GHCI" ]; then
        echo "no ghci found"
        exit 1
      fi

      HIE_BIOS=$(type -p hie-bios)
      if [ -z "$HIE_BIOS" ]; then
        echo "no hie-bios found"
        exit 1
      fi

      GHCI_FILE=$1
      HIE_BIOS_FILE=$1
      shift 1
      if [ -z "$1" ]; then
        HIE_BIOS_FILE="fake_file_name_to_make_hie_bios_happy.hs"
      fi

      ghci $(hie-bios flags $HIE_BIOS_FILE | sed 's/CompilerOptions: //' | jq --raw-output '.[]' | xargs) $@ $GHCI_FILE
    '';
in
{ inherit ghci-bios; }
