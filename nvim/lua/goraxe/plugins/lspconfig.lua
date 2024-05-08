
local merge_tb = vim.tbl_deep_extend
return {
        "neovim/nvim-lspconfig",
        lazy = true,
        event = { "BufRead", "BufWinEnter", "BufNewFile" },
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "folke/neoconf.nvim",
        },
        config = function ()
        require("mason-lspconfig").setup_handlers {
            -- The first entry (without a key) will be the default handler
            -- and will be called for each installed server that doesn't have
            -- a dedicated handler.
            function (server_name) -- default handler (optional)
                local lsp = require("goraxe.lsp")
                local found, lsp_config = pcall(function() return require("goraxe.lsp." .. server_name)end)
                if not found then
                    lsp_config = lsp[server_name] or {}
                else 
                    print("found config for: " .. server_name)
                end
                require("lspconfig")[server_name].setup  (merge_tb("force", {
                    on_attach = lsp.on_attach,
                    capabilities = lsp.capabilities,
                }, lsp_config )
                )
            end,
            -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for the `rust_analyzer`:

     ["rust_analyzer"] = function ()
       return
     end
        }

    end
}
