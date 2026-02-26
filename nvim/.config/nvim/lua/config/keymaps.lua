vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Guardar archivo" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Cerrar ventana" })
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Cerrar buffer" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Quitar resaltado" })

vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>write<cr>", { desc = "Guardar" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Ir a ventana izquierda" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Ir a ventana abajo" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Ir a ventana arriba" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Ir a ventana derecha" })

vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split horizontal" })
