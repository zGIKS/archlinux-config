return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format buffer",
      },
    },
    opts = function()
      local lang = require("lang")
      local formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
      }

      for ft, tools in pairs(lang.collect_conform()) do
        formatters_by_ft[ft] = tools
      end

      return {
        format_on_save = function(_)
          return {
            timeout_ms = 750,
            lsp_fallback = true,
          }
        end,
        formatters_by_ft = formatters_by_ft,
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    config = function()
      local lang = require("lang")
      local ok, lint = pcall(require, "lint")
      if not ok then
        vim.notify("nvim-lint could not be loaded", vim.log.levels.ERROR)
        return
      end

      lint.linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "shellcheck" },
      }
      for ft, tools in pairs(lang.collect_lint()) do
        lint.linters_by_ft[ft] = tools
      end

      local lint_augroup = vim.api.nvim_create_augroup("dotfiles_lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
