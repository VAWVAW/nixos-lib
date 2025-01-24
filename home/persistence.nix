# mostly copied from https://github.com/nix-community/impermanence

{ lib, ... }: {
  options.home.needsPersistence = {
    directories = lib.mkOption {
      type = with lib.types;
        listOf (either str (submodule {
          options = {
            directory = lib.mkOption {
              type = str;
              default = null;
              description = "The directory path to be linked.";
            };
            method = lib.mkOption {
              type = lib.types.enum [ "bindfs" "symlink" ];
              default = "bindfs";
              description = ''
                The linking method that should be used for this
                directory. bindfs is the default and works for most use
                cases, however some programs may behave better with
                symlinks.
              '';
            };
          };
        }));
      default = [ ];
      description = ''
        A list of directories in your home directory that
        you want to link to persistent storage. You may optionally
        specify the linking method each directory should use.
      '';
    };

    files = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = ''
        A list of files in your home directory you want to
        link to persistent storage.
      '';
    };
  };

}
