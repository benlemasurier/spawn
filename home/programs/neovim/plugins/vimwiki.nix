{
  programs.nixvim.plugins.vimwiki = {
    enable = true;

    settings = {
      path = "~/vimwiki/";
      syntax = "markdown";
      ext = ".md";
    };
  };
}
