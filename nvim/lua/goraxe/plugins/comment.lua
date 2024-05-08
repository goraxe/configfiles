return {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o", "v" }, desc = "Comment toggle blockwise" },
      { "<leader>/", mode = { "n", "o", "v" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
-- FIXME TODO correct this  
--    init = function()
--      require("core.utils").load_mappings "comment"
   -- end,
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  }
