{ lib, options, ... }:

{
  dependencies = {
    gcc.enable = false;
    nodejs.enable = false;
    tree-sitter.enable = false;
  };

  plugins.treesitter = {
    enable = true;
    # exclude some big (above 10 MB) and rarely used languages
    grammarPackages = lib.filter (
      g: g.pname != "tree-sitter-gnuplot"
      && g.pname != "tree-sitter-razor"
      && g.pname != "tree-sitter-systemverilog"
    ) options.plugins.treesitter.grammarPackages.default;

    settings.highlight.enable = true;
  };

  # Enable automatically closing and renaming HTML tags
  plugins.ts-autotag.enable = true;
}
