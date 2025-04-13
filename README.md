This flake contains the public parts of my nixos configuration.

Nothing is activated by default but defaults are overwritten.

# packages

## nixvim

Variants:

- `nixvim`: base config; ~ 1G
- `nixvim-all`: support for all languages enabled; ~ 4G
- `nixvim-small`: use system packages for e.g. git; ~ 500M
- `nixvim-minimal`: no treesitter; ~ 250M
- `nixvim-<version>-tty`: reduce number of special glypgs for use in tty

# `homeModules`

## Interacting with the specific configuration

### `home.needsPersistence`

This contains all the paths used by these modules that need to be persisted if using some kind of impermanence.

All paths are relative to `config.home.homeDirectory`.

The syntax is the same as [impermanence](https://github.com/nix-community/impermanence) so setting `home.persistence.<name> = config.home.needsPersistence` should just work.

### new options

- `services.ssh-agent`
    - `askPass`
    - `timeout`
- `programs.discord.enable`
- `programs.lutris.enable`
- `programs.minecraft.enable` (via `prismlauncher`)
- `programs.signal-desktop.enable`
- `programs.steam.enable`
- `programs.obsidian.enable`


## Notes

- `foot` copies the look of `alacritty`

# `lib`

## `wrapFirejailBinary`

creates a firejail wrapper for a binary
