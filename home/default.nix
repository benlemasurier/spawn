{ config, pkgs, lib, fetchFromGitHub, buildGoModule, ... }:

{
  home.stateVersion = "23.05";

  imports = [
    ./accounts.nix
    ./programs/bat.nix
    ./programs/dunst.nix
    ./programs/fonts.nix
    ./programs/ghostty.nix
    ./programs/khal.nix
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
    historyControl = [ "ignoredups" "ignorespace" ];

    shellAliases = {
      bc = "bc -l"; # always load math lib for decimals
      cat = "bat -pp"; # plain, disable paging
      k = "kubectl";
      tf = "terraform";
      ls = "eza";
      man = "batman";
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
    awscli2
    bc
    cc65
    check-jsonschema
    clang-tools
    dig
    direnv
    dive
    esphome
    eza
    feh
    file
    gcc
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
    mockgen
    reftools
    revive
    richgo

    graphviz
    hadolint
    higan
    himalaya
    htop
    isort
    jq
    k9s
    killall
    kind
    kubectl
    kubernetes-helm
    libusb1
    libnotify
    luarocks
    manix
    moonlight-qt
    msmtp
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
    pyright
    python311Packages.pip
    python3Full
    rustup
    shellcheck
    signal-desktop-source
    slack
    terraform
    tree-sitter
    ttf_bitstream_vera
    unzip
    vanilla-dmz
    vegeta
    vendir
    vlc
    xclip
    yq-go
    zathura
  ];

  xresources.extraConfig = builtins.readFile ./files/Xresources;

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

  home.file.".gitconfig" = { source = ./files/gitconfig; };

  home.file."/code/lambda/.gitconfig" = { source = ./files/gitconfig-work; };

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
}
