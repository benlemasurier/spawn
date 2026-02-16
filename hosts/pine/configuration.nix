{
  nixpkgs,
  config,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "ipv6.disable=1" ];
  boot.resumeDevice = "/dev/mapper/luks-d54ce8a7-14cf-4eed-a121-aab6d88d82a6";

  services.logind.lidSwitch = "suspend-then-hibernate";
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=75min
  '';

  networking.hostName = "pine";
  networking.enableIPv6 = false;
  networking.timeServers = [
    "192.168.1.4"
    "0.nixos.pool.ntp.org"
    "1.nixos.pool.ntp.org"
  ];
  # networking.wireless.enable = true;  # wireless via wpa_supplicant.

  services.mullvad-vpn = {
    enable = true;
  };

  security.pam.services.i3lock.enable = true;
  security.pam.services.i3lock.fprintAuth = true;

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

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ben" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    age
    brightnessctl
    easyeffects
    git
    gnupg
    lsof
    pulseaudio
    silver-searcher
    sops
    twingate
    wget
    xinit
  ];

  # fingerprint reader
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  # x11
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
  #virtualisation.libvirtd = {
  #  enable = true;
  #  qemu = {
  #    # package = pkgs.qemu_kvm;
  #    package = pkgs.qemu_full;
  #    runAsRoot = true;
  #  };
  #};

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  #services.k3s = {
  #   enable = true;
  #    role = "server";
  #    # extraFlags = toString [
  #    #   "--docker"
  #    # ];
  #  };

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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.settings.auto-optimise-store = true;
}
