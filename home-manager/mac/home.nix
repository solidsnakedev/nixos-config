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

  # ~/.local/bin for uv-installed tools (marker-pdf, etc.); ~/.dpm/bin for the Daml dpm CLI
  home.sessionPath = [ "$HOME/.local/bin" "$HOME/nixos-config/scripts" "$HOME/.aiken/bin" "$HOME/.dpm/bin" "/opt/homebrew/bin" ];

  # JDK 17 for Canton/Daml (dpm). openjdk@17 is installed via homebrew (keg-only).
  home.sessionVariables.JAVA_HOME = "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home";

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
      github-copilot-cli
      eza
      lazygit
      typst
      inputs.herdr.packages.aarch64-darwin.default
      (writeShellScriptBin "pi" ''exec npx @mariozechner/pi-coding-agent "$@"'')

       # Python tool runner (ingest.py deps managed via uv inline metadata)
       uv

       # System tools still needed by ingest.py and other workflows
      ffmpeg                       # required by yt-dlp for audio/merge
      pandoc                       # universal doc converter
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
      python = {
        disabled = true;
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
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
      # Pin the flake attribute. Without it darwin-rebuild picks the config by
      # `scutil --get LocalHostName`, which macOS silently renames on a Bonjour
      # name collision (Jonathans-MacBook-Pro -> ...-2) and the switch then
      # fails with "does not provide attribute". networking.hostName in
      # hosts/mac/configuration.nix resets the name on every switch, but this
      # keeps the command working even before that lands.
      darwin-switch = "sudo darwin-rebuild switch --flake ~/nixos-config#Jonathans-MacBook-Pro";
      home-switch = "home-manager switch --flake ~/nixos-config#jonathan";
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
    ./../../modules/herdr.nix
    ./../../modules/bat.nix
    # ./../../modules/neovim.nix
    ./../../modules/nixvim.nix
  ];

}
