{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:MarcelCoding/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { nixvim, ... }: {
    homeManagerModules = rec {
      nvim = {
        imports = [
          nixvim.homeManagerModules.nixvim
          ./module
        ];
      };
      default = nvim;
    };
  };
}
