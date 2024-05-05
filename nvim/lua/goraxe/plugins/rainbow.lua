-- lua/plugins/rainbow.lua
return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      -- This module contains a number of default definitions
      local rainbow_delimiters = require("rainbow-delimiters")

      ---@type rainbow_delimiters.config
      vim.g.rainbow_delimiters = {
         -- try typing in here
      }
    end,
  },
}
