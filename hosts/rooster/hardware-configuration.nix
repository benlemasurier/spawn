{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ "nvme" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/af89c46c-145b-41b8-8011-538d0b04bf05";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  boot.initrd.luks.devices."luks-1b6afcf8-c239-4018-948a-3d35403ed2ee" = {
    device = "/dev/disk/by-uuid/1b6afcf8-c239-4018-948a-3d35403ed2ee";
    allowDiscards = true;
    bypassWorkqueues = true;
  };
  boot.initrd.luks.devices."luks-2399bf84-a6f8-4f0b-bbcc-663fb41c5a99" = {
    device = "/dev/disk/by-uuid/2399bf84-a6f8-4f0b-bbcc-663fb41c5a99";
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A904-A81E";
    fsType = "vfat";
  };

  fileSystems."/storage" = {
    device = "/dev/disk/by-uuid/009d3e13-3e34-4ea1-8607-a2aaf3fe761e";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/82b4e8a2-a1fd-4e62-8fab-c325d60f6992"; }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
