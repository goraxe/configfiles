---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
}

M.telescope = {
  n = {
    ["<leader>ft"] = { "<cmd> Telescope <CR> ", "Open Telescope" },
  }
}

-- more keybinds!

return M
