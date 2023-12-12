final: prev:
{
  swayJournald = final.callPackage
    ({
       # inputs to create the wrapping script
       sway
     , writeShellApplication
     , logger
     , sway-unwrapped
     , symlinkJoin
     , # customizations arguments passed to the sway wrapper
       withBaseWrapper ? true
     , extraSessionCommands ? ""
     , withGtkWrapper ? false
     , extraOptions ? [ ]
     , isNixOS ? false
     , enableXWayland ? true
     , dbusSupport ? true

     }:
      let
        swayWrapper = sway.override {
          inherit withBaseWrapper extraSessionCommands withGtkWrapper extraOptions isNixOS enableXWayland dbusSupport;

        };
        swayLogging = (writeShellApplication {
          name = "sway";

          text = ''
            ${swayWrapper}/bin/sway "$@" 2>&1 | ${logger}/bin/logger -t sway
          '';
        }).overrideAttrs (_: _: rec {
          pname = "sway-logging-${version}";
          version = sway-unwrapped.version;
        });
      in
      symlinkJoin {
        name = "sway-journald-${sway-unwrapped.version}";
        paths = [ swayLogging swayWrapper ];
        passthru = {
          providedSessions = [ "sway" ];
        };
      })
    { };
}
