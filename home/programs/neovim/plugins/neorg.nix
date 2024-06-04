{
  programs.nixvim.plugins.neorg = {
    enable = true;
    lazyLoading = true;
    modules = {
      "core.defaults".__empty = null;
      "core.dirman".config = {
        workspaces = {
          notes = "~/notes";
        };
        default_workspace = "notes";
      };
      "core.concealer".__empty = null;
      "core.completion".config.engine = "nvim-cmp";
    };
  };
}
