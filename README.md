# nvim.nix

## Usage

```nix
# flake.nix
inputs = {
  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  nixvim = {
    url = "github:nix-community/nixvim/nixos-unstable";
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

  # See <https://nix-community.github.io/nixvim/NeovimOptions/index.html>
  # for available options.
  programs.nixvim.enable = true;
}
```

### Home-Manager

```nix
# home.nix
{
  imports = [ inputs.nvim.homeManagerModules.nvim ];

  # See <https://nix-community.github.io/nixvim/NeovimOptions/index.html>
  # for available options.
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
      # See <https://nix-community.github.io/nixvim/NeovimOptions/index.html>
      # for available options.
      options.enableMan = false;
    })
  ];
}
```
