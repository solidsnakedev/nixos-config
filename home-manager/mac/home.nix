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

  # ~/.local/bin for uv-installed tools (marker-pdf, etc.)
  home.sessionPath = [ "$HOME/.local/bin" ];

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
      claude-code
      inputs.hermes-agent.packages.aarch64-darwin.default
      inputs.opencode.packages.aarch64-darwin.default

       # Python tool runner (for imperatively-installed ML CLIs like marker-pdf, mineru)
       uv

       # URL / content extraction toolkit
       yt-dlp                       # video/audio downloader (1000+ sites)
      ffmpeg                       # required by yt-dlp for audio/merge
      pandoc                       # universal doc converter
      whisper-cpp                  # local audio transcription
      gitingest                    # github repo -> LLM-friendly text
      python313Packages.trafilatura  # article/HTML extraction CLI
      python3Packages.twscrape       # twitter/X scraping CLI
      (pkgs.callPackage ../../pkgs/readability-cli { })
      (pkgs.callPackage ../../pkgs/crawl4ai { })
      # pdf2md: tiny CLI wrapper around pymupdf4llm (PDF -> markdown, no ML)
      (pkgs.writers.writePython3Bin "pdf2md" {
        libraries = [ pkgs.python3Packages.pymupdf4llm ];
        flakeIgnore = [ "E501" "W503" ];
      } ''
        import sys
        import pymupdf4llm

        if len(sys.argv) < 2 or sys.argv[1] in ("-h", "--help"):
            print("usage: pdf2md <file.pdf> [output.md]")
            print("  Converts PDF to markdown. Writes to stdout if output not given.")
            sys.exit(0 if len(sys.argv) >= 2 else 1)

        md = pymupdf4llm.to_markdown(sys.argv[1])
        if len(sys.argv) >= 3:
            with open(sys.argv[2], "w") as f:
                f.write(md)
        else:
            sys.stdout.write(md)
      '')
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
