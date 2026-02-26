return {
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<C-b>", "<cmd>NvimTreeToggle<cr>", desc = "File Explorer" },
      { "<leader>e", "<cmd>NvimTreeFocus<cr>", desc = "Focus File Explorer" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local ok, nvim_tree = pcall(require, "nvim-tree")
      if not ok then
        vim.notify("nvim-tree could not be loaded", vim.log.levels.ERROR)
        return
      end

      nvim_tree.setup({
        view = {
          width = 32,
          side = "left",
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
        git = {
          ignore = false,
        },
      })
    end,
  },
}
