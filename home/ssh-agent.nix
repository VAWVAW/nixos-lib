{ config, pkgs, lib, ... }:

# this module adds to the upstream in home-manager

let
  cfg = config.services.ssh-agent;
  openssh = config.programs.ssh.package or pkgs.openssh;

  askPasswordWrapper = pkgs.writeScript "ssh-askpass-wrapper" ''
    #! ${pkgs.runtimeShell} -e
    export DISPLAY="$(systemctl --user show-environment | ${pkgs.gnused}/bin/sed 's/^DISPLAY=\(.*\)/\1/; t; d')"
    export XAUTHORITY="$(systemctl --user show-environment | ${pkgs.gnused}/bin/sed 's/^XAUTHORITY=\(.*\)/\1/; t; d')"
    export WAYLAND_DISPLAY="$(systemctl --user show-environment | ${pkgs.gnused}/bin/sed 's/^WAYLAND_DISPLAY=\(.*\)/\1/; t; d')"
    exec ${cfg.askPass} "$@"
  '';
in {
  options.services.ssh-agent = {
    askPass = lib.mkOption {
      description = "ssh-askpass programs to use";
      type = lib.types.str;
      default = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
      example = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
    };

    timeout = lib.mkOption {
      description = "How long to keep the private keys in memory";
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "1h";
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables."SSH_ASKPASS" = cfg.askPass;
    home.sessionVariablesExtra = ''
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"
    '';

    systemd.user.services."ssh-agent".Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/rm -f %t/ssh-agent";
      ExecStart = lib.mkForce ("${openssh}/bin/ssh-agent -a %t/ssh-agent"
        + lib.optionalString (cfg.timeout != null) "-t ${cfg.timeout}");
      StandardOutput = "null";
      Type = "forking";
      Restart = "on-failure";
      SuccessExitStatus = "0 2";

      # Allow ssh-agent to ask for confirmation. This requires the
      # unit to know about the user's $DISPLAY (via ‘systemctl
      # import-environment’).
      Environment = [ "SSH_ASKPASS=${askPasswordWrapper}" "DISPLAY=fake" ];
    };

  };
}
