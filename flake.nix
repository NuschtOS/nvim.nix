{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixvim = {
      url = "github:MarcelCoding/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
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
