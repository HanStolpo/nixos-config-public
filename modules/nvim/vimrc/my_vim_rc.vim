
set spelllang=en_gb

set gfn=Roboto\ Mono\ for\ Powerline:h14

set ffs=unix,mac,dos
set shiftwidth=2
set tabstop=2
set noautochdir


au BufEnter *.spec setfiletype coffee

if has("gui_running")
  set guioptions-=T "Remove toolbar
  set guioptions-=r "Remove right-handed scrollbar
  set guioptions-=R "Remove right-handed scrollbar
  set guioptions-=l "??Remove right-handed scrollbar
  set guioptions-=L "??Remove right-handed scrollbar
endif

set ruler "Show the cursor position all the time.

set relativenumber "View the distance to the next line (useful with d commands). When this is set, number is reset.

set nowrap "Don't perform line wrapping.

set hidden " Don't close buffers, only hide them. Unwritten changes allowed.

" clear highlighting
nnoremap <leader>nh :noh<CR>
nnoremap <C-s> :w<CR>

" Navigation
nnoremap <C-t> <C-w><C-t>
nnoremap <C-b> <C-w><C-b>
nnoremap <C-p> <C-w><C-p>

" Move quick fix window to bottom
autocmd FileType qf wincmd J

set wildignore+=*.o,*.obj,*.hi,*.dyn_hi,*.dyn_o,.cabal-sandbox/**/

"system clipboard is default clipboard
set cb=unnamedplus
set cursorline

au InsertEnter * set nocursorline
au InsertEnter * set cursorcolumn
au InsertLeave * set cursorline
au InsertLeave * set nocursorcolumn


autocmd BufEnter *.hs set indentkeys=
autocmd BufEnter *.nix set indentkeys=
autocmd BufEnter *.elm set indentkeys=


"localvimrc settings
let g:localvimrc_persistent = 2
let g:localvimrc_whitelist=['.*/dev/circuithub/\(client\|projects\|api\)/\.lvimrc']

set hidden

au BufNewFile,BufRead *.hs map <buffer> <leader>hh :Hoogle
au BufNewFile,BufRead *.hs map <buffer> <leader>hH :Hoogle<CR>
au BufNewFile,BufRead *.hs map <buffer> <leader>hc :HoogleClose<CR>
au BufNewFile,BufRead *.hs map <buffer> <leader>hl :HoogleLine<CR>


lua << EOF


-- tree sitter setup
require'nvim-treesitter.configs'.setup {
  highlight = {
    -- `false` will disable the whole extension
  enable = true,

  -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
  -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
  -- the name of the parser)
  -- list of language that will be disabled
  disable = { },

  -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
  -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
  -- Using this option may slow down your editor, and you may see some duplicate highlights.
  -- Instead of true it can also be a list of languages
  additional_vim_regex_highlighting = false,
  },
}

vim.cmd[[colorscheme base16-gruvbox-light-hard]]

require('telescope').setup{
defaults = {
  dynamic_preview_title = true,
  layout_strategy = "flex",
  path_display = { smart = {} }
  }
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
    },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
    },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
    },
  tabline = {},
  extensions = {}
  }

require('auto-session').setup {
  log_level = 'info',
  auto_session_enable_last_session = false,
  auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
  auto_session_enabled = true,
  auto_save_enabled = true,
  auto_restore_enabled = true,
  auto_session_suppress_dirs = nil,
  -- the configs below are lua only
  bypass_session_save_file_types = nil
  }

vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

-- Setup nvim-cmp.
vim.opt.completeopt='menu,menuone,noselect'

local cmp = require'cmp'

cmp.setup {
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
    i = cmp.mapping.abort(),
    c = cmp.mapping.close(),
    }),
  ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
snippet = {
  expand = function(args)
  require 'snippy'.expand_snippet(args.body)
end
},
  sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'snippy' },
  }, {
  { name = 'buffer' },
  })
}

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
  { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
  { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
    }
  })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
  { name = 'path' }
  }, {
  { name = 'cmdline' }
  })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())


-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '<M-k>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', '<M-j>', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

-- https://github.com/elm-tooling/elm-language-server/issues/503#issuecomment-773922548
if client.config.flags then
  client.config.flags.allow_incremental_sync = true
end

-- Enable completion triggered by <c-x><c-o>
vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

-- Mappings.
-- See `:help vim.lsp.*` for documentation on any of the below functions
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ad', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ah', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ad', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local function assign(t1)
return function (t2)
for k,v in pairs(t2) do
  t1[k] = v
end
return t1
  end
end

local servers = {
  hls = {
    cmd = { "haskell-language-server", "--lsp" },
    -- root_dir = require('lspconfig.util').root_pattern('cabal.project'),
    },
elmls = {
  settings = {
  elmLS = {
    trace = {
      server = true
      },
  elmPath = "elm",
elmReviewPath = "elm-review",
        elmReviewDiagnostics = "warning",
      elmFormatPath = "elm-format",
    elmTestPath = "elm-test",
    }
  },
},
  }

for lsp, cfg in pairs(servers) do
  require('lspconfig')[lsp].setup ( assign(cfg) {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
      }
    })
end
EOF

"tree sitter for fold
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
