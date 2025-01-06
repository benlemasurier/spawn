{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      auto-update = "off";
      font-family = "mononoki";
      font-size = 9;
      theme = "GruvboxDarkHard";
      window-decoration = false;
    };
  };
}
