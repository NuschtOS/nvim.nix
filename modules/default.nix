{ lib, pkgs, ... }:

{
  imports = [
    ./cmp.nix
    ./lsp.nix
    ./nvim-tree.nix
    ./treesitter.nix
    ./which_key.nix
    ./telescope.nix
  ];
} // lib.mapAttrsRecursive (_: lib.mkDefault) {
  colorschemes.kanagawa.enable = true;

  editorconfig.enable = true;

  extraPlugins = with pkgs.vimPlugins; [
    vim-fetch # accept ./path/to/file:123 as line numbers
  ];

  globals.mapleader = " ";

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

  opts = {
    number = true;
    relativenumber = true;
    signcolumn = "yes";
    scrolloff = 8;
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;

    # Allow project-specific .vimrc files, but restrict commands to secure ones
    exrc = true;
    secure = true;
  };

  plugins = {
    bufferline.enable = true;
    commentary.enable = true;
    crates-nvim.enable = true;
    gitsigns.enable = true;
    indent-blankline.enable = true;
    lastplace.enable = true;
    lualine = {
      enable = true;
      globalstatus = true;
      theme = "onedark";
    };
    nvim-autopairs.enable = true; # brackets, html, ...
    nvim-colorizer.enable = true;
    rainbow-delimiters.enable = true;
    tmux-navigator.enable = true;
    ts-context-commentstring.enable = true; # set comment string dynamically
    vim-matchup.enable = true; # extends % key with comments
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
