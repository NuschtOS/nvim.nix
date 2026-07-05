{
  description = "A very basic NeoVim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "nixvim/systems";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, nixpkgs, nixvim, ... }:
    let
      mkModules = { config, lib, pkgs }: [
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
                nix = config.nix.package;
              };
            in pkg: mapping.${pkg} or pkgs.${pkg})
            (lib.flatten (lib.attrValues config.programs.nixvim.plugins.lint.lintersByFt));
          };
        }
      ];
    in
    {
      darwinModules = {
        nvim = { config, lib, pkgs, ... }: {
          imports = [
            nixvim.nixDarwinModules.nixvim
            ./modules/darwin.nix
          ] ++ mkModules { inherit config lib pkgs; };
        };

        default = self.darwinModules.nvim;
      };

      homeManagerModules = {
        nvim = { config, lib, pkgs, ... }: {
          imports = [
            nixvim.homeManagerModules.nixvim
            ./modules/home-manager.nix
          ] ++ mkModules { inherit config lib pkgs; };
        };

        default = self.homeManagerModules.nvim;
      };

      nixosModules = {
        nvim = { config, lib, pkgs, ... }: {
          imports = [
            nixvim.nixosModules.nixvim
            ./modules/nixos.nix
          ] ++ mkModules { inherit config lib pkgs; };
        };

        default = self.nixosModules.nvim;
      };
    } // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (nixpkgs) lib;

      checks = {
        inherit (self.packages.${system}) default;

        nixos = (lib.nixosSystem {
          modules = [
            self.nixosModules.default
            # include a very basic config which contains fileSystem, etc. to avoid many assertions
            ({ modulesPath, ... }: {
              imports = lib.singleton "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix";
            })
          ];
          inherit system;
        }).config.system.build.toplevel;
      };
    in {
      inherit checks;

      packages = {
        nixvimWithOptions = { pkgs, options ? { } } : nixvim.legacyPackages.${system}.makeNixvimWithModule {
          module.imports = [
            ./modules
            options
          ];
          inherit pkgs;
        };

        nixvim = self.packages.${system}.nixvimWithOptions {
          inherit pkgs;
        };

        default = self.packages.${system}.nixvim;

        # for easier `nix build` to avoid `nix flake check` failing because of nixvimWithOptions is not being a package
        inherit checks;
      };
    });
}
