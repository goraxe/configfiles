-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- provided by rust-analyzer.
-- vim.g.lazyvim_rust_diagnostics = "bacon-ls"
--
-- Set to false to disable auto format
vim.g.lazyvim_eslint_auto_format = true

vim.g.lazyvim_rust_diagnostics = "bacon-ls"
vim.print("options included")
