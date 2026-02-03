local M = {}

local state = {
  buf = -1,  -- Shared buffer between split and float
  split = {
    win = -1,
  },
  floating = {
    win = -1,
  }
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create a buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- Define window configuration
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

function M.toggle_float()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    -- Close split window if open
    if vim.api.nvim_win_is_valid(state.split.win) then
      vim.api.nvim_win_hide(state.split.win)
      state.split.win = -1
    end

    local result = create_floating_window({ buf = state.buf })
    state.floating.win = result.win
    state.buf = result.buf

    if vim.bo[state.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
      state.buf = vim.api.nvim_get_current_buf()
    end
    vim.cmd('startinsert')
  else
    vim.api.nvim_win_hide(state.floating.win)
    state.floating.win = -1
  end
end

function M.toggle_split()
  -- If terminal window exists and is valid, close it
  if vim.api.nvim_win_is_valid(state.split.win) then
    vim.api.nvim_win_hide(state.split.win)
    state.split.win = -1
    return
  end

  -- Close floating window if open
  if vim.api.nvim_win_is_valid(state.floating.win) then
    vim.api.nvim_win_hide(state.floating.win)
    state.floating.win = -1
  end

  -- If terminal buffer doesn't exist or is invalid, create new one
  if not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
  end

  -- Open terminal in a split
  vim.cmd('botright split')
  state.split.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(state.split.win, state.buf)
  vim.api.nvim_win_set_height(state.split.win, 15)

  -- Start terminal if buffer is empty (first time or terminal was closed)
  if vim.bo[state.buf].buftype ~= "terminal" then
    vim.fn.termopen(vim.o.shell)
  end

  vim.cmd('startinsert')
end

-- Alias for backward compatibility
M.toggle = M.toggle_split

return M
