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
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        custom_highlights = ''
          function(colors)
            return {
              LineNr = { fg = colors.overlay2, style = {} },
            }
          end
        '';
      };
    };
    plugins = {
      # UI Enhancements
      # Add file type icons to various plugins
      web-devicons.enable = true;
      # Lightweight and customizable status line
      lualine.enable = true;
      # Seamless navigation between tmux and vim panes
      tmux-navigator.enable = true;
      # Improved syntax highlighting and parsing
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          incremental_selection.enable = true;
        };
      };
      # Git integration using lazygit
      lazygit.enable = true;
      # Adds a buffer line with tab-like interface
      bufferline.enable = true;
      barbecue.enable = true;
      # Automatically close brackets, parentheses, and quotes
      nvim-autopairs.enable = true;
      # Integrate with direnv for environment management
      direnv.enable = true;
      # Display key binding hints and help
      which-key.enable = true;
      # Enhanced command-line completion
      noice = {
        enable = true;
        settings = {
          presets = {
            lsp_doc_border = true;
          };
        };
      };
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
      notify.enable = true;
      # Improved text wrapping
      wrapping.enable = true;
      # Automatically saves and restores session state
      auto-session.enable = true;

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
      # Add icons to completion menu
      lspkind.enable = true;
      # Automatic code formatting
      lsp-format.enable = true;

      # Code Formatting with conform-nvim
      conform-nvim = {
        enable = true;
        settings = {
          notify_on_error = true;
          format_on_save = {
            lspFallback = true;
            timeoutMs = 500;
          };
          formatters_by_ft = {
            javascript = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              stop_after_first = true;
            };
            typescript = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              stop_after_first = true;
            };
            typescriptreact = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              stop_after_first = true;
            };
            rust = [ "rustfmt" ];
          };
        };
      };

      # Autocompletion engine configuration
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          window =
            {
              completion.border = "rounded";
              documentation.border = "rounded";
            };
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
            { name = "friendly_snippets"; }
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

      # Snippets
      # Snippet engine with auto-snippet support
      luasnip = {
        enable = true;
        settings = {
          # Enable automatic snippet expansion
          enable_autosnippets = true;
        };
      };
      # Snippet management plugin
      nvim-snippets = {
        enable = true;
        settings = {
          friendly-snippets = true;
        };
      };
      # Pre-configured Snippet Collection
      friendly-snippets.enable = true;

    };
    # Load additional Lua configuration from init.lua
    extraConfigLua = builtins.readFile ./init.lua;
    # Add extra plugins (in this case, aiken-vim)
    extraPlugins = [ aiken-vim ];
  };
}
