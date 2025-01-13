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
          };
        };

        servers = {
          ansiblels.enable = true;
          bashls.enable = true;
          dockerls.enable = true;
          gopls.enable = true;
          helm_ls.enable = true;
          html.enable = true;
          jsonls.enable = true;
          nil_ls.enable = true;
          ruff.enable = true;
          terraformls.enable = true;
          yamlls.enable = true;

          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };
    };

    keymaps = [{
      options.desc = "Show diagnostic";
      action.__raw = "function() vim.diagnostic.open_float() end";
      key = "gl";
      mode = "n";
    }];
  };
}
