{
  programs.nixvim.files = {
    /*
      "ftplugin/c.lua".extraConfigLua = ''
         vim.opt_local.expandtab = false
         vim.opt_local.cindent = true;
         vim.opt_local.smartindent = false;
         vim.opt_local.autoindent = true;

         -- auto-format on save
         vim.api.nvim_create_autocmd("BufWritePre", {
           buffer = 0,
           callback = function()
             vim.lsp.buf.format({ async = false })
           end,
         })
       '';
    */
    "ftplugin/c.lua".extraConfigLua = ''
      vim.opt_local.expandtab = false
      vim.opt_local.cindent = true
      vim.opt_local.autoindent = true

      -- auto-format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = 0,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    '';

    "ftplugin/css.lua".extraConfigLua = ''
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 2
    '';

    "ftplugin/dockerfile.lua".extraConfigLua = ''
      vim.opt_local.expandtab = true
    '';

    "ftplugin/go.lua".extraConfigLua = ''
      vim.opt_local.expandtab = false
      vim.opt_local.shiftwidth = 8
    '';

    "ftplugin/html.lua".extraConfigLua = ''
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 2
    '';

    "ftplugin/json.lua".extraConfigLua = ''
      vim.opt_local.expandtab = true
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
    '';

    "ftplugin/nix.lua".extraConfigLua = ''
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 2
    '';

    "ftplugin/python.lua".extraConfigLua = ''
      -- PEP 8 compliance
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
      vim.opt_local.softtabstop = 4
      vim.opt_local.textwidth = 88  -- black's default

      -- Auto-format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = 0,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    '';

    "ftplugin/sh.lua".extraConfigLua = ''
      vim.opt_local.expandtab = true
    '';

    "ftplugin/yaml.lua".extraConfigLua = ''
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 2
      vim.opt_local.indentkeys:remove({ '0#', '<:>' })
    '';
  };
}
