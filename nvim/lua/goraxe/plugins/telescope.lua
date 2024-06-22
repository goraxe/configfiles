return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.7',
    dependencies = {
        'nvim-lua/plenary.nvim',
        "nvim-web-devicons",
        "nvim-telescope/telescope-symbols.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = {
        {
            '<leader>ff',
            function()
                local builtin = require('telescope.builtin')
                builtin.find_files {}
            end,
            desc = "find files"
        },
        {
            '<leader>fr',
            function()
                local builtin = require('telescope.builtin')
                builtin.live_grep {}
            end,
            desc = "live grep"
        },
        {
            '<leader>fb',
            function()
                local builtin = require('telescope.builtin')
                builtin.buffers {}
            end,
            desc = "find buffers"
        },
        {
            '<leader>fd',
            function()
                local builtin = require('telescope.builtin')
                builtin.diagnostics {}
            end,
            desc = "find diagnostics"
        },
        {
            '<leader>fh',
            function()
                local builtin = require('telescope.builtin')
                builtin.help_tags {}
            end,
            desc = "find help tags"
        },
        { '<leader>t', ":Telescope<Cr>", desc = "open telescope"
        }
    },
    opts = {
        defaults = {
            color_devicons = true,
        },
        extensions = {
            "telescope-symbols",
            file_browser = { }
        }
    }

}
