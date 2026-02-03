local M = {}

M.opts = {
  num = true,
  modified = true,
}

function M.get_buf(n)
  local winnr = vim.fn.tabpagewinnr(n)
  local buflist = vim.fn.tabpagebuflist(n)
  return buflist[winnr]
end

function M.get_label(buf)
  local filename = vim.fn.bufname(buf)
  return filename == '' and '[No Name]' or vim.fn.fnamemodify(filename, ':t')
end

function M.tabline()
  local s = ''
  for i = 1, vim.fn.tabpagenr('$') do
    local buf = M.get_buf(i)

    if i == vim.fn.tabpagenr() then
      s = s .. '%#TabLineSel#'
    else
      s = s .. '%#TabLine#'
    end

    -- Set tab page number (for mouse clicks)
    s = s .. '%' .. i .. 'T'

    s = s .. ' '

    if M.opts.num == true then
      s = s ..  i .. ':'
    end

    s = s ..  M.get_label(buf)

    if M.opts.modified == true then
      s = s .. (vim.bo[buf].modified and '+' or ' ')
    else
      s = s .. ' '
    end
  end

  -- After the last tab, fill with TabLineFill and reset the tab page number
  s = s .. '%#TabLineFill#%T'

  return s
end

function M.init()

  _G.my_tabline = M.tabline

  vim.o.tabline = "%!v:lua.my_tabline()"
end

M.init()
