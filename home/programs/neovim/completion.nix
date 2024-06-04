{
  programs.nixvim = {
    plugins = {
      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-vsnip.enable = true;
      copilot-cmp.enable = true;

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

          sources = [
            { name = "copilot"; }
            { name = "nvim_lsp"; }
            { name = "buffer"; }
          ];

          mapping = {
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
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
  };
}
