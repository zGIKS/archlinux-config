vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight copied text",
  group = vim.api.nvim_create_augroup("dotfiles_yank_highlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
  desc = "Retry filetype detection when missing",
  group = vim.api.nvim_create_augroup("dotfiles_filetype_retry", { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].filetype ~= "" then
      return
    end

    if vim.api.nvim_buf_get_name(args.buf) == "" then
      return
    end

    vim.cmd("filetype detect")
    local ft = vim.filetype.match({ buf = args.buf })
    if ft and ft ~= "" then
      vim.bo[args.buf].filetype = ft
    end
  end,
})
