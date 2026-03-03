return {

    -- add typescript to treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, { "typescript", "tsx", "vue" })
            end
        end,
    },

    -- correctly setup lspconfig
    {
        "neovim/nvim-lspconfig",
        opts = {
            -- make sure mason installs the server
            servers = {
                ---@type lspconfig.options.ts_ls
                ---@diagnostic disable-next-line: missing-fields
                ts_ls = {
                    init_options = {
                        plugins = {
                            {
                                name = "@vue/typescript-plugin",
                                location = "/home/goraxe/.local/share/pnpm/global/5/node_modules/@vue/typescript-plugin",
                                languages = { "javascript", "typescript", "vue" },
                            }
                        }
                    },
                    filetypes = {
                        'javascript',
                        'javascriptreact',
                        'typescript',
                        'typescriptreact',
                        'vue',
                    },
                    keys = {
                        {
                            "<leader>co",
                            function()
                                vim.lsp.buf.code_action({
                                    apply = true,
                                    context = {
                                        only = { "source.organizeImports.ts" },
                                        diagnostics = {},
                                    },
                                })
                            end,
                            desc = "Organize Imports",
                        },
                        {
                            "<leader>cR",
                            function()
                                vim.lsp.buf.code_action({
                                    apply = true,
                                    context = {
                                        only = { "source.removeUnused.ts" },
                                        diagnostics = {},
                                    },
                                })
                            end,
                            desc = "Remove Unused Imports",
                        },
                    },
                    ---@diagnostic disable-next-line: missing-fields
                    settings = {
                        completions = {
                            completeFunctionCalls = true,
                        },
                    },
                },
            },
        },
    },

    {
        "mfussenegger/nvim-dap",
        optional = true,
        dependencies = {
            {
                "williamboman/mason.nvim",
                opts = function(_, opts)
                    opts.ensure_installed = opts.ensure_installed or {}
                    table.insert(opts.ensure_installed, "js-debug-adapter")
                end,
            },
        },
        opts = function()
            local dap = require("dap")
            if not dap.adapters["pwa-node"] then
                require("dap").adapters["pwa-node"] = {
                    type = "server",
                    host = "localhost",
                    port = "${port}",
                    executable = {
                        command = "node",
                        -- 💀 Make sure to update this path to point to your installation
                        args = {
                            require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                            .. "/js-debug/src/dapDebugServer.js",
                            "${port}",
                        },
                    },
                }
            end
            for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" }) do
                if not dap.configurations[language] then
                    dap.configurations[language] = {
                        {
                            type = "pwa-node",
                            request = "launch",
                            name = "Launch file",
                            program = "${file}",
                            cwd = "${workspaceFolder}",
                        },
                        {
                            type = "pwa-node",
                            request = "attach",
                            name = "Attach",
                            processId = require("dap.utils").pick_process,
                            cwd = "${workspaceFolder}",
                        },
                    }
                end
            end
        end,
    },
}
