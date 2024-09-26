{ nixpkgs, config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "ipv6.disable=1" ];

  boot.initrd.luks.devices."luks-c50a894f-4c4e-4966-9ea5-62270bb86c5f".device =
    "/dev/disk/by-uuid/c50a894f-4c4e-4966-9ea5-62270bb86c5f";
  networking.hostName = "rooster";
  networking.enableIPv6 = false;
  networking.timeServers = [ "192.168.1.4" ];
  # networking.wireless.enable = true;  # wireless via wpa_supplicant.

  networking.nameservers = [ "192.168.1.4" ];
  services.resolved.enable = true;

  services.mullvad-vpn = { enable = true; };

  networking.networkmanager.enable = true;

  time.timeZone = "America/Denver";

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  security.sudo.wheelNeedsPassword = false;

  users.users.ben = {
    isNormalUser = true;
    description = "ben";
    extraGroups =
      [ "audio" "dialout" "docker" "libvirtd" "networkmanager" "wheel" ];
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    vivaldi = {
      propietaryCodecs = true;
      enableWideVine = true;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    age
    git
    gnupg
    lsof
    pulseaudio-ctl
    silver-searcher
    sops
    twingate
    wget
    xorg.xinit
  ];

  # x11
  services.autorandr.enable = true;
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    videoDrivers = [ "nvidia" ];

    displayManager = {
      session = [{
        manage = "desktop";
        name = "default";
        start = "exec xmonad";
      }];

      lightdm = {
        enable = true;
        greeters.slick = { enable = true; };
      };
    };

    desktopManager = { wallpaper.mode = "fill"; };

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
  };

  services.displayManager.defaultSession = "default";

  location.latitude = 40.13;
  location.longitude = -105.43;

  services.twingate.enable = true;
  services.tailscale.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  services.openssh.enable = true;
  virtualisation.docker.enable = true;

  # https://nixos.wiki/wiki/Libvirt
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;

    # experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  programs.bash.promptInit = ''
    # Provide a nice prompt if the terminal supports it.
    if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
      PROMPT_COLOR="1;31m"
      ((UID)) && PROMPT_COLOR="1;32m"
      if [ -n "$INSIDE_EMACS" ] || [ "$TERM" = "eterm" ] || [ "$TERM" = "eterm-color" ]; then
        # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
        PS1="\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
      else
        PS1="\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
      fi
      if test "$TERM" = "xterm"; then
        PS1="\[\033]2;\h:\u:\w\007\]$PS1"
      fi
    fi
  '';

  # sops-nix configured via this README:
  # - https://github.com/Mic92/sops-nix/blob/4606d9b1595e42ffd9b75b9e69667708c70b1d68/README.md
  sops.defaultSopsFile = ../../secrets/sops.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;
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
}
