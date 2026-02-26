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
      if vim.fn.has("nvim-0.11") == 0 then
        vim.notify("La config LSP actual requiere Neovim 0.11+", vim.log.levels.WARN)
        return
      end

      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if not ok_cmp then
        vim.notify("cmp_nvim_lsp no pudo cargarse", vim.log.levels.ERROR)
        return
      end

      local capabilities = cmp_lsp.default_capabilities()

      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "LSP: Ir a definición")
        map("n", "gr", vim.lsp.buf.references, "LSP: Referencias")
        map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
        map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Renombrar")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
        map("n", "[d", vim.diagnostic.goto_prev, "Diag anterior")
        map("n", "]d", vim.diagnostic.goto_next, "Diag siguiente")
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

      for server, server_opts in pairs(servers) do
        server_opts.capabilities = capabilities
        server_opts.on_attach = on_attach
        vim.lsp.config(server, server_opts)
        vim.lsp.enable(server)
      end
    end,
  },
}
