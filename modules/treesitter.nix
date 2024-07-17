{ lib, options, ... }:

{
  plugins.treesitter = {
    enable = true;
    grammarPackages = lib.filter (g: g.pname != "verilog-grammar" && g.pname != "systemverilog-grammar")
      options.plugins.treesitter.grammarPackages.default;
  };

  # Enable automatically closing and renaming HTML tags
  plugins.ts-autotag.enable = true;
}
