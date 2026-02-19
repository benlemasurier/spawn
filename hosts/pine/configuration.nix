{
  nixpkgs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../common
    ./hardware-configuration.nix
  ];

  boot.resumeDevice = "/dev/mapper/luks-d54ce8a7-14cf-4eed-a121-aab6d88d82a6";

  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=75min
  '';

  networking.hostName = "pine";

  security.pam.services.i3lock.enable = true;
  security.pam.services.i3lock.fprintAuth = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ben" ];
  };

  # fingerprint reader
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  fonts.packages = [
    (pkgs.stdenvNoCC.mkDerivation {
      pname = "battery-symbols";
      version = "unstable";
      src = pkgs.fetchurl {
        url = "https://github.com/cawaltrip/battery-symbols/raw/main/BatterySymbols-Regular.ttf";
        sha256 = "sha256-yIxusD/d1FO9xcBEpR9opSVZodqnNGSrK4E9SiRa1mE=";
      };
      dontUnpack = true;
      installPhase = ''
        install -Dm444 $src $out/share/fonts/truetype/BatterySymbols-Regular.ttf
      '';
    })
  ];

  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = false;
      tappingDragLock = true;
      clickMethod = "clickfinger";
      accelProfile = "adaptive";
      accelSpeed = "0.2";
      disableWhileTyping = true;
      scrollMethod = "twofinger";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
