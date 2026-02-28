return {
  mason = { "jdtls" },
  treesitter = { "java" },
  lsp = {
    server = "jdtls",
    opts = {
      root_dir = function(fname)
        return require("lspconfig.util").root_pattern(
          ".git",
          "pom.xml",
          "build.gradle",
          "build.gradle.kts",
          "settings.gradle",
          "settings.gradle.kts"
        )(fname)
      end,
      single_file_support = false,
    },
  },
  conform = {
    java = { "google-java-format" },
  },
}
