{ config, pkgs, lib, ... }: {
  options.programs.discord.enable = lib.mkEnableOption "discord";

  config = lib.mkIf config.programs.discord.enable {
    home.persistence."/persist/home/vaw".directories = [{
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
        exec = "discord --url -- %u";
        mimeType = [ "x-scheme-handler/discord" ];
        icon = "discord";
      };
    };

    home.packages = let
      discord = (import ./firejail.nix {
        inherit pkgs lib;
        name = "discord";
        wrappedExecutable =
          "${pkgs.discord.override { nss = pkgs.nss_latest; }}/bin/discord";
        profile = "${pkgs.firejail}/etc/firejail/discord.profile";
        extraArgs = [
          "--dbus-user.talk=org.freedesktop.Notifications"
          "--ignore=private-tmp"
        ];
      });
    in [
      # needed for nvidia wayland
      (pkgs.writeShellScriptBin "discord" ''
        NIXOS_OZONE_WL= ${pkgs.expect}/bin/unbuffer ${discord}/bin/discord "$@"
      '')
    ];
  };
}
