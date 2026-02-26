vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = false
opt.mouse = "a"
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 500
opt.completeopt = { "menu", "menuone", "noselect" }

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8

-- Prevents lag and clipboard leaks over SSH; maintains convenience locally.
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
  opt.clipboard = ""
else
  opt.clipboard = "unnamedplus"
end

-- nvim-tree replaces netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
