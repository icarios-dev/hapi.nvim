local M = {}

--- Exemple: trim string
function M.trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

return M
