{ config, lib, ... }: {
  programs.nixvim = {
    globals = {
      mapleader = ",";
      maplocalleader = ".";
    };

    keymaps = let
      normal = lib.mapAttrsToList (key: action: {
        mode = "n";
        inherit action key;
      }) {
        # split navigation (ctrl-j/k)
        "<C-j>" = "<C-W>j<C-W>_";
        "<C-k>" = "<C-W>k<C-W>_";

        # quickfix and location list navigation
        "<C-n>" = ":cnext<CR>zz";
        "<C-p>" = ":cprev<CR>zz";
        "<leader>n" = ":lnext<CR>zz";
        "<leader>p" = ":lprev<CR>zz";
        "<leader>c" = ":cclose<CR>:lclose<CR>";
      };
      visual = lib.mapAttrsToList (key: action: {
        mode = "v";
        inherit action key;
      }) {
        # move selected lines up/down
        "J" = ":m '>+1<CR>gv=gv";
        "K" = ":m '>-2<CR>gv=gv";

        # retain selection when shifting indentation
        ">" = ">gv";
        "<" = "<gv";
      };
    in config.nixvim.helpers.keymaps.mkKeymaps { options.silent = true; }
    (normal ++ visual);
  };
}
