{ config, pkgs, lib, ... }:
let cfg = config.programs.obsidian;
in {
  imports = [ ./persistence.nix ];

  options.programs.obsidian.enable = lib.mkEnableOption "obsidian";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ obsidian ];

    home.needsPersistence.directories = [{
      directory = ".config/obsidian";
      method = "symlink";
    }];
  };
}
