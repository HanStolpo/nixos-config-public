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
