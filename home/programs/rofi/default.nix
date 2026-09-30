{ hostname, ... }:

let
  isLaptop = hostname == "pine";
in
{
  programs.rofi = {
    enable = true;
    theme = "phant";
    settings = {
      font = if isLaptop then "mononoki 14" else "mononoki 20";
      "display-run" = ">_";
    };
  };

  home.file.".config/rofi/phant.rasi" = {
    source = ./phant.rasi;
  };
}
