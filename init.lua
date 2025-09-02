local M = {}

local config = require("voiden.config")
local commands = require("voiden.commands")

-- Setup du plugin avec des configurations par défaut
-- @param opts table|nil: Configuration utilisateur

function M.setup(opts)
  config.set(opts or {}) -- merge user config with default config
  commands.register() -- enregistre les :commands
end

return M
