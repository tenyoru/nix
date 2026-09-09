local indentscope = require("mini.indentscope")

indentscope.setup({
  -- quadruple-dash is thinner and broken up vs a solid │
  symbol = "┊",
  draw = { animation = indentscope.gen_animation.none() },
  options = { try_as_border = true },
})

local function mute()
  vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { link = "Comment" })
end
mute()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("indentscope_hl", { clear = true }),
  callback = mute,
})

-- these buffers are either not indented code or already draw their own
-- structure, where a scope line is just noise
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("indentscope_disable", { clear = true }),
  pattern = { "help", "man", "oil", "qf", "checkhealth" },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})
