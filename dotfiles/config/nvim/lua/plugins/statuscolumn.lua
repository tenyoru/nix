local M = {}

local diagnostic_hl = {
  [vim.diagnostic.severity.ERROR] = "%#DiagnosticError#",
  [vim.diagnostic.severity.WARN] = "%#DiagnosticWarn#",
  [vim.diagnostic.severity.INFO] = "%#DiagnosticInfo#",
  [vim.diagnostic.severity.HINT] = "%#DiagnosticHint#"
}

local current_line_hl = "%#CursorLineNr#"
local non_current_line_hl = "%#LineNr#"

local function get_diagnostic_highlight(line_nr)
  local diagnostics = vim.diagnostic.get(0, { lnum = line_nr - 1 })
  if #diagnostics == 0 then return nil end

  local highest_severity = diagnostics[1].severity
  for i = 2, #diagnostics do
    highest_severity = math.min(highest_severity, diagnostics[i].severity)
  end

  return diagnostic_hl[highest_severity]
end

function M.statuscolumn()
  if vim.v.virtnum ~= 0 then return "" end

  local line_nr = vim.v.lnum
  local is_current = line_nr == vim.fn.line('.')
  local lnum = is_current and line_nr or vim.v.relnum

  local hl_group = get_diagnostic_highlight(line_nr) or (is_current and current_line_hl or non_current_line_hl)

  return (not is_current and "%=" or "") .. hl_group .. lnum .. " "
end

function M.init()
  _G.my_statuscolumn = M.statuscolumn

  local function update_statuscolumn()
    -- Don't apply statuscolumn to terminal buffers
    if vim.bo.buftype == "terminal" then
      return
    end
    vim.o.statuscolumn = vim.wo.number and "%!v:lua.my_statuscolumn()" or ""
    vim.o.relativenumber = vim.wo.number
  end

  -- Disable statuscolumn for special buffers
  vim.api.nvim_create_autocmd("FileType", {
    pattern = {"help", "netrw"},
    callback = function()
      vim.wo.statuscolumn = ""
    end
  })

  vim.api.nvim_create_autocmd({"TermOpen", "TermEnter"}, {
    callback = function()
      vim.wo.statuscolumn = ""
      vim.wo.number = false
      vim.wo.relativenumber = false
    end
  })

  vim.api.nvim_create_autocmd("OptionSet", {
    pattern = {"number", "relativenumber"},
    callback = function()
      update_statuscolumn()
    end
  })

  update_statuscolumn()
end

M.init()
