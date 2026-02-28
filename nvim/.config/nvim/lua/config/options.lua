vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- Force filetype + syntax detection early to avoid empty &filetype on first open.
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

opt.number = true
opt.relativenumber = false
opt.mouse = "a"
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 500
opt.completeopt = { "menu", "menuone", "noselect" }

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8
opt.laststatus = 3

local git_branch_cache = {}
local status_author = vim.env.GIT_AUTHOR_NAME or vim.env.USER or "unknown"

local function get_git_branch(bufname)
  local dir = bufname ~= "" and vim.fn.fnamemodify(bufname, ":p:h") or vim.fn.getcwd()
  if git_branch_cache[dir] ~= nil then
    return git_branch_cache[dir]
  end

  local branch = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--abbrev-ref", "HEAD" })[1] or ""
  if vim.v.shell_error ~= 0 or branch == "HEAD" then
    branch = "-"
  end
  git_branch_cache[dir] = branch
  return branch
end

function _G.dotfiles_status_meta()
  local bufname = vim.api.nvim_buf_get_name(0)
  local ft = vim.bo.filetype ~= "" and vim.bo.filetype or "no-ft"
  local branch = get_git_branch(bufname)
  return string.format(" %s | %s | %s", branch, status_author, ft)
end

vim.api.nvim_create_autocmd("DirChanged", {
  desc = "Clear cached git branch for statusline",
  callback = function()
    git_branch_cache = {}
  end,
})

opt.statusline = "%f%m%r%=%( %{v:lua.dotfiles_status_meta()} %)"

-- Backup and Swap files (Disabled to avoid annoying popups)
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true -- Persistent undo: saves undo history to disk

-- Prevents lag and clipboard leaks over SSH; maintains convenience locally.
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
  opt.clipboard = ""
else
  opt.clipboard = "unnamedplus"
end

-- nvim-tree replaces netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
