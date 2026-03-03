-- local wgsl_analyzer = require "lspconfig.configs.wgsl_analyzer"

vim.filetype.add({ extensions = { wesl = "wgsl" } })
vim.lsp.config("wgsl_analyzer", {
  cmd = { "wgsl-analyzer" },
  filetypes = { "wgsl", "wesl" },
  root_markers = { ".git" },
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.wgsl", "*.wesl" },
  callback = function()
    -- vim.lsp.enable("wgsl-analyzer")
    vim.lsp.enable("wgsl_analyzer")
    -- vim.print("setting some stuff")
    vim.bo.filetype = "wgsl"
  end,
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "wgsl_bevy" } },
  },
  -- {
  --   "mason-org/mason.nvim",
  --   opts = { ensure_installed = { "wgsl-analyzer" } },
  -- },

  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        ["wgsl_analyzer"] = {},
        --        ["wgsl-analyzer"] = {},
      },
    },
  },
}
