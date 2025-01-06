{
  programs.nixvim.plugins.floaterm = {
    enable = true;

    settings = {
      title = "";
      keymaps.toggle = "<C-space>";
    };
  };
}
