if vim.fn.has('nvim-0.12') == 0 then
  vim.api.nvim_echo({
    {
      "You need Neovim 0.12 or higher!\n",
      "ErrorMsg",
    },
    { "Press any key to exit", "MoreMsg" },
  }, true, {})

  vim.fn.getchar()
  vim.cmd([[quit]])
end

-- Completion options
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Diagnostic config
vim.diagnostic.config({
  virtual_text = { current_line = true }
})

for _, m in ipairs({ "options", "keymaps", "autocmds", "disable" }) do
  require("config." .. m)
end
require("plugins")

-- flip to false to go back to paper
local use_matugen = false

local function paper()
  vim.cmd([[colorscheme base16-gruvbox-light-soft]])
  -- colorscheme runs hi clear; re-apply after in case ColorScheme autocmds
  -- already ran against the previous (or default) palette
  pcall(vim.api.nvim_exec_autocmds, "ColorScheme", { modeline = false })
end

local function apply_matugen()
  require("matugen").setup()
  pcall(vim.api.nvim_exec_autocmds, "ColorScheme", { modeline = false })
end

if use_matugen then
  apply_matugen()
else
  paper()
end

-- noctalia's neovim template appends require('matugen') and SIGUSR1 on
-- wallpaper change. VimEnter runs after that append: drop their signal
-- handler and put paper back unless we're trying matugen.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    if use_matugen then
      apply_matugen()
      return
    end
    if _G.__matugen_signal then
      pcall(function()
        _G.__matugen_signal:stop()
        _G.__matugen_signal:close()
      end)
      _G.__matugen_signal = nil
    end
    paper()
  end,
})

vim.lsp.enable({
  "basedpyright",
  "clangd",
  "gopls",
  "lua-ls",
  "markdown_oxide",
  "pyright",
  "ruff",
  "rust_analyzer",
  "texlab",
  "tinymist",
  "zls",
})
