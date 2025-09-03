local M = {}

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

--- Parse les blocs Hapi dans un buffer
---@param bufnr number|nil buffer à parser (par défaut: courant)
---@return table[] Liste des blocs trouvés
function M.parse(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local blocks = {}
  local inside = false
  local current = nil

  for _, line in ipairs(lines) do
    -- Début d'un bloc :::request <METHOD> <URL>
    local method, url = line:match("^:::request%s+([A-Z]+)%s+(.+)%s*$")
    if method and url then
      current = {
        type = "request",
        method = method,
        url = trim(url),
        headers = {},
      }
      inside = true

    -- Fin de bloc :::
    elseif inside and line:match("^:::%s*$") then
      if current then
        table.insert(blocks, current)
      end
      current = nil
      inside = false

    -- Contenu du bloc (ex: headers)
    elseif current and not line:match("^%s*$") then
      -- On stocke la ligne telle quelle (ex: "Authorization: Bearer XXX")
      table.insert(current.headers, line)
    end
  end

  return blocks
end

return M
