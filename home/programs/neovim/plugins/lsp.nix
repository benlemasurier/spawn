{ pkgs, ... }:

{
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;

        keymaps = {
          silent = true;

          diagnostic = {
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };

          lspBuf = {
            "K" = "hover";
            "gD" = "declaration";
            "gR" = "references";
            "gd" = "definition";
            "gi" = "implementation";
            "gr" = "rename";
            "gM" = "type_definition";
            "<leader>ca" = "code_action";
            "<leader>f" = "format";
          };
        };

        servers = {
          bashls.enable = true;
          clangd.enable = true;
          dockerls.enable = true;
          helm_ls.enable = true;
          html.enable = true;
          jsonls.enable = true;
          nil_ls.enable = true;
          ruff.enable = true;
          terraformls.enable = true;
          yamlls.enable = true;

          pyright = {
            enable = true;
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "basic";
                  autoSearchPaths = true;
                  useLibraryCodeForTypes = true;
                  autoImportCompletions = true;
                };
              };
            };
          };

          gopls = {
            enable = true;

            settings = {
              gofumpt = true;
            };
          };

          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };
    };

    keymaps = [
      {
        options.desc = "Show diagnostic";
        action.__raw = "function() vim.diagnostic.open_float() end";
        key = "gl";
        mode = "n";
      }
    ];
  };
}
