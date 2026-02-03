return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
  settings = {
    ['rust-analyzer'] = {
      procMacro = { enable = true },
      cargo = { allFeatures = true },
      rustfmt = {
        extraArgs = { "+nightly" },
      },
      checkOnSave = {
        command = "clippy",
        extraArgs = { "--no-deps" },
      },
    }
  }
}
