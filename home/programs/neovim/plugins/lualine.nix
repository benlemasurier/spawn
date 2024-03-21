{
  programs.nixvim.plugins.lualine = {
    enable = true;

    iconsEnabled = false;
    sections.lualine_x = [ "encoding" "filetype" ];
  };
}
