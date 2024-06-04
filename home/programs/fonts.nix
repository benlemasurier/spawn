{ pkgs, ... }: {
  home.packages = with pkgs; [ dejavu_fonts font-awesome mononoki nerdfonts ];
}
