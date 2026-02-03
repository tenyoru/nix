local plugins = {
  "https://github.com/WTFox/jellybeans.nvim",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/nvim-mini/mini.icons",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/Saghen/blink.cmp",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/michaelb/sniprun",
}

vim.pack.add(plugins)

vim.cmd([[colorscheme jellybeans]])

local p = {
  "oil",
  "statuscolumn",
  "tabline",
  "treesitter",
  "markdown",
  "blink",
  "sniprun",
}

for _, plugin in ipairs(p) do
  require("plugins." .. plugin)
end
