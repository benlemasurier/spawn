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
}
