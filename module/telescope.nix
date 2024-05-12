{
  programs.nixvim.plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader>ff" = "live_grep";
    };
  };
}
