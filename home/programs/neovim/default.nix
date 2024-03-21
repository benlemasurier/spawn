{ config, pkgs, inputs, ... }:

{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

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
      floaterm.enable = true;
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

      lsp = {
        enable = true;

        servers = {
          ansiblels.enable = true;
          bashls.enable = true;
          dockerls.enable = true;
          gopls.enable = true;
          html.enable = true;
          jsonls.enable = true;
          nil_ls.enable = true;
          ruff-lsp.enable = true;
          terraformls.enable = true;
          yamlls.enable = true;

          rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };

        keymaps.lspBuf = {
          "K" = "hover";
          "gD" = "declaration";
          "gR" = "references";
          "gd" = "definition";
          "gi" = "implementation";
          "gr" = "rename";
          "gM" = "type_definition";
        };
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

      # completion
      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-vsnip.enable = true;

      cmp = {
        enable = true;

        settings = {
          snippet.expand = ''
            function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end
          '';

          window = {
            completion = {
              winhighlight =
                "FloatBorder:CmpBorder,Normal:CmpPmenu,Search:PmenuSel";
              scrollbar = true;
              sidePadding = 0;
              border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
            };

            documentation = {
              border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
              winhighlight =
                "FloatBorder:CmpBorder,Normal:CmpPmenu,Search:PmenuSel";
            };
          };

          sources = [ { name = "nvim_lsp"; } { name = "buffer"; } ];

          mapping = {
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-k>" = "cmp.mapping.select_prev_item()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" =
              "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<CR>" =
              "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })";
          };
        };
      };
    };

    # prevent completion for normal text
    extraConfigLuaPost = ''
      require('cmp').setup({
          sources = {
                  {
                          name = 'nvim_lsp',
                          entry_filter = function(entry, ctx)
                                  return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
                          end,
                  },
          },
      })
    '';

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

      # toggle terminal with Ctrl-<space>
      {
        action = ":FloatermToggle<CR>";
        key = "<C-space>";
        mode = [ "n" ];
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        action = "<C-\\><C-n>:FloatermToggle<CR>";
        key = "<C-space>";
        mode = [ "t" ];
        options = {
          noremap = true;
          silent = true;
        };
      }
    ];

    extraPlugins = with pkgs.vimPlugins; [ vim-vsnip vimwiki ];
  };
}
