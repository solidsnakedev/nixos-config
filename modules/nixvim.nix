{ ... }:
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    colorschemes.catppuccin.enable = true;
    plugins = {
      web-devicons.enable = true;
      # ui
      lualine.enable = true;
      tmux-navigator.enable = true;
      treesitter.enable = true;
      lazygit.enable = true;
      bufferline.enable = true;
      nvim-autopairs.enable = true;
      direnv.enable = true;
      which-key.enable = true;
      wilder.enable = true;
      telescope.enable = true;
      dressing.enable = true;
      dashboard.enable = true;
      hop.enable = true;
      neo-tree = {
        enable = true;
        closeIfLastWindow = true;
      };
      todo-comments.enable = true;
      vim-surround.enable = true;
      lastplace.enable = true;
      bufdelete.enable = true;
      fidget.enable = true;

      # lsp
      # rust-tools.enable = true;
      # typescript-tools = {
      #   enable = true;
      #   settings.settings.exposeAsCodeAction = "all";
      # };
      lsp = {
        enable = true;
        servers = {
          nil_ls = {
            enable = true; # Enable nil_ls. You can use nixd or anything you want from the docs.
            settings.formatting.command = [ "nixpkgs-fmt" ];
          };
          lua_ls = {
            enable = true;
            settings.diagnostics.globals = [ "vim" ];
          };
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          hls = {
            enable = true;
            installGhc = false;
          };
          ts_ls.enable = true;
        };
      };
      lspsaga = {
        enable = true;
        lightbulb.enable = false;
      };
      lspkind.enable = true;
      lsp-format.enable = true;

      # snippets
      nvim-snippets.enable = true;
      friendly-snippets.enable = true;
      luasnip = {
        enable = true;
        settings = {
          enable_autosnippets = true;
        };
      };

      # completions
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp-buffer.enable = true;
      cmp_luasnip.enable = true;
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "luasnip"; }
            { name = "snippets"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-u>" = "cmp.mapping.scroll_docs(-4)";
            "<C-d>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };

    };

    extraConfigLua = builtins.readFile ./init.lua;
  };
}
