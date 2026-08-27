
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

-- Enable type file detection, plugins, and indent (syntax handled by treesitter)
vim.cmd('filetype plugin indent on')

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
vim.opt.showmode = false          -- Disabled: noice shows mode in its own UI
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
-- Diffview: review everything changed in the working tree, close with <leader>gq
km('n', '<leader>gd', ':DiffviewOpen<cr>',          { desc = 'Diff view (working tree)' })
km('n', '<leader>gq', ':DiffviewClose<cr>',         { desc = 'Close diff view' })
km('n', '<leader>gh', ':DiffviewFileHistory %<cr>', { desc = 'File history' })
-- PR review after `gh pr checkout`: diff the branch against its merge base
km('n', '<leader>gD', ':DiffviewOpen origin/main...HEAD<cr>', { desc = 'Diff view (vs origin/main)' })
-- Gitsigns: per-hunk review, revert what you don't want to keep
km('n', ']h', ':Gitsigns next_hunk<cr>',            { desc = 'Next changed hunk' })
km('n', '[h', ':Gitsigns prev_hunk<cr>',            { desc = 'Prev changed hunk' })
km('n', '<leader>gp', ':Gitsigns preview_hunk<cr>', { desc = 'Preview hunk diff' })
km('n', '<leader>gr', ':Gitsigns reset_hunk<cr>',   { desc = 'Revert hunk' })
km('v', '<leader>gr', ':Gitsigns reset_hunk<cr>',   { desc = 'Revert selected hunks' })
km('n', '<leader>gs', ':Gitsigns stage_hunk<cr>',   { desc = 'Stage hunk' })
km('n', '<leader>gb', ':Gitsigns blame_line<cr>',   { desc = 'Blame line' })

-- Find (Telescope)
km('n', '<leader>ff', ':Telescope find_files<cr>', { desc = 'Files' })
km('n', '<leader>fg', ':Telescope live_grep<cr>',  { desc = 'Grep' })
km('n', '<leader>fb', ':Telescope buffers<cr>',    { desc = 'Buffers' })
km('n', '<leader>fr', ':GrugFar<cr>',              { desc = 'Find & replace (project)' })
km('n', '<leader>fh', ':Telescope help_tags<cr>',  { desc = 'Help tags' })

-- LSP
km('n', 'gd', ':Telescope lsp_definitions<cr>',     { desc = 'Go to definition' })
km('n', 'gr', ':Telescope lsp_reference<cr>',       { desc = 'References' })
km('n', 'gi', ':Telescope lsp_implementations<cr>', { desc = 'Implementations' })
km('n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<cr>', { desc = 'Code action' })

