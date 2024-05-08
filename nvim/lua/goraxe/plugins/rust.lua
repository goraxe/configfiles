local M = {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    lazy = false, -- This plugin is already lazy
}


vim.g.rustaceanvim = {

    server = {
        default_settings = {
            ['rust-analyzer'] = {
                cargo = {
                    extraEnv = {
                        RUSTFLAGS="-Cinstrument-coverage"
                    }
                }
            }
        }
    }
}

return M
