--[[ M = {
    "ray-x/go.nvim",
    dependencies = {  -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
}*/ ]]

M = {
    --[[ {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, {
                "go",
                "gomod",
                "gowork",
                "gosum",
            })
        end,
    }, ]]
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                gopls = {
                    keys = {
                        -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
                        { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
                    },
                    settings = {
                        gopls = {
                            gofumpt = true,
                            codelenses = {
                                gc_details = false,
                                generate = true,
                                regenerate_cgo = true,
                                run_govulncheck = true,
                                test = true,
                                tidy = true,
                                upgrade_dependency = true,
                                vendor = true,
                            },
                            hints = {
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                constantValues = true,
                                functionTypeParameters = true,
                                parameterNames = true,
                                rangeVariableTypes = true,
                            },
                            analyses = {
                                fieldalignment = true,
                                nilness = true,
                                unusedparams = true,
                                unusedwrite = true,
                                useany = true,
                            },
                            usePlaceholders = true,
                            completeUnimported = true,
                            staticcheck = true,
                            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                            semanticTokens = true,
                        },
                    },
                },
            },
            setup = {
                gopls = function(_, opts)
                    -- workaround for gopls not supporting semanticTokensProvider
                    -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
                    require("goraxe.lsp").on_attach(function(client, _)
                        if client.name == "gopls" then
                            if not client.server_capabilities.semanticTokensProvider then
                                local semantic = client.config.capabilities.textDocument.semanticTokens
                                client.server_capabilities.semanticTokensProvider = {
                                    full = true,
                                    legend = {
                                        tokenTypes = semantic.tokenTypes,
                                        tokenModifiers = semantic.tokenModifiers,
                                    },
                                    range = true,
                                }
                            end
                        end
                    end)
                    -- end workaround
                end,
            },
        },
    },
    -- Ensure Go tools are installed
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, { "goimports", "gofumpt" })
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        optional = true,
        dependencies = {
            {
                "williamboman/mason.nvim",
                opts = function(_, opts)
                    opts.ensure_installed = opts.ensure_installed or {}
                    vim.list_extend(opts.ensure_installed, { "gomodifytags", "impl" })
                end,
            },
        },
        opts = function(_, opts)
            local nls = require("null-ls")
            opts.sources = vim.list_extend(opts.sources or {}, {
                nls.builtins.code_actions.gomodifytags,
                nls.builtins.code_actions.impl,
                nls.builtins.formatting.goimports,
                nls.builtins.formatting.gofumpt,
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                go = { "goimports", "gofumpt" },
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
                    vim.list_extend(opts.ensure_installed, { "delve" })
                end,
            },
            {
                "leoluz/nvim-dap-go",
                config = true,
            },
        },
    },
    {
        "goraxe/neotest",
        optional = true,
        dependencies = {
            "nvim-neotest/neotest-go",
        },
        opts = {
            adapters = {
            }
        },
        --[[ opts = function(_, opts)
            opts.adapters = opts.adapters or {}
            local result = vim.list_extend(opts.adapters, {
                "neotest-go",
                ["neotest-go"] = {
                    -- Here we can set options for neotest-go, e.g.
                    -- args = { "-tags=integration" }
                    recursive_run = true,
                },
            })
            return opts 
        end ]]
    },
}


return M
