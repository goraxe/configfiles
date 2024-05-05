return {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim', "nvim-web-devicons" },
    keys = {
        { '<leader>ff',
            function() 
                local builtin = require('telescope.builtin')
                builtin.find_files {} 
            end, desc = "find files"
        },
        { '<leader>fr',
            function() 
                local builtin = require('telescope.builtin')
                builtin.live_grep{} 
            end, desc = "live grep"
        },
        { '<leader>fb',
            function() 
                local builtin = require('telescope.builtin')
                builtin.buffers{} 
            end, desc = "find buffers"
        },
        { '<leader>fd',
            function() 
                local builtin = require('telescope.builtin')
                builtin.diagnostics{}
            end, desc = "find diagnostics"
        },
        { '<leader>t',":Telescope", desc = "open telescope"
        }
    }
}
