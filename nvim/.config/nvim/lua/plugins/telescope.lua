return {
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.x",
    cmd = "Telescope",
    keys = {
      {
        "<C-p>",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Buscar archivos",
      },
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Buscar archivos",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Buscar texto",
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Ayuda",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if not ok then
        vim.notify("telescope no pudo cargarse", vim.log.levels.ERROR)
        return
      end

      telescope.setup({
        defaults = {
          file_ignore_patterns = { ".git/" },
        },
      })
    end,
  },
}
