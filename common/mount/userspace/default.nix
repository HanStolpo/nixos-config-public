{ config, pkgs, ... }:
{
  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
     udisks2    # mount removable drives as user in /run/media/username/drivename
     usermount  # automounter that works with udisks2
     udevil     # user space mounting program
   ];


  # allow udisks2 to work for no privileged
  # mount using `udisksctl mount --block-device /dev/sda1`
  security.polkit.extraConfig =
  ''
  polkit.addRule(function(action, subject) {
      var YES = polkit.Result.YES;
      var permission = {
        // only required for udisks1:
        "org.freedesktop.udisks.filesystem-mount": YES,
        "org.freedesktop.udisks.filesystem-mount-system-internal": YES,
        "org.freedesktop.udisks.luks-unlock": YES,
        "org.freedesktop.udisks.drive-eject": YES,
        "org.freedesktop.udisks.drive-detach": YES,
        // only required for udisks2:
        "org.freedesktop.udisks2.filesystem-mount": YES,
        "org.freedesktop.udisks2.filesystem-mount-system": YES,
        "org.freedesktop.udisks2.encrypted-unlock": YES,
        "org.freedesktop.udisks2.eject-media": YES,
        "org.freedesktop.udisks2.power-off-drive": YES,
        // required for udisks2 if using udiskie from another seat (e.g. systemd):
        "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
        "org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
        "org.freedesktop.udisks2.eject-media-other-seat": YES,
        "org.freedesktop.udisks2.power-off-drive-other-seat": YES
      };
      if (subject.isInGroup("users")) {
        return permission[action.id];
      }
    });
    '';
}
