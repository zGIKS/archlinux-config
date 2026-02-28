return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    opts = {},
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "bash-language-server",
        "rust-analyzer",
        "gopls",
        "stylua",
        "shfmt",
        "shellcheck",
      },
      auto_update = false,
      run_on_start = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    init = function()
      local retry_group = vim.api.nvim_create_augroup("dotfiles_lsp_attach_retry", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = retry_group,
        callback = function(args)
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(args.buf) then
              return
            end
            if #vim.lsp.get_clients({ bufnr = args.buf }) > 0 then
              return
            end
            pcall(vim.cmd, "silent! LspStart")
          end)
        end,
      })
    end,
    config = function()
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
        rust_analyzer = {},
        gopls = {},
      }

      if has_new_lsp then
        for server, server_opts in pairs(servers) do
          server_opts.capabilities = capabilities
          server_opts.on_attach = on_attach
          vim.lsp.config(server, server_opts)
          vim.lsp.enable(server)
        end
      else
        local lspconfig = require("lspconfig")
        for server, server_opts in pairs(servers) do
          server_opts.capabilities = capabilities
          server_opts.on_attach = on_attach
          lspconfig[server].setup(server_opts)
        end
      end
    end,
  },
}
