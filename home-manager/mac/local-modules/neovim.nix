{ pkgs, ... }:
let
  aiken-vim = pkgs.vimUtils.buildVimPlugin {
    pname = "aiken";
    version = "2023";
    src = pkgs.fetchFromGitHub {
      owner = "aiken-lang";
      repo = "editor-integration-nvim";
      rev = "259203266da4ef367a4a41baa60fe49177d55598";
      sha256 = "sha256-vlhqunKmQTUGPCPq3sSW3QOKJgnAwQdFnGzWKEjGNzE=";
    };
  };

in
{
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
        "suggest.enablePreselect" = false;
        "suggest.floatConfig.border" = true;
        "suggest.floatConfig.rounded" = true;
        "diagnostic.errorSign" = "✘";
        "diagnostic.hintSign" = "";
        "diagnostic.infoSign" = "";
        "diagnostic.warningSign" = "∆";
        "hover.floatConfig.border" = true;
        "hover.floatConfig.rounded" = true;
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
          aiken = {
            command = "aiken";
            args = [ "lsp" ];
            trace.server = "verbose";
            rootPatterns = [
              "aiken.toml"
            ];
            filetypes = [ "aiken" ];
          };
          nix = {
            command = "nil";
            filetypes = [ "nix" ];
            rootPatterns = [ "flake.nix" ];
            settings = {
              nil = {
                formatting = { command = [ "nixpkgs-fmt" ]; };
              };
            };
          };
        };
      };
    };
    extraPackages = [
      pkgs.nodejs # coc requires nodejs
      pkgs.ripgrep # telescope live_grep and grep_string requires ripgrep
      pkgs.lazygit # lazygit-nvim requires lazygit
      pkgs.watchman # coc-tsserver, requires watchman to rename imports on file rename
    ];

    plugins = with pkgs.vimPlugins; [
      # Basic settings
      sensible

      # Git support
      {
        plugin = lazygit-nvim;
        type = "lua";
        config = '' 
          nmap("<leader>gg", ":LazyGit<cr>")
        '';
      }

      # Coc plugins
      coc-tsserver
      coc-json
      coc-snippets
      coc-eslint
      jsonc-vim

      #Markdown
      markdown-preview-nvim


      # Language syntax highlight
      vim-nix
      aiken-vim
      {
        plugin = haskell-vim;
        config = ''
          let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
          let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
          let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
          let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
          let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
          let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
        '';
      }

      # direnv support
      direnv-vim

      # tmux integration
      vim-tmux-navigator

      # Sorround support
      vim-surround

      # Comments
      {
        plugin = comment-nvim;
        type = "lua";
        config = ''
          require('Comment').setup()
        '';
      }

      {
        plugin = todo-comments-nvim;
        type = "lua";
        config = ''
          require('todo-comments').setup {}
        '';
      }

      # Autopair like VSCode
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''
          require('nvim-autopairs').setup {}
        '';
      }

      # Syntax Support
      # (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require("nvim-treesitter.configs").setup({
            highlight = {
              enable = true,
            },
          })
        '';
      }

      # Buffer tabs
      {
        plugin = bufferline-nvim;
        type = "lua";
        config = ''
          require("bufferline").setup( { 
            options = {
              mode = 'buffers',
              themable = false,
              offsets = {
                  {filetype = 'NvimTree'}
              },
              separator_style = "slant",
          }
          })
          nmap("<leader><tab>", ":BufferLineCycleNext<cr>")
          nmap("<leader><S-tab>", ":BufferLineCyclePrev<cr>")
          nmap("<leader>bd", ":bd<cr>")
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
          require("nvim-tree").setup{ 
            actions = {
              open_file = { 
                quit_on_open = true,
              },
            },
          }
          nmap("<leader>n", ":NvimTreeToggle<cr>")
        '';
      }

      # File/Grep Search
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          nmap("<leader>ff", ":Telescope find_files<cr>")
          nmap("<leader>fg", ":Telescope live_grep<cr>")
          nmap("<leader>fb", ":Telescope buffers<cr>")
          nmap("<leader>fh", ":Telescope help_tags<cr>")
        '';
      }
      lightspeed-nvim

      # WildMenu
      {
        plugin = wilder-nvim;
        type = "lua";
        config = ''
          local wilder = require('wilder')
          wilder.setup({
            modes = {':', '/', '?'},
            accept_key = '<Right>',
            reject_key = '<Left>',
          })

          wilder.set_option('renderer', wilder.popupmenu_renderer(
            wilder.popupmenu_border_theme({
              highlighter = wilder.basic_highlighter(),
              highlights = {
                border = 'Normal', -- highlight to use for the border
                accent = wilder.make_hl('WilderAccent', 'Pmenu', {{a = 1}, {a = 1}, {foreground = '#f4468f'}}),
              },
              -- 'single', 'double', 'rounded' or 'solid'
              -- can also be a list of 8 characters, see :h wilder#popupmenu_border_theme() for more details
              border = 'rounded',
              left = {' ', wilder.popupmenu_devicons()},
              right = {' ', wilder.popupmenu_scrollbar()},
            })
            ))
        '';
      }

      # Dashboard
      {
        plugin = dashboard-nvim;
        type = "lua";
        config = ''
          require('dashboard').setup({
            config = {
              week_header = {
               enable = true,
              },
            },
          })
        '';
      }

      # Tokyo Night Theme
      {
        plugin = tokyonight-nvim;
        type = "lua";
        config = ''
          require('tokyonight').setup({
            on_highlights = function(highlights, colors)
              highlights.LineNr = { fg = colors.cyan, bold = false }
              highlights.CursorLineNr = { fg = colors.orange, bold = true }
            end,
          })
        '';
      }
      papercolor-theme
      {
        plugin = material-nvim;
        type = "lua";
        config = ''
          vim.g.material_style = "deep ocean"
          require('material').setup({
            custom_highlights = {
              CocMenuSel = { fg = '#000000', bg = '#89DDFF' },
            }
          })
          vim.cmd("colorscheme material ")
        '';
      }

      {
        plugin = sonokai;
        type = "lua";
        config = ''
           vim.g.sonokai_diagnostic_text_highlight = 1
          -- vim.cmd[[colorscheme sonokai]]
        '';
      }

      {
        plugin = vim-monokai-pro;
        config = ''
        '';
      }

      # Dracula Theme
      {
        plugin = dracula-vim;
        config = ''
        '';
      }

      {
        plugin = nightfox-nvim;
        type = "lua";
        config = ''
          require("nightfox").setup({
            groups = {
              all = {
                LineNr = { fg = "cyan" },
                CursorLineNr = { fg = "orange", style = "bold"};
              },
            },
          })
          -- vim.cmd("colorscheme carbonfox")
        '';
      }

      # Airline theme
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup {
            -- options = {
            --   theme = 'powerline_dark'
            -- },
            sections = {
              lualine_a = {
                {
                  'filename',
                  path = 1,
                }
              },
              lualine_b = {'branch', 'diff', 'diagnostics','g:coc_status'}
            },
          }
        '';
      }
    ];

    extraLuaConfig = ''
      -- disable netrw at the very start of your init.lua (strongly advised)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- set termguicolors to enable highlight groups
      vim.opt.termguicolors = true

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

      " Disable compatibility with vi which can cause unexpected issues.
      set nocompatible

      " Enable type file detection. Vim will be able to try to detect the type of file in use.
      filetype on

      " Enable plugins and load plugin for the detected file type.
      filetype plugin on

      " Load an indent file for the detected file type.
      filetype indent on

      " Turn syntax highlighting on.
      syntax on

      " Add numbers to each line on the left-hand side.
      set number

      " Add relativenumber
      set relativenumber

      " Highlight cursor line underneath the cursor horizontally.
      set cursorline

      " Set shift width to 2 spaces.
      set shiftwidth=2

      " Set tab width to 2 columns.
      set tabstop=2

      " Use space characters instead of tabs.
      set expandtab

      " Do not save backup files.
      set nobackup

      " Do not let cursor scroll below or above N number of lines when scrolling.
      set scrolloff=10

      " Do not wrap lines. Allow long lines to extend as far as the line goes.
      set nowrap

      " While searching though a file incrementally highlight matching characters as you type.
      set incsearch

      " Ignore capital letters during search.
      set ignorecase

      " Override the ignorecase option if searching for capital letters.
      " This will allow you to search specifically for capital letters.
      set smartcase

      " Show partial command you type in the last line of the screen.
      set showcmd

      " Show the mode you are on the last line.
      set showmode

      " Show matching words during a search.
      set showmatch

      " Use highlighting when doing a search.
      set hlsearch

      " Set the commands to save in history default number is 20.
      set history=1000

      " Enable auto completion menu after pressing TAB.
      set wildmenu

      " Disable swap
      set noswapfile

      " Make wildmenu behave like similar to Bash completion.
      " set wildmode=longest:list,full

      set softtabstop=2           " see multiple spaces as tabstops so <BS> does the right thing
      set autoindent              " indent a new line the same amount as the line just typed
      set mouse=a                 " enable mouse click
      set clipboard=unnamedplus   " using system clipboard
      set ttyfast                 " Speed up scrolling in Vim
      set list listchars=tab:▸▸,trail:·
      
      " escape with key combination
      inoremap jk <Esc>
      inoremap kj <Esc>
      
      " allow to move blocks up or down with arrow key
      nnoremap <down> :m .+1<CR>==
      nnoremap <up> :m .-2<CR>==
      vnoremap <down> :m '>+1<CR>gv=gv
      vnoremap <up> :m '<-2<CR>gv=gv

      " toggle hlsearch
      nnoremap <Leader>h :nohl<CR>

      " --------------------------------------------------------
      " COC-VIM TAB SETTINGS START

      " Some servers have issues with backup files, see #649
      set nobackup
      set nowritebackup

      " Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
      " delays and poor user experience
      set updatetime=300

      " Always show the signcolumn, otherwise it would shift the text each time
      " diagnostics appear/become resolved
      set signcolumn=yes

      " Use tab for trigger completion with characters ahead and navigate
      " NOTE: There's always complete item selected by default, you may want to enable
      " no select by `"suggest.noselect": true` in your configuration file
      " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
      " other plugin before putting this into your config
      inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
      inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

      " Make <CR> to accept selected completion item or notify coc.nvim to format
      " <C-g>u breaks current undo, please make your own choice
      inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

      function! CheckBackspace() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction

      " Use <c-space> to trigger completion
      if has('nvim')
        inoremap <silent><expr> <c-space> coc#refresh()
      else
        inoremap <silent><expr> <c-@> coc#refresh()
      endif

      " Use `[g` and `]g` to navigate diagnostics
      " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
      nmap <silent> [g <Plug>(coc-diagnostic-prev)
      nmap <silent> ]g <Plug>(coc-diagnostic-next)

      " GoTo code navigation
      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)

      " Use K to show documentation in preview window
      nnoremap <silent> K :call ShowDocumentation()<CR>

      function! ShowDocumentation()
        if CocAction('hasProvider', 'hover')
          call CocActionAsync('doHover')
        else
          call feedkeys('K', 'in')
        endif
      endfunction

      " Highlight the symbol and its references when holding the cursor
      autocmd CursorHold * silent call CocActionAsync('highlight')

      " Symbol renaming
      nmap <leader>rn <Plug>(coc-rename)

      " Formatting selected code
      xmap <leader>f  <Plug>(coc-format-selected)
      nmap <leader>f  <Plug>(coc-format-selected)

      augroup mygroup
        autocmd!
        " Setup formatexpr specified filetype(s)
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
      augroup end

      " Applying code actions to the selected code block
      " Example: `<leader>aap` for current paragraph
      xmap <leader>a  <Plug>(coc-codeaction-selected)
      nmap <leader>a  <Plug>(coc-codeaction-selected)

      " Remap keys for applying code actions at the cursor position
      nmap <leader>ac  <Plug>(coc-codeaction-cursor)
      " Remap keys for apply code actions affect whole buffer
      nmap <leader>as  <Plug>(coc-codeaction-source)
      " Apply the most preferred quickfix action to fix diagnostic on the current line
      nmap <leader>qf  <Plug>(coc-fix-current)

      " Remap keys for applying refactor code actions
      nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
      xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
      nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

      " Run the Code Lens action on the current line
      nmap <leader>cl  <Plug>(coc-codelens-action)

      " Map function and class text objects
      " NOTE: Requires 'textDocument.documentSymbol' support from the language server
      xmap if <Plug>(coc-funcobj-i)
      omap if <Plug>(coc-funcobj-i)
      xmap af <Plug>(coc-funcobj-a)
      omap af <Plug>(coc-funcobj-a)
      xmap ic <Plug>(coc-classobj-i)
      omap ic <Plug>(coc-classobj-i)
      xmap ac <Plug>(coc-classobj-a)
      omap ac <Plug>(coc-classobj-a)

      " Remap <C-f> and <C-b> to scroll float windows/popups
      if has('nvim-0.4.0') || has('patch-8.2.0750')
        nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
        inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
        vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
      endif

      " Use CTRL-S for selections ranges
      " Requires 'textDocument/selectionRange' support of language server
      nmap <silent> <C-s> <Plug>(coc-range-select)
      xmap <silent> <C-s> <Plug>(coc-range-select)

      " Add `:Format` command to format current buffer
      command! -nargs=0 Format :call CocActionAsync('format')

      " Add `:Fold` command to fold current buffer
      command! -nargs=? Fold :call     CocAction('fold', <f-args>)

      " Add `:OR` command for organize imports of the current buffer
      command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

      " Mappings for CoCList
      " Show all diagnostics
      nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
      " Manage extensions
      nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
      " Show commands
      nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
      " Find symbol of current document
      nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
      " Search workspace symbols
      nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
      " Do default action for next item
      nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
      " Do default action for previous item
      nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
      " Resume latest coc list
      nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

      " COC-VIM TAB SETTINGS END
      " --------------------------------------------------------
    '';
  };
}
