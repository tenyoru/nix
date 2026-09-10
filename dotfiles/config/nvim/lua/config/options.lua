local o = vim.opt
local g = vim.g

-- Global options
g.mapleader = " "
g.nord_underline = 1
g.netrw_banner = 0

-- Set options
-- o.clipboard = "unnamedplus"
o.cmdheight = 0
o.winborder = 'single'
o.autocomplete = false
o.completeopt = { "menu", "menuone", "noselect" }
-- 0 keeps the bottom window free of a statusline; the horizontal rules between
-- windows are then the statuslines of the upper ones. Cost: they stop at the
-- window edge, so they cannot join a vertical separator (laststatus=3 can).
o.laststatus = 0
o.statusline = "%=" -- renders nothing; the stl/stlnc fillchars draw the line
o.list = true
o.exrc = true -- auto-load .nvim.lua from project directory
vim.o.secure = false -- disable trust checking
-- o.background = "light"

o.listchars = {
  lead = " ",
  tab = "> ",
  trail = "-",
}

o.conceallevel = 2
o.concealcursor = 'nc'
o.number = true
o.relativenumber = true
o.signcolumn = "no"
o.cursorline = true
-- the -Cursor suffix binds the shape to the Cursor highlight group, which is
-- what lets autocmds.lua recolour it when the buffer has unsaved changes
o.guicursor = "n:block-Cursor,i-ci-c:ver25-Cursor,r-v-cr:hor50-Cursor,a:blinkon0"
o.pumblend = 0
o.winblend = 0
o.pumheight = 10

o.fillchars = {
  foldopen = "",
  foldclose = "",
  diff = "/",
  eob = " ",
  stl = "─",
  stlnc = "─", -- non-current windows draw their rule from this one
  vert = "│",
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
  msgsep = "─",
}

o.termguicolors = true
o.spelllang = { "en", "ru", "fr" }
o.spelloptions = "camel"
o.spell = true
o.fileencoding = "utf-8"
o.confirm = false

o.wrap = true
-- without this, wrapped lines scroll a whole logical line at a time, so one
-- <C-e> or wheel notch can jump six screen rows
o.smoothscroll = true
o.tabstop = 2
o.shiftwidth = 0
o.numberwidth = 3
o.softtabstop = -1
o.expandtab = true
o.autoindent = false
o.hlsearch = false
o.showmatch = true
-- o.mouse = ""
o.splitright = true
o.splitbelow = true
o.splitkeep = "topline"
o.fixeol = false
o.ignorecase = true
o.smartcase = true
o.smartindent = true
o.scrolloff = 10
o.visualbell = false
o.helpheight = 15

o.backup = false
o.backupcopy = "auto"
o.backupdir = ("%s/backup//"):format(vim.fn.stdpath("state"))

o.swapfile = false
o.hidden = true
o.writebackup = true
o.undofile = true
o.undolevels = 100
o.modifiable = true
o.showmode = false
-- 'cursorline' skips the breakindent gap by design (vim-patch 8.2.3295), so a
-- wrapped cursor line shows an unpainted notch before the text. Re-enable on
-- 0.13: neovim#30255 lets an extmark hl_group paint that gap.
o.breakindent = false
o.timeoutlen = 750
o.timeout = false
o.updatetime = 500
o.backupskip:append({ "*/.git/*", "*.gpg" })

-- Remove options
o.complete:remove({ "u", "t" })

o.shortmess = {
  a = true,
  o = true,
  t = true,
  s = true,
  T = true,
  W = true,
  I = true,
  c = true,
  C = true,
  F = true,
  S = true,
}
