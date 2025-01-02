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

  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        import = [
          "${pkgs.alacritty-theme}/catppuccin_mocha.toml"
        ];
      };
      env = {
        TERM = "xterm-256color";
      };
      terminal.shell = "${pkgs.fish}/bin/fish";
      font = {
        size = 14;
        normal.family = "JetBrainsMono Nerd Font";
      };
      window = {
        decorations = "Buttonless";
        padding = { x = 10; y = 10; };
        opacity = 0.95;
      };
      selection = {
        save_to_clipboard = true;
      };
      keyboard.bindings = [
        # Delete entire line
        { key = "Back"; mods = "Command"; chars = "\\u0015"; }
        # Move to end of line
        { key = "Right"; mods = "Command"; chars = "\\u0005"; }
        # Move to start of line
        { key = "Left"; mods = "Command"; chars = "\\u0001"; }
      ];
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
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
      darwin-switch = "darwin-rebuild switch --flake ~/nixos-config";
      home-switch = "home-manager switch --flake ~/nixos-config";
    };
    interactiveShellInit = ''
      neofetch --disable packages
      # export PATH="$PATH:/Users/jonathan/.aiken/bin"
      # eval "$(/opt/homebrew/bin/brew shellenv)"
      tmux source-file ~/.config/tmux/tmux.conf
    '';
  };

  xdg.configFile.yabai = {
    source = ../../config/yabai;
    recursive = true;
  };

  xdg.configFile.skhd = {
    source = ../../config/skhd;
    recursive = true;
  };

  xdg.configFile.wezterm = {
    source = ../../config/wezterm;
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
