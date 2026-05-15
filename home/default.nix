{
  config,
  pkgs,
  lib,
  hostname ? "rooster",
  ...
}:

{
  imports = [
    ./common.nix
    ./accounts.nix
    ./programs/alacritty.nix
    ./programs/dunst.nix
    ./programs/meshtastic.nix
    ./programs/firefox.nix
    ./programs/khal.nix
    ./programs/polybar.nix
    ./programs/rofi
    ./xdg
  ];

  home.packages = with pkgs; [
    asdbctl
    cc65
    feh
    gdb
    higan
    i3lock
    ipmitool
    libnotify
    libx11
    moonlight-qt
    nh
    open-policy-agent
    pavucontrol
    polkit_gnome
    polybar-pulseaudio-control
    signal-desktop
    slack
    speakeasy
    vanilla-dmz
    vlc
    xclip
    xss-lock
    xwobf
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
    inactiveInterval = 10;
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
