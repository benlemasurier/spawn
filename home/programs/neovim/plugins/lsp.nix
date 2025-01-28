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

          # override to enable cc65 support
          # FIXME: remove on asm-lsp's next release
          asm_lsp = {
            enable = true;
            package = pkgs.rustPlatform.buildRustPackage {
              pname = "asm-lsp";
              version = "0.9.0";

              src = pkgs.fetchFromGitHub {
                owner = "bergercookie";
                repo = "asm-lsp";
                rev = "b74fc0f96c852b6721f90a50482819a00b0bc695";
                hash = "sha256-0Vh2EQrJqGltqdM6q5hGaS36Oyy1V531tXX242rLfsA=";
              };

              cargoHash = "sha256-fJN/r+JAutm07YIoX7x1nZrSf5H3aKHbvlpiN+sqEz8=";
              nativeBuildInputs = [ pkgs.pkg-config ];
              buildInputs = [ pkgs.openssl ];

              # tests expect ~/.cache/asm-lsp to be writable
              preCheck = ''
                export HOME=$(mktemp -d)
              '';
            };
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
