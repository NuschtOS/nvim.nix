{
  plugins.treesitter = {
    enable = true;
    ignoreInstall = [
      # remove rather big grammars
      "systemverilog"
      "verilog"
    ];
    indent = true;
  };

  # Enable automatically closing and renaming HTML tags
  plugins.ts-autotag.enable = true;
}
