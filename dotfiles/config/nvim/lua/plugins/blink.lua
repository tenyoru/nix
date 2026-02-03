require('blink.cmp').setup({
  -- Use Rust fuzzy matcher
  fuzzy = {
    implementation = "prefer_rust",
  },

  -- Appearance
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono',
  },

  -- Sources
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      lsp = {
        name = 'LSP',
        module = 'blink.cmp.sources.lsp',
      },
      path = {
        name = 'Path',
        module = 'blink.cmp.sources.path',
      },
      snippets = {
        opts = {
          search_paths = {
            vim.fn.stdpath("config") .. "/snippets",
            vim.fn.expand("~/.notes/99 - Obsidian/templates"),
          },
        },
      },
      buffer = {
        name = 'Buffer',
        module = 'blink.cmp.sources.buffer',
      },
    },
  },

  -- Completion behavior
  completion = {
    accept = {
      auto_brackets = {
        enabled = true,
      },
    },
    menu = {
      draw = {
        treesitter = { 'lsp' },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
    ghost_text = {
      enabled = false,
    },
  },

  -- Keymaps
  keymap = {
    preset = 'default',
    ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<CR>'] = { 'accept', 'fallback' },
    ['<C-e>'] = { 'hide', 'fallback' },
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<C-p>'] = { 'select_prev', 'fallback' },
    ['<C-n>'] = { 'select_next', 'fallback' },
    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
  },

  -- Signature help
  signature = {
    enabled = true,
  },
})
