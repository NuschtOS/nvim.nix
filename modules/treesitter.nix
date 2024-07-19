{ lib, options, ... }:

{
  plugins.treesitter = {
    enable = true;
    grammarPackages = lib.filter (g: g.pname != "verilog-grammar" && g.pname != "systemverilog-grammar")
      options.plugins.treesitter.grammarPackages.default;

  } // lib.optionalAttrs (lib.versionAtLeast lib.version "24.11pre") {
    # we are not installing packages by hand
    gccPackage = null;
    nodejsPackage = null;
    treesitterPackage = null;
  };

  # Enable automatically closing and renaming HTML tags
  plugins.ts-autotag.enable = true;
}
