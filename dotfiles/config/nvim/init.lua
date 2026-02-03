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

