local M = {}

local hl = {
  [vim.diagnostic.severity.ERROR] = "%#DiagnosticError#",
  [vim.diagnostic.severity.WARN] = "%#DiagnosticWarn#",
  [vim.diagnostic.severity.INFO] = "%#DiagnosticInfo#",
  [vim.diagnostic.severity.HINT] = "%#DiagnosticHint#",
}

local v = vim.v
local get_buf = vim.api.nvim_get_current_buf
local get_tick = vim.api.nvim_buf_get_changedtick
local diag_get = vim.diagnostic.get

local c_buf, c_tick, c_sev = -1, -1, {}

local function sev_map(buf)
  local tick = get_tick(buf)
  if c_buf == buf and c_tick == tick then
    return c_sev
  end
  local sev = {}
  for _, d in ipairs(diag_get(buf)) do
    local l, s = d.lnum, d.severity
    if not sev[l] or s < sev[l] then
      sev[l] = s
    end
  end
  c_buf, c_tick, c_sev = buf, tick, sev
  return sev
end

function M.statuscolumn()
  if v.virtnum ~= 0 then return "" end
  local lnum, relnum = v.lnum, v.relnum
  local s = sev_map(get_buf())[lnum - 1]
  if relnum == 0 then
    return (s and hl[s] or "%#CursorLineNr#") .. lnum .. " "
  end
  return "%=" .. (s and hl[s] or "%#LineNr#") .. relnum .. " "
end

function M.init()
  _G.my_statuscolumn = M.statuscolumn

  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function()
      c_tick = -1
    end,
  })

  local function update()
    if vim.bo.buftype == "terminal" then return end
    vim.wo.statuscolumn = vim.wo.number and "%!v:lua.my_statuscolumn()" or ""
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "netrw", "nnp-pad" },
    callback = function()
      vim.wo.statuscolumn = ""
    end,
  })
  vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
    callback = function()
      vim.wo.statuscolumn = ""
      vim.wo.number = false
      vim.wo.relativenumber = false
    end,
  })
  vim.api.nvim_create_autocmd("OptionSet", {
    pattern = { "number", "relativenumber" },
    callback = update,
  })
  update()
end

M.init()
