{ ... }:
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    # colorschemes.catppuccin.enable = true;
    colorschemes.kanagawa.enable = true;
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
      telescope.enable = true;
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
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
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
