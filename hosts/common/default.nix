{
  nixpkgs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./programs.nix
    ./x.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "ipv6.disable=1" ];

  networking.networkmanager.enable = true;

  networking.enableIPv6 = false;
  networking.timeServers = [
    "192.168.1.4"
    "0.nixos.pool.ntp.org"
    "1.nixos.pool.ntp.org"
  ];
  # networking.wireless.enable = true;  # wireless via wpa_supplicant.

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  time.timeZone = "America/Denver";

  location.latitude = 40.13;
  location.longitude = -105.43;

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  security.sudo.wheelNeedsPassword = false;

  users.users.ben = {
    isNormalUser = true;
    description = "ben";
    extraGroups = [
      "audio"
      "dialout"
      "docker"
      "libvirtd"
      "networkmanager"
      "wheel"
    ];
  };

  # allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    vivaldi = {
      propietaryCodecs = true;
      enableWideVine = true;
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.settings.auto-optimise-store = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  services.twingate.enable = true;
  services.tailscale.enable = true;

  services.mullvad-vpn = {
    enable = true;
  };

  services.openssh.enable = true;
  virtualisation.docker.enable = true;

  # sops-nix configured via this README:
  # - https://github.com/Mic92/sops-nix/blob/4606d9b1595e42ffd9b75b9e69667708c70b1d68/README.md
  sops.defaultSopsFile = ../../secrets/sops.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;
}
