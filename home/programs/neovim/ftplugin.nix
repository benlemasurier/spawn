{
  programs.nixvim.files = {
    "ftplugin/c.lua".extraConfigLua = ''
      vim.opt.expandtab = true
    '';

    "ftplugin/css.lua".extraConfigLua = ''
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
    '';

    "ftplugin/go.lua".extraConfigLua = ''
      vim.opt.expandtab = false
      vim.opt.shiftwidth = 8
    '';

    "ftplugin/html.lua".extraConfigLua = ''
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
    '';

    "ftplugin/json.lua".extraConfigLua = ''
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
    '';

    "ftplugin/nix.lua".extraConfigLua = ''
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
    '';

    "ftplugin/yaml.lua".extraConfigLua = ''
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt_local.indentkeys:remove({ '0#', '<:>' })
    '';
  };
}
