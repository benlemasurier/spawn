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

  boot.kernel.sysctl."vm.swappiness" = 10;

  boot.initrd.luks.devices."luks-c50a894f-4c4e-4966-9ea5-62270bb86c5f" = {
    device = "/dev/disk/by-uuid/c50a894f-4c4e-4966-9ea5-62270bb86c5f";
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  networking.hostName = "rooster";
  networking.nameservers = [ "192.168.1.4" ];

  services.resolved.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  services.xserver.videoDrivers = [ "nvidia" ];

  # https://nixos.wiki/wiki/Libvirt
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      # package = pkgs.qemu_kvm;
      package = pkgs.qemu_full;
      runAsRoot = true;
    };
  };

  hardware.nvidia = {
    modesetting.enable = true;

    # keep the driver loaded to avoid cold-start latency on first use
    nvidiaPersistenced = true;

    # experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  sops.secrets."duplicity/env" = { };

  # backups
  # NOTE: this wouldn't work until a full backup was first completed.
  # `systemctl cat duplicity.service`, execute ExecStart cmd, replacing `incr` with `full`.
  # be sure to set env (password) from EnvironmentFile
  services.duplicity = {
    enable = true;
    frequency = "daily";
    root = "/home/ben";
    targetUrl = "file:///storage/duplicity-backups";
    secretFile = config.sops.secrets."duplicity/env".path;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
