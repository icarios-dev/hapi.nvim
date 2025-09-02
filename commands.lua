local M = {}
local core = require("voiden.core")

function M.register()
  vim.api.nvim_create_user_command("VoidenHello", function()
    core.hello()
  end, { desc = "Test command: say hello" })

  vim.api.nvim_create_user_command("VoidenParse", function()
    core.parse_current()
  end, { desc = "Parse le buffer courant" })

  vim.api.nvim_create_user_command("VoidenRequest", function()
    core.run_current_request()
  end, { desc = "Exécute le premier block request" })
end

return M
