local function augroup(name)
  return vim.api.nvim_create_augroup( name, { clear = true })
end

-- highlighting copied text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup("YankHighlight"),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

-- remove extra spaces
vim.api.nvim_create_autocmd({"BufWritePre"}, {
    group = augroup('remove_extra_spaces'),
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.cmd [[autocmd BufEnter * set fo-=c fo-=r fo-=o]]

vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("terminal_settings"),
  pattern = "*",
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"

    -- Double escape to exit terminal mode
    local esc_timer = nil
    vim.keymap.set("t", "<esc>", function()
      if esc_timer then
        esc_timer:stop()
        esc_timer:close()
        esc_timer = nil
        vim.cmd("stopinsert")
      else
        esc_timer = vim.uv.new_timer()
        esc_timer:start(200, 0, function()
          esc_timer:close()
          esc_timer = nil
        end)
        return "<esc>"
      end
    end, { expr = true, buffer = true, desc = "Double escape to normal mode" })
  end,
})

-- LSP Attach autocmd
vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup("lsp_attach"),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- Disable LSP highlighting
    -- if client then
    --   client.server_capabilities.semanticTokensProvider = nil
    -- end

    -- Native LSP completion (you can use it instead of blink)
    -- vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

    -- Tinymist-specific setup
    if client.name == 'tinymist' then
      vim.api.nvim_create_user_command("OpenPdf", function()
        local filepath = vim.api.nvim_buf_get_name(0)
        if not filepath:match("%.typ$") then return end

        local pdf_path = filepath:gsub("%.typ$", ".pdf")

        if vim.fn.executable("zathura") == 1 then
          vim.system({ "zathura", pdf_path }, { detach = true })
        else
          vim.notify("Zathura not found in PATH.", vim.log.levels.ERROR)
        end
      end, { desc = "Open compiled PDF in Zathura" })

      -- Pin current file as main
      vim.keymap.set("n", "<leader>tp", function()
        client:exec_cmd({
          title = "pin",
          command = "tinymist.pinMain",
          arguments = { vim.api.nvim_buf_get_name(0) },
        }, { bufnr = ev.buf })
      end, { desc = "[T]inymist [P]in", noremap = true, buffer = ev.buf })

      -- Unpin
      vim.keymap.set("n", "<leader>tu", function()
        client:exec_cmd({
          title = "unpin",
          command = "tinymist.pinMain",
          arguments = { vim.v.null },
        }, { bufnr = ev.buf })
      end, { desc = "[T]inymist [U]npin", noremap = true, buffer = ev.buf })
    end
  end,
})
