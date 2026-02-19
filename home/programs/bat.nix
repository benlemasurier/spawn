{ pkgs, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "gruvbox-dark";
      style = "plain";
    };

    extraPackages = builtins.attrValues {
      inherit (pkgs.bat-extras)

        # manpage viewer
        batman
        ;
    };
  };
}
