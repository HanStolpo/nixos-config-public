--------------------------------------------------------------------------------
-- Neovim Configuration
-- Consolidated from haskell-vim-now.vim and my_vim_rc.vim
-- For Neovim 0.11+
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Leader Keys
--------------------------------------------------------------------------------
-- Set leader key to comma (must be set before any mappings that use it)
vim.g.mapleader = ","
vim.g.maplocalleader = "<BS>"

-- Allow normal use of "," by pressing it twice
vim.keymap.set("n", ",,", ",", { noremap = true })

--------------------------------------------------------------------------------
-- General Settings
--------------------------------------------------------------------------------

local opt = vim.opt

-- File handling
opt.autoread = true           -- Auto read when file changed from outside
opt.hidden = true             -- Don't close buffers, only hide them
opt.backup = false            -- No backup files (stuff is in git)
opt.writebackup = false
opt.swapfile = false
opt.fileformats = "unix,mac,dos"
opt.autochdir = false

-- Encoding
opt.encoding = "utf-8"

-- UI
opt.termguicolors = true
opt.ruler = true              -- Show cursor position
opt.number = true             -- Show line numbers
opt.relativenumber = true     -- Show relative line numbers
opt.cursorline = true         -- Highlight current line
opt.wrap = false              -- Don't wrap lines
opt.cmdheight = 1
opt.laststatus = 2            -- Always show status line
opt.showmatch = true          -- Show matching brackets
opt.matchtime = 2             -- Tenths of a second to blink

-- Timeout for leader key
opt.timeoutlen = 2000

-- Wildmenu (command completion)
opt.wildmenu = true
opt.wildmode = "list:longest,full"
opt.wildignore:append("*.o,*.obj,*.hi,*.dyn_hi,*.dyn_o,.cabal-sandbox/**/")

-- Show whitespace
opt.list = true
opt.listchars = { tab = "> ", trail = "-", extends = ">", precedes = "<", nbsp = "+" }

-- Search
opt.ignorecase = true         -- Ignore case when searching
opt.smartcase = true          -- Smart case (override ignorecase if uppercase)
opt.hlsearch = true           -- Highlight search results
opt.incsearch = true          -- Incremental search
opt.magic = true              -- Regular expressions

-- Indentation
opt.expandtab = true          -- Use spaces instead of tabs
opt.smarttab = true
opt.shiftwidth = 2            -- 1 tab == 2 spaces
opt.tabstop = 2
opt.autoindent = true
opt.smartindent = true

-- Folding (using treesitter)
opt.foldenable = false        -- Start with folding disabled (zi to toggle)
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Backspace behavior
opt.backspace = "eol,start,indent"
opt.whichwrap:append("<,>,h,l")

-- Performance
opt.lazyredraw = true

-- Clipboard - use system clipboard
opt.clipboard = "unnamedplus"

-- Spelling
opt.spelllang = "en_gb"

-- Session options
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Remember info about open buffers
opt.viminfo:append("%")

-- Disable error bells
opt.errorbells = false
opt.visualbell = true

-- Font (for GUI)
opt.guifont = "Roboto Mono for Powerline:h14"

--------------------------------------------------------------------------------
-- Cursor Line/Column Toggle
-- Highlight cursor line in normal mode, cursor column in insert mode
--------------------------------------------------------------------------------

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.opt.cursorline = false
    vim.opt.cursorcolumn = true
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.opt.cursorline = true
    vim.opt.cursorcolumn = false
  end,
})

--------------------------------------------------------------------------------
-- Return to Last Edit Position
--------------------------------------------------------------------------------

vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("last_edit", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

--------------------------------------------------------------------------------
-- Filetype-specific Settings
--------------------------------------------------------------------------------

-- Disable indentkeys for certain filetypes
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.hs", "*.nix", "*.elm" },
  callback = function()
    vim.opt_local.indentkeys = ""
  end,
})

-- Treat .spec files as coffee
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.spec",
  callback = function()
    vim.bo.filetype = "coffee"
  end,
})

-- Move quickfix window to bottom
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  command = "wincmd J",
})

-- Delete trailing whitespace on save for Haskell files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.hs",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//ge]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Register d2 filetype
vim.filetype.add({
  extension = {
    d2 = "d2",
  },
})

--------------------------------------------------------------------------------
-- Key Mappings - General
--------------------------------------------------------------------------------

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Treat long lines as break lines
keymap("n", "j", "gj", opts)
keymap("n", "k", "gk", opts)

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-t>", "<C-w><C-t>", opts)
keymap("n", "<C-b>", "<C-w><C-b>", opts)
keymap("n", "<C-p>", "<C-w><C-p>", opts)

