{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./completion.nix
    ./ftplugin.nix
    ./keymaps.nix
    ./options.nix
    ./plugins
    inputs.nixvim.homeModules.nixvim
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

    extraPlugins = with pkgs.vimPlugins; [
      vim-vsnip
      (himalaya-vim.overrideAttrs (old: {
        src = pkgs.fetchFromGitHub {
          owner = "pimalaya";
          repo = "himalaya-vim";
          rev = "bb8d0ebbe82b1ba1d487354fab86d81f12a82c4d";
          sha256 = "sha256-YW4qoCDLg/LSUKkptvecoa4n1niwZLeiSBCFLCY30j4=";
        };
        nvimSkipModule = [
          "himalaya.folder.pickers.telescope"
          "himalaya.folder.pickers.fzflua"
        ];
      }))
    ];
  };
}
