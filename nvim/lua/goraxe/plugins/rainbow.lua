-- lua/plugins/rainbow.lua
return {
  ---@type LazyPlugin
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      -- This module contains a number of default definitions
      local rainbow_delimiters = require("rainbow-delimiters")

      ---@type rainbow_delimiters.config
      vim.g.rainbow_delimiters = {
         whitelist = { 'lua', 'luadoc', 'go', 'rust', 'toml', 'vim', 'tsx', 'typescript', 'terraform', 'bash', 'c' }
         -- try typing in here
      }
      local wk = require("which-key")
      local keys = {
      r = {
          name = "Rainbow",
          t = { function () 
                  local buf_nr = vim.api.nvim_get_current_buf()
                  rainbow_delimiters.toggle(buf_nr)
              end, "Toggle" },
          e = { function () 
                  local buf_nr = vim.api.nvim_get_current_buf()
                  rainbow_delimiters.enable(buf_nr)
              end, "Enable" },
          d = { function () rainbow_delimiters.disable(buf_nr) end, "Disable" },
      }
      }

      wk.register(keys, { prefix = "<leader>",  mode = "n" })
      wk.register(keys, { prefix = "<leader>",  mode = "v" })

    end,
  },
}
