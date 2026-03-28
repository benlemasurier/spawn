{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    package = null; # installed via .dmg on macOS
    enableBashIntegration = true;
    settings = {
      theme = "Gruvbox Dark";
      font-family = "mononoki";
      font-size = 16;
      cursor-style = "block";
      cursor-style-blink = false;
      mouse-scroll-multiplier = 3;
      scrollback-limit = 10000;
      term = "xterm-256color";
      window-padding-x = 2;
      window-padding-y = 2;
    };
  };
}
