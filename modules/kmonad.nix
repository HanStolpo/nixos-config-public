{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hanstolpo.kmonad;
in
{
  options = {
    hanstolpo.kmonad = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      keyboards = mkOption {
        type =
          types.attrsOf
            (types.either types.str (types.submodule {
              options = {
                device = mkOption { type = types.str; };
                # the fold up bluetooth keyboard has no cmp button so we map right control to right alt
                noComposeKeyRCtrlAsRAlt = mkOption { type = types.bool; default = false; };
                leftArrowAsCtrl = mkOption { type = types.bool; default = false; };
              };
            }));
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kmonad
    ];

    services.kmonad = {
      enable = true;

      # extraArgs = ["--log-level" "debug"];

      keyboards =
        let
          keyboardLayout = { noComposeKeyRCtrlAsRAlt ? false, leftArrowAsCtrl ? false }:
            let
                # Bottom row key definitions for defsrc
                # When noComposeKeyRCtrlAsRAlt, leave out cmp
                bottomRowSrc = if noComposeKeyRCtrlAsRAlt
                  then "lctl lmet lalt           spc            ralt rctl"
                  else "lctl lmet lalt           spc            ralt cmp rctl";
                # Bottom row mappings for deflayer qwerty
                # When noComposeKeyRCtrlAsRAlt turn right ctrl into right alt
                bottomRowMap = if noComposeKeyRCtrlAsRAlt
                  then "  _ lmet   @inSym           _          @inSym  ralt"
                  else "  _ lmet   @inSym           _          @inSym  ralt  _";
                bottomRowSymbols = if noComposeKeyRCtrlAsRAlt
                  then "  _   _   _           esc          _  _"
                  else "  _   _   _           esc          _  _  _";

            in
            {
            defcfg = {
              enable = true;
              fallthrough = true;
              allowCommands = false;
            };

            config = ''

                (defsrc
                  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
                  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
                  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
                  caps a    s    d    f    g    h    j    k    l    ;    '    ret
                  lsft z    x    c    v    b    n    m    ,    .    /    rsft
                  ${bottomRowSrc}
                  left
                )

                (defalias
                  inSym (layer-toggle symbols)   ;; perform next key press in symbol layer

                  uscr (around sft -) ;; underscore
                )

                (deflayer qwerty
                  _    _    _    _    _    _    _    _    _    _    _    _    _
                  _    _    _    _    _    _    _    _    _    _    _    _    _    _
                  _    _    _    _    _    _    _    _    _    _    _    _    _    _
                bspc   _    _    _    _    _    _    _    _    _    _    _    _
                  _    _    _    _    _    _    _    _    _    _    _    _
                  ${bottomRowMap}
                  ${if leftArrowAsCtrl then "rctl" else "_"}
                )

                (deflayer symbols
                  _    _    _    _    _    _   _    _    _    _    _    _    _
                  _    _    _    _    _    _   _    _    _    _    _    _    _    _
                  _    !    @    {    }    |   *    =    -   @uscr +    _    _    _
                  _    #    $   \(   \)    ` left  down  up  rght  _    _    _
                  _    %    ^    [    ]    ~  \\    /    &    _    _    _
                  ${bottomRowSymbols}
                  _
                )

                '';
          };

          mkService = k: cfg:
            if builtins.typeOf cfg == "string"
              then
                { device = cfg; } // (keyboardLayout {})
              else
                { inherit (cfg) device;} // (keyboardLayout { inherit (cfg) noComposeKeyRCtrlAsRAlt leftArrowAsCtrl; });

        in
        mapAttrs mkService cfg.keyboards;
    };
  };
}
