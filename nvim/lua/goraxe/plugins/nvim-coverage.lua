local M = {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- Optional: needed for PHP when using the cobertura parser
    opts = {
        auto_reload = true,
        commands = true,
        highlights = {
           -- customize highlight groups created by the plugin
           covered = { fg = "#C3E88D" }, -- supports style, fg, bg, sp (see :h highlight-gui)
           uncovered = { fg = "#F07178" },
        },
        signs = {
            -- use your own highlight groups or text markers
            covered = { hl = "CoverageCovered", text = "⦚" },
            uncovered = { hl = "CoverageUncovered", text = "⦚" },
            partial = { hl = "CoveragePartial", text = "⦚" },
            priority = 11,
        },
        summary = {
            -- customize the summary pop-up
            min_coverage = 80.0, -- minimum coverage threshold (used for highlighting)
        },
    },
    config = function(_, opts)
        require("coverage").setup(opts)
    end,
}

return M
