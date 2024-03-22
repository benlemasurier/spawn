{ config, pkgs, inputs, ... }:

{
  imports = [
    ./completion.nix
    ./ftplugin.nix
    ./keymaps.nix
    ./options.nix
    ./plugins
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    vimAlias = true;
    viAlias = true;

    globals = {
      netrw_banner = 0; # don't show help banner

      gruvbox_contrast_dark = "hard";
      gruvbox_sign_column = "bg0";
    };

    colorschemes.gruvbox.enable = true;

    extraPlugins = with pkgs.vimPlugins; [ vim-vsnip vimwiki ];
  };
}