-- Navigation
-- Flash S is not mapped in visual mode; nvim-surround owns S there
km({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end,       { desc = 'Flash jump' })
km({ 'n', 'o' },      'S', function() require('flash').treesitter() end, { desc = 'Flash treesitter' })

-- herdr vim-navigator (mirror of vim-tmux-navigator): herdr's nav plugin
-- forwards ctrl+hjkl here when this pane runs nvim; move between nvim
-- windows first, cross to the neighboring herdr pane at the edge
if vim.env.HERDR_PANE_ID then
  vim.g.tmux_navigator_no_mappings = 1
  local function nav(wincmd_dir, herdr_dir)
    return function()
      local before = vim.api.nvim_get_current_win()
      vim.cmd('wincmd ' .. wincmd_dir)
      if vim.api.nvim_get_current_win() == before then
        vim.system({ 'herdr', 'pane', 'focus', '--direction', herdr_dir, '--pane', vim.env.HERDR_PANE_ID })
      end
    end
  end
  km('n', '<C-h>', nav('h', 'left'),  { desc = 'Window/pane left' })
  km('n', '<C-j>', nav('j', 'down'),  { desc = 'Window/pane down' })
  km('n', '<C-k>', nav('k', 'up'),    { desc = 'Window/pane up' })
  km('n', '<C-l>', nav('l', 'right'), { desc = 'Window/pane right' })
end
km('n', '<S-L>', ':BufferLineCycleNext<cr>', { desc = 'Next buffer' })
km('n', '<S-H>', ':BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })
km('n', ']b',    ':BufferLineCycleNext<cr>', { desc = 'Next buffer' })
km('n', '[b',    ':BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })

-- Buffers, LazyVim-style (Snacks.bufdelete keeps the window layout)
km('n', '<leader>bb', '<cmd>e #<cr>',                        { desc = 'Switch to other buffer' })
km('n', '<leader>bd', function() Snacks.bufdelete() end,     { desc = 'Delete buffer' })
km('n', '<leader>bo', function() Snacks.bufdelete.other() end, { desc = 'Delete other buffers' })
km('n', '<leader>bD', ':bd<cr>',                             { desc = 'Delete buffer and window' })
km('n', '<leader>bp', ':BufferLineTogglePin<cr>',            { desc = 'Toggle pin' })
km('n', '<leader>bP', ':BufferLineGroupClose ungrouped<cr>', { desc = 'Delete non-pinned buffers' })
km('n', '<leader>br', ':BufferLineCloseRight<cr>',           { desc = 'Delete buffers to the right' })
km('n', '<leader>bl', ':BufferLineCloseLeft<cr>',            { desc = 'Delete buffers to the left' })

-- Reopen files at the last edit position (replaces the archived lastplace plugin)
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- AI (CodeCompanion)
km('n', '<leader>at', ':CodeCompanionChat Toggle<cr>',  { desc = 'Toggle AI chat' })
km('n', '<leader>ai', ':CodeCompanion<cr>',             { desc = 'AI inline prompt' })
km('v', '<leader>as', ':CodeCompanionChat Add<cr>',     { desc = 'Send selection to AI' })

-- Claude Code (agent runs in a tmux pane, diffs land here for review)
km('n', '<leader>kb', '<cmd>ClaudeCodeAdd %<cr>',      { desc = 'Add buffer to Claude context' })
km('v', '<leader>ks', '<cmd>ClaudeCodeSend<cr>',       { desc = 'Send selection to Claude' })
km('n', '<leader>ka', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Accept Claude diff' })
km('n', '<leader>kr', '<cmd>ClaudeCodeDiffDeny<cr>',   { desc = 'Reject Claude diff' })
km('n', '<leader>kq', '<cmd>ClaudeCodeCloseAllDiffs<cr>', { desc = 'Close all Claude diffs' })
km('n', '<leader>kS', '<cmd>ClaudeCodeStatus<cr>',     { desc = 'Claude connection status' })
-- In neo-tree, <leader>kb adds the file under the cursor instead of the buffer
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'neo-tree',
  callback = function(ev)
    km('n', '<leader>kb', '<cmd>ClaudeCodeTreeAdd<cr>', { desc = 'Add tree file to Claude context', buffer = ev.buf })
  end,
})

-- Diagnostics panels (Trouble, LazyVim-style)
km('n', '<leader>xx', ':Trouble diagnostics toggle<cr>',              { desc = 'Diagnostics (Trouble)' })
km('n', '<leader>xX', ':Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer diagnostics' })
km('n', '<leader>xt', ':Trouble todo toggle<cr>',                     { desc = 'Todos (Trouble)' })
km('n', '<leader>xq', ':Trouble qflist toggle<cr>',                   { desc = 'Quickfix list' })
km('n', '<leader>xl', ':Trouble loclist toggle<cr>',                  { desc = 'Location list' })

-- Visual indent
km('v', '>', '>gv', s)
km('v', '<', '<gv', s)

-- Terminal
km('t', '<Esc>', '<C-\\><C-n>', s)

-- which-key group labels
local wk = require('which-key')
wk.add({
  { '<leader>b', group = 'Buffer' },
  { '<leader>f', group = 'Find' },
  { '<leader>g', group = 'Git' },
  { '<leader>a', group = 'AI / Actions' },
  { '<leader>k', group = 'Claude Code' },
  { '<leader>x', group = 'Diagnostics' },
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

-- Auto-reload files changed outside of Neovim
vim.opt.autoread = true
-- Fast CursorHold so the checktime autocmd (and gitsigns/LSP UI) reacts quickly
vim.opt.updatetime = 300
-- Poll for external changes too: agents write to disk while nvim is unfocused,
-- and pane-switch focus events may not reach nvim through the multiplexer
vim.uv.new_timer():start(2000, 2000, vim.schedule_wrap(function()
  if vim.fn.mode() ~= 'c' and vim.fn.getcmdwintype() == '' then
    vim.cmd('silent! checktime')
  end
end))
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  desc = 'Check if file has changed on disk',
  group = vim.api.nvim_create_augroup('auto-reload', { clear = true }),
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd('checktime')
    end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
