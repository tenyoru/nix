local WIDTH = 60 -- inner width of the cmdline box

-- Where nui puts the 50%-centred cmdline. Pinning the menu there instead of
-- letting noice anchor it means it no longer slides right while completing a
-- command argument, nor gets clamped upward by nvim on top of the cmdline.
-- The menu has no top border and starts on the cmdline's bottom border row,
-- so the two windows never share a row and fuse into one box.
local function menu_geom()
  local row = math.floor((vim.o.lines - 1) / 2)
  return { row = row + 2, col = math.floor((vim.o.columns - WIDTH) / 2) - 1 },
    math.max(4, vim.o.lines - row - 4)
end

local menu_pos, menu_height = menu_geom()

require("noice").setup({
  cmdline = {
    format = {
      cmdline = { icon = ">" },
      -- search_down = { icon = "" },
      -- search_up = { icon = "" },
      -- filter = { icon = "" },
      -- lua = { icon = "" },
      help = { icon = "?" },
    },
  },
  popupmenu = { backend = "nui" },
  views = {
    cmdline_popup = {
      position = { row = "50%", col = "50%" },
      size = { width = WIDTH, height = "auto" },
      border = {
        style = "single",
        padding = { 0, 1 },
        text = { top = "" },
      },
      win_options = {
        winhighlight = {
          Normal = "Normal",
          FloatBorder = "Comment",
          FloatTitle = "Normal",
        },
      },
    },
    popupmenu = {
      border = { style = "single" },
      win_options = {
        winhighlight = {
          Normal = "Pmenu",
          FloatBorder = "Comment",
          CursorLine = "PmenuSel",
        },
      },
    },
    -- padding.left = cmdline padding (1) + icon (1) + space (1), so items line
    -- up with the cmdline text; width compensates for that padding. zindex
    -- beats the cmdline's 200 so the first item reliably replaces its bottom
    -- border instead of z-fighting with it.
    cmdline_popupmenu = {
      position = menu_pos,
      zindex = 210,
      size = { width = WIDTH - 2, height = "auto", max_height = menu_height },
      border = {
        style = { "", "", "", "│", "┘", "─", "└", "│" },
        padding = { 0, 1, 0, 3 },
      },
    },
  },
  messages = {
    view = "mini",
    view_error = "mini",
    view_warn = "mini",
  },
  routes = {
    { filter = { event = "notify" }, view = "mini" },
    { filter = { event = "msg_show" }, view = "mini" },
  },
})

vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    local view = require("noice.config").options.views.cmdline_popupmenu
    view.position, view.size.max_height = menu_geom()
  end,
})

local function paper_hl()
  local n = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local bg = n.bg or 0x161310
  local r, g, b = math.floor(bg / 65536) % 256, math.floor(bg / 256) % 256, bg % 256
  local step = (0.299 * r + 0.587 * g + 0.114 * b) > 128 and -22 or 18
  local function clamp(x)
    return math.max(0, math.min(255, x))
  end
  local float = string.format("#%02x%02x%02x", clamp(r + step), clamp(g + step), clamp(b + step))
  local border = vim.api.nvim_get_hl(0, { name = "Comment", link = false }).fg
  local fill = { fg = n.fg, bg = float }
  vim.api.nvim_set_hl(0, "NormalFloat", fill)
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = border, bg = float })
  vim.api.nvim_set_hl(0, "Pmenu", fill)
  vim.api.nvim_set_hl(0, "PmenuExtra", fill)
  vim.api.nvim_set_hl(0, "PmenuSel", { link = "CursorLine" })
  vim.api.nvim_set_hl(0, "PmenuSbar", fill)
  vim.api.nvim_set_hl(0, "PmenuThumb", { link = "Comment" })
  vim.api.nvim_set_hl(0, "PmenuMatch", { link = "Title" })
  vim.api.nvim_set_hl(0, "PmenuMatchSel", { link = "Title" })
  for _, g in ipairs({
    "NoiceCmdlinePopupBorder",
    "NoiceCmdlineIcon",
    "NoiceCmdlinePopupBorderSearch",
    "NoiceCmdlineIconSearch",
  }) do
    vim.api.nvim_set_hl(0, g, { link = "Comment" })
  end
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { link = "Normal" })
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", { fg = "bg", bg = "bg" })
end
paper_hl()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("noice_paper", { clear = true }),
  callback = paper_hl,
})
