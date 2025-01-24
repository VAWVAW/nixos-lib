{ config, pkgs, lib, ... }: {
  imports = [ ./persistence.nix ];

  options.programs.lutris.enable = lib.mkEnableOption "lutris";

  config.home = lib.mkIf config.programs.lutris.enable {
    packages = with pkgs; [ lutris ];

    needsPersistence.directories = [
      {
        directory = ".config/lutris";
        method = "symlink";
      }
      {
        directory = ".cache/lutris";
        method = "symlink";
      }
      {
        directory = ".local/share/lutris";
        method = "symlink";
      }
    ];
  };
}
