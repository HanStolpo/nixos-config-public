# nixos-config-public
My publicly visible nixos configurations


# Notes

## Dropbox

### Noctalia shell

Dropbox icon was not showing in tray in noctalia shell

running `qs -c noctalia-shell` saw the following warning

```
  WARN scene: QML QQuickImage at qrc:/qt/qml/Quickshell/Widgets/IconImage.qml[59:2]: Cannot open: file:///home/handre/.dropbox-dist/dropbox-lnx.x86_64-239.4.8301/images/dropboxstatus-idle
```

the images were actually located at

```
~/.dropbox-dist/dropbox-lnx.x86_64-239.4.8301/images/hicolor/16x16/status/
```

and not 

```
~/.dropbox-dist/dropbox-lnx.x86_64-239.4.8301/images
```

copy the images over to the parent directory fixed it

## nordvpn

### mesh net

To enable nordvpn mesh net one would

```
nordvpn set mesh on
```

but this fails because it attempts to edit the `/etc/hosts` file which is a symlink
to the read only filesystem in the nix store

to get around it copy the actual file from the nix store to `/etc/hosts` so that
nordvpn can modify it

```
sudo cp /etc/hosts /etc/hosts-s && sudo mv /etc/hosts-s /etc/hosts
```
