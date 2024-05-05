M = {
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

M.on_attach = function(client, bufnr)
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
end

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

return {}
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
