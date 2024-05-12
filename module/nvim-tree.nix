{
  programs.nixvim = {
    plugins.nvim-tree = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>ne";
        action = "<cmd>NvimTreeToggle<CR>";
        options.desc = "Toggle file tree";
      }
      {
        mode = "n";
        key = "<leader>nf";
        action = "<cmd>NvimTreeFindFile<CR>";
        options.desc = "Show current file in tree";
      }
    ];
  };
}
