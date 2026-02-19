{ hostname, ... }:

let
  isLaptop = hostname == "pine";
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      general.live_config_reload = true;

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      window.padding = {
        x = 2;
        y = 2;
      };

      cursor = {
        style = "Block";
        unfocused_hollow = true;
      };

      font = {
        size = if isLaptop then 7.0 else 9.5;
        normal = {
          family = "mononoki";
          style = "Regular";
        };
      };

      colors = {
        draw_bold_text_with_bright_colors = true;
        primary = {
          background = "#1d2021";
          foreground = "#ebdbb2";
          bright_foreground = "#fbf1c7";
          dim_foreground = "#a89984";
        };
        cursor = {
          cursor = "CellForeground";
          text = "CellBackground";
        };
        vi_mode_cursor = {
          cursor = "CellForeground";
          text = "CellBackground";
        };
        selection = {
          background = "CellForeground";
          text = "CellBackground";
        };
        normal = {
          black = "#1d2021";
          red = "#cc241d";
          green = "#98971a";
          yellow = "#d79921";
          blue = "#458588";
          magenta = "#b16286";
          cyan = "#689d6a";
          white = "#a89984";
        };
        bright = {
          black = "#928374";
          red = "#fb4934";
          green = "#b8bb26";
          yellow = "#fabd2f";
          blue = "#83a598";
          magenta = "#d3869b";
          cyan = "#8ec07c";
          white = "#ebdbb2";
        };
        dim = {
          black = "#32302f";
          red = "#9d0006";
          green = "#79740e";
          yellow = "#b57614";
          blue = "#076678";
          magenta = "#8f3f71";
          cyan = "#427b58";
          white = "#928374";
        };
        indexed_colors = [
          {
            index = 66;
            color = "#458588";
          }
          {
            index = 72;
            color = "#689d6a";
          }
          {
            index = 106;
            color = "#98971a";
          }
          {
            index = 108;
            color = "#8ec07c";
          }
          {
            index = 109;
            color = "#83a598";
          }
          {
            index = 124;
            color = "#cc241d";
          }
          {
            index = 132;
            color = "#b16286";
          }
          {
            index = 142;
            color = "#b8bb26";
          }
          {
            index = 166;
            color = "#d65d0e";
          }
          {
            index = 167;
            color = "#fb4934";
          }
          {
            index = 172;
            color = "#d79921";
          }
          {
            index = 175;
            color = "#d3869b";
          }
          {
            index = 208;
            color = "#fe8019";
          }
          {
            index = 214;
            color = "#fabd2f";
          }
          {
            index = 223;
            color = "#ebdbb2";
          }
          {
            index = 229;
            color = "#fbf1c7";
          }
          {
            index = 234;
            color = "#1d2021";
          }
          {
            index = 235;
            color = "#282828";
          }
          {
            index = 236;
            color = "#32302f";
          }
          {
            index = 237;
            color = "#3c3836";
          }
          {
            index = 239;
            color = "#504945";
          }
          {
            index = 241;
            color = "#665c54";
          }
          {
            index = 243;
            color = "#7c6f64";
          }
          {
            index = 245;
            color = "#928374";
          }
          {
            index = 246;
            color = "#a89984";
          }
          {
            index = 248;
            color = "#bdae93";
          }
          {
            index = 250;
            color = "#d5c4a1";
          }
        ];
      };
    };
  };
}
