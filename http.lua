local M = {}
local parser = require("voiden.parser")

-- Assure qu'une fenêtre + buffer "VoidenOutput" existe
local function ensure_output_win()
  local buf, win

  -- Vérifie si le buffer existe déjà
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(b):match("VoidenOutput") then
      buf = b
      break
    end
  end

  -- Sinon crée le buffer
  if not buf then
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, "VoidenOutput")
  else
    -- vide le contenu si réutilisé
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
  end

  -- Vérifie si une fenêtre affiche déjà ce buffer
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(w) == buf then
      win = w
      break
    end
  end

  -- Sinon ouvre une fenêtre
  if not win then
    vim.cmd("vsplit")
    win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
  end

  return buf, win
end

-- Append lines dans le buffer + scrolle la fenêtre correspondante
local function append(buf, lines, prefix)
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
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(w) == buf then
        local lc = vim.api.nvim_buf_line_count(buf)
        vim.api.nvim_win_set_cursor(w, { lc, 0 })
      end
    end
  end
end

-- Exécute une requête choisie via menu
function M.run_request()
  local blocks = parser.parse()
  if #blocks == 0 then
    vim.notify("[Voiden] Aucun bloc trouvé", vim.log.levels.WARN)
    return
  end

  -- Construire la liste pour le menu
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

    local buf, _ = ensure_output_win()

    vim.fn.jobstart(cmd, {
      stdout_buffered = false,
      stderr_buffered = false,
      on_stdout = function(_, data)
        append(buf, data)
      end,
      on_stderr = function(_, data)
        append(buf, data, "[ERR] ")
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
