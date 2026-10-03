{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wsjtx
  ];
}
