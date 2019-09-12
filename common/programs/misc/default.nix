{ config, pkgs, ... }:
{

  environment.systemPackages =
  with pkgs;
  [
     ffmpeg-full # A complete, cross-platform solution to record, convert and stream audio and video
     mpv # A media player that supports many video formats (MPlayer and mplayer2 fork)
     vlc # Cross-platform media player and streaming server
     gimp # The GNU Image Manipulation Program
     adobe-reader # PDF viewer
     pkgs-18-0-3.libreoffice # Comprehensive, professional-quality productivity suite (Still/stable release)
     #obs-studio # Free and open source software for video recording and live streaming
     inkscape # Vector graphics editor
     nmap # / ncat : A free and open source utility for network discovery and security auditing
     tcpdump # Network sniffer
     bc # GNU software calculator
     vifm # vi like terminal file manager
     openssl # A cryptographic library that implements the SSL and TLS protocols
     netcat-openbsd # TCP/IP swiss army knife, OpenBSD variant
     mesa_noglu  # An open source implementation of OpenGL
     mesa_drivers # An open source implementation of OpenGL
     # glmark2 # OpenGL (ES) 2.0 benchmark
     glxinfo # info about opengl implementation
     libinput # Handles input devices in Wayland compositors and provides a generic X.Org input drivelibinputr

     # spelling
     aspell # Spell checker for many languages
     aspellDicts.en # Aspell dictionary for English

     zoom-us # video chat client



     kpcli # command line interface to keepass

     ghostscript # 
     gv # postscript viewer
     giv # image viewer

     easyrsa

     flameshot # easy screenshot tool

     xdotool # x desktop automation

     mkpasswd # generate password hashes

     autojump # used in ohmyzsh to quickly jump between directories
  ];

}
