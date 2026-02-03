-- nvim-treesitter setup (new API)
local ts = require("nvim-treesitter")

-- Install parsers
-- ts.install({
--   "bash",
--   "c",
--   "css",
--   "diff",
--   "gitcommit",
--   "go",
--   "html",
--   "json",
--   "lua",
--   "markdown",
--   "markdown_inline",
--   "nix",
--   "python",
--   "regex",
--   "rust",
--   "toml",
--   "typescript",
--   "vim",
--   "vimdoc",
--   "yaml",
--   "zig",
-- })

-- Enable treesitter features
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    -- Try to enable treesitter highlighting
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- Folding with treesitter
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.wo[0][0].foldmethod = "expr"
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldenable = true
    vim.wo[0][0].foldlevel = 99
  end,
})

-- Better markdown concealing with treesitter
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "nc"
  end,
})
