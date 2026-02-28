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
    opts = function()
      local lang = require("lang")
      local ensure_installed = {
        "lua-language-server",
        "bash-language-server",
        "stylua",
        "shfmt",
        "shellcheck",
      }

      local seen = {}
      for _, item in ipairs(ensure_installed) do
        seen[item] = true
      end
      for _, item in ipairs(lang.collect_mason_tools()) do
        if not seen[item] then
          ensure_installed[#ensure_installed + 1] = item
          seen[item] = true
        end
      end

      return {
        ensure_installed = ensure_installed,
        auto_update = false,
        run_on_start = true,
      }
    end,
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
      local lang = require("lang")

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

      for server, opts in pairs(lang.collect_lsp_servers()) do
        servers[server] = vim.tbl_deep_extend("force", servers[server] or {}, opts)
      end

      if has_new_lsp then
        for server, server_opts in pairs(servers) do
          server_opts.capabilities = capabilities
          server_opts.on_attach = on_attach
          vim.lsp.config(server, server_opts)
          vim.lsp.enable(server)
        end
      else
        local lspconfig = require("lspconfig")
        local server_alias = {
          ts_ls = "tsserver",
        }
        for server, server_opts in pairs(servers) do
          local resolved = lspconfig[server] and server or server_alias[server]
          if not resolved or not lspconfig[resolved] then
            vim.notify("LSP server not found in lspconfig: " .. server, vim.log.levels.WARN)
            goto continue
          end
          server_opts.capabilities = capabilities
          server_opts.on_attach = on_attach
          lspconfig[resolved].setup(server_opts)
          ::continue::
        end
      end
    end,
  },
}
