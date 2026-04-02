{ config, pkgs, inputs, ... }:


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
      fastfetch
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
      lazygit
      typst
      claude-code
      inputs.hermes-agent.packages.aarch64-darwin.default
    ];

  programs.alacritty = {
    enable = true;
    theme = "catppuccin_mocha";
    settings = {
      env = {
        TERM = "xterm-256color";
      };
      terminal.shell = "${pkgs.zsh}/bin/zsh";
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
        # Delete to beginning of line
        { key = "Backspace"; mods = "Command"; chars = "\\u0015"; }
        # Move to end of line
        { key = "Right"; mods = "Command"; chars = "\\u0005"; }
        # Move to start of line
        { key = "Left"; mods = "Command"; chars = "\\u0001"; }
        # Move word forward/backward (zsh emacs: \ef / \eb)
        { key = "Right"; mods = "Option"; chars = "\\u001bf"; }
        { key = "Left"; mods = "Option"; chars = "\\u001bb"; }
      ];
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
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
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    shellAliases = {
      l = "eza -lh --git --octal-permissions";
      ll = "eza -la --git --octal-permissions";
      darwin-switch = "sudo darwin-rebuild switch --flake ~/nixos-config";
      home-switch = "home-manager switch --flake ~/nixos-config";
    };
    initContent = ''
      bindkey "^U" backward-kill-line  # Cmd+Backspace: delete from cursor to beginning (not whole line)

      fastfetch
    '';
  };

  xdg.configFile.aerospace = {
    source = ../../config/aerospace;
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
