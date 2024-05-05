return {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    config = function(_, opts)
        require("nvim-tree").setup(opts)
    end,
    opts = {
        hijack_unnamed_buffer_when_opening = true,
        git = {
            enable = true,
        },

        renderer = {
            highlight_git = true,
            icons = {
                show = {
                    git = true,
                },
            },
        },
    },
    ft = "NvimTree",
    keys = {
        { "<leader>n", "<cmd>:NvimTreeToggle<cr>", desc = "Open NvimTree" }, 
        { "<leader>nf", "<cmd>:NvimTreeFocus<cr>", desc = "Focus NvimTree" }, 
    },
}
