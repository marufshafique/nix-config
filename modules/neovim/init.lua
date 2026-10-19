vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.number = true
vim.o.relativenumber = true

vim.o.signcolumn = "yes"

-- Use spaces instead of tabs
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.tabstop = 2      -- number of spaces a <Tab> counts for
vim.opt.shiftwidth = 2   -- spaces used for autoindent
vim.opt.softtabstop = 2  -- spaces inserted when pressing Tab

vim.o.termguicolors = true
vim.o.wrap = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.swapfile = false

-- nvim-treesitter 0.10 (main branch) ships bundled queries under its own
-- `runtime/queries/`, which neovim doesn't search by default. Add it to rtp
-- so parsers provided by nix pick up highlight/indent queries without having
-- to hand-copy them into ~/.local/share/nvim/site/queries.
local nts_runtime = vim.fn.stdpath("data") .. "/site/pack/hm/start/nvim-treesitter/runtime"
if vim.fn.isdirectory(nts_runtime) == 1 then
  vim.opt.runtimepath:append(nts_runtime)
end
