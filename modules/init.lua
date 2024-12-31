local function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

local function nmap(shortcut, command)
  map('n', shortcut, command)
end

local function imap(shortcut, command)
  map('i', shortcut, command)
end

local function vmap(shortcut, command)
  map('v', shortcut, command)
end

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
imap('jk', '<Esc>') -- Escape using jk
imap('kj', '<Esc>') -- Escape using kj
-- Shift + Up/Down to move line up/down
map('n', '<S-Up>', 'yyddkP')
map('n', '<S-Down>', 'yyddp')
nmap('<Leader>h', ':nohl<cr>') -- Toggle highlight search

-- Show all diagnostics on current line in floating window
nmap("<Leader>d", ":lua vim.diagnostic.open_float()<cr>")
nmap("<leader>n", ":Neotree toggle reveal<cr>")
nmap("<leader>gg", ":LazyGit<cr>")
nmap("<leader>ff", ":Telescope find_files<cr>")
nmap("<leader>fg", ":Telescope live_grep<cr>")
nmap("<leader>fb", ":Telescope buffers<cr>")
nmap("<leader>fh", ":Telescope help_tags<cr>")
nmap("gd", ":Telescope lsp_definitions<cr>")
nmap("gr", ":Telescope lsp_reference<cr>")
nmap("gi", ":Telescope lsp_implementations<cr>")
nmap("<leader>ac", "<cmd>lua vim.lsp.buf.code_action()<cr>")
nmap("gp", "<cmd>lua vim.diagnostic.open_float()<cr>")
nmap("gk", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
nmap("gj", "<cmd>lua vim.diagnostic.goto_next()<cr>")
nmap("s", ":HopChar1<cr>")
nmap("<S-L>", ":BufferLineCycleNext<cr>")
nmap("<S-H>", ":BufferLineCyclePrev<cr>")
nmap("<leader>c", ":Bdelete<cr>")
vmap(">", ">gv")
vmap("<", "<gv")

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

local wilder = require('wilder')
wilder.setup({
  modes = { ':', '/', '?' },
})
wilder.set_option('renderer', wilder.popupmenu_renderer(
  wilder.popupmenu_border_theme({
    highlighter = wilder.basic_highlighter(),
    highlights = {
      accent = wilder.make_hl('WilderAccent', 'Pmenu', { { a = 1 }, { a = 1 }, { foreground = '#f4468f' } }),
    },
    border = 'rounded',
    left = { ' ', wilder.popupmenu_devicons() },
    right = { ' ', wilder.popupmenu_scrollbar() },
  })
))

require('dashboard').setup({
  config = {
    week_header = {
      enable = true,
    },
  },
})

require('lspconfig').hls.setup {
  cmd = (vim.fn.executable('haskell-language-server-wrapper') == 1 and { 'haskell-language-server-wrapper', '--lsp' })
      or (vim.fn.executable('haskell-language-server') == 1 and { 'haskell-language-server', '--lsp' })
      or nil,
}

-- require("noice").setup({
--   routes = {
--     {
--       view = "notify",
--       filter = { event = "msg_showmode" },
--     },
--   },
-- })

-- require("lualine").setup({
--   sections = {
--     lualine_x = {
--       {
--         require("noice").api.statusline.mode.get,
--         cond = require("noice").api.statusline.mode.has,
--         color = { fg = "#ff9e64" },
--       }
--     },
--   },
-- })
