{
  programs.nixvim.plugins.none-ls = {
    enable = true;
    enableLspFormat = true;
    sources = {
      diagnostics = {
        golangci_lint.enable = true;
        statix.enable = true;
      };

      formatting = {
        black.enable = true;
        isort.enable = true;
        gofmt.enable = true;
        gofumpt.enable = true;
        goimports.enable = true;
        nixfmt.enable = true;
        markdownlint.enable = true;
      };

      code_actions = { refactoring.enable = true; };
    };
  };
}
