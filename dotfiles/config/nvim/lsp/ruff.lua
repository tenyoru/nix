return {
  cmd = { "uv", "run", "ruff", "server" },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', 'setup.py', '.git' },
  init_options = {
    settings = {
      -- Ruff language server settings go here
    }
  }
}
