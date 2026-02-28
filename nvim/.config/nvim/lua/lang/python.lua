return {
  mason = { "pyright", "ruff" },
  treesitter = { "python" },
  lsp = {
    server = "pyright",
    opts = {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
    },
  },
  conform = {
    python = { "ruff_format", "black" },
  },
}
