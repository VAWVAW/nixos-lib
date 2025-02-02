{ pkgs, lib, ... }:
with lib; {
  options.desktop = {
    screens = mkOption {
      default = [ ];
      description = ''
        Physical screens that should be configured by
        the window manager / compositor.
      '';
      type = types.listOf (types.submodule {
        options = {
          name = mkOption { type = types.str; };
          size = mkOption {
            type = types.str;
            default = "1920x1080";
            description = "Size of the screen";
            example = literalExpression "2256x1504";
          };
          scale = mkOption {
            type = types.str;
            default = "1";
            description = ''
              Scale factor of the screen. Non-integer scales
              can be blurry on wayland.
            '';
            example = literalExpression ''"2"'';
          };
          position = mkOption {
            type = types.str;
            default = "0 0";
            description = ''
              Virtual position of the screen.
            '';
            example = literalExpression "1920 0";
          };
          workspaces = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = ''
              Workspaces to assign to this screen.
            '';
            example = literalExpression ''["9" "10"]'';
          };
        };
      });
    };

    keybinds = let
      mods = types.enum [ "Super" "Alt" "Ctrl" "Shift" ];
      keyOpts = {
        "mods" = mkOption {
          description = "Modifiers for the keybind";
          type = types.listOf mods;
          default = [ ];
        };

        "key" = mkOption { type = types.str; };
      };
      keybindOpts = keyOpts // { "command" = mkOption { type = types.str; }; };
    in {
      "binds" = mkOption {
        description = ''
          Generic keybinds.
        '';
        type = types.listOf (types.submodule { options = keybindOpts; });
        default = [ ];
      };

      "global-binds" = mkOption {
        description = ''
          Generic keybinds that work in all modes.
        '';
        type = types.listOf (types.submodule { options = keybindOpts; });
        default = [ ];
      };

      "modes" = mkOption {
        description = ''
          Generic modes/submaps that provide only the specified keybinds.
        '';
        default = { };

        type = types.attrsOf (types.submodule {
          options = {
            "enter" =
              mkOption { type = types.submodule { options = keyOpts; }; };
            "default-exit" = mkOption {
              description =
                "Generate exit commands for Escape, BackSpace and `enter`";
              type = types.bool;
              default = true;
            };
            "binds" = mkOption {
              type = types.listOf (types.submodule {
                options = keybindOpts // {
                  "exit" = mkOption {
                    description = "Exit the mode after executing the command";
                    type = types.bool;
                    default = true;
                  };
                };
              });
              default = [ ];
            };
          };
        });
      };

      "generated" = {
        "mod" = mkOption {
          description = "The mod key to use in generated keybinds.";
          type = mods;
          default = "Alt";
        };
        "left" = mkOption {
          description = "The left key to use in generated keybinds";
          type = types.str;
          default = "j";
        };
        "down" = mkOption {
          description = "The down key to use in generated keybinds";
          type = types.str;
          default = "k";
        };
        "up" = mkOption {
          description = "The up key to use in generated keybinds";
          type = types.str;
          default = "l";
        };
        "right" = mkOption {
          description = "The right key to use in generated keybinds";
          type = types.str;
          default = "Semicolon";
        };
      };
    };

    startup_commands = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Commands to execute at startup of the
        window manager / compositor.
      '';
      example = literalExpression ''
        [ "''${pkgs.noisetorch}/bin/noisetorch -i" ]
      '';
    };

    theme = {
      wallpaper = mkOption {
        description = "the wallpaper to use";
        type = types.nullOr types.path;
        default = null;
      };

      focused = {
        border = mkOption {
          description = "the border color for focused items";
          type = types.str;
          default = "#4c7899";
        };
        background = mkOption {
          description = "the background color for focused items";
          type = types.str;
          default = "#285577";
        };
        text = mkOption {
          description = "the text color for focused items";
          type = types.str;
          default = "#ffffff";
        };
      };
      secondary = {
        border = mkOption {
          description =
            "the border color for secondary items like visible but inactive workspaces";
          type = types.str;
          default = "#333333";
        };
        background = mkOption {
          description =
            "the background color for secondary items like visible but inactive workspaces";
          type = types.str;
          default = "#5f676a";
        };
        text = mkOption {
          description =
            "the text color for secondary items like visible but inactive workspaces";
          type = types.str;
          default = "#ffffff";
        };
      };
      unfocused = {
        border = mkOption {
          description = "the border color for unfocused items";
          type = types.str;
          default = "#333333";
        };
        background = mkOption {
          description = "the background color for unfocused items";
          type = types.str;
          default = "#222222";
        };
        text = mkOption {
          description = "the text color for unfocused items";
          type = types.str;
          default = "#888888";
        };
      };
      urgent = {
        border = mkOption {
          description = "the border color for urgent items";
          type = types.str;
          default = "#c01010";
        };
        background = mkOption {
          description = "the background color for urgent items";
          type = types.str;
          default = "#900000";
        };
        text = mkOption {
          description = "the text color for urgent items";
          type = types.str;
          default = "#ffffff";
        };
      };
    };

    terminal = lib.mkOption {
      type = types.str;
      default = "${pkgs.alacritty}/bin/alacritty";
      description = ''
        terminal to use on the desktop
      '';
      example = literalExpression ''
        ''${pkgs.foot}/bin/foot
      '';
    };
  };
}
