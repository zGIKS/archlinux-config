local uv = vim.uv or vim.loop
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy_commit = "306a05526ada86a7b30af95c5cc81ffba93fef97"

local function bootstrap_lazy()
  if uv.fs_stat(lazypath) then
    return
  end

  vim.notify("Installing lazy.nvim (fixed commit)...", vim.log.levels.INFO)

  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.notify("Could not clone lazy.nvim", vim.log.levels.ERROR)
    return
  end

  vim.fn.system({ "git", "-C", lazypath, "checkout", lazy_commit })
  if vim.v.shell_error ~= 0 then
    vim.notify(
      "Could not pin lazy.nvim to commit " .. lazy_commit,
      vim.log.levels.ERROR
    )
    return
  end
end

bootstrap_lazy()
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  defaults = {
    lazy = true,
  },
  install = {
    colorscheme = { "tokyonight", "habamax" },
  },
  checker = { enabled = false },
  change_detection = { notify = false },
})
