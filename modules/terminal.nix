{ config, lib, pkgs, ... }:

with lib;
let

  cfg = config.hanstolpo.terminal;
in
{
  options = {
    hanstolpo.terminal = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      # nix related
      nix # nix package manager
      nix-prefetch-scripts # Collection of all the nix-prefetch-* scripts which may be used to obtain source hashes
      patchelf # A small utility to modify the dynamic linker and RPATH of ELF executables
      nix-du # Visualise which gc-roots to delete to free some space in your nix store
      nix-index # Quickly locate nix packages with specific files
      nixpkgs-fmt # formatter for nix files


      # Utilities
      wget # Tool for retrieving files using HTTP, HTTPS, and FTP
      sudo # A command to run commands as root
      man-pages # / man-pages : Linux development manual pages
      iptables # A program to configure the Linux IP packet filtering ruleset
      zlib # Lossless data-compression library
      psmisc # A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
      file # A program that shows the type of files
      atool # Archive command line helper
      p7zip # A port of the 7-zip archiver
      rsync # A fast incremental file transfer utility
      unzip # An extraction utility for archives compressed in .zip format
      gnupg # Modern (2.1) release of the GNU Privacy Guard, a GPL OpenPGP implementation
      pinentry # pinentry program to be used by gnupg by default
      utillinux # for dmesg, kill,...
      htop # An interactive process viewer for Linux
      traceroute # Tracks the route taken by packets over an IP network
      which # get location of executable
      tldr # examples of bash commands
      zip
      unrar
      inotify-tools # inotifywait to block awaiting changes on files in shell scripts
      tree # print directory trees
      testdisk # rescue the disk or undelete files
      vault
      graphviz # draw graphs for networks of nodes
      nmap #  A free and open source utility for network discovery and security auditing
      tcpdump # Network sniffer
      bc # GNU software calculator
      vifm # vi like terminal file manager
      openssl # A cryptographic library that implements the SSL and TLS protocols
      netcat-openbsd # TCP/IP swiss army knife, OpenBSD variant
      kpcli # command line interface to keepass
      easyrsa
      mkpasswd # generate password hashes
      autojump # used in ohmyzsh to quickly jump between directories

      # source control for configs etc
      gitAndTools.gitFull # git source control
      gitAndTools.gitRemoteGcrypt # encrypted git remotes
      git-crypt

      # development
      binutils # Tools for manipulating binaries (linker, assembler, etc.)
      silver-searcher # A code-searching tool similar to ack, but faster
      ctags # A tool for fast source code browsing (exuberant ctags)
      gnumake # A tool to control the generation of non-source files from sources
      cabal2nix # Convert Cabal files into Nix build instructions
      perl # The standard implementation of the Perl 5 programmming language
      heroku # Everything you need to get started using Heroku
      nodePackages.node2nix # generate nix from node packages
      direnv # automatically setup environment variables when entering a directory
      gdb # debugger
      # json
      jq
      yaml2json
      (haskell.lib.justStaticExecutables haskellPackages.aeson-pretty) # pretty print json text
      # haskell
      # (haskell.lib.justStaticExecutables haskellPackages.haskell-language-server)
      (haskell.lib.justStaticExecutables haskellPackages.hie-bios)
      # rust
      cargo
      rustc

      # spelling
      aspell # Spell checker for many languages
      aspellDicts.en # Aspell dictionary for English


      # networking
      dnsutils # gives nslookup and dig (and dns server enabled through services.bind.enable)
      autossh # keep ssh tunnels open
      arp-scan

      ripgrep # rg - A utility that combines the usability of The Silver Searcher with the raw speed of grep

      pgcli

      cachix # Command line client for Nix binary cache hosting https://cachix.org

      pass # Stores, retrieves, generates, and synchronizes passwords securely

      tmux # multiplex shells
      mosh # ssh alternative for intermittent connections

      fzf

      stgit # stacked git

      git-branchless # newer stacked git

      gh # github cli tool

      kubectl # Kubernetes CLI
      awscli2 # AWS CLI
      aws-iam-authenticator # AWS IAM credentials for Kubernetes authentication
      google-cloud-sdk # gcloud cli
      sops # Mozilla secret OPerationS
      kubernetes-helm
      fluxcd
    ];

    security.pki = {
      # from the example import mozillas certificates https://curl.haxx.se/docs/caextract.html
      certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ];
      # from the example black list some CAs
      caCertificateBlacklist = [
        # these are not in the mozilla trust store anymore
        # which throws an error in nixos 21.11
        # "WoSign"
        # "WoSign China"
        # "CA WoSign ECC Root"
        # "Certification Authority of WoSign G2"
      ];
    };
    programs.ssh.startAgent = false;

    programs.gnupg.agent = {
      enable = true;
      pinentryFlavor = "qt";
      enableSSHSupport = true;
      enableExtraSocket = true;
      enableBrowserSocket = true;
    };
  };
}
