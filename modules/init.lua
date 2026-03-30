
vim.opt.updatetime = 100
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Set leader key
vim.g.mapleader = " "

-- Disable compatibility with vi which can cause unexpected issues.
vim.opt.compatible = false

-- Enable type file detection, plugins, indent, and syntax highlighting
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')

-- Editor appearance and behavior settings
vim.opt.number = true             -- Add numbers to each line
vim.opt.relativenumber = true     -- Add relative numbers
vim.opt.cursorline = true         -- Highlight cursor line
vim.opt.shiftwidth = 2            -- Set shift width to 2 spaces
vim.opt.tabstop = 2               -- Set tab width to 2 columns
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.scrolloff = 20            -- Do not scroll below/above N lines
vim.opt.wrap = false              -- Do not wrap lines
vim.opt.incsearch = true          -- Highlight matches as you type
vim.opt.ignorecase = true         -- Ignore case in searches
vim.opt.smartcase = true          -- Override ignorecase if uppercase is used
vim.opt.showcmd = true            -- Show command in the last line
vim.opt.showmode = true           -- Show mode in the last line
vim.opt.showmatch = true          -- Show matching words during a search
vim.opt.hlsearch = true           -- Highlight search results
vim.opt.history = 1000            -- Set history size
vim.opt.wildmenu = true           -- Enable wildmenu for auto-completion
vim.opt.backup = false            -- Do not save backup files
vim.opt.swapfile = false          -- Disable swap files
vim.opt.softtabstop = 2           -- Treat spaces as tabstops
vim.opt.autoindent = true         -- Auto-indent new lines
vim.opt.mouse = 'a'               -- Enable mouse support
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.ttyfast = true            -- Speed up scrolling
vim.opt.list = true               -- Show whitespace characters
vim.opt.listchars = { tab = '▸▸', trail = '·' }
vim.opt.signcolumn = "yes"


-- Key mappings
local km = vim.keymap.set
local s = { noremap = true, silent = true }

-- Insert mode escapes
km('i', 'jk', '<Esc>', s)
km('i', 'kj', '<Esc>', s)

-- Move lines up/down
km('n', '<S-Up>',   'yyddkP', { desc = 'Move line up' })
km('n', '<S-Down>', 'yyddp',  { desc = 'Move line down' })

-- Search
km('n', '<Leader>h', ':nohl<cr>', { desc = 'Clear highlight' })

-- Diagnostics
km('n', '<Leader>d', ':lua vim.diagnostic.open_float()<cr>', { desc = 'Show diagnostics' })
km('n', 'gp', '<cmd>lua vim.diagnostic.open_float()<cr>', { desc = 'Diagnostics float' })
km('n', 'gk', '<cmd>lua vim.diagnostic.goto_prev()<cr>',  { desc = 'Prev diagnostic' })
km('n', 'gj', '<cmd>lua vim.diagnostic.goto_next()<cr>',  { desc = 'Next diagnostic' })

-- File tree
km('n', '<leader>n', ':Neotree toggle reveal<cr>', { desc = 'Toggle file tree' })

-- Git
km('n', '<leader>gg', ':LazyGit<cr>', { desc = 'LazyGit' })

-- Find (Telescope)
km('n', '<leader>ff', ':Telescope find_files<cr>', { desc = 'Files' })
km('n', '<leader>fg', ':Telescope live_grep<cr>',  { desc = 'Grep' })
km('n', '<leader>fb', ':Telescope buffers<cr>',    { desc = 'Buffers' })
km('n', '<leader>fh', ':Telescope help_tags<cr>',  { desc = 'Help tags' })

-- LSP
km('n', 'gd', ':Telescope lsp_definitions<cr>',     { desc = 'Go to definition' })
km('n', 'gr', ':Telescope lsp_reference<cr>',       { desc = 'References' })
km('n', 'gi', ':Telescope lsp_implementations<cr>', { desc = 'Implementations' })
km('n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<cr>', { desc = 'Code action' })

-- Navigation
km('n', 's',    ':HopChar1<cr>',            { desc = 'Hop to char' })
km('n', '<S-L>', ':BufferLineCycleNext<cr>', { desc = 'Next buffer' })
km('n', '<S-H>', ':BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })

-- Buffer
km('n', '<leader>c', ':Bdelete<cr>', { desc = 'Close buffer' })

-- AI (CodeCompanion)
km('n', '<leader>at', ':CodeCompanionChat Toggle<cr>',  { desc = 'Toggle AI chat' })
km('n', '<leader>ai', ':CodeCompanion<cr>',             { desc = 'AI inline prompt' })
km('v', '<leader>as', ':CodeCompanionChat Add<cr>',     { desc = 'Send selection to AI' })

-- Visual indent
km('v', '>', '>gv', s)
km('v', '<', '<gv', s)

-- Terminal
km('t', '<Esc>', '<C-\\><C-n>', s)

-- which-key group labels
local wk = require('which-key')
wk.add({
  { '<leader>f', group = 'Find' },
  { '<leader>g', group = 'Git' },
  { '<leader>a', group = 'AI / Actions' },
  { 'g',         group = 'Go to' },
  { '<C-w>',     group = 'Windows' },
  { ']',         group = 'Next' },
  { '[',         group = 'Prev' },
  { 'z',         group = 'Fold / View' },
  -- Tmux navigator
  { '<C-h>', desc = 'Window left (tmux)' },
  { '<C-j>', desc = 'Window down (tmux)' },
  { '<C-k>', desc = 'Window up (tmux)' },
  { '<C-l>', desc = 'Window right (tmux)' },
  { '<C-\\>', desc = 'Window prev (tmux)' },
  -- LSP
  { 'K', desc = 'Hover docs' },
  -- Scrolling
  { '<C-d>', desc = 'Scroll down half page' },
  { '<C-u>', desc = 'Scroll up half page' },
  { '<C-f>', desc = 'Scroll down full page' },
  { '<C-b>', desc = 'Scroll up full page' },
  { '<C-e>', desc = 'Scroll down line' },
  { '<C-y>', desc = 'Scroll up line' },
})

require("neo-tree").setup({
  close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
  window = {
    position = "right",
    width = 40
  },
  file_size = {
    enabled = false,
  },
  event_handlers = {
    {
      event = "file_open_requested",
      handler = function()
        -- auto close
        -- vim.cmd("Neotree close")
        -- OR
        require("neo-tree.command").execute({ action = "close" })
      end
    },

  }
})

require('dashboard').setup({
  config = {
    week_header = {
      enable = true,
    },
  },
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
