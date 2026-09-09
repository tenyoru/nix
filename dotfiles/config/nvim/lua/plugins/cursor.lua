-- laststatus=0 hides the usual [+] marker, so the cursor carries buffer state
-- instead. Needs the -Cursor suffix in 'guicursor' (see config/options.lua).
--
-- Colours live on CursorIdle / CursorLocked / CursorDirty, filled from the
-- active colorscheme. This file only picks which of those Cursor links to.
local M = {}

function M.theme()
  local n = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local function fg(group)
    return vim.api.nvim_get_hl(0, { name = group, link = false }).fg
  end
  local ok, base16 = pcall(require, "base16-colorscheme")
  local p = ok and base16.colors or {}
  vim.api.nvim_set_hl(0, "CursorIdle", { fg = n.bg, bg = n.fg })
  vim.api.nvim_set_hl(0, "CursorLocked", { fg = n.bg, bg = p.base0A or fg("WarningMsg") })
  vim.api.nvim_set_hl(0, "CursorDirty", { fg = n.bg, bg = p.base08 or fg("ErrorMsg") })
end

function M.apply()
  local group = "CursorIdle"
  if vim.bo.readonly or not vim.bo.modifiable then
    group = "CursorLocked"
  elseif vim.bo.modified then
    group = "CursorDirty"
  end
  vim.api.nvim_set_hl(0, "Cursor", { link = group })
end

function M.init()
  local g = vim.api.nvim_create_augroup("cursor_state", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = g,
    callback = function()
      M.theme()
      M.apply()
    end,
  })
  vim.api.nvim_create_autocmd(
    { "BufModifiedSet", "BufWritePost", "BufEnter" },
    { group = g, callback = M.apply }
  )
  vim.api.nvim_create_autocmd("OptionSet", {
    group = g,
    pattern = { "readonly", "modifiable" },
    callback = M.apply,
  })
  M.theme()
  M.apply()
end

M.init()

return M
