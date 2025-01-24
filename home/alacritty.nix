{ config, lib, ... }: {
  programs.alacritty = lib.mkIf config.programs.alacritty.enable {
    settings = {
      font = {
        normal = {
          family = lib.mkDefault "monospace";
          style = lib.mkDefault "Regular";
        };
        bold = {
          family = lib.mkDefault "monospace";
          style = lib.mkDefault "Bold";
        };
        italic = {
          family = lib.mkDefault "monospace";
          style = lib.mkDefault "Italic";
        };
        bold_italic = {
          family = lib.mkDefault "monospace";
          style = lib.mkDefault "Bold Italic";
        };
        size = lib.mkDefault 10.0;
      };
      colors = {
        primary = {
          background = lib.mkDefault "#000000";
          foreground = lib.mkDefault "#ffffff";
        };
        normal = {
          black = lib.mkDefault "#000000";
          red = lib.mkDefault "#c21818";
          green = lib.mkDefault "#48c092";
          yellow = lib.mkDefault "#ff9f05";
          blue = lib.mkDefault "#4f4fff";
          magenta = lib.mkDefault "#8c00c2";
          cyan = lib.mkDefault "#18b2b2";
          white = lib.mkDefault "#b2b2b2";
        };
        bright = {
          black = lib.mkDefault "#686868";
          red = lib.mkDefault "#ff0000";
          green = lib.mkDefault "#00ff66";
          yellow = lib.mkDefault "#ffdd00";
          blue = lib.mkDefault "#0000ff";
          magenta = lib.mkDefault "#ff44ff";
          cyan = lib.mkDefault "#00ffff";
          white = lib.mkDefault "#ffffff";
        };
        dim = {
          black = lib.mkDefault "#181818";
          red = lib.mkDefault "#650000";
          green = lib.mkDefault "#006500";
          yellow = lib.mkDefault "#655e00";
          blue = lib.mkDefault "#000065";
          magenta = lib.mkDefault "#650065";
          cyan = lib.mkDefault "#006565";
          white = lib.mkDefault "#656565";
        };
      };
      keyboard.bindings = lib.mkDefault [{
        key = "Return";
        mods = "Control|Shift";
        action = "SpawnNewInstance";
      }];
    };
  };
}
