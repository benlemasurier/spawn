{ hostname, ... }:

let
  isLaptop = hostname == "pine";
in
{
  programs.rofi = {
    enable = true;
    pass.enable = true;
    font = if isLaptop then "mononoki 14" else "mononoki 20";
    theme = "phant";
    extraConfig = {
      "display-run" = ">_";
    };
  };

  home.file.".config/rofi/phant.rasi" = {
    source = ./phant.rasi;
  };
}
