local function augroup(name)
  return vim.api.nvim_create_augroup( name, { clear = true })
end

local function hide_statusline()
  vim.api.nvim_set_hl(0, "StatusLine", { link = "Normal" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { link = "Normal" })
end
hide_statusline()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup("statusline_hide"),
  callback = hide_statusline,
})

local notebook_ns = vim.api.nvim_create_namespace("notebook_lines")

local function notebook_hl()
  local bg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg or 0x161310
  local r, g, b = math.floor(bg / 65536) % 256, math.floor(bg / 256) % 256, bg % 256
  -- step away from the background, so the rule darkens on paper and lightens
  -- on a dark scheme instead of clipping to white
  local step = (0.299 * r + 0.587 * g + 0.114 * b) > 128 and -22 or 14
  vim.api.nvim_set_hl(0, "NotebookRule", {
    underline = true,
    sp = string.format(
      "#%02x%02x%02x",
      math.max(0, math.min(255, r + step)),
      math.max(0, math.min(255, g + step)),
      math.max(0, math.min(255, b + step))
    ),
  })
end
notebook_hl()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup("notebook_lines"),
  callback = notebook_hl,
})

vim.api.nvim_set_decoration_provider(notebook_ns, {
  on_win = function(_, win, buf)
    local bt = vim.bo[buf].buftype
    if bt == "terminal" or bt == "prompt" or bt == "quickfix" then
      return false
    end
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      return false
    end
    return true
  end,
  on_line = function(_, win, buf, row)
    local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
    if line ~= "" then
      vim.api.nvim_buf_set_extmark(buf, notebook_ns, row, 0, {
        ephemeral = true,
        end_col = #line,
        hl_group = "NotebookRule",
        hl_mode = "combine",
      })
    end
    -- overlay lands exactly at the end of the text, but conceal (oil) makes
    -- strdisplaywidth over-count and pushes it too far right; eol is always
    -- placed correctly yet nvim inserts one unstyled cell before it. Emitting
    -- both means normal buffers get no gap and concealed ones get one cell.
    local width = vim.api.nvim_win_get_width(win)
    local rule = { { string.rep(" ", width), "NotebookRule" } }
    vim.api.nvim_buf_set_extmark(buf, notebook_ns, row, 0, {
      ephemeral = true,
      virt_text = rule,
      virt_text_pos = "eol",
      -- NotebookRule carries no background, so without combine the default
      -- replace mode wipes CursorLine past the end of the text
      hl_mode = "combine",
    })
    -- oil hides a "/123 " id prefix (its syntax/oil.vim conceals `^/\d* `),
    -- which strdisplaywidth still counts; drop it so overlay lands exactly
    local hidden = vim.bo[buf].filetype == "oil" and line:match("^/%d* ") or nil
    vim.api.nvim_buf_set_extmark(buf, notebook_ns, row, 0, {
      ephemeral = true,
      virt_text = rule,
      virt_text_pos = "overlay",
      virt_text_win_col = vim.fn.strdisplaywidth(line) - (hidden and #hidden or 0),
      hl_mode = "combine",
    })
  end,
})

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

    -- zls semantic tokens repaint over the tonsky-style treesitter
    -- highlight overrides in plugins/treesitter.lua; disable them so
    -- those overrides are actually visible
    if client and client.name == 'zls' then
      client.server_capabilities.semanticTokensProvider = nil
    end

    -- Native LSP completion (used instead of blink)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { --[[ autotrigger = true ]] })
    end

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
