{ lib, ... }:

{
  services.polybar = {
    enable = true;
    script = "polybar default &";
    config = {
      "colors" = {
        background = "#222";
        background-alt = "#444";
        foreground = "#dfdfdf";
        foreground-alt = "#55";
        primary = "#ffb52a";
        secondary = "#e60053";
        alert = "#bd2c40";
      };
      "global/wm" = {
        margin-top = 0;
	margin-bottom = 0;
      };
      "bar/default" = {
        width = "100%";
        height = 50;
        offset-x = 0;
        offset-y = 0;
        background = "\${colors.background}";
        foreground = "\${colors.foreground}";
        overline-size = 2;
        overline-color = "#f00";
        underline-size = 0;
        underline-color = "#00f";
        border-bottom-size = 1;
        border-bottom-color = "#333";
        spacing = 1;
        padding-left = 1;
        padding-right = 1;
        module-margin-left = 1;
        module-margin-right = 1;
        font-0 = "mononoki:pixelsize=20;5";
        font-1 = "Bitstream Vera Sans Mono:size=14:heavy:fontformat=truetype;";
        font-2 = "DejaVu Sans Mono:size=14:heavy:fontformat=truetype;3";
        font-3 = "Font Awesome 6 Free:size=20:fontformat=truetype;5";
        modules-left = "ewmh xwindow";
        modules-center = "";
        modules-right = "pulseaudio-control filesystem tray date";
      };
      "module/tray" = {
        type = "internal/tray";
      };
      "module/ewmh" = {
        type = "internal/xworkspaces";
        enable-click = false;
        enable-scroll = false;
        label-active = "%name%";
        label-occupied = "%name%";
        label-urgent = "%name%";
        label-empty = "%name%";
        label-active-padding = 1;
        label-occupied-padding = 1;
        label-urgent-padding = 1;
        label-empty-padding = 1;
        label-active-background = "#3f3f3f";
      };
      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:90:...%";
      };
      "module/filesystem" = {
        type = "internal/fs";
        interval = 25;
        mount-0 = "/";
        label-mounted = "%mountpoint%: %percentage_free%";
        label-unmounted = "%mountpoint%: not mounted";
        label-unmounted-foreground = "\${colors.foreground-alt}";
      };
      "module/date" = {
        type = "internal/date";
        interval = 5;
        date = "";
        date-alt = "%Y-%m-%d";
        time = "%l:%M";
        time-alt = "%H:%M:%S";
        format-prefix = " ";
        format-prefix-foreground = "\${colors.foreground-alt}";
        format-underline = "#0a6cf5";
	label = "%date% %time%";
      };
      "module/pulseaudio-control" = {
        type = "custom/script";
        tail = true;
        label-padding = 2;
        exec = "pulseaudio-control --icons-volume \" , \" --icon-muted \"\" --node-nicknames-from \"device.description\" --node-nickname \"alsa_output.pci-0000_2d_00.1.hdmi-stereo:\" --node-nickname \"alsa_output.pci-0000_2f_00.4.analog-stereo:\" listen";
        click-right = "exec pavucontrol &";
        click-left = "pulseaudio-control togmute";
        click-middle = "pulseaudio-control next-sink";
        scroll-up = "pulseaudio-control --volume-max 130 up";
        scroll-down = "pulseaudio-control --volume-max 130 down";
      };
    };
  };

  # ugh, fix polybar systemd service PATH
  # see: https://github.com/nix-community/home-manager/issues/1616
  systemd.user.services.polybar = {
    Service.Environment = lib.mkForce "";
    Service.PassEnvironment = "PATH";
  };
}
