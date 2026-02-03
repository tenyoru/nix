local o = vim.opt
local g = vim.g

-- Global options
g.mapleader = " "
g.nord_underline = 1
g.netrw_banner = 0

-- Set options
-- o.clipboard = "unnamedplus"
o.cmdheight = 0
o.winborder = 'shadow'
o.autocomplete = false
o.completeopt = { "menu", "menuone", "noselect" }
o.laststatus = 3
o.list = true
o.exrc = true -- auto-load .nvim.lua from project directory
vim.o.secure = false -- disable trust checking
-- o.background = "light"

o.listchars = {
  lead = " ",
  tab = "> ",
  trail = "-",
  eol = " ",
}

o.conceallevel = 2
o.concealcursor = 'nc'
o.number = true
o.relativenumber = true
o.signcolumn = "no"
o.cursorline = true
o.guicursor = "n:block,i-ci-c:ver25,r-v-cr:hor50,a:blinkon0"
o.pumblend = 15
o.winblend = 5
o.pumheight = 10

o.fillchars = {
  foldopen = "",
  foldclose = "",
  diff = "/",
  eob = " ",
}

o.termguicolors = true
o.spelllang = { "en", "ru", "fr" }
o.spelloptions = "camel"
o.spell = true
o.fileencoding = "utf-8"
o.confirm = false

o.wrap = true
o.tabstop = 2
o.shiftwidth = 0
o.numberwidth = 3
o.softtabstop = -1
o.expandtab = true
o.autoindent = false
o.hlsearch = false
o.showmatch = true
o.mouse = ""
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
o.breakindent = true
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
