return {
    'akinsho/bufferline.nvim', 
    -- version = "*", 
    branch ='main',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function(_, opts) 
        require("bufferline").setup(opts)
    end,
    event = "VeryLazy",
    opts = {
        options = {

            diagnostics_indicator = function(count, level, diagnostics_dict, context)
                local icon = level:match("error") and " " or " "
                return " " .. icon .. count
            end
        }
    }
}
