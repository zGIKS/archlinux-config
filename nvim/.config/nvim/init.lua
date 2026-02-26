vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 300

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

-- Keep the repo simple: no plugin manager bootstrap yet.

vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Guardar archivo" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Cerrar ventana" })
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Cerrar buffer" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Quitar resaltado" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Ir a ventana izquierda" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Ir a ventana abajo" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Ir a ventana arriba" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Ir a ventana derecha" })

vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split horizontal" })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Resalta texto copiado",
  group = vim.api.nvim_create_augroup("dotfiles_yank_highlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

