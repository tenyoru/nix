local ks = vim.keymap.set

local function send_to_claude(use_tmux)
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local code = table.concat(lines, "\n")

  local file = vim.fn.expand("%:.")
  local ft = vim.bo.filetype

  local text = string.format("%s:%d-%d\n```%s\n%s\n```", file, start_line, end_line, ft, code)

  if use_tmux then
    local panes = vim.fn.systemlist("tmux list-panes -a -F '#{pane_id}:#{pane_current_command}'")
    local target
    for _, pane in ipairs(panes) do
      if pane:match("claude") or pane:match("node") then
        target = pane:match("^(%%[^:]+)")
        break
      end
    end
    if target then
      vim.fn.system("tmux load-buffer -", text)
      vim.fn.system("tmux paste-buffer -t " .. target)
    else
      vim.notify("Claude Code pane not found", vim.log.levels.WARN)
    end
  else
    vim.fn.setreg("+", text)
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

local function closeTab()
    local current = vim.fn.tabpagenr()
    local total = vim.fn.tabpagenr('$')

    if total == 1 then
      vim.notify("Cannot close the tab, you have only one tab", vim.log.levels.WARN)
      return
    end

    vim.cmd("tabc")
    if current > 1 then
      vim.cmd("tabp")
    end
end

local km = {
  -- Buffer management
  {"n", "<leader>qq", "<cmd>w | bd<cr>", { desc = "Write and close buffer" }},
  {"n", "<leader>qz", "<cmd>bd<cr>", { desc = "Close buffer without saving" }},
  {"n", "<leader>bn", "<cmd>bn<cr>", { desc = "Next buffer" }},
  {"n", "<leader>bN", "<cmd>bp<cr>", { desc = "Previous buffer" }},

  -- Insert mode word navigation
  {"i", "<C-l>", "<S-Right>"},
  {"i", "<C-h>", "<S-Left>"},

  -- Delete without yanking
  {{"n", "v"}, "<leader>d", [["_d]]},
  {{"n", "v"}, "<M-d>d", [["_d]], { desc = "Delete without yanking" }},
  {"n", "<M-D>d", [["_dd]], { desc = "Delete line without yanking" }},

  -- Diagnostics
  {"n", "[d", function()
                vim.diagnostic.goto_next()
                vim.diagnostic.open_float()
              end},
  {"n", "]d", function()
                vim.diagnostic.goto_prev()
                vim.diagnostic.open_float()
              end},
  {"n", "J", vim.diagnostic.open_float},
  {"n", "<leader>df", vim.diagnostic.open_float, { desc = "Show diagnostic message in float" }},

  -- LSP
  {"n", "gd", function() vim.lsp.buf.definition() end},
  {"n", "<leader>au", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, { desc = "Toggle LSP inlay hints" }},

  -- Tabs
  {"n", "<leader>tc", closeTab},
  {"n", "<leader>t-", "<cmd>-tabmove<cr>"},
  {"n", "<leader>t+", "<cmd>+tabmove<cr>"},
  {"n", "<leader>ts", "<cmd>tab split<cr>"},

  -- Spell
  {"n", "z=", "<cmd>FzfLua spell_suggest<cr>"},

  -- FzfLua
  {"n", "<leader>ff", "<cmd>FzfLua files<cr>"},
  {"n", "<leader>fg", "<cmd>FzfLua live_grep<cr>"},
  {"n", "<leader>fb", "<cmd>FzfLua buffers<cr>"},
  {"n", "<leader>fq", "<cmd>FzfLua quickfix<cr>"},
  {"n", "<leader>fc", "<cmd>FzfLua cgrep_curbuf<cr>"},
  {"n", "<leader>fo", "<cmd>FzfLua oldfiles<cr>"},
  {"n", "<leader>fz", "<cmd>FzfLua<cr>"},
  {"n", "<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>"},
  {"n", "<leader>sr", "<cmd>FzfLua lsp_references<cr>"},
  {"n", "<leader>sd", "<cmd>FzfLua lsp_workspace_diagnostics<cr>"},
  {"n", "<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>"},

  -- Substitute
  {"n", "<leader>as", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
    desc = "Substitute word under cursor (global, case-insensitive)"
  }},

  -- Indent
  {"v", "<", "<gv", { desc = "Indent left and reselect" }},
  {"v", ">", ">gv", { desc = "Indent right and reselect" }},
  {"n", "<", "<<", { desc = "Indent line left" }},
  {"n", ">", ">>", { desc = "Indent line right" }},

  -- Terminal
  {"t", "<C-\\>n", "<C-\\><C-n>", { desc = "Exit terminal mode" }},
  {"n", "<leader>tt", function() require("plugins.terminal").toggle_split() end, { desc = "Toggle terminal (split)" }},
  {"n", "<leader>tf", function() require("plugins.terminal").toggle_float() end, { desc = "Toggle terminal (float)" }},

  -- Quickfix/Location list
  {"n", "<leader>mk", "<cmd>lnext<CR>zz", { desc = "Next location list item" }},
  {"n", "<leader>mj", "<cmd>lprev<CR>zz", { desc = "Previous location list item" }},

  -- Clipboard
  {{"n", "v"}, "<leader>p", [["+p]], { desc = "Paste from system clipboard" }},
  {{"n", "v"}, "<leader>y", [["+y]], { desc = "Yank to system clipboard" }},
  {"n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" }},

  -- Navigation (visual lines)
  {{'n', 'v'}, 'j', "v:count == 0 ? 'gj' : 'j'", {expr = true}},
  {{'n', 'v'}, 'k', "v:count == 0 ? 'gk' : 'k'", {expr = true}},

  -- File explorer
  {"n", "<leader>fe", "<cmd>Oil<cr>", {desc = "Open file explorer"}},
  {"n", "<leader>fd", function()
    require("fzf-lua").fzf_exec("fd --type d", {
      prompt = "Folders> ",
      actions = {
        ["default"] = function(selected)
          require("oil").open(selected[1])
        end
      }
    })
  end
  },


  -- Misc
  {{"n", "v", "i"}, '<D-SPACE>', ''},
  {"i", "<C-d>", "<C-k>", { desc = "Digraph" }},

  -- Send to Claude Code
  {"v", "<leader>a", function() send_to_claude(false) end, { desc = "Copy selection for Claude Code" }},
  -- {"v", "<leader>A", function() send_to_claude(true) end, { desc = "Send selection to Claude Code (tmux)" }},
}

vim.schedule(function()
    for _, mapping in ipairs(km) do
        local num_elements = #mapping

        if num_elements < 3 or num_elements > 4 then
            print("Invalid bind format:", vim.inspect(mapping))
            goto continue
        end

        local mode = mapping[1]
        local keys = mapping[2]
        local command = mapping[3]
        local opts = num_elements == 4 and mapping[4] or { noremap = true, silent = true }
        vim.keymap.set(mode, keys, command, opts)

        ::continue::
    end
end)
