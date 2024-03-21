{ config, pkgs, inputs, ... }:

{
  imports =
    [ ./plugins ./completion.nix inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;

    vimAlias = true;
    viAlias = true;

    globals = {
      mapleader = ",";
      netrw_banner = 0; # don't show help banner

      gruvbox_contrast_dark = "hard";
      gruvbox_sign_column = "bg0";
    };

    options = {
      # files
      swapfile = false; # don't create swapfiles
      undodir = "${config.xdg.stateHome}/.vim/backups";
      undofile = true;

      # windows
      title = true; # set the window title to the current filename
      updatetime = 300; # CursorHold event timeout (ms)
      winminheight = 0; # minimum window height
      signcolumn = "yes"; # always reserve space for diagnostics

      # scrolling
      scrolloff = 8; # minimum lines to keep above/below cursor
      sidescrolloff = 15; # minimum columns to keep left/right of cursor

      # lines
      number = true; # show line numbers
      wrap = false; # don't wrap lines

      # tabs
      softtabstop = 4;
      shiftwidth = 4;

      # syntax
      showmatch = true; # show matching brackets

      # indentation
      # fixme: disabling for now because this is what's causing comments to
      # start at the beginning of the line
      smartindent = false;

      # listchars
      listchars = {
        eol = "↵"; # end of line
        nbsp = "."; # non-breaking spaces
        trail = "·"; # trailing spaces
        tab = "  "; # don't show tabs
        extends = "…"; # line wrap
      };

      # searching
      ignorecase = true; # ignore case when searching
      smartcase = true; # unless query contains a capital
    };

    colorschemes.gruvbox.enable = true;

    plugins = {
      lsp-format.enable = true;

      lualine = {
        enable = true;
        iconsEnabled = false;
        sections.lualine_x = [ "encoding" "filetype" ];
      };

      gitsigns = {
        enable = true;
        numhl = true;
      };

      neorg = {
        enable = true;
        lazyLoading = true;
        modules = {
          "core.defaults".__empty = null;
          "core.dirman".config = {
            workspaces = { notes = "~/notes"; };
            default_workspace = "notes";
          };
          "core.concealer".__empty = null;
          "core.completion".config.engine = "nvim-cmp";
        };
      };

      treesitter = {
        enable = true;
        indent = true;
      };

      none-ls = {
        enable = true;
        enableLspFormat = true;
        sources = {
          diagnostics = {
            golangci_lint.enable = true;
            statix.enable = true;
          };

          formatting = {
            gofmt.enable = true;
            gofumpt.enable = true;
            goimports.enable = true;
            nixfmt.enable = true;
            markdownlint.enable = true;
          };
        };
      };
    };

    files."ftplugin/c.lua".extraConfigLua = ''
      vim.opt.expandtab = true
    '';

    files."ftplugin/css.lua".extraConfigLua = ''
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
    '';

    files."ftplugin/go.lua".extraConfigLua = ''
      vim.opt.expandtab = false
      vim.opt.shiftwidth = 8
    '';

    files."ftplugin/html.lua".extraConfigLua = ''
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
    '';

    files."ftplugin/json.lua".extraConfigLua = ''
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
    '';

    files."ftplugin/nix.lua".extraConfigLua = ''
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
    '';

    files."ftplugin/yaml.lua".extraConfigLua = ''
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt_local.indentkeys:remove({ '0#', '<:>' })
    '';

    keymaps = [
      # move selected lines up/down
      {
        action = ":m '>+1<CR>gv=gv";
        key = "J";
        mode = [ "v" ];
      }
      {
        action = ":m '>-2<CR>gv=gv";
        key = "K";
        mode = [ "v" ];
      }

      # retain selection when shifting indentation
      {
        action = ">gv";
        key = ">";
        mode = [ "v" ];
        options = { noremap = true; };
      }
      {
        action = "<gv";
        key = "<";
        mode = [ "v" ];
        options = { noremap = true; };
      }

      # split navigation (ctrl-j/k)
      {
        action = "<C-W>j<C-W>_";
        key = "<C-j>";
        mode = [ "n" ];
      }
      {
        action = "<C-W>k<C-W>_";
        key = "<C-k>";
        mode = [ "n" ];
      }

      # quickfix and location list navigation
      {
        action = ":cnext<CR>zz";
        key = "<C-n>";
        mode = [ "n" ];
      }
      {
        action = ":cprev<CR>zz";
        key = "<C-p>";
        mode = [ "n" ];
      }
      {
        action = ":lnext<CR>zz";
        key = "<leader>n";
        mode = [ "n" ];
      }
      {
        action = ":lprev<CR>zz";
        key = "<leader>p";
        mode = [ "n" ];
      }
      {
        action = ":cclose<CR>:lclose<CR>";
        key = "<leader>c";
        mode = [ "n" ];
      }
    ];

    extraPlugins = with pkgs.vimPlugins; [ vim-vsnip vimwiki ];
  };
}
