{
  pkgs,
  hostname ? "rooster",
  ...
}:

{
  home.stateVersion = "23.05";

  imports = [
    ./programs/bash.nix
    ./programs/bat.nix
    ./programs/fonts.nix
    ./programs/git.nix
    ./programs/nats.nix
    ./programs/neovim
    ./programs/tmux.nix
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  home.packages = with pkgs; [
    silver-searcher
    ansible
    ansible-lint
    awscli2
    bison
    bc
    buildkite-cli
    check-jsonschema
    clang-tools
    claude-code
    cscope
    dig
    dive
    esphome
    eza
    file
    gcc
    flex
    gdu
    ghc
    gnumake
    gnupg

    # golang
    delve
    go
    go-critic
    golangci-lint
    golines
    golint
    gomodifytags
    gotests
    gotestsum
    gotools
    govulncheck
    iferr
    impl
    mockgen
    reftools
    revive
    richgo

    graphviz
    (pkgs.go-migrate.overrideAttrs (oldAttrs: {
      tags = [ "postgres" ];
    }))
    hadolint
    himalaya
    htop
    httpie
    hurl
    isort
    jq
    k9s
    killall
    kind
    kubectl
    kubelogin-oidc
    kubernetes-helm
    kubevirt
    kustomize
    libusb1
    luarocks
    manix
    msmtp
    ncurses
    ncurses.dev
    nodejs
    openfortivpn
    openssl
    pass
    pkg-config
    plantuml
    poetry
    postgresql
    pre-commit
    pyright
    python3Packages.pip
    python3
    quilt
    rustup
    shellcheck
    step-cli
    terraform
    tree-sitter
    ttf_bitstream_vera
    universal-ctags
    unzip
    uv
    vegeta
    vendir
    yq-go
    zathura
  ];

  home.file.".quiltrc" = {
    source = ./files/quiltrc;
  };
}
