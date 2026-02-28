return {
  mason = { "rust-analyzer" },
  treesitter = { "rust" },
  lsp = {
    server = "rust_analyzer",
    opts = {
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          check = { command = "clippy" },
        },
      },
    },
  },
  conform = {
    rust = { "rustfmt" },
  },
}
