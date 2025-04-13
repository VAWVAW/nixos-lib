{ config, lib, ... }: {
  config = lib.mkMerge [
    { plugins.treesitter.enable = lib.mkDefault true; }
    (lib.mkIf config.plugins.treesitter.enable {
      plugins = {
        rainbow-delimiters.enable = true;
        nvim-autopairs.enable = true;
        treesitter-context.enable = true;

        illuminate = {
          enable = true;
          minCountToHighlight = 2;
        };

        treesitter = {
          folding = true;
          settings.indent.enable = true;
          settings.highlight.enable = true;
        };
      };
      dependencies = {
        tree-sitter.package = null;
        nodejs.package = null;
        gcc.package = null;
      };
    })
  ];
}
