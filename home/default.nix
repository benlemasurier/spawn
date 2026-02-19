{
  config,
  pkgs,
  lib,
  hostname ? "rooster",
  ...
}:

{
  home.stateVersion = "23.05";

  imports = [
    ./accounts.nix
    ./programs/alacritty.nix
    ./programs/bat.nix
    ./programs/dunst.nix
    ./programs/fonts.nix
    ./programs/git.nix
    ./programs/khal.nix
    ./programs/meshtastic.nix
    ./programs/nats.nix
    ./programs/neovim
    ./programs/polybar.nix
    ./programs/rofi
    ./programs/tmux.nix
    ./xdg
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    historySize = -1;
    historyFileSize = -1;
    historyControl = [
      "ignoredups"
      "ignorespace"
    ];

    shellAliases = {
      bc = "bc -l"; # always load math lib for decimals
      cat = "bat -pp"; # plain, disable paging
      k = "kubectl";
      tf = "terraform";
      ls = "eza";
      man = "batman";
      mk = "minikube kubectl --";
      pbcopy = "xclip -selection clipboard";
    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.firefox = {
    enable = true;

    package = pkgs.firefox.override { cfg.speechSynthesisSupport = false; };
    profiles.default.settings = {
      # compact ui: remove minimize, maximize, close buttons
      "browser.tabs.inTitleBar" = 0;
    }
    // lib.optionalAttrs (hostname == "pine") {
      # scale ui to a reasonable size
      "layout.css.devPixelsPerPx" = "0.6";
    };
  };

  home.packages = with pkgs; [
    ansible
    ansible-lint
    asdbctl
    awscli2
    bison
    bc
    buildkite-cli
    cc65
    check-jsonschema
    clang-tools
    cscope
    dig
    dive
    esphome
    eza
    feh
    file
    gcc
    flex
    gdb
    gdu
    ghc
    gnumake
    gnupg

    # golang
    delve
    go
    go-critic
    golangci-lint
    golines
    golint
    gomodifytags
    gotests
    gotestsum
    gotools
    govulncheck
    iferr
    impl
    ipmitool
    mockgen
    reftools
    revive
    richgo

    graphviz
    (pkgs.go-migrate.overrideAttrs (oldAttrs: {
      tags = [ "postgres" ];
    }))
    hadolint
    higan
    himalaya
    htop
    httpie
    hurl
    i3lock
    isort
    jq
    k9s
    killall
    kind
    kubectl
    kubelogin-oidc
    kubernetes-helm
    kubevirt
    kustomize
    libx11
    libusb1
    libnotify
    luarocks
    manix
    minikube
    moonlight-qt
    msmtp
    ncurses
    ncurses.dev
    nh
    nodejs
    openfortivpn
    openssl
    pass
    pavucontrol
    pkg-config
    plantuml
    polkit_gnome
    polybar-pulseaudio-control
    postgresql
    pyright
    python3Packages.pip
    python3
    quilt
    rustup
    shellcheck
    signal-desktop
    slack
    terraform
    tree-sitter
    ttf_bitstream_vera
    unzip
    universal-ctags
    vanilla-dmz
    vegeta
    vendir
    vlc
    xclip
    xss-lock
    xwobf
    yq-go
    zathura
  ];

  home.pointerCursor = {
    name = "Vanilla-DMZ-AA";
    size = 24;
    package = pkgs.vanilla-dmz;
    gtk.enable = true;
    x11.enable = true;
  };

  home.file.".gdbinit" = {
    source = ./files/gdbinit;
  };
  home.file.".quiltrc" = {
    source = ./files/quiltrc;
  };

  # fix x1 carbon (gen13) terrible audio
  home.file.".config/easyeffects/output/LoudnessEqualizer.json" = lib.mkIf (hostname == "pine") {
    source = ./files/LoudnessEqualizer.json;
  };

  xsession = {
    enable = true;
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = ./files/xmonad.hs;
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
  };

  services.redshift = {
    enable = true;
    latitude = "40.13";
    longitude = "-105.43";
  };

  services.random-background = {
    enable = true;
    interval = "1h"; # remove to set bg once at login
    imageDirectory = "${config.home.homeDirectory}/.config/background-images";
  };

  home.file.".config/background-images" = {
    source = ./files/background-images;
    recursive = true;
  };

  services.screen-locker = lib.mkIf (hostname == "pine") {
    enable = true;

    lockCmd =
      let
        lockScript = pkgs.writeShellScript "lock" ''
          ${pkgs.xwobf}/bin/xwobf /tmp/.lock.png && ${pkgs.i3lock}/bin/i3lock -n -i /tmp/.lock.png
        '';
      in
      "${lockScript}";
    inactiveInterval = 5;
    xautolock.enable = false;
    xss-lock.extraOptions = [ "--transfer-sleep-lock" ];
  };

  xresources.properties = {
    "Xft.antialias" = 1;
    "Xft.autohint" = 0;
    "Xft.hinting" = 1;
    "Xft.hintstyle" = if hostname == "pine" then "hintslight" else "hintfull";
    "Xft.lcdfilter" = "lcddefault";
    "Xft.rgba" = "rgb";
    "Xft.dpi" = if hostname == "pine" then 196 else 218;

    # special
    "*.foreground" = "#c5c8c6";
    "*.background" = "#1d1f21";
    "*.cursorColor" = "#c5c8c6";

    # black
    "*.color0" = "#282a2e";
    "*.color8" = "#373b41";

    # red
    "*.color1" = "#a54242";
    "*.color9" = "#cc6666";

    # green
    "*.color2" = "#8c9440";
    "*.color10" = "#b5bd68";

    # yellow
    "*.color3" = "#de935f";
    "*.color11" = "#f0c674";

    # blue
    "*.color4" = "#5f819d";
    "*.color12" = "#81a2be";

    # magenta
    "*.color5" = "#85678f";
    "*.color13" = "#b294bb";

    # cyan
    "*.color6" = "#5e8d87";
    "*.color14" = "#8abeb7";

    # white
    "*.color7" = "#707880";
    "*.color15" = "#c5c8c6";
  };
}
