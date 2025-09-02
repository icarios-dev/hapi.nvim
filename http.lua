local M = {}
local parser = require("voiden.parser")

--- Affiche le résultat dans une fenêtre dédiée "VoidenOutput"
function M.show_output(lines)
  -- Cherche si un buffer nommé "VoidenOutput" existe déjà
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf):match("VoidenOutput") then
      -- Remplace le contenu
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      -- Vérifie si une fenêtre affiche déjà ce buffer
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
      -- Si pas affiché, ouvre dans un split
      vim.cmd("vsplit")
      local win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(win, buf)
      return
    end
  end

  -- Sinon crée un nouveau buffer
  vim.cmd("vsplit")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, "VoidenOutput")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_win_set_buf(win, buf)
end

function M.run_request()
  local blocks = parser.parse()
  if #blocks == 0 then
    vim.notify("[Voiden] Aucun bloc trouvé", vim.log.levels.WARN)
    return
  end

  -- Fabrique une liste lisible pour le menu
  local items = {}
  for i, b in ipairs(blocks) do
    local title = string.format("[%d] %s %s", i, b.method or "GET", b.url or "??")
    table.insert(items, { idx = i, text = title, block = b })
  end

  vim.ui.select(items, {
    prompt = "Sélectionne une requête à exécuter",
    format_item = function(item)
      return item.text
    end,
  }, function(choice)
    if not choice then
      vim.notify("[Voiden] Annulé", vim.log.levels.INFO)
      return
    end

    local block = choice.block
    local cmd = { "curl", "-i", "-s", "-X", block.method, block.url }
    for _, h in ipairs(block.headers) do
      table.insert(cmd, "-H")
      table.insert(cmd, h)
    end

    -- Prépare la fenêtre de sortie
    local buf
    local found = false
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_get_name(b):match("VoidenOutput") then
        buf = b
        found = true
        break
      end
    end
    if not found then
      vim.cmd("vsplit")
      buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_name(buf, "VoidenOutput")
      vim.api.nvim_win_set_buf(0, buf)
    else
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, {}) -- clear
    end

    local function scroll_to_end(buf)
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
          local line_count = vim.api.nvim_buf_line_count(buf)
          vim.api.nvim_win_set_cursor(win, { line_count, 0 })
        end
      end
    end

    local function append(lines, prefix)
      if not lines then
        return
      end
      local clean = {}
      for _, l in ipairs(lines) do
        if l ~= "" then
          table.insert(clean, (prefix or "") .. l)
        end
      end
      if #clean > 0 then
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, clean)
        scroll_to_end(buf)
      end
    end

    vim.fn.jobstart(cmd, {
      stdout_buffered = false,
      stderr_buffered = false,
      on_stdout = function(_, data)
        append(data)
      end,
      on_stderr = function(_, data)
        append(data, "[ERR] ")
      end,
      on_exit = function(_, code)
        vim.notify(
          string.format("[Voiden] '%s %s' terminé avec code: %d", block.method, block.url, code),
          code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
        )
      end,
    })
  end)
end

return M
