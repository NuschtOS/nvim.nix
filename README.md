# nvim.nix

## Usage

```nix
# flake.nix
inputs = {
  home-manager = {
    url = "github:nix-community/home-manager/release-24.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  nixvim = {
    url = "github:nix-community/nixvim/nixos-24.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  nvim = {
    url = "github:NuschtOS/nvim.nix";
    inputs.home-manager.follows = "home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

### NixOS

```nix
# configuration.nix
{
  imports = [ inputs.nvim.nixosModules.nvim ];

  programs.nixvim.enable = true;
}
```

### HomeManager

```nix
# home.nix
{
  imports = [ inputs.nvim.homeManagerModules.nvim ];

  programs.nixvim.enable = true;
}
```

### Package

```nix
{
  environment.systemPackages = [ inputs.nvim.packages.x86_64-linux.nixvim ];
}
```

```nix
{
  environment.systemPackages = [
    (inputs.nvim.packages.x86_64-linux.nixvimWithOptions {
      inherit pkgs;
      options.enableMan = false;
    })
  ];
}
```
