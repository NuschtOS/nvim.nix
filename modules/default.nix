{ lib, config, pkgs, ... }:

{
  imports = [
    ./cmp.nix
    ./lsp.nix
    ./nvim-tree.nix
    ./treesitter.nix
    ./telescope.nix
  ];

  #assertions = [{
  #  assertion = !config.programs.nixvim.colorschemes.kanagawa.enable && config.programs.nixvim.plugins.lualine.settings.options.theme == "kanagawa";
  #  message = "NixVim `colorschemes.kanagawa.enable` is disabled but `plugins.lualine.settings.options.theme` is set to `kanagawa`.";
  #}];

  extraPlugins = with pkgs.vimPlugins; [
    vim-fetch # accept ./path/to/file:123 as line numbers
  ];

  keymaps = [
    # Use tab as buffer switcher in normal mode
    {
      mode = "n";
      key = "<Tab>";
      action = ":bnext<CR>";
    }
    {
      mode = "n";
      key = "<S-Tab>";
      action = ":bprevious<CR>";
    }

    # Delete search highlight with backspace
    {
      mode = "n";
      key = "<BS>";
      action = ":nohlsearch<CR>";
    }
    # move line up(n)
    { mode = "n"; key = "<A-j>"; action = ":m .+1<CR>=="; }
    # move line down(n)
    { mode = "n"; key = "<A-k>"; action = ":m .-2<CR>=="; }
    # move line up(v)
    { mode = "v"; key = "<A-j>"; action = ":m '>+1<CR>gv=gv"; }
    # move line down(v)
    { mode = "v"; key = "<A-k>"; action = ":m '<-2<CR>gv=gv"; }
    { mode = "n"; key = "<leader>gb"; action = ":Gitsign blame_line<CR>"; }
  ];
} // lib.mapAttrsRecursive (_: lib.mkDefault) {
  colorschemes.kanagawa.enable = true;
  editorconfig.enable = true;
  globals.mapleader = " ";
  luaLoader.enable = true;

  opts = {
    expandtab = true;
    number = true;
    pumheight = 15;
    relativenumber = true;
    scrolloff = 8;
    shiftwidth = 2;
    signcolumn = "yes";
    smartindent = true;
    tabstop = 2;
    # save undo file after quit
    undofile = true;
    undolevels = 1000;
    undoreload = 10000;

    # Allow project-specific .vimrc files, but restrict commands to secure ones
    exrc = true;
    secure = true;
  };

  plugins = {
    bufferline.enable = true;
    commentary.enable = true;
    crates-nvim.enable = true;
    fidget.enable = true;
    gitsigns.enable = true;
    indent-blankline.enable = true;
    lastplace.enable = true;
    lualine = {
      enable = true;
      settings = {
        options = {
          globalstatus = true;
          theme = lib.mkDefault "kanagawa";
        };
        # https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#filename-component-options
        sections = {
          lualine_b = [{
            sources = [ "nvim_diagnostic" "nvim_lsp" ];
          }];
          lualine_c = [{
            path = 1;
          }];
        };
      };
    };
    nvim-autopairs.enable = true; # brackets, html, ...
    nvim-colorizer.enable = true;
    rainbow-delimiters.enable = true;
    ts-context-commentstring.enable = true; # set comment string dynamically
    vim-matchup.enable = true; # extends % key with comments
    web-devicons.enable = true;
    which-key.enable = true;
  };

  userCommands = {
    # Command aliases for common typos
    "W" = {
      command = "w";
      bang = true;
    };
    "Wq" = {
      command = "wq";
      bang = true;
    };
    "WQ" = {
      command = "wq";
      bang = true;
    };
    "Q" = {
      command = "q";
      bang = true;
    };
  };

  viAlias = true;
  vimAlias = true;
}
