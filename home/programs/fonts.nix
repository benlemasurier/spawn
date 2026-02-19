{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dejavu_fonts
    font-awesome
    mononoki
    nerd-fonts.symbols-only
  ];
}
