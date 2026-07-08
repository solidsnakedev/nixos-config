{ pkgs, inputs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.vim
    ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  programs.zsh.enable = true;

  # Enable TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  services = {
    skhd.enable = false;
    tailscale.enable = true;
  };

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # Set primary user
  system.primaryUser = "jonathan";

  system.defaults = {
    dock =
      {
        autohide = true;
        orientation = "bottom";
        persistent-apps = [
          "/Applications/Brave Browser.app"
          "/Users/jonathan/Applications/Home Manager Apps/Alacritty.app"
          "/System/Applications/Launchpad.app"
        ];
      };
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    brews = [
      "borders"
      "opencode"
      "openjdk@17" # Canton 3.5 / Daml dpm needs JDK 17 (NOT JDK 20); keg-only
      # hermes-platform-cli (`box`) toolchain (uv stays standalone; docker via the cask below)
      "kubectl" # talks to each box's cluster
      "helm" # box create / box destroy
      "rsync" # box image load (newer than macOS's built-in rsync)
      "magic-wormhole" # wormhole send/receive , one-time E2E-encrypted transfers
    ];
    casks = [
      "claude"
      "docker-desktop"
      "tailscale-app"
      "postman"
      "aerospace"
      "whatsapp"
      "telegram"
      "bitwarden"
      "logi-options+"
    ];
    # Third-party taps are declared here (not in the structured `taps` option)
    # so they can be marked `trusted: true`. Homebrew 6 refuses to load formulae
    # from untrusted taps (e.g. felixkratz/formulae -> borders), and nix-darwin's
    # `taps` option can't emit that flag yet. This replaces a manual `brew trust`.
    extraConfig = ''
      tap "nikitabobko/tap", trusted: true
      tap "felixkratz/formulae", trusted: true
    '';
  };

  # Global system settings
  system.defaults.NSGlobalDomain = {
    # Disable press-and-hold for keys
    ApplePressAndHoldEnabled = false;
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}

