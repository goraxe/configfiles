return {
    {
        ["f"] = {
            name = "file",
            s = {"<cmd>w<cr>", "save"},
        },
        ["l"] = {
            name = "lazy",
            l = { "<cmd>Lazy<cr>", "Open Lazy" },
            i = { "<cmd>Lazy install<cr>", "Open Lazy" },
            a = { "<cmd>LspRestart<cr>", "Restart LSPs"},
            r = { "<cmd>LspRestart<tab>", "Restart LSPs"}
        },
        ["c"] = {
            name = "code",
            a = { function() vim.lsp.buf.code_action() end, "Code Actions" },
            d = { function() vim.lsp.buf.definition() end, "Lsp Definition" },
            r = { function() vim.lsp.buf.references() end, "Lsp References" },
            h = { function() vim.lsp.buf.hover() end, "Lsp Hover"},
            f = { function() vim.lsp.buf.format() end, "Lsp format"},
            c = {
                name = "Create",
                t = {"<cmd>GoAddTest<cr>", "test" }
            }
        },
        ["d"] = {
            name = "debug",
            c = { "<cmd>DapContinue<cr>", "Debug continue" },
            i = { "<cmd>DapStepIn<cr>", "Debug Step In"},
            o = { "<cmd>DapStepOver<cr>", "Debug Step Over"},
            O = { "<cmd>DapStepOut<cr>", "Debug Step Out"},
            s = { "<cmd>DapStop<cr>", "Debug Stop"},
            t = { "<cmd>DapUiToggle<cr>", "Debug UI Toggle"},
            f = { "<cmd>DapUiFloat<cr>", "Debug UI Float"}

        },
        ["/"] = {
          function()
            require("Comment.api").toggle.linewise.current()
          end,
          "Toggle comment",
        },
    },
    { prefix = "<leader>" }
}
