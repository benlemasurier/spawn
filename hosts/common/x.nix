{
  nixpkgs,
  config,
  pkgs,
  ...
}:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.autorandr.enable = true;

  services.xserver = {
    enable = true;

    xkb.layout = "us";

    displayManager = {
      session = [
        {
          manage = "desktop";
          name = "default";
          start = "exec xmonad";
        }
      ];

      lightdm = {
        enable = true;
        greeters.slick = {
          enable = true;
        };
      };
    };

    desktopManager = {
      wallpaper.mode = "fill";
    };

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
  };

  services.displayManager.defaultSession = "default";
}
