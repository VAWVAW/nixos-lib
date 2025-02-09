{ config, pkgs, lib, ... }:
let
  cfg = config.programs.discord;

  defaultPackage = let
    args = {
      inherit pkgs lib;
      package = pkgs.discord.override { nss = pkgs.nss_latest; };

      profile = "${pkgs.firejail}/etc/firejail/discord.profile";
      extraArgs = [
        "--dbus-user.talk=org.freedesktop.Notifications"
        "--ignore=private-tmp"
      ];
    };
    discord = import ../lib/firejail.nix (args // {
      package = import ../lib/firejail.nix args;
      relativePath = "/bin/Discord";
    });
  in discord.overrideAttrs (old: {
    postPhases = old.postPhases ++ [ "wrapUnbufferPhase" ];
    wrapUnbufferPhase = ''
      (
          local prog="$out/bin/discord"
          local hidden unbuffer

          hidden="$(dirname "$prog")/.$(basename "$prog")"-wrapped
          while [ -e "$hidden" ]; do
            hidden="''${hidden}_"
          done
          mv "$prog" "$hidden"

          # ignore check
          assertExecutable() {
            :
          }

          unbuffer="${pkgs.expect}/bin/unbuffer\" \"$hidden"

          makeShellWrapper "$unbuffer" "$prog" --inherit-argv0 --set NIXOS_OZONE_WL ""
      )'';
  });
in {
  options.programs.discord = {
    enable = lib.mkEnableOption "discord";
    package = lib.mkOption {
      type = lib.types.package;
      default = defaultPackage;
    };
  };

  config = lib.mkIf cfg.enable {
    home.needsPersistence.directories = [{
      directory = ".config/discord";
      method = "bindfs";
    }];

    xdg = {
      configFile = {
        "discord/settings.json".text = ''{ "SKIP_HOST_UPDATE": true }'';
        "firejail/discord.local".text = "ignore join-or-start";
      };
      desktopEntries."discord" = {
        type = "Application";
        name = "Discord";
        categories = [ "Network" "InstantMessaging" ];
        exec = "${cfg.package}/bin/discord --url -- %u";
        mimeType = [ "x-scheme-handler/discord" ];
        icon = "discord";
      };
    };

    home.packages = [ cfg.package ];
  };
}
