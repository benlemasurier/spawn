{ ... }:

{

  programs.rofi = {
    enable = true;
    pass.enable = true;
    font = "mononoki 14";
    theme = "phant";
    extraConfig = {
      "display-run" = ">_";
    };
  };

  home.file.".config/rofi/phant.rasi" = {
    source = ./phant.rasi;
  };
}
