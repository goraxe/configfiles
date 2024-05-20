local goraxe = require("goraxe.config")
return {
    {
        "neovim/nvim-lspconfig",
        lazy = true,
        -- FIXME this requires a custom mapping in lazy plugin
        --        event = "LazyFile",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        dependencies = {
            { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
            { "folke/neodev.nvim",  opts = {} },
            "williamboman/mason-lspconfig.nvim",
            "folke/neoconf.nvim",
        },
        ---@class PluginLspOpts
        opts = {
            -- options for vim.diagnostic.config()
            ---@type vim.diagnostic.Opts
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "●",
                    -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                    -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
                    -- prefix = "icons",
                },
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = goraxe.icons.diagnostics.Error,
                        [vim.diagnostic.severity.WARN] = goraxe.icons.diagnostics.Warn,
                        [vim.diagnostic.severity.HINT] = goraxe.icons.diagnostics.Hint,
                        [vim.diagnostic.severity.INFO] = goraxe.icons.diagnostics.Info,
                    },
                },
            },
            -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
            -- Be aware that you also will need to properly configure your LSP server to
            -- provide the inlay hints.
            inlay_hints = {
                enabled = true,
            },
            -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
            -- Be aware that you also will need to properly configure your LSP server to
            -- provide the code lenses.
            codelens = {
                enabled = true,
            },
            -- add any global capabilities here
            capabilities = {},
            -- options for vim.lsp.buf.format
            -- `bufnr` and `filter` is handled by the LazyVim formatter,
            -- but can be also overridden when specified
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },
            -- LSP Server Settings
            -- -@type lspconfig.options
            servers = {
                lua_ls = {
                    -- mason = false, -- set to false if you don't want this server to be installed with mason
                    -- Use this to add any additional keymaps
                    -- for specific lsp servers
                    ---@type LazyKeysSpec[]
                    keys = {
                    },
                    ---@type lspconfig.settings.lua_ls
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            },
                            workspace = {
                                library = {
                                    vim.fn.expand ("$VIMRUNTIME/lua",false,true),
                                    vim.fn.expand ("$VIMRUNTIME/lua/vim/lsp",false, true),
                                    vim.fn.stdpath ("data") .. "/lazy/lazy.nvim/lua/lazy",
                                    --[[ [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                                    [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                                    [vim.fn.expand((vim.fn.stdpath "data") .. "/lazy/*/lua/*")] = true,
                                    [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true, ]]
                                },
                                maxPreload = 100000,
                                preloadFileSize = 10000,
                                checkThirdParty = false,
                            },
                            codeLens = {
                                enable = true,
                            },
                            completion = {
                                enable = true,
                                callSnippet = "Replace",
                            },
                        },
                    },
                },
            },
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
            setup = {
                -- example to setup with typescript.nvim
                -- tsserver = function(_, opts)
                --   require("typescript").setup({ server = opts })
                --   return true
                -- end,
                -- Specify * to use this function as a fallback for any server
                -- ["*"] = function(server, opts) end,
            },
        },
        config = function(_, opts)
            --            LazyVim.format.register(LazyVim.lsp.formatter())
            --
            if require("goraxe.core").has("neoconf.nvim") then
                local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
                require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
            end

            local register_capability = vim.lsp.handlers["client/registerCapability"]

            vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
                ---@diagnostic disable-next-line: no-unknown
                local ret = register_capability(err, res, ctx)
                local client = vim.lsp.get_client_by_id(ctx.client_id)
                local buffer = vim.api.nvim_get_current_buf()
                vim.print(require("goraxe.lsp.keymaps"))
                require("goraxe.lsp.keymaps").on_attach(client, buffer)
                return ret
            end

            -- diagnostics signs
            if vim.fn.has("nvim-0.10.0") == 0 then
                for severity, icon in pairs(opts.diagnostics.signs.text) do
                    local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
                    name = "DiagnosticSign" .. name
                    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
                end
            end

            -- inlay hints
            if opts.inlay_hints.enabled then
                require("goraxe.lsp").on_attach(function(client, buffer)
                    if client.supports_method("textDocument/inlayHint") then
                        require("goraxe.core.toggle").inlay_hints(buffer, true)
                    end
                end)
            end

            -- code lens
            if opts.codelens.enabled and vim.lsp.codelens then
                require("goraxe.lsp").on_attach(function(client, buffer)
                    if client.supports_method("textDocument/codeLens") then
                        vim.lsp.codelens.refresh()
                        --- autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
                        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                            buffer = buffer,
                            callback = vim.lsp.codelens.refresh,
                        })
                    end
                end)
            end

            if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
                opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
                    or function(diagnostic)
                        local icons = require("goraxe.config").icons.diagnostics
                        for d, icon in pairs(icons) do
                            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                                return icon
                            end
                        end
                    end
            end

            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            local servers = opts.servers
            local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {},
                opts.capabilities or {}
            )

            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                }, servers[server] or {})

                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end

                require("lspconfig")[server].setup(server_opts)
            end

            -- get all the servers that are available through mason-lspconfig
            local have_mason, mlsp = pcall(require, "mason-lspconfig")
            local all_mslp_servers = {}
            if have_mason then
                all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
            end

            local ensure_installed = {} ---@type string[]
            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                    if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
                        setup(server)
                    elseif server_opts.enabled ~= false then
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end
            end

            if have_mason then
                mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
            end


            --[[ require("mason-lspconfig").setup_handlers {
                -- The first entry (without a key) will be the default handler
                -- and will be called for each installed server that doesn't have
                -- a dedicated handler.
                function(server_name) -- default handler (optional)
                    local lsp = require("goraxe.lsp")
                    local found, lsp_config = pcall(function() return require("goraxe.lsp." .. server_name) end)
                    if not found then
                        lsp_config = lsp[server_name] or {}
                    else
                        print("found config for: " .. server_name)
                    end
                    require("lspconfig")[server_name].setup(merge_tb("force", {
                        on_attach = lsp.on_attach,
                        capabilities = lsp.capabilities,
                    }, lsp_config)
                    )
                end,
                -- Next, you can provide a dedicated handler for specific servers.
                -- For example, a handler override for the `rust_analyzer`:

                ["rust_analyzer"] = function()
                end
            } ]]
        end
    }
}
