local M = {}

local ns = vim.api.nvim_create_namespace("notebook_lines")

function M.theme()
  local bg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg or 0x161310
  local r, g, b = math.floor(bg / 65536) % 256, math.floor(bg / 256) % 256, bg % 256
  -- step away from the background, so the rule darkens on paper and lightens
  -- on a dark scheme instead of clipping to white
  local step = (0.299 * r + 0.587 * g + 0.114 * b) > 128 and -22 or 14
  vim.api.nvim_set_hl(0, "NotebookRule", {
    underline = true,
    sp = string.format(
      "#%02x%02x%02x",
      math.max(0, math.min(255, r + step)),
      math.max(0, math.min(255, g + step)),
      math.max(0, math.min(255, b + step))
    ),
  })
end

function M.init()
  local g = vim.api.nvim_create_augroup("notebook_lines", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = g,
    callback = M.theme,
  })
  M.theme()

  vim.api.nvim_set_decoration_provider(ns, {
    on_win = function(_, win, buf)
      local bt = vim.bo[buf].buftype
      if bt == "terminal" or bt == "prompt" or bt == "quickfix" then
        return false
      end
      if vim.api.nvim_win_get_config(win).relative ~= "" then
        return false
      end
      if vim.bo[buf].filetype == "nnp-pad" then
        return false
      end
      return true
    end,
    on_line = function(_, win, buf, row)
      local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
      if line ~= "" then
        vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
          ephemeral = true,
          end_col = #line,
          hl_group = "NotebookRule",
          hl_mode = "combine",
        })
      end
      -- overlay lands exactly at the end of the text, but conceal (oil) makes
      -- strdisplaywidth over-count and pushes it too far right; eol is always
      -- placed correctly yet nvim inserts one unstyled cell before it. Emitting
      -- both means normal buffers get no gap and concealed ones get one cell.
      local width = vim.api.nvim_win_get_width(win)
      local rule = { { string.rep(" ", width), "NotebookRule" } }
      vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
        ephemeral = true,
        virt_text = rule,
        virt_text_pos = "eol",
        -- NotebookRule carries no background, so without combine the default
        -- replace mode wipes CursorLine past the end of the text
        hl_mode = "combine",
      })
      -- oil hides a "/123 " id prefix (its syntax/oil.vim conceals `^/\d* `),
      -- which strdisplaywidth still counts; drop it so overlay lands exactly
      local hidden = vim.bo[buf].filetype == "oil" and line:match("^/%d* ") or nil
      vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
        ephemeral = true,
        virt_text = rule,
        virt_text_pos = "overlay",
        virt_text_win_col = vim.fn.strdisplaywidth(line) - (hidden and #hidden or 0),
        hl_mode = "combine",
      })
    end,
  })
end

M.init()

return M