-- Window splits
keymap("n", "<leader>sh", ":leftabove vnew<CR>", opts)
keymap("n", "<leader>sl", ":rightbelow vnew<CR>", opts)
keymap("n", "<leader>sk", ":leftabove new<CR>", opts)
keymap("n", "<leader>sj", ":rightbelow new<CR>", opts)

-- File operations
keymap("n", "<leader>e", ":e <C-R>=expand('%:p:h') . '/'<CR>", { noremap = true })
keymap("n", "<C-s>", ":w<CR>", opts)

-- Search
keymap("n", "<leader>nh", ":noh<CR>", opts)

-- Spell checking
keymap("n", "<leader>ss", ":setlocal spell!<CR>", opts)

-- Terminal mode mappings
keymap("t", "<Esc>", "<C-\\><C-n>", opts)
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)

--------------------------------------------------------------------------------
-- Key Mappings - Telescope
--------------------------------------------------------------------------------

keymap("n", "<Leader><space>", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>b<space>", ":Telescope buffers<CR>", opts)

--------------------------------------------------------------------------------
-- Key Mappings - Haskell-specific
--------------------------------------------------------------------------------

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.hs",
  callback = function()
    keymap("n", "<leader>hh", ":Hoogle ", { buffer = true })
    keymap("n", "<leader>hH", ":Hoogle<CR>", { buffer = true, silent = true })
    keymap("n", "<leader>hc", ":HoogleClose<CR>", { buffer = true, silent = true })
    keymap("n", "<leader>hl", ":HoogleLine<CR>", { buffer = true, silent = true })
  end,
})

--------------------------------------------------------------------------------
-- Plugin: Tree-sitter
--------------------------------------------------------------------------------

local parser_install_dir = vim.fn.stdpath("state") .. "/treesitter/parsers"
vim.opt.runtimepath:append(parser_install_dir)

-- Register d2 parser
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.d2 = {
  install_info = {
    url = "https://github.com/pleshevskiy/tree-sitter-d2",
    revision = "main",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  filetype = "d2",
}

require("nvim-treesitter.configs").setup({
  parser_install_dir = parser_install_dir,
  auto_install = false,
  highlight = {
    enable = true,
    disable = { "markdown" },
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
})

--------------------------------------------------------------------------------
-- Plugin: Telescope
--------------------------------------------------------------------------------

require("telescope").setup({
  defaults = {
    dynamic_preview_title = true,
    layout_strategy = "flex",
    path_display = { smart = {} },
    mappings = {
      i = {
        ["<C-Down>"] = require("telescope.actions").cycle_history_next,
        ["<C-Up>"] = require("telescope.actions").cycle_history_prev,
      },
    },
  },
})

--------------------------------------------------------------------------------
-- Plugin: Lualine (Status Line)
--------------------------------------------------------------------------------

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})

--------------------------------------------------------------------------------
-- Plugin: Auto-session
--------------------------------------------------------------------------------

require("auto-session").setup({
  auto_restore = true,
  auto_restore_last_session = false,
  auto_save = true,
  enabled = true,
  log_level = "info",
  root_dir = vim.fn.stdpath("data") .. "/sessions/",
})

--------------------------------------------------------------------------------
-- Plugin: mini.completion
--------------------------------------------------------------------------------

require("mini.completion").setup({
  delay = { completion = 100, info = 100, signature = 50 },
  window_dimensions = {
    info = { height = 25, width = 80 },
    signature = { height = 25, width = 80 },
  },
  lsp_completion = {
    source_func = "completefunc",
    auto_setup = true,
  },
  mappings = {
    force_twostep = "<C-Space>",
    force_fallback = "<A-Space>",
  },
  set_vim_settings = true,
})

--------------------------------------------------------------------------------
-- Plugin: mini.indentscope
--------------------------------------------------------------------------------

require("mini.indentscope").setup({
  draw = {
    delay = 100,
  },
  mappings = {
    object_scope = "ii",
    object_scope_with_border = "ai",
    goto_top = "[i",
    goto_bottom = "]i",
  },
  options = {
    border = "both",
    indent_at_cursor = true,
    try_as_border = false,
  },
  symbol = "╎",
})

--------------------------------------------------------------------------------
-- LSP Configuration (Neovim 0.11+)
--------------------------------------------------------------------------------

-- Get LSP capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Diagnostic mappings
keymap("n", "<leader>d", vim.diagnostic.open_float, opts)
keymap("n", "<M-k>", vim.diagnostic.goto_prev, opts)
keymap("n", "<M-j>", vim.diagnostic.goto_next, opts)
keymap("n", "<space>q", vim.diagnostic.setloclist, opts)

