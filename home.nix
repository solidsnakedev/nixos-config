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

  home.packages =
    with pkgs; [
      wget
      jq
      nodejs
      ntfs3g
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
    coc = {
      enable = true;
      settings = {
        "suggest.noselect" = true;
        "suggest.enablePreview" = true;
        "suggest.enablePreselect" = false;
        "suggest.disableKind" = true;
        languageserver = {
          haskell = {
            command = "haskell-language-server";
            args = [ "--lsp" ];
            rootPatterns = [
              "*.cabal"
              "stack.yaml"
              "cabal.project"
              "package.yaml"
              "hie.yaml"
            ];
            filetypes = [ "haskell" "lhaskell" ];
          };
        };
      };
    };
    extraPackages = [
      pkgs.nodejs # coc requires nodejs
    ];
    extraLuaConfig = ''

      function map (mode, shortcut, command)
      vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
      end

      function nmap(shortcut, command)
      map('n', shortcut, command)
      end

      function imap(shortcut, command)
      map('i', shortcut, command)
      end

    '';
    extraConfig = ''
      let mapleader=" "
      set nocompatible            " disable compatibility to old-time vi
      set showmatch               " show matching 
      set ignorecase              " case insensitive 
      set mouse=v                 " middle-click paste with 
      set hlsearch                " highlight search 
      set incsearch               " incremental search
      set tabstop=4               " number of columns occupied by a tab 
      set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
      set expandtab               " converts tabs to white space
      set shiftwidth=4            " width for autoindents
      set autoindent              " indent a new line the same amount as the line just typed
      set number                  " add line numbers
      set wildmode=longest,list   " get bash-like tab completions
      filetype plugin indent on   "allow auto-indenting depending on file type
      syntax on                   " syntax highlighting
      set mouse=a                 " enable mouse click
      set clipboard=unnamedplus   " using system clipboard
      filetype plugin on
      set cursorline              " highlight current cursorline
      set ttyfast                 " Speed up scrolling in Vim
    '';
    plugins = with pkgs.vimPlugins; [
      # Basic settings
      sensible
      # Language support
      vim-nix
      # direnv
      direnv-vim
      # tmux integration
      vim-tmux-navigator
      # Comments
      {
        plugin = comment-nvim;
        type = "lua";
        config = ''
          require('Comment').setup()
        '';
      }

      # Syntax 
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      # Buffer tabs
      {
        plugin = bufferline-nvim;
        type = "lua";
        config = ''
          vim.opt.termguicolors = true
          require("bufferline").setup( { 
            options = {
              mode = 'buffers',
              offsets = {
                  {filetype = 'NvimTree'}
              },
          }
          })
          nmap("<leader>b", ":BufferLineCycleNext<cr>")
          nmap("<leader>B", ":BufferLineCyclePrev<cr>")
        '';
      }

      # Icons Tree
      nvim-web-devicons
      # File Tree
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          -- empty setup using defaults
          require("nvim-tree").setup{ }
          nmap("<leader>n", ":NvimTreeToggle<cr>")
        '';
      }

      # Theme
      {

        plugin = tokyonight-nvim;
        config = ''
          colorscheme tokyonight
        '';
      }
      # Airline theme
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup {
            options = {
              theme = 'tokyonight'
            }
          }
        '';
      }


    ];
  };

  programs.bat = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins ; [
      vim-tmux-navigator
      better-mouse-mode
      {
        plugin = dracula;
        extraConfig = ''
                          set -g @dracula-plugins "cpu-usage ram-usage network-bandwidth time weather"
          				set -g @dracula-show-powerline true
          			'';
      }
    ];
    extraConfig = ''
      #Configure True Colors
      set -g default-terminal "screen-256color"
      
      # Mouse works as expected
      set-option -g mouse on

      #Add keybind for maximizing and minimizing tmux pane
      bind -r m resize-pane -Z

      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.fish.enable = true;


}
