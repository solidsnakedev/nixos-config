{ ... }:
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    # colorschemes.kanagawa.enable = true;
    # colorschemes.tokyonight.enable = true;
    colorschemes.catppuccin.enable = true;
    plugins = {
      lsp = {
        enable = true;
        servers = {
          nil-ls = {
            enable = true; # Enable nil_ls. You can use nixd or anything you want from the docs.
            settings.formatting.command = [ "nixpkgs-fmt" ];
          };
          lua-ls = {
            enable = true;
            settings.diagnostics.globals = [ "vim" ];
          };
          # tsserver.enable = true;
        };
      };
      lspsaga = {
        enable = true;
        lightbulb.enable = false;
      };
      lspkind.enable = true;
      typescript-tools = {
        enable = true;
        settings.exposeAsCodeAction = "all";
      };
      lualine.enable = true;
      tmux-navigator.enable = true;
      lsp-format.enable = true;
      treesitter.enable = true;
      lazygit.enable = true;
      bufferline.enable = true;
      nvim-autopairs.enable = true;
      direnv.enable = true;
      which-key.enable = true;
      wilder.enable = true;
      telescope = {
        enable = true;
        # extensions.ui-select.enable = true;
      };
      dressing.enable = true;
      dashboard.enable = true;
      hop.enable = true;
      nvim-tree.enable = true;
      todo-comments.enable = true;
      surround.enable = true;
      lastplace.enable = true;
      bufdelete.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp-buffer.enable = true;
      cmp_luasnip.enable = true;
      nvim-snippets.enable = true;
      friendly-snippets.enable = true;
      luasnip = {
        enable = true;
        settings = {
          enable_autosnippets = true;
        };
      };
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
