{ config, pkgs, lib, ... }: {
  config = lib.mkIf config.wayland.windowManager.sway.enable {
    home.packages = [
      (pkgs.runCommandLocal "sway-wrapped" { meta.priority = -5; } ''
        mkdir -p $out/bin
        cat <<EOF >$out/bin/sway
        #!${pkgs.runtimeShell}
        ${config.wayland.windowManager.sway.package}/bin/sway "\$@"
        ${pkgs.systemd}/bin/systemctl --user stop sway-session.target
        EOF

        chmod +x $out/bin/sway
      '')
    ];

    xdg.portal = {
      extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
      config."sway".default = [ "wlr" "gtk" "*" ];
    };

    wayland.windowManager.sway.config = let
      cfg = config.desktop;
      transformMod =
        builtins.replaceStrings [ "Super" "Alt" ] [ "Mod4" "Mod1" ];
      generateKeybind = genExec: bind: {
        name = transformMod
          (builtins.concatStringsSep "+" (bind.mods ++ [ bind.key ]));
        value = genExec bind;
      };
      generateKeybinds = genExec: binds:
        builtins.listToAttrs (map (generateKeybind genExec) binds);

    in {
      inherit (cfg.keybinds.generated) left right up down;
      modifier = transformMod cfg.keybinds.generated.mod;

      # keyboard layout
      input."type:keyboard" = {
        xkb_layout = lib.mkIf (config.home.keyboard.layout != null)
          config.home.keyboard.layout;
        xkb_variant = lib.mkIf (config.home.keyboard.variant != null)
          config.home.keyboard.variant;
        xkb_options =
          lib.mkIf (builtins.length config.home.keyboard.options > 0)
          (builtins.concatStringsSep "," config.home.keyboard.options);
      };

      output = lib.mkMerge [
        # screens
        (builtins.listToAttrs (builtins.map (s: {
          inherit (s) name;
          value = {
            inherit (s) position scale;
            resolution = s.size;
          };
        }) cfg.screens))

        # wallpaper
        (lib.mkIf (cfg.theme.wallpaper != null) {
          "*".bg = "${toString cfg.theme.wallpaper} fill";
        })
      ];

      # workspaces
      workspaceOutputAssign = builtins.concatMap (screen:
        map (workspace: {
          inherit workspace;
          output = screen.name;
        }) screen.workspaces) cfg.screens;

      # startup commands
      startup = builtins.map (cmd: { command = cmd; }) cfg.startup_commands;

      # theming
      colors = let
        genColor = variant: {
          inherit (variant) background border text;
          childBorder = variant.border;
          indicator = variant.border;
        };
      in {
        focused = genColor cfg.theme.focused;
        focusedInactive = genColor cfg.theme.secondary;
        unfocused = genColor cfg.theme.unfocused;
        urgent = genColor cfg.theme.urgent;
        background = "#000000";
      };

      # keybinds
      keybindings =
        # general exec binds
        (generateKeybinds (bind: "exec " + bind.command)
          (cfg.keybinds.binds ++ cfg.keybinds.global-binds)) //
        # mode enter binds
        (builtins.listToAttrs (builtins.attrValues (builtins.mapAttrs
          (name: mode: generateKeybind (_: "mode " + name) mode.enter)
          cfg.keybinds.modes)));

      # modes
      modes = builtins.mapAttrs (_: mode:
        generateKeybinds

        (bind:
          if builtins.isString bind.command then
            (lib.optionalString bind.exit "mode default; ") + "exec "
            + (toString bind.command)
          else
            "mode default")

        (mode.binds
          ++ (map (bind: bind // { exit = false; }) cfg.keybinds.global-binds)
          ++ (lib.optionals mode.default-exit [
            {
              mods = [ ];
              key = "escape";
              command = null;
            }
            {
              mods = [ ];
              key = "backspace";
              command = null;
            }
            (mode.enter // { command = null; })
          ]))

      ) cfg.keybinds.modes;
    };
  };
}
