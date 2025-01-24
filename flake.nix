{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs."nixpkgs".follows = "nixpkgs";
  };
  outputs = { nixpkgs, ... }@inputs: {
    homeModules = import ./home/default.nix;

    packages = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ]
      (system: (import ./nixvim/versions.nix).packages { inherit system inputs; });

    checks = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ]
      (system: (import ./nixvim/versions.nix).checks { inherit system inputs; });

  };
}
