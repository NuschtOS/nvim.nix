{
  description = "A very basic NeoVim flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixvim, ... }: let
    angularLsp = { pkgs }: {
      name = "angularls";
      package = pkgs.callPackage ./pkgs/angular-language-server { };
    };
  in {
    homeManagerModules = {
      nvim = { config, lib, pkgs, ... }: let
        mkLsp = import "${nixvim.outPath}/plugins/lsp/language-servers/_mk-lsp.nix" { inherit config lib pkgs; };
      in {
        imports = [
          nixvim.homeManagerModules.nixvim
          {
            programs.nixvim = mkLsp (angularLsp { inherit pkgs; });
          }
          ./module
        ];
      };
      default = self.homeManagerModules.nvim;
    };

    nixosModules = {
      nvim = { config, lib, pkgs, ... }: let
        mkLsp = import "${nixvim.outPath}/plugins/lsp/language-servers/_mk-lsp.nix" { inherit config lib pkgs; };
      in {
        imports = [
          nixvim.nixosModules.nixvim
          {
            programs.nixvim = mkLsp (angularLsp { inherit pkgs; });
          }
          ./module
        ];
      };

      default = self.nixosModules.nvim;
    };
  };
}
