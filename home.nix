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
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    wget
    jq
    nixpkgs-lint
    nixpkgs-fmt
    neofetch
    onefetch
  ];


  programs.git = {
    enable = true;
    userName = "solidsnakedev";
    userEmail = "jona.ca.eng@gmail.com";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
      set number relativenumber
    '';
    plugins = with pkgs.vimPlugins; [
      fzf-vim
      gitv
      vim-airline
      vim-fugitive
      vim-nix
      vim-sensible
      vim-surround
      vim-unimpaired
      vim-vinegar
      nerdtree
      vim-devicons
    ];
  };

  programs.bat = {
    enable = true;
  };
}
