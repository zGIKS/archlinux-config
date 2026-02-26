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
        desc = "Find files",
      },
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find files",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Find text",
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
        desc = "Help",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if not ok then
        vim.notify("telescope could not be loaded", vim.log.levels.ERROR)
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
