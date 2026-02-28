return {
  mason = { "texlab" },
  treesitter = { "latex", "bibtex" },
  lsp = {
    server = "texlab",
    opts = {
      settings = {
        texlab = {
          build = {
            onSave = true,
          },
          chktex = {
            onOpenAndSave = true,
          },
        },
      },
    },
  },
  conform = {
    tex = { "latexindent" },
    plaintex = { "latexindent" },
  },
}
