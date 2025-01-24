{ config, pkgs, lib, ... }: {
  imports = [ ./persistence.nix ];

  options.programs.minecraft.enable = lib.mkEnableOption "minecraft";

  config = lib.mkIf config.programs.minecraft.enable {
    home.packages = with pkgs; [ prismlauncher ];

    home.needsPersistence.directories = [{
      directory = ".local/share/PrismLauncher";
      method = "symlink";
    }];
  };
}
