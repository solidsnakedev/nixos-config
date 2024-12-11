{ pkgs, ... }:
let
  aiken-vim = pkgs.vimUtils.buildVimPlugin {
    pname = "aiken";
    version = "2024";
    src = pkgs.fetchFromGitHub {
      owner = "aiken-lang";
      repo = "editor-integration-nvim";
      rev = "a816a1f171a5d53c9e5dcba6f6823f5d5e51d559";
      sha256 = "sha256-v6/6oAPOgvMHpULDSyN1KzOf33q92Wri2BcqcuHGJzI=";
    };
  };
in
{
  programs.nixvim = {
    enable = true;
    # Create aliases for Vi and Vim commands
    viAlias = true;
    vimAlias = true;

    # Color Scheme
    # Use Catppuccin color scheme
    colorschemes.catppuccin.enable = true;
    plugins = {
      # UI Enhancements
      # Add file type icons to various plugins
      web-devicons.enable = true;
      # Lightweight and customizable status line
      lualine.enable = true;
      # Seamless navigation between tmux and vim panes
      tmux-navigator.enable = true;
      # Improved syntax highlighting and parsing
      treesitter.enable = true;
      # Git integration using lazygit
      lazygit.enable = true;
      # Adds a buffer line with tab-like interface
      bufferline.enable = true;
      # Automatically close brackets, parentheses, and quotes
      nvim-autopairs.enable = true;
      # Integrate with direnv for environment management
      direnv.enable = true;
      # Display key binding hints and help
      which-key.enable = true;
      # Enhanced command-line completion
      wilder.enable = true;
      # Powerful fuzzy finder and picker
      telescope.enable = true;
      # Improve the look of vim's native UI elements
      dressing.enable = true;
      # Start screen with recent files and shortcuts
      dashboard.enable = true;
      # Easy word and line navigation
      hop.enable = true;
      # File tree explorer with git integration
      neo-tree.enable = true;
      # Highlight and list TODO and other special comments
      todo-comments.enable = true;
      # Easily modify surrounding characters
      vim-surround.enable = true;
      # Reopen files at the last edit position
      lastplace.enable = true;
      # Improved buffer deletion
      bufdelete.enable = true;
      # Show LSP progress and status
      fidget.enable = true;
      # Improved text wrapping
      wrapping.enable = true;

      # lsp
      # rust-tools.enable = true;
      # typescript-tools = {
      #   enable = true;
      #   settings.settings.exposeAsCodeAction = "all";
      # };

      # Language Server Protocol (LSP)
      lsp = {
        enable = true;
        servers = {
          # Aiken language server for Cardano smart contract development
          aiken = {
            enable = true;
            cmd = [ "aiken" "lsp" ];
            filetypes = [ "aiken" ];
            rootDir = "require('lspconfig.util').root_pattern('aiken.toml')";
          };
          # Nix language server with nixpkgs-fmt for formatting
          nil_ls = {
            enable = true; # Enable nil_ls. You can use nixd or anything you want from the docs.
            settings.formatting.command = [ "nixpkgs-fmt" ];
          };
          # Lua language server with vim global recognized
          lua_ls = {
            enable = true;
            settings.diagnostics.globals = [ "vim" ];
          };
          # Rust language server without installing cargo and rustc
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          # Haskell language server without installing GHC
          hls = {
            enable = true;
            installGhc = false;
          };
          # TypeScript language server
          ts_ls.enable = true;
        };
      };
      # Enhanced LSP UI with code actions and more
      lspsaga = {
        enable = true;
        # Disable lightbulb code action indicator
        lightbulb.enable = false;
      };
      # Add icons to completion menu
      lspkind.enable = true;
      # Automatic code formatting
      lsp-format.enable = true;

      # Snippets
      # Snippet management plugin
      nvim-snippets.enable = true;
      # Collection of pre-made snippets
      friendly-snippets.enable = true;
      # Snippet engine with auto-snippet support
      luasnip = {
        enable = true;
        settings = {
          # Enable automatic snippet expansion
          enable_autosnippets = true;
        };
      };

      # Autocompletion
      # Use LSP as a completion source
      cmp-nvim-lsp.enable = true;
      # Add path completion
      cmp-path.enable = true;
      # Add buffer word completion
      cmp-buffer.enable = true;
      # Enable LuaSnip as a completion source
      cmp_luasnip.enable = true;
      # Completion engine configuration
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          # Automatically enable completion sources
          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
          # Define completion sources
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "luasnip"; }
            { name = "snippets"; }
          ];
          # Completion key mappings
          mapping = {
            # Show completion menu
            "<C-Space>" = "cmp.mapping.complete()";
            # Scroll documentation up
            "<C-u>" = "cmp.mapping.scroll_docs(-4)";
            # Scroll documentation down
            "<C-d>" = "cmp.mapping.scroll_docs(4)";
            # Confirm selection
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            # Navigate completion menu (previous item)
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            # Navigate completion menu (next item)
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };

    };
    # Load additional Lua configuration from init.lua
    extraConfigLua = builtins.readFile ./init.lua;
    # Add extra plugins (in this case, aiken-vim)
    extraPlugins = [ aiken-vim ];
  };
}
