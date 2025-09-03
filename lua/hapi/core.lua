local M = {}
local config = require("hapi.config")
local parser = require("hapi.parser")
local http = require("hapi.http")

--- Exemple simple
function M.hello()
  if config.options.debug then
    print("[Hapi] Debug: hello called")
  end
  print("Hello Hapi.nvim 👋")
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
