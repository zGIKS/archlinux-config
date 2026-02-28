return {
  mason = { "gopls" },
  treesitter = { "go", "gomod", "gowork", "gosum" },
  lsp = {
    server = "gopls",
    opts = {
      settings = {
        gopls = {
          gofumpt = true,
          staticcheck = true,
        },
      },
    },
  },
  conform = {
    go = { "gofmt" },
  },
}
