{ ... }:

let
  bg_color = "#181818";
in {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        alignment = "left";
        allow_markup = "true";
        follow = "mouse";
        font = "mononoki 10";
        format = "<b>%s</b>\\n%b";
        frame_width = "1";
        frame_color = "#383838";

        width = "400";
        height = "200";
        origin = "top-right";
        offset = "2x25"; # <horizontal>x<vertical>
        notification_limit = "5";
        padding = 10;
        idle_threshold = 120;
        ignore_newline = "false";
        indicate_hidden = "true";
        line_height = 0;
        separator_color = "frame";
        separator_height = 1;
        show_age_threshold = 60;
        sort = "true";
        startup_notification = "false";
        sticky_history = "true";
        word_wrap = "true";
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
      };

      urgency_low = {
        background = "${bg_color}";
        foreground = "#e3c7af";
        timeout = 10;
      };

      urgency_normal = {
        background = "${bg_color}";
        foreground = "#aed7e3";
        timeout = 20;
      };

      urgency_critical = {
        background = "${bg_color}";
        foreground = "#a54242";
        timeout = 0;
      };
    };
  };
}
