{ lib, options, ... }:

let
  # TODO: drop with 25.05
  hasDependencies = lib.versionAtLeast lib.version "25.05";
in
lib.optionalAttrs hasDependencies {
  dependencies = {
    gcc.enable = false;
    nodejs.enable = false;
    tree-sitter.enable = false;
  };
} // {
  plugins.treesitter = {
    enable = true;
    # exclude some big (above 10 MB) and rarely used languages
    grammarPackages = lib.filter (
      g: g.pname != "gnuplot-grammar"
      && g.pname != "razor-grammar"
      && g.pname != "systemverilog-grammar"
      && g.pname != "verilog-grammar"
    ) options.plugins.treesitter.grammarPackages.default;

    settings.highlight.enable = true;
  } // lib.optionalAttrs (!hasDependencies) {
    # we are not installing packages by hand
    gccPackage = null;
    nodejsPackage = null;
    treesitterPackage = null;
  };

  # Enable automatically closing and renaming HTML tags
  plugins.ts-autotag.enable = true;
}
