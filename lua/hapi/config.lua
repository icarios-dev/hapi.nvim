local M = {}

-- valeurs par défaut
M.options = {
  debug = false,
}

--- Fusionne les options utilisateur
---@param opts table
function M.set(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
