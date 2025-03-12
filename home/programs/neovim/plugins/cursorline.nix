{
  programs.nixvim.plugins.cursorline = {
    enable = true;

    settings = {
      cursorline.enable = false;
      cursorword.enable = true;
    };
  };
}
