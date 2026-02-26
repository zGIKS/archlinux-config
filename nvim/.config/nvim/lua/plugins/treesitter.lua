return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      local ok, ts = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.notify("treesitter could not be loaded", vim.log.levels.ERROR)
        return
      end

      ts.setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "bash",
          "json",
          "yaml",
          "toml",
          "markdown",
          "markdown_inline",
        },
        auto_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
