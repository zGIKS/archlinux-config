return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local lang = require("lang")
      local ok, ts = pcall(require, "nvim-treesitter")
      if not ok then
        vim.notify("treesitter could not be loaded", vim.log.levels.ERROR)
        return
      end

      ts.setup({})

      vim.api.nvim_create_user_command("DotfilesTSInstall", function()
        local parsers = {
          "lua",
          "vim",
          "vimdoc",
          "bash",
          "json",
          "yaml",
          "toml",
          "markdown",
          "markdown_inline",
        }

        local seen = {}
        for _, parser in ipairs(parsers) do
          seen[parser] = true
        end
        for _, parser in ipairs(lang.collect_treesitter()) do
          if not seen[parser] then
            parsers[#parsers + 1] = parser
            seen[parser] = true
          end
        end

        ts.install(parsers)
      end, { desc = "Install treesitter parsers from dotfiles language modules" })

      local ts_group = vim.api.nvim_create_augroup("dotfiles_treesitter_start", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = ts_group,
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}
