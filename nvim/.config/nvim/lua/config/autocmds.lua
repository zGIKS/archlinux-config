vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Resalta texto copiado",
  group = vim.api.nvim_create_augroup("dotfiles_yank_highlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
