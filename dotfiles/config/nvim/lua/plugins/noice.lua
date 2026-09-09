require("noice").setup({
  views = {
    cmdline_popup = {
      position = { row = "50%", col = "50%" },
      size = { width = 60, height = "auto" },
      border = {
        style = "rounded",
        padding = { 0, 1 },
        text = { top = "" },
      },
      win_options = {
        winhighlight = {
          Normal = "Normal",
          FloatBorder = "Comment",
          FloatTitle = "Comment",
        },
      },
    },
  },
  routes = {
    { filter = { event = "notify" }, view = "mini" },
    { filter = { event = "msg_show", kind = "" }, view = "mini" },
  },
})

local function paper_hl()
  for _, g in ipairs({
    "NoiceCmdlinePopup",
    "NoiceCmdlinePopupBorder",
    "NoiceCmdlinePopupTitle",
    "NoiceCmdlineIcon",
    "NoiceCmdlinePopupBorderSearch",
    "NoiceCmdlineIconSearch",
  }) do
    vim.api.nvim_set_hl(0, g, { link = "Comment" })
  end
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { link = "Normal" })
end
paper_hl()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("noice_paper", { clear = true }),
  callback = paper_hl,
})
