
local parserInstallDir = print(vim.fn.stdpath("state") .. "/treesitter/parsers")
require'nvim-treesitter.configs'.setup {
  -- A directory to install the parsers into.
  -- If this is excluded or nil parsers are installed
  -- to either the package dir, or the "site" dir.
  -- If a custom path is used (not nil) it must be added to the runtimepath.
  parser_install_dir = parserInstallDir,
}
vim.opt.runtimepath:append(parserInstallDir)
