{ config, lib, pkgs, ... }:

{
  programs.nixvim = {
    defaultEditor = true;
    nixpkgs = {
      config = lib.mkIf (config.nixpkgs.config != null) config.nixpkgs.config;
      overlays = lib.mkIf (config.nixpkgs.overlays != null) config.nixpkgs.overlays;
      source = pkgs.path;
    };
  };
}
