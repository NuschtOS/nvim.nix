{ config, ... }:

{
  programs.nixvim = {
    defaultEditor = true;
    nixpkgs = {
      inherit (config.nixpkgs) buildPlatform config hostPlatform overlays;
    };
  };
}
