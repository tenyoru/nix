-- Set BASH_ENV so bash auto-sources dv.sh
-- vim.env.BASH_ENV = vim.fn.expand("~/.notes/99 - Obsidian/dv.sh")

require("sniprun").setup({
  display = {
    "Terminal",
  },
  display_options = {
    terminal_scrollback = 100,
    terminal_width = 45,
    terminal_position = "vertical",
    terminal_close_on_quit = false,  -- Отключить авто-закрытие
  },
  show_no_output = {
    "NvimNotify",
  },
})
