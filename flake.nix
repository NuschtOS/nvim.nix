{
  description = "A very basic NeoVim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixvim-stable = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.home-manager.follows = "home-manager-stable";
    };
  };

  outputs = { self, flake-utils, nixpkgs, nixvim, ... }:
    let
      angularLsp = { pkgs }: {
        name = "angularls";
        package = pkgs.callPackage ./pkgs/angular-language-server { };
      };

      mkLsp = import "${nixvim.outPath}/plugins/lsp/language-servers/_mk-lsp.nix";

      mkModules = { config, lib, pkgs }: [
        ./modules/nixos.nix
        # partly copied from https://github.com/nix-community/nixvim/blob/main/wrappers/nixos.nix#L31-L49
        {
          options.programs.nixvim = lib.mkOption {
            type = lib.types.submoduleWith {
              shorthandOnlyDefinesConfig = true;
              modules = [{
                imports = [ ./modules ];
              }];
            };
          };

          config.programs.nixvim = mkLsp { inherit config lib pkgs; } (angularLsp { inherit pkgs; });
        }
      ];
    in
    {
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
