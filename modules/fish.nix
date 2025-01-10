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
     plugins = [{
      name = "foreign-env";
      src = pkgs.fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "plugin-foreign-env";
        rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
        sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
      };
    }];
  };
}
