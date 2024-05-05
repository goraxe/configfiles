M = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            [vim.fn.expand ((vim.fn.stdpath "data") .. "/lazy/*/lua/*") ] = true,
            [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  }

local foo =  vim.fn.expand ((vim.fn.stdpath "data") .. "/lazy/*/lua/*" )
for s in foo:gmatch("[^\n]+") do
    M.settings.Lua.workspace.library[s] = true
end

return M
