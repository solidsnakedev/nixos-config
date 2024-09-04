{ ... }:
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    # colorschemes.catppuccin.enable = true;
    colorschemes.kanagawa.enable = true;
    plugins = {
      lualine = {
        enable = true;
      };
      tmux-navigator.enable = true;
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
          tsserver.enable = true;
        };
      };
      # typescript-tools.enable = true;
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
    };

    extraConfigLua = builtins.readFile ./init.lua;
  };
}
