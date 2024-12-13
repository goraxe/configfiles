local goraxe = require("goraxe.core")

local defautls = {
    pylsp = {

        settings = {
            pylsp = {

                plugins = {
                    jedi_completion = {
                        fuzzy = true
                    }
                }
            }
        }
    },
    lua_ls = {

        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = {
                        [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                        [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                        [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
                    },
                    maxPreload = 100000,
                    preloadFileSize = 10000,
                },
            },
        },
    },
    tsserver = {
        --    root_dir = nvim_lsp.util.root_pattern("package.json"),
        single_file_support = false
    }
}

local M = {}

--[[ M.on_attach = function(client, bufnr)
    ---TODO this needs to behecked out
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- TODO this looks like something which loads bespoke keyboard
    -- mappings
    -- utils.load_mappings("lspconfig", { buffer = bufnr })

    if client.server_capabilities.signatureHelpProvider then
        -- require("nvchad.signature").setup(client)
    end

    -- FIXME  this is going to need some playing with
    -- if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
    --  client.server_capabilities.semanticTokensProvider = nil
    -- end
end ]]

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
    -- TODO review this
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}

function M.formatter(opts)
    opts = opts or {}
    local filter = opts.filter or {}
    filter = type(filter) == "string" and { name = filter } or filter
    ---@cast filter lsp.Client.filter
    ---@type LazyFormatter
    local ret = {
        name = "LSP",
        primary = true,
        priority = 1,
        format = function(buf)
            M.format(require("lazy.core.util").merge({}, filter, { bufnr = buf }))
        end,
        sources = function(buf)
            local clients = M.get_clients(goraxe.merge({}, filter, { bufnr = buf }))
            ---@param client lsp.Client
            local ret = vim.tbl_filter(function(client)
                return client.supports_method("textDocument/formatting")
                    or client.supports_method("textDocument/rangeFormatting")
            end, clients)
            ---@param client lsp.Client
            return vim.tbl_map(function(client)
                return client.name
            end, ret)
        end,
    }
    return require("lazy.core.util").merge(ret, opts) --[[@as LazyFormatter]]
end

---@param opts? lsp.Client.format
function M.format(opts)
    opts = vim.tbl_deep_extend(
        "force",
        {},
        opts or {},
        goraxe.opts("nvim-lspconfig").format or {},
        goraxe.opts("conform.nvim").format or {}
    )
    local ok, conform = pcall(require, "conform")
    -- use conform for formatting with LSP when available,
    -- since it has better format diffing
    if ok then
        opts.formatters = {}
        conform.format(opts)
    else
        vim.lsp.buf.format(opts)
    end
end

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf ---@type number
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

---@param opts? lsp.Client.filter
function M.get_clients(opts)
    local ret = {} ---@type lsp.Client[]
    if vim.lsp.get_clients then
        ret = vim.lsp.get_clients(opts)
    else
        ---@diagnostic disable-next-line: deprecated
        ret = vim.lsp.get_active_clients(opts)
        if opts and opts.method then
            ---@param client lsp.Client
            ret = vim.tbl_filter(function(client)
                return client.supports_method(opts.method, { bufnr = opts.bufnr })
            end, ret)
        end
    end
    return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param from string
---@param to string
function M.on_rename(from, to)
    local clients = M.get_clients()
    for _, client in ipairs(clients) do
        if client.supports_method("workspace/willRenameFiles") then
            ---@diagnostic disable-next-line: invisible
            local resp = client.request_sync("workspace/willRenameFiles", {
                files = {
                    {
                        oldUri = vim.uri_from_fname(from),
                        newUri = vim.uri_from_fname(to),
                    },
                },
            }, 1000, 0)
            if resp and resp.result ~= nil then
                vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
            end
        end
    end
end

---@param server string
---@param cond fun( root_dir, config): boolean
function M.disable(server, cond)
    local util = require("lspconfig.util")
    local def = M.get_config(server)
    ---@diagnostic disable-next-line: undefined-field
    def.document_config.on_new_config = util.add_hook_before(def.document_config.on_new_config,
        function(config, root_dir)
            if cond(root_dir, config) then
                config.enabled = false
            end
        end)
end

return M
-- @type LazySpec
--return {
--    {
--    "goraxe/lsp-golang",
--    dir = "/home/goraxe/configfiles/nvim/lua/goraxe/foo",
--    ft =  "go",
--    build = function()
--        print "build got called"
--    end,
--    opts = {
--      gopls = {
--        namer = "test",
--      },
--
--    }
--}
--
--}
