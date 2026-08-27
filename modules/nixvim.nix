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

  # Notification-bar view for noice: full-width transient bar flush above
  # the statusline; hl picks the severity tint (see catppuccin highlights).
  noiceMiniView = hl: {
    backend = "mini";
    align = "message-left";
    timeout = 4000;
    # Anchor the bar's bottom edge above the statusline so multi-line
    # messages grow upward into the editor, never over the statusline.
    anchor = "SW";
    position = { row = -1; col = 0; };
    size = { width = "100%"; height = "auto"; };
    border.style = "none";
    win_options = {
      winblend = 0;
      winhighlight.Normal = hl;
    };
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
    # Reuse the host's nixpkgs instance (which sets allowUnfree) instead of
    # letting nixvim re-import nixpkgs with an empty config. Without this,
    # unfree plugin deps such as copilot-language-server fail to evaluate.
    nixpkgs.pkgs = pkgs;
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
              -- Notification bar (noice mini views): quiet surface, text
              -- tinted by severity
              NoiceMiniInfo = { bg = colors.surface0, fg = colors.blue },
              NoiceMiniWarn = { bg = colors.surface0, fg = colors.yellow },
              NoiceMiniError = { bg = colors.surface0, fg = colors.red },
            }
          end
        '';
      };
    };
    # claude-code itself comes from the npm install in ~/.local, not nixpkgs.
    dependencies.claude-code.enable = false;

    # Language servers via the top-level lsp module (vim.lsp.config/enable),
    # replacing the deprecated plugins.lsp compat layer. Servers without an
    # explicit config get their base cmd/filetypes from nvim-lspconfig,
    # enabled via plugins.lspconfig below.
    lsp.servers = {
      # Aiken language server for Cardano smart contract development
      aiken = {
        enable = true;
        config = {
          cmd = [ "aiken" "lsp" ];
          filetypes = [ "aiken" ];
          root_markers = [ "aiken.toml" ];
        };
      };
      # Nix language server with nixpkgs-fmt for formatting
      nil_ls = {
        enable = true;
        config.settings."nil".formatting.command = [ "nixpkgs-fmt" ];
      };
      # Lua language server with vim global recognized
      lua_ls = {
        enable = true;
        config.settings.Lua.diagnostics.globals = [ "vim" ];
      };
      # Rust language server (rust-analyzer only; cargo and rustc come from
      # the project's devshell)
      rust_analyzer.enable = true;
      # Haskell language server from PATH (no GHC bundled)
      hls = {
        enable = true;
        package = null;
      };
      # TypeScript language server (vtsls; better monorepo handling
      # than the retired ts_ls default)
      vtsls.enable = true;
      jsonls.enable = true;
      tinymist.enable = true;
      dockerls.enable = true;
      docker_compose_language_service.enable = true;
      # Quint language server (custom package built above; freeform server
      # name, so no lspconfig registration needed)
      quint_language_server = {
        enable = true;
        config = {
          cmd = [ "${quint-language-server}/bin/quint-language-server" "--stdio" ];
          filetypes = [ "quint" ];
          root_markers = [ "quint.json" ".git" ];
        };
      };
    };

    plugins = {
      # Base server definitions (cmd/filetypes/root markers) for lsp.servers
      # entries that don't set an explicit config.
      lspconfig.enable = true;
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
      # Show current function/class context header while scrolling
      treesitter-context = {
        enable = true;
        settings = {
          max_lines = 3;
        };
      };
      # Git integration using lazygit
      lazygit.enable = true;
      # Side-by-side diff viewer for git changes and PR review
      diffview.enable = true;
      # Git gutter signs, hunk navigation, and inline blame
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add.text = "▎";
            change.text = "▎";
            delete.text = "";
            topdelete.text = "";
            changedelete.text = "▎";
          };
          current_line_blame = false;
        };
      };
      # Adds a buffer line with tab-like interface
      bufferline.enable = true;
      # Winbar breadcrumbs (replaces the archived barbecue)
      dropbar.enable = true;
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
          # Notification bar: messages render in a transient full-width bar
          # just above the statusline and disappear after the timeout. No
          # floating toasts covering code. Text color follows severity
          # (blue info, yellow warn, red error) on one quiet surface.
          notify.view = "mini";
          messages = {
            view = "mini";
            view_warn = "mini_warn";
            view_error = "mini_error";
          };
          views = {
            mini = noiceMiniView "NoiceMiniInfo";
            mini_warn = noiceMiniView "NoiceMiniWarn";
            mini_error = noiceMiniView "NoiceMiniError";
          };
          routes = [
            {
              view = "mini_warn";
              filter = { event = "notify"; warning = true; };
            }
            {
              view = "mini_error";
              filter = { event = "notify"; error = true; };
            }
            {
              view = "mini";
              filter = {
                event = "msg_showmode";
                find = "recording";
              };
            }
          ];
        };
      };
      # Powerful fuzzy finder and picker
      telescope.enable = true;
      # Improve the look of vim's native UI elements. Only the input and
      # bufdelete modules are used (dressing.nvim and bufdelete.nvim are
      # archived upstream); picker/dashboard/notifier stay with the
      # dedicated plugins.
      snacks = {
        enable = true;
        settings = {
          input.enabled = true;
        };
      };
      # Start screen with recent files and shortcuts
      dashboard.enable = true;
      # Easy word and line navigation (flash; hop's original repo is gone)
      flash.enable = true;
      # Project-wide diagnostics, references, and quickfix panel
      trouble.enable = true;
      # File tree explorer with git integration
      neo-tree.enable = true;
      # Highlight and list TODO and other special comments
      todo-comments.enable = true;
      # Easily modify surrounding characters (lua successor to vim-surround)
      nvim-surround.enable = true;
      notify = {
        settings.top_down = true;
        enable = true;
      };
      neoscroll.enable = true;
      # Improved text wrapping
      wrapping.enable = true;
      # Automatically saves and restores session state
      auto-session = {
        enable = true;
        settings = {
          # A neo-tree window restored from a session comes back without its
          # backing state and errors on interaction; close it before saving.
          close_filetypes_on_save = [ "checkhealth" "neo-tree" ];
        };
      };
      # In-buffer markdown rendering (replaces the dormant markdown-preview
      # and its node build step); also styles codecompanion chat buffers.
      render-markdown.enable = true;
      # Project-wide search and replace (ripgrep UI)
      grug-far.enable = true;

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

      # Autocompletion engine (blink.cmp; nvim-cmp is in maintenance mode).
      # Kind icons are built in, so no lspkind. Snippets stay on luasnip.
      blink-cmp = {
        enable = true;
        settings = {
          # "enter" preset: <CR> accepts, <C-space> opens the menu
          keymap = {
            preset = "enter";
            "<Tab>" = [ "select_next" "snippet_forward" "fallback" ];
            "<S-Tab>" = [ "select_prev" "snippet_backward" "fallback" ];
            "<S-k>" = [ "scroll_documentation_up" "fallback" ];
            "<S-j>" = [ "scroll_documentation_down" "fallback" ];
          };
          completion = {
            menu.border = "rounded";
            documentation = {
              auto_show = true;
              window.border = "rounded";
            };
          };
          snippets.preset = "luasnip";
          sources.default = [ "lsp" "snippets" "path" "buffer" ];
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

      # Claude Code IDE integration: nvim runs the WebSocket/MCP server that the
      # official VS Code extension speaks, so a `claude` session in a tmux pane
      # can attach with /ide. Every edit Claude proposes then opens here as a
      # side-by-side diff tab you accept (<leader>ka) or reject (<leader>kr),
      # and the buffer/selection you are on is sent along as context.
      claudecode = {
        enable = true;
        settings = {
          auto_start = true;
          # Claude lives in its own tmux pane; nvim manages no terminal for it.
          terminal.provider = "none";
          # Current buffer + visual selection are pushed to Claude as context.
          track_selection = true;
          diff_opts = {
            layout = "vertical";
            open_in_new_tab = true;
            # Nothing to resize with provider = "none".
            auto_resize_terminal = false;
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
    extraConfigLua = builtins.readFile ./init.lua;
    # Add extra plugins (in this case, aiken-vim)
    extraPlugins = [
      aiken-vim
      pkgs.vimPlugins.typst-preview-nvim
    ];
  };
}
