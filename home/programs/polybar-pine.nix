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
        height = 25;
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
        font-0 = "mononoki:pixelsize=12;3";
        font-1 = "Bitstream Vera Sans Mono:size=14:heavy:fontformat=truetype;";
        font-2 = "DejaVu Sans Mono:size=14:heavy:fontformat=truetype;3";
        font-3 = "Font Awesome 6 Free:size=16:fontformat=truetype;5";
        font-4 = "Symbols Nerd Font Mono:size=12;3";
        font-5 = "Battery Symbols:size=21;-10";
        modules-left = "ewmh xwindow";
        modules-center = "";
        modules-right = "pulseaudio-control filesystem network battery tray date";
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
      "module/battery" = {
        type = "internal/battery";
        full-at = 99;
        battery = "BAT0";
        adapter = "AC";
        poll-interval = 5;

        format-charging = "<animation-charging>";
        format-discharging = "<ramp-capacity>";
        format-full = "󲃉";

        ramp-capacity-0 = "󲁥";
        ramp-capacity-0-foreground = "\${colors.alert}";
        ramp-capacity-1 = "󲁯";
        ramp-capacity-1-foreground = "\${colors.alert}";
        ramp-capacity-2 = "󲁹";
        ramp-capacity-3 = "󲂃";
        ramp-capacity-4 = "󲂍";
        ramp-capacity-5 = "󲂗";
        ramp-capacity-6 = "󲂡";
        ramp-capacity-7 = "󲂫";
        ramp-capacity-8 = "󲂵";
        ramp-capacity-9 = "󲂿";

        animation-charging-0 = "󲀀";
        animation-charging-1 = "󲀔";
        animation-charging-2 = "󲀨";
        animation-charging-3 = "󲀼";
        animation-charging-4 = "󲁐";
        animation-charging-5 = "󲁤";
        animation-charging-framerate = 750;
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
        exec = ''pulseaudio-control --icons-volume " " --icon-muted "󰝟" --node-nicknames-from "device.description" --node-nickname "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__Speaker__sink:󰓃" --node-nickname "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__Headphones__sink:󰋋" --node-nickname "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__HDMI1__sink:󰍹" --node-nickname "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__HDMI2__sink:󰍹" --node-nickname "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__HDMI3__sink:󰍹" listen'';
        click-right = "exec pavucontrol &";
        click-left = "pulseaudio-control togmute";
        click-middle = "pulseaudio-control next-sink";
        scroll-up = "pulseaudio-control --volume-max 130 up";
        scroll-down = "pulseaudio-control --volume-max 130 down";
      };
      "module/network" = {
        type = "internal/network";
        interface = "wlp0s20f3";
        interface-type = "wireless";
        interval = 3;

        format-connected = "<ramp-signal>";
        format-disconnected = "<label-disconnected>";
        label-disconnected = "󰤮";
        label-disconnected-foreground = "\${colors.foreground-alt}";

        ramp-signal-0 = "󰤯";
        ramp-signal-1 = "󰤟";
        ramp-signal-2 = "󰤢";
        ramp-signal-3 = "󰤥";
        ramp-signal-4 = "󰤨";
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
