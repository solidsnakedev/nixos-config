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
    ];


  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = false;
    settings = {
      command_timeout = 1000;
    };
  };

  programs.fish = {
    enable = true;

    shellAliases = {
      l = "ls -la";
      # update = "sudo nixos-rebuild switch";
    };
    interactiveShellInit = ''
      neofetch --disable packages
      export PATH="$PATH:/Users/jonathan/.aiken/bin"
      eval "$(/opt/homebrew/bin/brew shellenv)"
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

  xdg.configFile."yabai/yabairc".text = ''
    # bsp or float (default: float)
    yabai -m config layout bsp

    # on or off (default: off)
    yabai -m config auto_balance on

    # New window spawns to the right if vertical split, or bottom if horizontal split
    yabai -m config window_placement second_child

    # Set all padding and gaps to 20pt (default: 0)
    yabai -m config top_padding    12
    yabai -m config bottom_padding 12
    yabai -m config left_padding   12
    yabai -m config right_padding  12
    yabai -m config window_gap     12

    # set mouse follows focus mode (default: off)
    yabai -m config mouse_follows_focus on

    yabai -m config focus_follows_mouse off

    yabai -m config mouse_drop_action swap

    # set mouse interaction modifier key (default: fn)
    yabai -m config mouse_modifier alt

    # set modifier + left-click drag to move window (default: move)
    yabai -m config mouse_action1 move

    # set modifier + right-click drag to resize window (default: resize)
    yabai -m config mouse_action2 resize

    # float system preferences
    yabai -m rule --add app="^System Settings$" manage=off
    yabai -m rule --add app="^Calculator$" manage=off
    yabai -m rule --add app="^Activity Monitor$" manage=off
    yabai -m rule --add app="^Mail$" manage=off
    yabai -m rule --add app="^PenTablet$" manage=off
    yabai -m rule --add app="^Spotify$" manage=off
    yabai -m rule --add app="^zoom.us$" manage=off
    yabai -m rule --add app="^Calendar$" manage=off

  '';

  xdg.configFile."skhd/skhdrc".text = ''
    alt - j : yabai -m window --focus south
    alt - k : yabai -m window --focus north
    alt - h : yabai -m window --focus west
    alt - l : yabai -m window --focus east

    # rotate layout clocwise
    shift + alt - r : yabai -m space --rotate 270

    # swap layout
    shift + alt - s : yabai -m window --swap recent

    # maximize a window
    shift + alt - m  : yabai -m window --toggle zoom-fullscreen

    # float / unfloat window and center on screen
    shift + alt - t : yabai -m window --toggle float --grid 4:4:1:1:2:2

    # Move focus container to workspace
    shift + alt - n : yabai -m window --space next; yabai -m space --focus next

    # increase window size
    shift + alt - h : yabai -m window --resize left:-20:0; yabai -m window --resize right:20:0
    shift + alt - j : yabai -m window --resize bottom:0:20
    shift + alt - k : yabai -m window --resize top:0:-20
    shift + alt - l : yabai -m window --resize right:-20:0; yabai -m window --resize left:20:0

    # open iterm
    alt - return : open -na /Applications/iTerm.app
  '';

    # programs.zsh = {
    #   enable = true;
    #   shellAliases = {
    #     ll = "ls -l";
    #     # update = "sudo nixos-rebuild switch";
    #   };
    #   history = {
    #     size = 10000;
    #     path = "${config.xdg.dataHome}/zsh/history";
    #   };
    #   enableVteIntegration = true;
    #   # zplug = {
    #   #   enable = true;
    #   #   plugins = [
    #   #     { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
    #   #     { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
    #   #   ];
    #   # };
    # };


    imports = [
  # ./../common-modules/fish.nix
  ./../common-modules/direnv.nix
  ./../common-modules/git.nix
  ./../common-modules/tmux.nix
  ./../common-modules/bat.nix
  ./local-modules/neovim.nix
  ];

}
