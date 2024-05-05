



-- disable netrw at the very start of your init.lua
vim.g.scrolloff = 10
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.o.signcolumn = "yes:1"
vim.o.number = true
vim.o.relativenumber = true
vim.g.relativenumber = true
vim.g.list = true
vim.o.list = true
vim.g.listchars = "eol:@,tab:<->,trail:-"
vim.o.listchars = "eol:@,tab:<->,trail:-"
vim.g.expandtab = true
vim.o.expandtab = true
vim.g.shiftwidth = 4
vim.o.shiftwidth = 4
vim.o.tabstop = 8
vim.g.softtabstop = 4
vim.o.softtabstop = 4
vim.b.softtabstop = 4

return {}
