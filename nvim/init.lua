local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

if vim.env['NVIM_DIST'] == "LazyVim" then
    vim.opt.rtp:prepend(vim.fn.stdpath("config") .. "/LazyVim")
    require("config.lazy")
else
    require("goraxe")

    require("lazy").setup({
       {
           "sainnhe/edge",
           priority = 1000,
           config = function ()
               vim.cmd 'colorscheme edge'
           end
       },
      { "folke/neoconf.nvim",
        cmd = "Neoconf",
        priority = 1000,
        lazy = false,
        config = function(_, opts)
                require("neoconf").setup(opts)
        end
      },
      { "folke/lazydev.nvim" },
      {{import = "goraxe.plugins"}},
      { dir = "~/.config/nvim/lua/goraxe/lsp"},
    })

end
