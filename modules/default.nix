{ lib, ... }:

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
  viAlias = true;
  vimAlias = true;

  globals.mapleader = " ";

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

  editorconfig.enable = true;
  clipboard = {
    register = "unnamedplus";
    providers.wl-copy.enable = true;
  };

  plugins = {
    autoclose.enable = true; # brackets, html, ...
    # does not work
    #commentary.enable = true;
    bufferline.enable = true;
    lastplace.enable = true;
    gitsigns.enable = true;
    nvim-colorizer.enable = true;
    indent-blankline.enable = true;
    lualine = {
      enable = true;
      globalstatus = true;
      theme = "onedark";
    };
    tmux-navigator.enable = true;
    crates-nvim.enable = true;
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

  colorschemes.kanagawa.enable = true;
}
