{
  description = "A very basic NeoVim flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, flake-utils, nixpkgs, nixvim, ... }: let
    angularLsp = { pkgs }: {
      name = "angularls";
      package = pkgs.callPackage ./pkgs/angular-language-server { };
    };

    mkLsp = import "${nixvim.outPath}/plugins/lsp/language-servers/_mk-lsp.nix";

    mkModules = { config, lib, pkgs }: [
      ./modules/nixos.nix
      {
        programs.nixvim = mkLsp { inherit config lib pkgs; } (angularLsp { inherit pkgs; });
      }
      (lib.mergeModules [ "programs" "nixvim" ] { imports = [ ./modules ]; })
    ];
  in {
    homeManagerModules = {
      nvim = { config, lib, pkgs, ... }: {
        imports = [
          nixvim.homeManagerModules.nixvim
        ] ++ mkModules { inherit config lib pkgs; };
      };

      default = self.homeManagerModules.nvim;
    };

    nixosModules = {
      nvim = { config, lib, pkgs, ... }: {
        imports = [
          nixvim.nixosModules.nixvim
        ] ++ mkModules { inherit config lib pkgs; };
      };

      default = self.nixosModules.nvim;
    };
  } // flake-utils.lib.eachDefaultSystem (system: {
    packages = {
      nixvim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
        module = { config, lib, pkgs, ... }: {
          imports = [
            (mkLsp { inherit config lib pkgs; } (angularLsp { inherit pkgs; }))
            ./modules
          ];
        };
        inherit (nixpkgs.legacyPackages.${system}) pkgs;
      };

      default = self.packages.${system}.nixvim;
    };
  });
}
