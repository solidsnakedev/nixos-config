{ config, pkgs, ... }:


{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jonathan";
  home.homeDirectory = "/Users/jonathan";
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
      bore-cli
      magic-wormhole-rs
      commitizen
      convco
      gh
      eza
    ];


  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = false;
    settings = {
      command_timeout = 1000;
      character = {
        success_symbol = "[𝝺](bold green)";
        error_symbol = "[𝝺](bold red)";
      };
    };

  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;

    shellAliases = {
      l = "eza -lh --git --octal-permissions";
      ll = "eza -la --git --octal-permissions";
      # update = "sudo nixos-rebuild switch";
      home-switch = "home-manager switch --flake ~/nixos-config";
    };
    interactiveShellInit = ''
      neofetch --disable packages
      export PATH="$PATH:/Users/jonathan/.aiken/bin"
      eval "$(/opt/homebrew/bin/brew shellenv)"
      tmux source-file ~/.config/tmux/tmux.conf
    '';
    plugins = [{
      name = "foreign-env";
      src = pkgs.fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "plugin-foreign-env";
        rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
        sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
      };
    }
      {
        name = "nix-env.fish";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
          sha256 = "RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
        };
      }];

  };

  xdg.configFile.yabai = {
    source = ../../config/yabai;
    recursive = true;
  };

  xdg.configFile.skhd = {
    source = ../../config/skhd;
    recursive = true;
  };


  imports = [
    ./../../modules/direnv.nix
    ./../../modules/git.nix
    ./../../modules/tmux.nix
    ./../../modules/bat.nix
    # ./../../modules/neovim.nix
    ./../../modules/nixvim.nix
  ];

}
