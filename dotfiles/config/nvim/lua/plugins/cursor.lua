-- laststatus=0 hides the usual [+] marker, so the cursor carries buffer state.
-- Needs the -Cursor suffix in 'guicursor' (see config/options.lua).
--
-- guicursor ignores a linked Cursor group (falls back to ANSI 11 / invert, which
-- is why the block went yellow or picked up the syntax colour under the cursor).
local M = {}

local pal = { idle = {}, locked = {}, dirty = {} }

function M.theme()
  local function hl(name)
    return vim.api.nvim_get_hl(0, { name = name })
  end
  local n, err, warn = hl("Normal"), hl("DiagnosticError"), hl("DiagnosticWarn")
  local ok, base16 = pcall(require, "base16-colorscheme")
  local p = ok and base16.colors or {}
  local bg, fg = n.bg or p.base00, n.fg or p.base05
  pal.idle = { fg = bg, bg = fg }
  pal.locked = { fg = bg, bg = warn.fg or p.base0A or fg }
  pal.dirty = { fg = bg, bg = err.fg or p.base08 or fg }
end

function M.apply()
  local hl = pal.idle
  if vim.bo.readonly or not vim.bo.modifiable then
    hl = pal.locked
  elseif vim.bo.modified then
    hl = pal.dirty
  end
  if not hl.bg then
    return
  end
  vim.api.nvim_set_hl(0, "Cursor", { fg = hl.fg, bg = hl.bg, force = true })
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
    { "BufModifiedSet", "BufWritePost", "BufEnter", "WinEnter" },
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
