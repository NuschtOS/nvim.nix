{ lib, options, ... }:

{
  plugins.treesitter = {
    enable = true;
    # exclude some big and rarely used languages
    grammarPackages = lib.filter (
      g: g.pname != "gnuplot-grammar"
      && g.pname != "systemverilog-grammar"
      && g.pname != "verilog-grammar"
    ) options.plugins.treesitter.grammarPackages.default;

    # we are not installing packages by hand
    gccPackage = null;
    nodejsPackage = null;
    treesitterPackage = null;

    settings.highlight.enable = true;
  };

  # Enable automatically closing and renaming HTML tags
  plugins.ts-autotag.enable = true;
}
