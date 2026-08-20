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

-- Minimal Zig highlighting (tonsky.me/blog/syntax-highlighting): only
-- comments, literals/constants, and declaration sites get an accent color;
-- keywords, type/function references, and punctuation stay plain text.
-- Strings/numbers/booleans/constants are left alone, base16 already keeps
-- those to a couple of restrained colors.
local zig_hl_links = {
  ["@keyword.zig"] = "Normal",
  ["@keyword.type.zig"] = "Normal",
  ["@keyword.coroutine.zig"] = "Normal",
  ["@keyword.function.zig"] = "Normal",
  ["@keyword.operator.zig"] = "Normal",
  ["@keyword.return.zig"] = "Normal",
  ["@keyword.conditional.zig"] = "Normal",
  ["@keyword.repeat.zig"] = "Normal",
  ["@keyword.import.zig"] = "Normal",
  ["@keyword.exception.zig"] = "Normal",
  ["@keyword.modifier.zig"] = "Normal",
  ["@type.zig"] = "Normal",
  ["@type.builtin.zig"] = "Normal",
  ["@function.zig"] = "Title",
  ["@function.call.zig"] = "Normal",
  ["@function.builtin.zig"] = "Normal",
  ["@variable.zig"] = "Normal",
  ["@variable.builtin.zig"] = "Normal",
  ["@type.definition.zig"] = "Title",
  ["@punctuation.bracket.zig"] = "Comment",
  ["@punctuation.delimiter.zig"] = "Comment",
  ["@operator.zig"] = "Normal",
}

local function apply_zig_hl()
  for group, target in pairs(zig_hl_links) do
    vim.api.nvim_set_hl(0, group, { link = target })
  end
end

-- matugen.setup() runs `:syntax reset` after plugins load, wiping any
-- highlights set here; ColorScheme never fires since it's called directly
-- rather than via `:colorscheme`, so reapply on FileType instead, which
-- always runs after startup's `:syntax reset` has already happened.
vim.api.nvim_create_autocmd("FileType", { pattern = "zig", callback = apply_zig_hl })
