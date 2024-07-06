{
  extraConfigLuaPre = /* lua */ ''
    local luasnip = require('luasnip')

    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end
  '';

  extraConfigLua = /* lua */ ''
    vim.api.nvim_create_autocmd({ 'TextChangedI' }, {
      callback = function()
        if has_words_before() then
          cmp.complete()
        end
      end,
    })
  '';

  plugins = {
    cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        completion.autocomplete = false;

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

        # https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
        mapping = {
          "<CR>" = /* lua */ ''
            cmp.mapping({
              i = function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                  if luasnip.expandable() then
                    luasnip.expand()
                  else
                    cmp.confirm({ select = true })
                  end
                else
                  fallback()
                end
              end,
              s = cmp.mapping.confirm({ select = true }),
              c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
            })
          '';
          "<C-Space>" = "cmp.mapping.complete()";

          # TODO: page up/down buttons to scroll multiple times
          "<Tab>" = /* lua */ ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { "i", "s" })
          '';
          "<S-Tab>" = /* lua */ ''
            cmp.mapping(function(fallback)
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
