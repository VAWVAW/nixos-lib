{
  # plumbing
  desktop.imports = [ ./desktop.nix ];
  persistence.imports = [ ./persistence.nix ];

  # simple configurations
  alacritty = import ./alacritty.nix;
  direnv = import ./direnv.nix;
  discord = import ./discord.nix;
  foot = import ./foot.nix;
  gpg = import ./gpg.nix;
  lutris = import ./lutris.nix;
  minecraft = import ./minecraft.nix;
  obsidian = import ./obsidian.nix;
  signal-desktop = import ./signal-desktop.nix;
  ssh-agent = import ./ssh-agent.nix;
  steam = import ./steam.nix;
}
