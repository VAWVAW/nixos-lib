{ config, pkgs, lib, ... }:
let
  cfg = config.programs.signal-desktop;

  defaultPackage = (import ../lib/firejail.nix {
    inherit pkgs lib;
    package = pkgs.signal-desktop-bin;
    profile = "${pkgs.firejail}/etc/firejail/signal-desktop.profile";
    extraArgs = [ "--dbus-user.talk=org.freedesktop.portal.Desktop" ];
  }).overrideAttrs (old: {
    postPhases = old.postPhases ++ [ "wrapUnbufferPhase" ];
    wrapUnbufferPhase = ''
      (
          local prog="$out/bin/signal-desktop"
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
  options.programs.signal-desktop = {
    enable = lib.mkEnableOption "signal-desktop";
    package = lib.mkOption {
      type = lib.types.package;
      default = defaultPackage;
    };
  };

  config = lib.mkIf cfg.enable {

    home.needsPersistence.directories = [{
      directory = ".config/Signal";
      method = "symlink";
    }];

    home.packages = [ cfg.package ];
  };
}
