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
                swapLMetFn = mkOption { type = types.bool; default = false; };
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
          keyboardLayout = swapLMetFn: 
            let fn = if swapLMetFn then "cmp" else "fn";
                lmet = if swapLMetFn then "fn" else "lmet";
            in
            {
            defcfg = {
              enable = true;
              compose.key = null;
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
                  lctl lmet lalt           spc            ralt cmp rctl
                  cmp
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
                  _ ${lmet} @inSym              _          @inSym  ralt  _
                  ${fn}
                )

                (deflayer symbols
                  _    _    _    _    _    _   _    _    _    _    _    _    _
                  _    _    2    3    4    5   _    _    _    _    _    _    _    _
                  _    !    @    {    }    |   _    =    -   @uscr +    _    _    _
                  _    #    $   \(   \)    ` left  down  up  rght  _    _    _
                  _    %    ^    [    ]    ~   _    _    _    _    _    _
                  _    _    _             esc            _    _    _
                  _
                )

                '';
          };

          mkService = k: cfg:
            if builtins.typeOf cfg == "string"
              then
                { device = cfg; } // (keyboardLayout false)
              else
                { inherit (cfg) device; } // (keyboardLayout cfg.swapLMetFn);

        in
        mapAttrs mkService cfg.keyboards;
    };
  };
}
