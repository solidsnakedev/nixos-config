{ config, pkgs, ... }:


{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "homeserver";
  home.homeDirectory = "/home/homeserver";
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages =
    with pkgs; [
      wget
      jq
      ripgrep
      trashy
      nodejs
      ntfs3g
      nixpkgs-lint
      nixpkgs-fmt
      nil
      neofetch
      onefetch
      docker-compose
      pciutils
      bottom
      gnumake
      gh
    ];

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = false;
    settings = {
      command_timeout = 1000;
    };
  };

  imports = [
    ./../../modules/fish.nix
    ./../../modules/direnv.nix
    ./../../modules/git.nix
    ./../../modules/tmux.nix
    ./../../modules/bat.nix
    ./../../modules/neovim.nix
  ];

}
