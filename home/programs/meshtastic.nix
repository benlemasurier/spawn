{ pkgs, ... }:

{
  home.packages = with pkgs; [
    contact
    esptool
    python3Packages.meshtastic
    python3Packages.pyserial
  ];
}
