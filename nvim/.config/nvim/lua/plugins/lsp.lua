return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "bashls" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Use the new lsp.config/enable if available (Nvim 0.11+),
      -- otherwise fallback to the traditional setup (Nvim 0.10).
      local has_new_lsp = vim.lsp.config ~= nil

      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if not ok_cmp then
        vim.notify("cmp_nvim_lsp could not be loaded", vim.log.levels.ERROR)
        return
      end

      local capabilities = cmp_lsp.default_capabilities()

      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
        map("n", "gr", vim.lsp.buf.references, "LSP: References")
        map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
        map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
        map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
      end

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
            },
          },
        },
        bashls = {},
      }

      local lspconfig = require("lspconfig")
      for server, server_opts in pairs(servers) do
        server_opts.capabilities = capabilities
        server_opts.on_attach = on_attach

        if has_new_lsp then
          vim.lsp.config(server, server_opts)
          vim.lsp.enable(server)
        else
          lspconfig[server].setup(server_opts)
        end
      end
    end,
  },
}
