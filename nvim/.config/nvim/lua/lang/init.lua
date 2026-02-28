local M = {}

local language_modules = {
  "lang.rust",
  "lang.go",
  "lang.java",
}

local function add_unique(list, seen, item)
  if seen[item] then
    return
  end
  seen[item] = true
  list[#list + 1] = item
end

local function merge_ft_map(into, from)
  for ft, tools in pairs(from or {}) do
    into[ft] = into[ft] or {}
    local seen = {}
    for _, item in ipairs(into[ft]) do
      seen[item] = true
    end
    for _, item in ipairs(tools) do
      if not seen[item] then
        into[ft][#into[ft] + 1] = item
        seen[item] = true
      end
    end
  end
end

function M.get_specs()
  local specs = {}
  for _, modname in ipairs(language_modules) do
    local ok, spec = pcall(require, modname)
    if ok and type(spec) == "table" then
      specs[#specs + 1] = spec
    end
  end
  return specs
end

function M.collect_mason_tools()
  local out, seen = {}, {}
  for _, spec in ipairs(M.get_specs()) do
    for _, tool in ipairs(spec.mason or {}) do
      add_unique(out, seen, tool)
    end
  end
  return out
end

function M.collect_lsp_servers()
  local servers = {}
  for _, spec in ipairs(M.get_specs()) do
    local lsp = spec.lsp
    if lsp and lsp.server then
      servers[lsp.server] = vim.tbl_deep_extend("force", servers[lsp.server] or {}, lsp.opts or {})
    end
  end
  return servers
end

function M.collect_conform()
  local formatters_by_ft = {}
  for _, spec in ipairs(M.get_specs()) do
    merge_ft_map(formatters_by_ft, spec.conform or {})
  end
  return formatters_by_ft
end

function M.collect_lint()
  local linters_by_ft = {}
  for _, spec in ipairs(M.get_specs()) do
    merge_ft_map(linters_by_ft, spec.lint or {})
  end
  return linters_by_ft
end

function M.collect_treesitter()
  local out, seen = {}, {}
  for _, spec in ipairs(M.get_specs()) do
    for _, parser in ipairs(spec.treesitter or {}) do
      add_unique(out, seen, parser)
    end
  end
  return out
end

return M
