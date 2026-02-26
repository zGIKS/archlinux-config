return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      terminal_colors = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_colors = function(colors)
        -- Slight adjustment to match your blue/cyan Alacritty palette.
        colors.blue = "#0a84ff"
        colors.cyan = "#64d2ff"
      end,
    },
    config = function(_, opts)
      local ok, tokyonight = pcall(require, "tokyonight")
      if not ok then
        vim.notify("tokyonight could not be loaded", vim.log.levels.ERROR)
        return
      end

      tokyonight.setup(opts)

      local ok_cs, err = pcall(vim.cmd.colorscheme, "tokyonight")
      if not ok_cs then
        vim.notify("Could not apply tokyonight: " .. err, vim.log.levels.ERROR)
      end
    end,
  },
}
