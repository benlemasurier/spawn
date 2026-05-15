final: prev: {
  xwobf = final.stdenv.mkDerivation {
    pname = "xwobf";
    version = "unstable-2020-01-04";
    src = final.fetchFromGitHub {
      owner = "glindstedt";
      repo = "xwobf";
      rev = "4ff96e34a155b32336c65d301f88b561b9450b82";
      sha256 = "sha256-twsfMlqrYY5SYqHcZCXJTZkBrDJWgftdpG41FPBBovo=";
    };
    nativeBuildInputs = [ final.pkg-config ];
    buildInputs = [
      final.imagemagick
      final.libxcb
    ];
    installFlags = [ "PREFIX=$(out)" ];
  };

  speakeasy = final.stdenv.mkDerivation rec {
    pname = "speakeasy";
    version = "1.761.8";

    src = final.fetchzip {
      url = "https://github.com/speakeasy-api/speakeasy/releases/download/v${version}/speakeasy_linux_amd64.zip";
      hash = "sha256-CWiEdRvP1Wz3fErtwOYSfSeZCFIXzp/ag87RwvKn9gw=";
      stripRoot = false;
    };

    nativeBuildInputs = [ final.autoPatchelfHook ];
    buildInputs = [ final.stdenv.cc.cc.lib ];

    installPhase = ''
      install -Dm755 $src/speakeasy $out/bin/speakeasy
    '';
  };
}
