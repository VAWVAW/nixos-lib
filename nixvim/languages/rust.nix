{ config, pkgs, lib, ... }: {
  options.languages.rust.enable = lib.mkEnableOption "rust language support";

  config = lib.mkIf config.languages.rust.enable {
    plugins = {
      lsp.enable = true;
      dap.enable = true;
    };
    plugins.rustaceanvim = {
      enable = true;
      settings = {
        dap = {
          adapter = {
            port = "13000";
            executable = {
              command =
                "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
              args = [ "--port" "13000" ];
            };
            type = "server";
          };
          autoloadConfigurations = true;
        };

        server = {
          default_settings = {
            rust-analyzer = {
              cargo.features = "all";
              diagnostics.styleLints.enable = true;

              check = {
                command = "clippy";
                features = "all";
              };

              files.excludeDirs =
                [ ".cargo" ".direnv" ".git" "node_modules" "target" ];

              inlayHints = {
                closureStyle = "rust_analyzer";
                closureCaptureHints.enable = true;
                discriminantHints.enable = "always";
                expressionAdjustmentHints.enable = "always";
                expressionAdjustmentHints.hideOutsideUnsafe = true;
                lifetimeElisionHints.enable = "skip_trivial";
              };

              rustc.source = "discover";
            };
          };
        };
      };
    };
  };
}
