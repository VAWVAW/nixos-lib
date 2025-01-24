{ config, pkgs, lib, ... }: {
  imports = [ ./persistence.nix ];

  options.programs.steam.enable = lib.mkEnableOption "steam";

  config.home = lib.mkIf config.programs.steam.enable {
    packages = with pkgs; [ steam ];

    needsPersistence.directories = [{
      directory = ".local/share/Steam";
      method = "symlink";
    }];
  };
}
