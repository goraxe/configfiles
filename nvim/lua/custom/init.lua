-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
vim.api.nvim_create_autocmd("VimResized", {
 pattern = "*",
 command = "tabdo wincmd =",
})


vim.api.nvim_set_option("relativenumber", true)
vim.api.nvim_set_option("foldmethod", "expr" )
vim.api.nvim_set_option("foldexpr", "nvim_treesitter#foldexpr" )
vim.api.nvim_set_option("foldenable",false)
