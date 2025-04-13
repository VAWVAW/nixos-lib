rec {
  packages = ({ system, inputs }:
    let nixvimpkgs = inputs.nixvim.legacyPackages.${system};
    in rec {
      # ~ 1 GB
      nixvim = nixvimpkgs.makeNixvimWithModule {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        module = import ./.;
        extraSpecialArgs = { inherit inputs; };
      };
      # ~ 3 GB
      nixvim-all = nixvim.extend { languages.all.enable = true; };
      # ~ 500 MB
      nixvim-small = nixvim.extend {
        dependencies.git.enable = false;
        plugins.lsp.servers = {
          bashls.enable = false;
          jsonls.enable = false;
          yamlls.enable = false;
        };

      };
      # ~ 250 MB
      nixvim-minimal =
        nixvim-small.extend { plugins.treesitter.enable = false; };

      # tty versions
      nixvim-tty = nixvim.extend { disable_nerdfonts = true; };
      nixvim-all-tty = nixvim-all.extend { disable_nerdfonts = true; };
      nixvim-small-tty = nixvim-small.extend { disable_nerdfonts = true; };
      nixvim-minimal-tty = nixvim-minimal.extend { disable_nerdfonts = true; };
    });

  checks = ({ system, inputs }:
    builtins.mapAttrs (name: nvim:
      inputs.nixvim.lib.${system}.check.mkTestDerivationFromNvim {
        nvim = nvim.extend {
          # some tests depend on git existing
          extraPackages = [ inputs.nixpkgs.legacyPackages.${system}.git ];
        };
        name = "check-${name}";
      }) (packages { inherit system inputs; }));
}
