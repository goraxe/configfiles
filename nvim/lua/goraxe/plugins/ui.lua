local M = {
    {
        'brenoprata10/nvim-highlight-colors',
        opts = {
            ---Render style
            ---@usage 'background'|'foreground'|'virtual'
            render = 'virtual',

            ---Set virtual symbol (requires render to be set to 'virtual')
            virtual_symbol = '■',

            ---Set virtual symbol suffix (defaults to '')
            virtual_symbol_prefix = '',

            ---Set virtual symbol suffix (defaults to ' ')
            virtual_symbol_suffix = ' ',

            ---Set virtual symbol position()
            ---@usage 'inline'|'eol'|'eow'
            ---inline mimics VS Code style
            ---eol stands for `end of column` - Recommended to set `virtual_symbol_suffix = ''` when used.
            ---eow stands for `end of word` - Recommended to set `virtual_symbol_prefix = ' ' and virtual_symbol_suffix = ''` when used.
            virtual_symbol_position = 'inline',

            ---Highlight hex colors, e.g. '#FFFFFF'
            enable_hex = true,

            ---Highlight short hex colors e.g. '#fff'
            enable_short_hex = true,

            ---Highlight rgb colors, e.g. 'rgb(0 0 0)'
            enable_rgb = true,

            ---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
            enable_hsl = true,

            ---Highlight CSS variables, e.g. 'var(--testing-color)'
            enable_var_usage = true,

            ---Highlight named colors, e.g. 'green'
            enable_named_colors = true,

            ---Highlight tailwind colors, e.g. 'bg-blue-500'
            enable_tailwind = true,

            ---Set custom colors
            ---Label must be properly escaped with '%' to adhere to `string.gmatch`
            --- :help string.gmatch
            custom_colors = {
                { label = '%-%-theme%-primary%-color',   color = '#0f1219' },
                { label = '%-%-theme%-secondary%-color', color = '#5a5d64' },
            },

            -- Exclude filetypes or buftypes from highlighting e.g. 'exclude_buftypes = {'text'}'
            exclude_filetypes = {},
            exclude_buftypes = {}
        },
        setup = function(_, opts)
            require('nvim-highlight-colors').setup(opts)
        end,
        event = 'VeryLazy',
    },
    {
        'echasnovski/mini.indentscope',
        version = '*',
        setup = function(opts)
            print(vim.inspect(opts))
            require('mini.indentscope').setup(opts)
        end,
        opts = {
            -- Draw options
            draw = {
                -- Delay (in ms) between event and start of drawing scope indicator
                delay = 50,

                -- Animation rule for scope's first drawing. A function which, given
                -- next and total step numbers, returns wait time (in ms). See
                -- |MiniIndentscope.gen_animation| for builtin options. To disable
                -- animation, use `require('mini.indentscope').gen_animation.none()`.
                --animation = --<function: implements constant 20ms between steps>,

                -- Symbol priority. Increase to display on top of more symbols.
                priority = 2,
            },

            -- Module mappings. Use `''` (empty string) to disable one.
            mappings = {
                -- Textobjects
                object_scope = 'ii',
                object_scope_with_border = 'ai',

                -- Motions (jump to respective border line; if not present - body line)
                goto_top = '[i',
                goto_bottom = ']i',
            },

            -- Options which control scope computation
            options = {
                -- Type of scope's border: which line(s) with smaller indent to
                -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
                border = 'both',

                -- Whether to use cursor column when computing reference indent.
                -- Useful to see incremental scopes with horizontal cursor movements.
                indent_at_cursor = true,

                -- Whether to first check input line to be a border of adjacent scope.
                -- Use it if you want to place cursor on function header to get scope of
                -- its body.
                try_as_border = false,
            },

            -- Which character to use for drawing scope indicator
            symbol = '│',
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        opts = {
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = { show_start = true, show_end = true },
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
            },
        },
        main = "ibl",
    }
}

return M
