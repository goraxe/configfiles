local M = {
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = {
                ["<leader>t"] = { name = "+test" },
            },
        },
    },
    ---@type LazyPlugin
    {
        "goraxe/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "goraxe/neotest-jest",
        },
        opts = {
            log_level = "trace",
            adapters = {
                ["neotest-jest"] = {

                    jestCommand = "pnpm test --",
                    jest_test_discovery = false,
                    jestConfigFile = "custom.jest.config.ts",
                    env = { CI = true },
                    cwd = function(path)
                        -- vim.print("getting cwd " .. path .. " returning " .. vim.fn.getcwd())
                        -- find a package.json
                        vim.print(vim.inspect(vim.fn.globpath(path, "**/package.json")))


                        return vim.fn.getcwd()
                    end,
                },
                ["neotest-go"] = {
                    recursive_run = true,
                    experimental = {
                        test_table = false,
                    },
                },
            },
            status = { virtual_text = true },
            output = { open_on_run = true },
            quickfix = { open = function() require("trouble").open({ mode = "quickfix", focus = false }) end },
        },
        config = function(_, opts)
            local neotest_ns = vim.api.nvim_create_namespace("neotest")
            vim.diagnostic.config({
                virtual_text = { prefix = " " },
                format = function(diagnostic)
                    local message = diagnostic.message:gsub("\n", ""):gusb("\t", " "):gusb("^%s+", "")
                    return message
                end,

            }, neotest_ns)
            opts.consumers = opts.consumers or {}
            -- Refresh and auto close trouble after running tests
            ---@type neotest.Consumer
            opts.consumers.trouble = function(client)
                client.listeners.results = function(adapter_id, results, partial)
                    if partial then
                        return
                    end
                    local tree = assert(client:get_position(nil, { adapter = adapter_id }))

                    local failed = 0
                    for pos_id, result in pairs(results) do
                        if result.status == "failed" and tree:get_key(pos_id) then
                            failed = failed + 1
                        end
                    end
                    vim.schedule(function()
                        local trouble = require("trouble")
                        if trouble.is_open() then
                            trouble.refresh()
                            if failed == 0 then
                                trouble.close()
                            end
                        end
                    end)
                    return {}
                end
            end

            if opts.adapters then
                local adapters = {}
                for name, config in pairs(opts.adapters) do
                    if type(name) == "number" then
                        if type(config) == "string" then
                            config = require(config)
                        else
                        end
                        adapters[#adapters + 1] = config
                    elseif config ~= false then
                        local adapter = require(name)
                        if type(config) == "table" and not vim.tbl_isempty(config) then
                            local meta = getmetatable(adapter)
                            if adapter.setup then
                                adapter = adapter.setup(config)
                            elseif meta and meta.__call then
                                adapter = adapter(config)
                            else
                                error("Adapter " .. name .. " does not have a setup function")
                            end
                        end

                        adapters[#adapters + 1] = adapter
                    end
                end
                opts.adapters = adapters
            end
            require("neotest").setup(opts)
        end,
        keys = {
            { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Run File" },
            { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end,                            desc = "Run All Test Files" },
            { "<leader>tr", function() require("neotest").run.run() end,                                        desc = "Run Nearest" },
            { "<leader>tl", function() require("neotest").run.run_last() end,                                   desc = "Run Last" },
            { "<leader>ts", function() require("neotest").summary.toggle() end,                                 desc = "Toggle Summary" },
            { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
            { "<leader>tO", function() require("neotest").output_panel.toggle() end,                            desc = "Toggle Output Panel" },
            { "<leader>tS", function() require("neotest").run.stop() end,                                       desc = "Stop" },
        },
    }
}

return M
