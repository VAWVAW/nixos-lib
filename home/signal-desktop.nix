{ config, pkgs, lib, ... }: {
  options.programs.signal-desktop.enable = lib.mkEnableOption "signal-desktop";

  config = lib.mkIf config.programs.signal-desktop.enable {
    home.persistence."/persist/home/vaw" = {
      directories = [{
        directory = ".config/Signal";
        method = "symlink";
      }];
    };

    home.packages = let
      signal-desktop = (import ./firejail.nix {
        inherit pkgs lib;
        name = "signal-desktop";
        wrappedExecutable = "${pkgs.signal-desktop}/bin/signal-desktop";
        profile = "${pkgs.firejail}/etc/firejail/signal-desktop.profile";
        extraArgs = [ "--dbus-user.talk=org.freedesktop.portal.Desktop" ];
      });
    in [
      # needed for nvidia wayland
      (pkgs.writeShellScriptBin "signal-desktop" ''
        NIXOS_OZONE_WL= ${pkgs.expect}/bin/unbuffer ${signal-desktop}/bin/signal-desktop
      '')
    ];
  };
}
