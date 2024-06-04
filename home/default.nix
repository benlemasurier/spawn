{ config, pkgs, lib, fetchFromGitHub, buildGoModule, ... }:

{
  home.stateVersion = "23.05";

  imports = [
    ./programs/bat.nix
    ./programs/dunst.nix
    ./programs/fonts.nix
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
      mutt = "neomutt";
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
    _1password
    _1password-gui
    alacritty
    ansible
    ansible-lint
    awscli2
    bandwhich
    bc
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
    go
    golangci-lint
    golint
    hadolint
    kubectl
    kubernetes-helm
    htop
    isort
    jq
    k9s
    killall
    libnotify
    luarocks
    manix
    neomutt
    nh
    nodejs
    openfortivpn
    openssl
    pass
    pavucontrol
    plantuml
    #poetry
    polkit_gnome
    polybar-pulseaudio-control
    pyright
    python311Packages.pip
    python3Full
    rustup
    signal-desktop
    shellcheck
    slack
    terraform
    tree-sitter
    ttf_bitstream_vera
    unzip
    vagrant
    vanilla-dmz
    vault
    vendir
    vlc
    xclip
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
