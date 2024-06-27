{
  imports = [
    ./cmp.nix
    ./lsp.nix
    ./markdown.nix
    ./nvim-tree.nix
    ./treesitter.nix
    ./which_key.nix
    ./telescope.nix
  ];

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
    # needs 24.05
    # remove from extraPlugins
    # autoclose.enable = true; # brackets, html, ...
    # does not work
    #commentary.enable = true;
    bufferline.enable = true;
    lastplace.enable = true;
    # icons in cmp
    lspkind.enable = true;
    gitsigns.enable = true;
    nvim-colorizer.enable = true;
    indent-blankline.enable = true;
    lint = {
      enable = true;
      lintersByFt = {
        css = [ "eslint_d" ];
        scss = [ "eslint_d" ];
        gitcommit = [ "commitlint" ];
        javascript = [ "eslint_d" ];
        javascriptreact = [ "eslint_d" ];
        json = [ "jsonlint" ];
        markdownlint = [ "markdownlint" ];
        nix = [ "nix" ];
        python = [ "ruff" ];
        sh = [ "shellcheck" ];
        typescript = [ "eslint_d" ];
        typescriptreact = [ "eslint_d" ];
        yaml = [ "yamllint" ];
      };
      # Trigger linting more aggressively, not only after writing a buffer
      autoCmd.event = [ "BufWritePost" "BufEnter" "BufLeave" ];
    };
    luasnip = {
      enable = true;
      extraConfig = {
        region_check_events = "CursorHold,InsertLeave";
        # those are for removing deleted snippets, also a common problem
        delete_check_events = "TextChanged,InsertEnter";
      };
    };
    lualine = {
      enable = true;
      globalstatus = true;
      theme = "onedark";
    };
    nvim-autopairs.enable = true;
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
    #move line down(n)
    { mode = "n"; key = "<A-k>"; action = ":m .-2<CR>=="; }
    # move line up(v)
    { mode = "v"; key = "<A-j>"; action = ":m '>+1<CR>gv=gv"; }
    #-- move line down(v)
    { mode = "v"; key = "<A-k>"; action = ":m '<-2<CR>gv=gv"; }
    { mode = "n"; key = "<leader>gb"; action = ":Gitsign blame_line<CR>"; }
  ];

  colorschemes.kanagawa.enable = true;
}
