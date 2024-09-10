{ config, ... }:

let
  cmpWinHeight = config.opts.pumheight;
in
{
  extraConfigLuaPre = /* lua */ ''
    local luasnip = require('luasnip')

    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end
  '';

  plugins = {
    cmp = {
      enable = true;
      autoEnableSources = true;

      # https://github.com/hrsh7th/cmp-cmdline?tab=readme-ov-file#setup
      # https://github.com/nix-community/nixvim/blob/a5e9dbdef1530a76056db12387d489a68eea6f80/plugins/completion/cmp/options/default.nix#L53-L71
      cmdline = {
        "/" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources = [ { name = "buffer"; } ];
        };
        ":" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources = [
            { name = "path"; }
            {
              name = "cmdline";
              option = {
                ignore_cmds = [
                  "Man"
                  "!"
                ];
              };
            }
          ];
        };
      };

      settings = {
        # https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
        mapping = {
          "<CR>" = /* lua */ ''
            cmp.mapping(function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                if luasnip.expandable() then
                  luasnip.expand()
                else
                  cmp.confirm({ select = true })
                end
              else
                fallback()
              end
            end, { "i", "s" })
          '';
          "<C-Space>" = "cmp.mapping.complete()";

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

          "<Up>" = /* lua */ ''
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
          "<Down>" = /* lua */ ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
              else
                fallback()
              end
            end, { "i", "s" })
          '';
          "<PageUp>" = /* lua */ ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item({ count = ${toString cmpWinHeight} })
              elseif luasnip.locally_jumpable(${toString (cmpWinHeight * -1)}) then
                luasnip.jump(${toString (cmpWinHeight * -1)})
              else
                fallback()
              end
            end, { "i", "s" })
          '';
          "<PageDown>" = /* lua */ ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item({ count = ${toString cmpWinHeight} })
              elseif luasnip.locally_jumpable(${toString cmpWinHeight}) then
                luasnip.jump(${toString cmpWinHeight})
              else
                fallback()
              end
            end, { "i", "s" })
          '';
        };

        snippet.expand = /* lua */ ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';

        # Order influences ranking
        sources = map (name: { inherit name; }) [
          "crates"
          "nvim_lsp"
          "treesitter"
          "luasnip"
          "path"
          #"calc"
        ] ++ [ {
          name = "buffer"; keyword_length = 3;
        } ];
      };
    };

    # icons in cmp
    lspkind.enable = true;

    luasnip = {
      enable = true;
      settings = {
        region_check_events = "CursorHold,InsertLeave";
        # those are for removing deleted snippets, also a common problem
        delete_check_events = "TextChanged,InsertEnter";
      };
    };
  };
}
