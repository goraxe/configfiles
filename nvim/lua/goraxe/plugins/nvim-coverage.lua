local M = {
      "andythigpen/nvim-coverage",
  requires = "nvim-lua/plenary.nvim",
  -- Optional: needed for PHP when using the cobertura parser
  config = function()
    require("coverage").setup()
  end,
}

return M