-- LSP on_attach function
local on_attach = function(client, bufnr)
  -- Enable incremental sync for elm-language-server
  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Buffer-local LSP mappings
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  keymap("n", "<leader>ad", vim.lsp.buf.definition, bufopts)
  keymap("n", "<leader>ah", vim.lsp.buf.hover, bufopts)
  keymap("n", "<leader>ac", vim.lsp.buf.code_action, bufopts)
  -- Uncomment as needed:
  -- keymap("n", "gi", vim.lsp.buf.implementation, bufopts)
  -- keymap("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  -- keymap("n", "<space>rn", vim.lsp.buf.rename, bufopts)
  -- keymap("n", "gr", vim.lsp.buf.references, bufopts)
  -- keymap("n", "<space>f", vim.lsp.buf.format, bufopts)
end

-- LSP server configurations
local servers = {
  cmake = {},
  clangd = {},
  hls = {
    filetypes = { "haskell", "lhaskell", "cabal" },
    cmd = { "haskell-language-server", "--lsp" },
    settings = {
      haskell = {
        cabalFormattingProvider = "cabalfmt",
        formattingProvider = "fourmolu",
        checkParents = "CheckOnSave",
        maxCompletions = 40,
        sessionLoading = "multiComponent",
      },
    },
  },
  elmls = {
    settings = {
      elmLS = {
        trace = {
          server = true,
        },
      },
    },
  },
  rust_analyzer = {},
  ts_ls = {},
}

-- Configure and enable LSP servers using vim.lsp.config (Nvim 0.11+)
for lsp, cfg in pairs(servers) do
  cfg.on_attach = on_attach
  cfg.capabilities = capabilities
  vim.lsp.config(lsp, cfg)
end
vim.lsp.enable(vim.tbl_keys(servers))

--------------------------------------------------------------------------------
-- Plugin: Ack.vim (using ag/silver searcher)
--------------------------------------------------------------------------------

vim.g.ackprg = "ag --vimgrep --smart-case"

-- Create command abbreviations for Ack
vim.cmd([[
  cnoreabbrev ag Ack
  cnoreabbrev aG Ack
  cnoreabbrev Ag Ack
  cnoreabbrev AG Ack
]])

--------------------------------------------------------------------------------
-- Plugin: localvimrc
--------------------------------------------------------------------------------

vim.g.localvimrc_persistent = 2
vim.g.localvimrc_whitelist = { ".*/code/(circuithub|circuithub-alt)/(client|projects|api)/.lvimrc" }

--------------------------------------------------------------------------------
-- Custom: Claude Code Reference Generator
-- Generate a reference to the current file and line/selection for Claude Code
--------------------------------------------------------------------------------

keymap({ "n", "v" }, "<leader>cr", function()
  local file_path = vim.fn.expand("%:p")
  local relative_path = vim.fn.fnamemodify(file_path, ":~:.")

  local start_line, end_line
  local mode = vim.fn.mode()

  if mode == "v" or mode == "V" or mode == "\22" then
    -- Use getpos to get current visual selection (marks aren't set until exit)
    local visual_start = vim.fn.getpos("v")[2]
    local cursor_pos = vim.fn.getpos(".")[2]
    start_line = math.min(visual_start, cursor_pos)
    end_line = math.max(visual_start, cursor_pos)
  else
    start_line = vim.fn.line(".")
    end_line = start_line
  end

  local reference
  if start_line == end_line then
    reference = string.format("@%s#%d", relative_path, start_line)
  else
    reference = string.format("@%s#%d,%d", relative_path, start_line, end_line)
  end

  vim.fn.setreg("+", reference)
  vim.fn.setreg('"', reference)
  vim.notify(string.format("Copied: %s", reference), vim.log.levels.INFO)
end, { desc = "Copy Claude Code reference" })

--------------------------------------------------------------------------------
-- Colorscheme
-- Use base16_theme environment variable if set, otherwise fall back to default
--------------------------------------------------------------------------------

local base16_theme = vim.env.base16_theme
if base16_theme and base16_theme ~= "" then
  local ok, _ = pcall(vim.cmd, "colorscheme base16-" .. base16_theme)
  if not ok then
    vim.notify("Colorscheme base16-" .. base16_theme .. " not found, using default", vim.log.levels.WARN)
    vim.cmd([[colorscheme base16-gruvbox-dark-hard]])
  end
else
  vim.notify("$base16_theme no set using default", vim.log.levels.INFO)
  vim.cmd([[colorscheme base16-gruvbox-dark-hard]])
end
