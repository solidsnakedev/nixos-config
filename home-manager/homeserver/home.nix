{ config, pkgs, inputs, ... }:


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
      fastfetch
      onefetch
      docker-compose
      pciutils
      bottom
      gnumake
      gh
      eza
      lazygit
      claude-code
      magic-wormhole-rs
      bore-cli
      uv
      (pkgs.stdenv.mkDerivation {
        pname = "opencode";
        version = "1.14.26";
        src = pkgs.fetchurl {
          url = "https://github.com/anomalyco/opencode/releases/download/v1.14.26/opencode-linux-x64.tar.gz";
          hash = "sha256-ef7aebe6990540a8dd13f28a2eae476eeaefa6bad950fa5f23b733ef29fcb5d5";
        };
        sourceRoot = ".";
        installPhase = ''
          mkdir -p $out/bin
          cp opencode $out/bin/
          chmod +x $out/bin/opencode
        '';
      })
      (writeShellScriptBin "pi" ''exec npx @mariozechner/pi-coding-agent "$@"'')
    ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      command_timeout = 1000;
    };
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
      nixos-switch = "sudo nixos-rebuild switch --flake ~/nixos-config";
      home-switch = "home-manager switch --flake ~/nixos-config";
    };
    initContent = ''
      fastfetch
    '';
  };

  imports = [
    ./../../modules/direnv.nix
    ./../../modules/git.nix
    ./../../modules/tmux.nix
    ./../../modules/bat.nix
    ./../../modules/nixvim.nix
  ];

}
