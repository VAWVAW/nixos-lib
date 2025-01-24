This flake contains the public parts of my nixos configuration.

Nothing is activated by default but defaults are overwritten.

# `homeModules`

## Interacting with the specific configuration

### `home.needsPersistence`

This contains all the paths used by these modules that need to be persisted if using some kind of impermanence.

All paths are relative to `config.home.homeDirectory`.

The syntax is the same as [impermanence](https://github.com/nix-community/impermanence) so setting `home.persistence.<name> = config.home.needsPersistence` should just work.

### new options

- `programs.lutris.enable`
- `programs.minecraft.enable` (via `prismlauncher`)
- `programs.steam.enable`
- `programs.obsidian.enable`


## Notes

- `foot` copies the look of `alacritty`
