local plugins = {
  "https://github.com/WTFox/jellybeans.nvim",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/nvim-mini/mini.icons",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/RRethy/base16-nvim",
}

vim.pack.add(plugins)

local p = {
  "fzf",
  "oil",
  "statuscolumn",
  "tabline",
  "treesitter",
  "markdown",
}

for _, plugin in ipairs(p) do
  require("plugins." .. plugin)
end

vim.api.nvim_create_user_command("PackUpdate", function()
  vim.pack.update(nil, { force = true })
end, { desc = "Update all plugins" })
