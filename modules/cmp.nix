{
  plugins = {
    cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        snippet.expand = /* lua */ ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';

        # Order influences ranking
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
          "<CR>" = /* lua */ ''
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
          "<Tab>" = /* lua */ ''
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
          "<S-Tab>" = /* lua */ ''
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

    # icons in cmp
    lspkind.enable = true;

    luasnip = {
      enable = true;
      extraConfig = {
        region_check_events = "CursorHold,InsertLeave";
        # those are for removing deleted snippets, also a common problem
        delete_check_events = "TextChanged,InsertEnter";
      };
    };
  };
}
