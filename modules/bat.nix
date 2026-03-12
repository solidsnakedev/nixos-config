{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    themes = {
      catppuccin-mocha = {
        src = pkgs.catppuccin.override { variant = "mocha"; };
        file = "bat/Catppuccin Mocha.tmTheme";
      };
    };
    config.theme = "catppuccin-mocha";
  };
}
