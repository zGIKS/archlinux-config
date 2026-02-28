return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local ok, vscode = pcall(require, "vscode")
      if not ok then
        vim.notify("vscode.nvim could not be loaded", vim.log.levels.ERROR)
        return
      end

      vscode.setup({
        transparent = true,
        italic_comments = true,
        underline_links = true,
        disable_nvimtree_bg = true,
      })

      local ok_cs, err = pcall(vim.cmd.colorscheme, "vscode")
      if not ok_cs then
        vim.notify("Could not apply vscode theme: " .. err, vim.log.levels.ERROR)
      end
    end,
  },
}
