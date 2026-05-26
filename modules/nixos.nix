{ config, lib, options, pkgs, ... }:

{
  programs.nixvim = {
    defaultEditor = true;
    nixpkgs = {
      inherit (config.nixpkgs) config overlays;
      source = pkgs.path;
    } // lib.optionalAttrs options.nixpkgs.hostPlatform.isDefined {
      inherit (config.nixpkgs) buildPlatform hostPlatform;
    };
  };
}
