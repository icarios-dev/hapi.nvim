local M = {}
local config = require("voiden.config")
local parser = require("voiden.parser")
local http = require("voiden.http")

--- Exemple simple
function M.hello()
  if config.options.debug then
    print("[Voiden] Debug: hello called")
  end
  print("Hello Voiden.nvim 👋")
end

function M.parse_current()
  local blocks = parser.parse()
  local inspect = vim.inspect
  if #blocks == 0 then
    print("Aucun bloc trouvé")
  else
    print(inspect(blocks))
  end
end

function M.run_current_request()
  http:run_request()
end

return M
