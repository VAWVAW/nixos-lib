{ pkgs, ... }: {
  imports = [
    ./languages

    ./buffer.nix
    ./cmp.nix
    ./dap.nix
    ./disable_nerdfonts.nix
    ./git.nix
    ./keybinds.nix
    ./lsp.nix
    ./lualine.nix
    ./none-ls.nix
    ./nvim-tree.nix
    ./outline.nix
    ./telescope.nix
    ./toggleterm.nix
    ./treesitter.nix
    ./undotree.nix
  ];

  clipboard.register = "unnamed";
  opts = {
    mouse = "";
    ignorecase = true;
    smartcase = true;
    smartindent = true;

    splitbelow = true;
    splitright = true;

    foldlevelstart = 99;

    expandtab = true;
    shiftwidth = 2;
    tabstop = 2;

    wrap = false;
    linebreak = true;
    scrolloff = 3;
    sidescrolloff = 8;

    number = true;
    relativenumber = true;
    signcolumn = "yes";

    showmode = false;
    completeopt = [ "menuone" "noselect" ];
  };

  plugins = {
    comment = {
      enable = true;
      luaConfig.post = "require('Comment.ft').set('asm', {';%s', ';%s'})";
    };
    project-nvim.enable = true;
    web-devicons.enable = true;
  };

  colorscheme = "vaw-colors";
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "vaw-colors";
      src = pkgs.fetchFromGitHub {
        owner = "vawvaw";
        repo = "nvim-colorscheme";
        rev = "e0697d5473f7558ddeccfe1615e7fd6e2defa12a";
        hash = "sha256-st4ikZpaYgbsba836xr18rKmewFGzooyE8DjsXuEnMQ=";
      };
    })
  ];
}
