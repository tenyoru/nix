-- column width in characters; side paddles fill the rest, like a max-width
-- page. change `width` to whatever N you want.
local data = vim.fn.stdpath("data")
require("no-neck-pain").setup({
  width = 80,
  autocmds = { enableOnVimEnter = true, reloadOnColorSchemeChange = true },
  buffers = {
    scratchPad = { enabled = true },
    left = { scratchPad = { pathToFile = data .. "/nnp-left.md" } },
    right = { scratchPad = { pathToFile = data .. "/nnp-right.md" } },
    bo = {
      -- not "no-neck-pain": the plugin rewrites that (and empty) to "norg"
      filetype = "nnp-pad",
      buflisted = false,
    },
    wo = {
      number = false,
      relativenumber = false,
      cursorline = false,
      statuscolumn = "",
      signcolumn = "no",
    },
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "nnp-pad",
  callback = function()
    vim.bo.modifiable = true
  end,
})

-- :close on help/qf lands on the next win, which is an nnp pad
vim.api.nvim_create_autocmd("WinClosed", {
  callback = function()
    vim.schedule(function()
      if vim.bo.filetype ~= "nnp-pad" then
        return
      end
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype ~= "nnp-pad" and vim.api.nvim_win_get_config(win).relative == "" then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
    end)
  end,
})
