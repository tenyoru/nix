local function command_factory(client, bufnr, cmd)
  return client:exec_cmd({
    title = ('Markdown-Oxide-%s'):format(cmd),
    command = 'jump',
    arguments = { cmd },
  }, { bufnr = bufnr })
end
local capabilities = require("blink.cmp").get_lsp_capabilities()

---@type vim.lsp.Config
return {
  root_markers = { '.moxide.toml', '.obsidian', '.git'  },
  filetypes = { 'markdown' },
  cmd = { 'markdown-oxide' },
  capabilities = vim.tbl_deep_extend( "force", capabilities, {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  }),
  on_attach = function(client, bufnr)
    for _, cmd in ipairs({ 'today', 'tomorrow', 'yesterday' }) do
      vim.api.nvim_buf_create_user_command(bufnr, 'Lsp' .. ('%s'):format(cmd:gsub('^%l', string.upper)), function()
        command_factory(client, bufnr, cmd)
      end, {
        desc = ('Open %s daily note'):format(cmd),
      })
    end
  end,
}
