{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      neofetch
    '';
    shellAliases = {
      l = "ls -la";
      nixos-switch = "sudo nixos-rebuild switch --flake ~/nixos-config";
      home-switch = "home-manager switch --flake ~/nixos-config";
    };
  };
}
