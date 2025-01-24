{
  # plumbing
  persistence = { imports = [ ./persistence.nix ]; };

  # simple configurations
  alacritty = import ./alacritty.nix;
  direnv = import ./direnv.nix;
  foot = import ./foot.nix;
  gpg = import ./gpg.nix;
  lutris = import ./lutris.nix;
  minecraft = import ./minecraft.nix;
  obsidian = import ./obsidian.nix;
  steam = import ./steam.nix;
}
