{ pkgs, ... }: {
  home.packages = with pkgs; [ natscli nats-server nats-top nkeys nsc ];
}
