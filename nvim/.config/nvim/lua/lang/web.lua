return {
  mason = { "typescript-language-server", "astro-language-server" },
  treesitter = { "javascript", "typescript", "tsx", "html", "css", "astro" },
  lsp_servers = {
    {
      server = "ts_ls",
      opts = {
        init_options = {
          preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
          },
        },
      },
    },
    {
      server = "astro",
    },
  },
  conform = {
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    astro = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    json = { "prettier" },
  },
}
