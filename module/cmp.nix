{
  programs.nixvim = {
    plugins.nvim-cmp = {
      enable = true;
      autoEnableSources = true;
      snippet.expand = "luasnip";

      preselect = "None";

      #cmdline =
      #  let
      #    search = {
      #      mapping.__raw = "cmp.mapping.preset.cmdline()";
      #      sources = [{ name = "buffer"; }];
      #    };
      #  in
      #  {
      #    "/" = search;
      #    "?" = search;
      #    ":" = {
      #      mapping.__raw = "cmp.mapping.preset.cmdline()";
      #      sources = [
      #        { name = "path"; }
      #        {
      #          name = "cmdline";
      #          option = { ignore_cmds = [ "Man" "!" ]; };
      #        }
      #      ];
      #     };
      #     };

      sources = map (name: { inherit name; }) [
        "crates"
        "nvim_lsp"
        "luasnip"
        #"treesitter"
        "path"
        "buffer"
        #"calc"
        "cmdline"
      ];

      mapping = {
        "<CR>" = ''
            cmp.mapping(function(fallback)
          local luasnip = require'luasnip'
                 if cmp.visible() then
                     if luasnip.expandable() then
                         luasnip.expand()
                     else
                         cmp.confirm({
                             select = true,
                         })
                     end
                 else
                     fallback()
                 end
             end)
        '';
        "<C-Space>" = "cmp.mapping.complete()";

        # TODO: page up/down buttons to scroll multiple times
        "<Tab>" = ''
            cmp.mapping(function(fallback)
          local luasnip = require'luasnip'
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
              else
                fallback()
              end
            end, { "i", "s" })
        '';
        "<S-Tab>" = ''
            cmp.mapping(function(fallback)
          local luasnip = require'luasnip'
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" })
        '';
      };
    };
  };
}
