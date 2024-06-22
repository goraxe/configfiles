local M = {

    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        config = function(opts)
            require("copilot").setup(opts)
        end,
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
        }
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "zbirenbaum/copilot.lua" },
        setup = function()
            require("copilot_cmp").setup()
        end
    },
    {
        'topaxi/gh-actions.nvim',
        cmd = 'GhActions',
        keys = {
            { '<leader>gh', '<cmd>GhActions<cr>', desc = 'Open Github Actions' },
        },
        -- optional, you can also install and use `yq` instead.
        build = 'make',
        dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
        opts = {},
        config = function(_, opts)
            require('gh-actions').setup(opts)
        end,
    },
}

return M
