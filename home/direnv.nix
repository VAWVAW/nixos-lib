{ config, lib, ... }: {
  imports = [ ./persistence.nix ];

  config = lib.mkIf config.programs.direnv.enable {
    programs.direnv.nix-direnv.enable = lib.mkDefault true;

    home.needsPersistence.directories = [{
      directory = ".local/share/direnv";
      method = "symlink";
    }];
  };
}
