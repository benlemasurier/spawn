{
  config,
  pkgs,
  lib,
  fetchFromGitHub,
  buildGoModule,
  hostname ? "rooster",
  ...
}:

{
  home.stateVersion = "23.05";

  imports = [
    ./accounts.nix
    ./programs/bat.nix
    ./programs/dunst.nix
    ./programs/fonts.nix
    ./programs/khal.nix
    ./programs/meshtastic.nix
    ./programs/nats.nix
    ./programs/neovim
    ./programs/tmux.nix
    ./xdg
  ]
  ++ (
    if hostname == "pine" then
      [
        ./programs/polybar-pine.nix
        ./programs/rofi-pine
      ]
    else
      [
        ./programs/polybar.nix
        ./programs/rofi
      ]
  );

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

    bashrcExtra = ''
      eval "$(direnv hook bash)"
    '';
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.firefox = {
    enable = true;

    package = pkgs.firefox.override { cfg.speechSynthesisSupport = false; };
    profiles.default.settings = lib.mkIf (hostname == "pine") {
      "layout.css.devPixelsPerPx" = "0.6";
      # "media.cubeb.backend" = "pipewire";
    };
  };

  #nixpkgs.overlays = [
  #  (final: prev: {
  #    vault = final.buildGoModule rec {
  #      version = "1.15.6";
  #      src = fetchFromGitHub {
  #        owner = "hashicorp";
  #        repo = "vault";
  #        rev = "v${version}";
  #        hash = lib.fakeSha256;
  #      };
  #    };
  #  })
  #];

  home.packages = with pkgs; [
    alacritty
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
    direnv
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
    python311Packages.pip
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

  xresources.extraConfig = builtins.readFile (
    if hostname == "pine" then ./files/Xresources-pine else ./files/Xresources
  );

  home.pointerCursor = {
    name = "Vanilla-DMZ-AA";
    size = 24;
    package = pkgs.vanilla-dmz;
    gtk.enable = true;
    x11.enable = true;
  };

  home.file.".config/alacritty/alacritty.toml" = {
    source = ./files/alacritty/alacritty.toml;
  };
  home.file.".config/alacritty/gruvbox-dark.toml" = {
    source = ./files/alacritty/gruvbox-dark.toml;
  };
  home.file.".config/alacritty/host.toml" = {
    source =
      if hostname == "pine" then
        ./files/alacritty/host-pine.toml
      else
        ./files/alacritty/host-rooster.toml;
  };

  home.file.".gitconfig" = {
    source = ./files/gitconfig;
  };
  home.file."/code/lambda/.gitconfig" = {
    source = ./files/gitconfig-work;
  };
  home.file.".gdbinit" = {
    source = ./files/gdbinit;
  };
  home.file.".quiltrc" = {
    source = ./files/quiltrc;
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

  services.screen-locker = {
    enable = true;
    lockCmd = let
      lockScript = pkgs.writeShellScript "lock" ''
        ${pkgs.xwobf}/bin/xwobf /tmp/.lock.png && ${pkgs.i3lock}/bin/i3lock -n -i /tmp/.lock.png
      '';
    in "${lockScript}";
    inactiveInterval = 5;
    xautolock.enable = false;
    xss-lock.extraOptions = [ "--transfer-sleep-lock" ];
  };

}
