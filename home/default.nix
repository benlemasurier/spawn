{ config, pkgs, ... }:

{
  home.stateVersion = "23.05";

  imports = [
    ./programs/dunst.nix
    ./programs/polybar.nix
    ./programs/neovim.nix
    ./programs/rofi
    ./xdg
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    historySize = -1;
    historyFileSize = -1;
    historyControl = [ "ignoredups" "ignorespace" ];

    shellAliases = {
      bc = "bc -l";    # always load math lib for decimals
      cat = "bat -pp"; # plain, disable paging
      tf = "terraform";
      ls = "eza";
      mutt = "neomutt";
    };
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableAliases = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "gruvbox-dark";
      style = "plain";
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg.speechSynthesisSupport = false;
    };
  };

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
    esphome
    eza
    feh
    file
    freecad
    gdu
    ghc
    gnumake
    gnupg
    go
    kicad
    kubectl
    kubernetes-helm
    htop
    isort
    jq
    killall
    libnotify
    luarocks
    manix
    neomutt
    nodejs
    openfortivpn
    pass
    pavucontrol
    pinentry-curses
    poetry
    polkit_gnome
    polybar-pulseaudio-control
    pyright
    python311Packages.pip
    python3Full
    rustup
    signal-desktop
    terraform
    tree-sitter
    ttf_bitstream_vera
    unzip
    vagrant
    vanilla-dmz
    vlc
    xclip
    zathura

    # fonts
    dejavu_fonts
    font-awesome
    mononoki
    nerdfonts
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

  home.file.".gitconfig" = {
    source = ./files/gitconfig;
  };

  home.file."/code/lambda/.gitconfig" = {
    source = ./files/gitconfig-work;
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
    pinentryFlavor = "curses";
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
