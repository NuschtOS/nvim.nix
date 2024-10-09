{
  description = "A very basic NeoVim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";

        # https://github.com/nix-community/nixvim/blob/main/flake.nix#L12-L34
        devshell.follows = "";
        flake-compat.follows = "";
        git-hooks.follows = "";
        nix-darwin.follows = "";
        treefmt-nix.follows = "";
      };
    };
  };

  outputs = { self, flake-utils, nixpkgs, nixvim, ... }:
    let
      mkModules = { config, lib, pkgs }: [
        ./modules/nixos.nix
        # partly copied from https://github.com/nix-community/nixvim/blob/main/wrappers/nixos.nix#L31-L49
        {
          options.programs.nixvim = lib.mkOption {
            type = lib.types.submoduleWith {
              modules = [{
                imports = [ ./modules ];
              }];
            };
          };

          config.programs.nixvim = {
            # this unfortunately needs to be here as we cannot access the nixos options inside of nixvim
            extraPackages = map (let
              mapping = with pkgs; {
                golangcilint = golangci-lint;
                jsonlint = nodePackages.jsonlint;
                nix = config.nix.package;
              };
            in pkg: if lib.hasAttr pkg mapping then mapping.${pkg} else pkgs.${pkg})
            (lib.flatten (lib.attrValues config.programs.nixvim.plugins.lint.lintersByFt));

            plugins.lsp.servers.angularls.package = pkgs.callPackage ./pkgs/angular-language-server { };
          };
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
        nixvimWithOptions = { pkgs, options ? { } } : nixvim.legacyPackages.${system}.makeNixvimWithModule {
          module = { config, lib, pkgs, ... }: {
            imports = [
              {
                plugins.lsp.servers.angularls.package = pkgs.callPackage ./pkgs/angular-language-server { };
              }
              ./modules
              options
            ];
          };
          inherit pkgs;
        };

        nixvim = self.packages.${system}.nixvimWithOptions {
          inherit (nixpkgs.legacyPackages.${system}) pkgs;
        };

        default = self.packages.${system}.nixvim;
      };
    });
}
