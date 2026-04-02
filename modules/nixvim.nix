{ pkgs, ... }:
let
  quint-language-server =
    let
      tarball = pkgs.fetchurl {
        url = "https://registry.npmjs.org/@informalsystems/quint-language-server/-/quint-language-server-0.19.0.tgz";
        hash = "sha256-gNoz7Pu+/TO/Vp86IB8tfZ9vHN78L7eRllITNtsnGFY=";
      };
      lockfile = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/informalsystems/quint/v0.32.0/vscode/quint-vscode/server/package-lock.json";
        hash = "sha256-2Do+6Ww2SMN9JaH7Nf7yHATY7NJUJga6giTH6XgwQEE=";
      };
    in
    pkgs.buildNpmPackage {
      pname = "quint-language-server";
      version = "0.19.0";
      src = pkgs.runCommand "quint-language-server-src" { } ''
        mkdir -p $out
        tar -xzf ${tarball} -C $out --strip-components=1
        cp ${lockfile} $out/package-lock.json
      '';
      npmDepsHash = "sha256-BT5KN9E5aRUIJQR0zGlT00tDmRpS2oFF/yOdQOPIGgQ=";
      dontNpmBuild = true;
      installPhase = ''
        mkdir -p $out/bin $out/lib/quint-language-server
        cp -r out package.json node_modules $out/lib/quint-language-server/
        makeWrapper ${pkgs.nodejs}/bin/node $out/bin/quint-language-server \
          --add-flags "$out/lib/quint-language-server/out/src/server.js" \
          --add-flags "--stdio"
      '';
    };

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
    diagnostic.settings =
      {
        virtual_text = {
          enable = true;
        };
        float = {
          border = "rounded";
        };
      };
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
      colorizer.enable = true;
      # Lightweight and customizable status line
      lualine = {
        enable = true;
      };
      # Seamless navigation between tmux and vim panes
      tmux-navigator.enable = true;
      # Improved syntax highlighting and parsing
      treesitter = {
        enable = true;
        grammarPackages =
          pkgs.vimPlugins.nvim-treesitter.allGrammars
          ++ [ pkgs.tree-sitter-grammars.tree-sitter-quint ];
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
          routes = [{
            view = "notify";
            filter = {
              event = "msg_showmode";
              find = "recording";
            };
          }];
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
      notify = {
        settings.top_down = true;
        enable = true;
      };
      neoscroll.enable = true;
      # Improved text wrapping
      wrapping.enable = true;
      # Automatically saves and restores session state
      auto-session.enable = true;
      markdown-preview.enable = true;

      # Language Server Protocol (LSP)
      lsp = {
        enable = true;
        servers = {
          # Aiken language server for Cardano smart contract development
          aiken = {
            enable = true;
            cmd = [ "aiken" "lsp" ];
            filetypes = [ "aiken" ];
            rootMarkers = [ "aiken.toml" ];
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
            package = null;
          };
          # TypeScript language server
          ts_ls.enable = true;
          jsonls.enable = true;
          tinymist.enable = true;
          dockerls.enable = true;
          docker_compose_language_service.enable = true;
        };
      };
      # Add icons to completion menu
      lspkind.enable = true;

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
          performance.max_view_entries = 20;
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          # Completion key mappings
          mapping = {
            # Show completion menu
            "<C-Space>" = "cmp.mapping.complete()";
            # Scroll documentation up
            "<S-k>" = "cmp.mapping.scroll_docs(-4)";
            # Scroll documentation down
            "<S-j>" = "cmp.mapping.scroll_docs(4)";
            # Confirm selection
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            # Navigate completion menu (previous item)
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            # Navigate completion menu (next item)
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };

      # GitHub Copilot inline completions (ghost text)
      copilot-lua = {
        enable = true;
        settings = {
          suggestion = {
            enabled = true;
            auto_trigger = true;
            keymap = {
              accept = "<M-l>";
              accept_word = "<M-w>";
              next = "<M-]>";
              prev = "<M-[>";
              dismiss = "<C-]>";
            };
          };
          panel.enabled = false;
        };
      };

      # AI chat and inline edits with diff accept/deny
      codecompanion = {
        enable = true;
        settings = {
          strategies = {
            chat.adapter = "copilot";
            inline.adapter = "copilot";
            agent.adapter = "copilot";
          };
        };
      };

      # Snippets
      # Snippet engine with auto-snippet support
      luasnip = {
        enable = true;
        settings = {
          enable_autosnippets = true;
        };
        fromVscode = [ { } ];
      };
      # Pre-configured Snippet Collection
      friendly-snippets.enable = true;
    };
    filetype.extension.qnt = "quint";

    # Load additional Lua configuration from init.lua
    extraConfigLua = builtins.readFile ./init.lua + ''

      -- Quint language server (custom lspconfig registration)
      do
        local configs = require('lspconfig.configs')
        local lspconfig = require('lspconfig')
        if not configs.quint_language_server then
          configs.quint_language_server = {
            default_config = {
              cmd = { '${quint-language-server}/bin/quint-language-server', '--stdio' },
              filetypes = { 'quint' },
              root_dir = lspconfig.util.root_pattern('quint.json', '.git'),
            },
          }
        end
        lspconfig.quint_language_server.setup({})
      end
    '';
    # Add extra plugins (in this case, aiken-vim)
    extraPlugins = [
      aiken-vim
      pkgs.vimPlugins.typst-preview-nvim
    ];
  };
}
