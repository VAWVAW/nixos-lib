{ config, pkgs, lib, ... }:
let
  cfg = config.programs.element-desktop;

  defaultPackage = (import ../lib/firejail.nix {
    inherit pkgs lib;
    package = pkgs.element-desktop;
    profile = "${pkgs.firejail}/etc/firejail/electron.profile";
    extraArgs = [
      "--dbus-user.talk=org.freedesktop.Notifications"
      "--dbus-user.talk=org.freedesktop.portal.Desktop"
      "--dbus-user.talk=org.kde.StatusNotifierWatcher"

      "--ignore=noexec /tmp"
      "--mkdir=\\\${HOME}/.config/Element"
      "--noblacklist=\\\${HOME}/.config/Element"
      "--whitelist=\\\${HOME}/.config/Element"
      "--dbus-user=filter"
      "--ignore=dbus-user none"
    ];
  }).overrideAttrs (old: {
    postPhases = old.postPhases ++ [ "wrapUnbufferPhase" ];
    wrapUnbufferPhase = ''
      (
          local prog="$out/bin/element-desktop"
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
  options.programs.element-desktop = {
    enable = lib.mkEnableOption "element-desktop";
    package = lib.mkOption {
      type = lib.types.package;
      default = defaultPackage;
    };
  };

  config = lib.mkIf cfg.enable {

    home.needsPersistence.directories = [{
      directory = ".config/Element";
      method = "symlink";
    }];

    home.packages = [ cfg.package ];
  };
}
